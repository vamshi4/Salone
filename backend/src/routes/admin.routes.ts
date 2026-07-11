import { Router } from 'express';
import { requireRole } from '../auth';
import { prisma } from '../index';
import { writeAudit } from '../admin-audit';

const router = Router();

// Every route here is platform-wide across all salons. SUPER_ADMIN only.
// Never widen this guard.
router.use(requireRole('SUPER_ADMIN'));

// No enum backs saasPlan (it's a plain String column), so validation lives here.
const KNOWN_SAAS_PLANS = ['FREE', 'PREMIUM'] as const;

// Fields we snapshot into the audit log and return from salon mutations.
const salonAuditSelect = {
  id: true,
  name: true,
  address: true,
  saasPlan: true,
  commissionRate: true,
  lat: true,
  lng: true,
  deletedAt: true,
} as const;

function daysAgo(days: number) {
  const d = new Date();
  d.setDate(d.getDate() - days);
  return d;
}

function dayKey(value: Date) {
  return value.toISOString().slice(0, 10);
}

// Salon has no createdAt column, so the owner's signup date is the salon's birthday.
const ownerSelect = { name: true, phone: true, createdAt: true } as const;

router.get('/stats', async (_req, res) => {
  try {
    const last30 = daysAgo(30);
    const last7 = daysAgo(7);

    const [salons, owners, customers, bookings, bookings30, newSalons7, newSalons30, activeRows] =
      await Promise.all([
        prisma.salon.count({ where: { deletedAt: null } }),
        prisma.user.count({ where: { role: 'SALON_OWNER', deletedAt: null } }),
        prisma.user.count({ where: { role: 'CUSTOMER', deletedAt: null } }),
        prisma.booking.count(),
        prisma.booking.count({ where: { createdAt: { gte: last30 } } }),
        prisma.user.count({ where: { role: 'SALON_OWNER', deletedAt: null, createdAt: { gte: last7 } } }),
        prisma.user.count({ where: { role: 'SALON_OWNER', deletedAt: null, createdAt: { gte: last30 } } }),
        prisma.booking.findMany({
          where: { createdAt: { gte: last30 }, salonId: { not: null } },
          select: { salonId: true },
          distinct: ['salonId'],
        }),
      ]);

    const activeSalons = activeRows.length;

    res.json({
      salons,
      owners,
      customers,
      bookings,
      bookings30,
      newSalons7,
      newSalons30,
      activeSalons,
      // A salon with no booking in 30 days is the churn signal that matters to us.
      dormantSalons: Math.max(salons - activeSalons, 0),
    });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

router.get('/salons', async (_req, res) => {
  try {
    const [salons, lastBookings] = await Promise.all([
      prisma.salon.findMany({
        where: { deletedAt: null },
        include: {
          owner: { select: ownerSelect },
          _count: { select: { bookings: true, customers: true, stylists: true } },
        },
      }),
      prisma.booking.groupBy({
        by: ['salonId'],
        where: { salonId: { not: null } },
        _max: { createdAt: true },
      }),
    ]);

    const lastBySalon = new Map<string, Date | null>();
    for (const row of lastBookings) {
      if (row.salonId) lastBySalon.set(row.salonId, row._max.createdAt);
    }

    const rows = salons.map((salon) => ({
      id: salon.id,
      name: salon.name,
      address: salon.address,
      saasPlan: salon.saasPlan,
      ownerName: salon.owner.name,
      ownerPhone: salon.owner.phone,
      signedUpAt: salon.owner.createdAt,
      bookings: salon._count.bookings,
      customers: salon._count.customers,
      stylists: salon._count.stylists,
      lastBookingAt: lastBySalon.get(salon.id) ?? null,
    }));

    rows.sort((a, b) => b.signedUpAt.getTime() - a.signedUpAt.getTime());
    res.json(rows);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

router.get('/salons/:salonId', async (req, res) => {
  try {
    const salon = await prisma.salon.findFirst({
      where: { id: req.params.salonId, deletedAt: null },
      include: {
        owner: { select: ownerSelect },
        _count: { select: { bookings: true, customers: true, stylists: true } },
      },
    });
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const bookings = await prisma.booking.findMany({
      where: { salonId: salon.id },
      orderBy: { slotStart: 'desc' },
      take: 20,
      select: {
        id: true,
        slotStart: true,
        status: true,
        price: true,
        customer: { select: { name: true, phone: true } },
        service: { select: { name: true } },
      },
    });

    res.json({ salon, bookings });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

router.get('/growth', async (req, res) => {
  try {
    const days = Math.min(Math.max(Number(req.query.days) || 30, 7), 180);
    const since = daysAgo(days);

    const [signups, bookings] = await Promise.all([
      prisma.user.findMany({
        where: { role: 'SALON_OWNER', deletedAt: null, createdAt: { gte: since } },
        select: { createdAt: true },
      }),
      prisma.booking.findMany({
        where: { createdAt: { gte: since } },
        select: { createdAt: true },
      }),
    ]);

    const buckets = new Map<string, { signups: number; bookings: number }>();
    for (let i = days - 1; i >= 0; i -= 1) {
      buckets.set(dayKey(daysAgo(i)), { signups: 0, bookings: 0 });
    }
    for (const row of signups) {
      const bucket = buckets.get(dayKey(row.createdAt));
      if (bucket) bucket.signups += 1;
    }
    for (const row of bookings) {
      const bucket = buckets.get(dayKey(row.createdAt));
      if (bucket) bucket.bookings += 1;
    }

    res.json([...buckets.entries()].map(([date, counts]) => ({ date, ...counts })));
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// --- Salon mutations -------------------------------------------------------

// PATCH /api/v2/admin/salons/:id — edit a salon's editable fields.
router.patch('/salons/:id', async (req, res) => {
  try {
    const existing = await prisma.salon.findFirst({
      where: { id: req.params.id, deletedAt: null },
      select: salonAuditSelect,
    });
    if (!existing) return res.status(404).json({ error: 'Salon not found' });

    const { name, address, saasPlan, commissionRate, lat, lng } = req.body ?? {};
    const data: {
      name?: string;
      address?: string;
      saasPlan?: string;
      commissionRate?: number;
      lat?: number;
      lng?: number;
    } = {};

    if (name != null) {
      const trimmed = String(name).trim();
      if (!trimmed) return res.status(400).json({ error: 'name cannot be empty' });
      data.name = trimmed;
    }
    if (address != null) {
      const trimmed = String(address).trim();
      if (!trimmed) return res.status(400).json({ error: 'address cannot be empty' });
      data.address = trimmed;
    }
    if (saasPlan != null) {
      const plan = String(saasPlan).trim().toUpperCase();
      if (!KNOWN_SAAS_PLANS.includes(plan as (typeof KNOWN_SAAS_PLANS)[number])) {
        return res
          .status(400)
          .json({ error: `saasPlan must be one of ${KNOWN_SAAS_PLANS.join(', ')}` });
      }
      data.saasPlan = plan;
    }
    if (commissionRate != null) {
      const rate = Number(commissionRate);
      if (!Number.isInteger(rate) || rate < 0 || rate > 100) {
        return res
          .status(400)
          .json({ error: 'commissionRate must be an integer between 0 and 100' });
      }
      data.commissionRate = rate;
    }
    if (lat != null) {
      const value = Number(lat);
      if (!Number.isFinite(value)) return res.status(400).json({ error: 'lat must be a number' });
      data.lat = value;
    }
    if (lng != null) {
      const value = Number(lng);
      if (!Number.isFinite(value)) return res.status(400).json({ error: 'lng must be a number' });
      data.lng = value;
    }

    if (Object.keys(data).length === 0) {
      return res.status(400).json({ error: 'No editable fields provided' });
    }

    const salon = await prisma.$transaction(async (tx) => {
      const updated = await tx.salon.update({
        where: { id: existing.id },
        data,
        select: salonAuditSelect,
      });
      await writeAudit(tx, {
        actorId: req.user!.id,
        action: 'salon.update',
        targetType: 'Salon',
        targetId: existing.id,
        before: existing,
        after: updated,
      });
      return updated;
    });

    res.json(salon);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// DELETE /api/v2/admin/salons/:id — soft delete (guardrail #1). The owner is
// left untouched; only the salon is hidden.
router.delete('/salons/:id', async (req, res) => {
  try {
    const existing = await prisma.salon.findFirst({
      where: { id: req.params.id, deletedAt: null },
      select: salonAuditSelect,
    });
    if (!existing) return res.status(404).json({ error: 'Salon not found' });

    const salon = await prisma.$transaction(async (tx) => {
      const updated = await tx.salon.update({
        where: { id: existing.id },
        data: { deletedAt: new Date() },
        select: salonAuditSelect,
      });
      await writeAudit(tx, {
        actorId: req.user!.id,
        action: 'salon.delete',
        targetType: 'Salon',
        targetId: existing.id,
        before: existing,
        after: updated,
      });
      return updated;
    });

    res.json(salon);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// POST /api/v2/admin/salons/:id/restore — clear the soft-delete timestamp.
router.post('/salons/:id/restore', async (req, res) => {
  try {
    const existing = await prisma.salon.findUnique({
      where: { id: req.params.id },
      select: salonAuditSelect,
    });
    if (!existing) return res.status(404).json({ error: 'Salon not found' });
    if (!existing.deletedAt) return res.status(400).json({ error: 'Salon is not deleted' });

    const salon = await prisma.$transaction(async (tx) => {
      const updated = await tx.salon.update({
        where: { id: existing.id },
        data: { deletedAt: null },
        select: salonAuditSelect,
      });
      await writeAudit(tx, {
        actorId: req.user!.id,
        action: 'salon.restore',
        targetType: 'Salon',
        targetId: existing.id,
        before: existing,
        after: updated,
      });
      return updated;
    });

    res.json(salon);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

export default router;
