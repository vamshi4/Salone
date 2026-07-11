import { Router } from 'express';
import { BookingStatus, UserRole } from '@prisma/client';
import { requireRole } from '../auth';
import { hashPassword } from '../password';
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

// User snapshot for audit/return. Never includes the password hash (guardrail
// #4: "omit secrets like password hash").
const userAuditSelect = {
  id: true,
  name: true,
  phone: true,
  email: true,
  role: true,
  deletedAt: true,
} as const;

const bookingAuditSelect = {
  id: true,
  salonId: true,
  customerId: true,
  stylistId: true,
  status: true,
  slotStart: true,
  slotEnd: true,
  price: true,
} as const;

const serviceAuditSelect = {
  id: true,
  name: true,
  category: true,
  duration: true,
  basePrice: true,
  salonId: true,
  stylistId: true,
} as const;

const customerAuditSelect = {
  id: true,
  salonId: true,
  customerId: true,
  notes: true,
  tags: true,
} as const;

const stylistAuditSelect = {
  id: true,
  userId: true,
  registrationType: true,
  basePrice: true,
  homeServiceEnabled: true,
  independentBookingEnabled: true,
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
// The drill-down owner panel needs the id/email/role the list view doesn't.
const ownerDetailSelect = {
  id: true,
  name: true,
  phone: true,
  email: true,
  role: true,
  createdAt: true,
} as const;

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
        owner: { select: ownerDetailSelect },
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

// --- User / owner mutations ------------------------------------------------

// PATCH /api/v2/admin/users/:id — edit identity fields. Phone/email uniqueness
// is enforced by the DB; P2002 surfaces as 409.
router.patch('/users/:id', async (req, res) => {
  try {
    const existing = await prisma.user.findFirst({
      where: { id: req.params.id, deletedAt: null },
      select: userAuditSelect,
    });
    if (!existing) return res.status(404).json({ error: 'User not found' });

    const { name, phone, email } = req.body ?? {};
    const data: { name?: string | null; phone?: string; email?: string | null } = {};

    if (name !== undefined) {
      const trimmed = name == null ? null : String(name).trim();
      data.name = trimmed && trimmed.length > 0 ? trimmed : null;
    }
    if (phone != null) {
      const trimmed = String(phone).trim();
      if (trimmed.length < 6) {
        return res.status(400).json({ error: 'Phone must be at least 6 digits' });
      }
      data.phone = trimmed;
    }
    if (email !== undefined) {
      const trimmed = email == null ? '' : String(email).trim();
      data.email = trimmed.length > 0 ? trimmed : null;
    }

    if (Object.keys(data).length === 0) {
      return res.status(400).json({ error: 'No editable fields provided' });
    }

    const user = await prisma.$transaction(async (tx) => {
      const updated = await tx.user.update({
        where: { id: existing.id },
        data,
        select: userAuditSelect,
      });
      await writeAudit(tx, {
        actorId: req.user!.id,
        action: 'user.update',
        targetType: 'User',
        targetId: existing.id,
        before: existing,
        after: updated,
      });
      return updated;
    });

    res.json(user);
  } catch (e: any) {
    if (e.code === 'P2002') {
      return res.status(409).json({ error: 'Phone or email is already registered' });
    }
    res.status(500).json({ error: e.message });
  }
});

// POST /api/v2/admin/users/:id/reset-password — set a new password. Min 12 chars
// (stricter than self-serve signup: an admin resetting someone else's password
// is a higher-stakes action). Hash format matches auth.routes via shared helper.
router.post('/users/:id/reset-password', async (req, res) => {
  try {
    const { password } = req.body ?? {};
    if (!password || String(password).length < 12) {
      return res.status(400).json({ error: 'Password must be at least 12 characters' });
    }

    const existing = await prisma.user.findFirst({
      where: { id: req.params.id, deletedAt: null },
      select: userAuditSelect,
    });
    if (!existing) return res.status(404).json({ error: 'User not found' });

    await prisma.$transaction(async (tx) => {
      await tx.user.update({
        where: { id: existing.id },
        data: { password: hashPassword(String(password)) },
      });
      // No before/after payload — the only thing that changed is the secret,
      // and the audit log must never carry password material.
      await writeAudit(tx, {
        actorId: req.user!.id,
        action: 'user.reset-password',
        targetType: 'User',
        targetId: existing.id,
      });
    });

    res.json({ ok: true });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// PATCH /api/v2/admin/users/:id/role — change a user's role. Guardrail #5: a
// SUPER_ADMIN can never change their own role (no locking yourself out).
router.patch('/users/:id/role', async (req, res) => {
  try {
    if (req.params.id === req.user!.id) {
      return res.status(400).json({ error: 'You cannot change your own role' });
    }

    const { role } = req.body ?? {};
    if (!role || !Object.values(UserRole).includes(role)) {
      return res
        .status(400)
        .json({ error: `role must be one of ${Object.values(UserRole).join(', ')}` });
    }

    const existing = await prisma.user.findFirst({
      where: { id: req.params.id, deletedAt: null },
      select: userAuditSelect,
    });
    if (!existing) return res.status(404).json({ error: 'User not found' });

    const user = await prisma.$transaction(async (tx) => {
      const updated = await tx.user.update({
        where: { id: existing.id },
        data: { role },
        select: userAuditSelect,
      });
      await writeAudit(tx, {
        actorId: req.user!.id,
        action: 'user.role',
        targetType: 'User',
        targetId: existing.id,
        before: existing,
        after: updated,
      });
      return updated;
    });

    res.json(user);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// DELETE /api/v2/admin/users/:id — soft delete. Guardrail #5: refuse self-delete.
router.delete('/users/:id', async (req, res) => {
  try {
    if (req.params.id === req.user!.id) {
      return res.status(400).json({ error: 'You cannot delete your own account' });
    }

    const existing = await prisma.user.findFirst({
      where: { id: req.params.id, deletedAt: null },
      select: userAuditSelect,
    });
    if (!existing) return res.status(404).json({ error: 'User not found' });

    const user = await prisma.$transaction(async (tx) => {
      const updated = await tx.user.update({
        where: { id: existing.id },
        data: { deletedAt: new Date() },
        select: userAuditSelect,
      });
      await writeAudit(tx, {
        actorId: req.user!.id,
        action: 'user.delete',
        targetType: 'User',
        targetId: existing.id,
        before: existing,
        after: updated,
      });
      return updated;
    });

    res.json(user);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// POST /api/v2/admin/users/:id/restore — clear the soft-delete timestamp so the
// user (and their login) is live again. Powers the deleted-items view.
router.post('/users/:id/restore', async (req, res) => {
  try {
    const existing = await prisma.user.findUnique({
      where: { id: req.params.id },
      select: userAuditSelect,
    });
    if (!existing) return res.status(404).json({ error: 'User not found' });
    if (!existing.deletedAt) return res.status(400).json({ error: 'User is not deleted' });

    const user = await prisma.$transaction(async (tx) => {
      const updated = await tx.user.update({
        where: { id: existing.id },
        data: { deletedAt: null },
        select: userAuditSelect,
      });
      await writeAudit(tx, {
        actorId: req.user!.id,
        action: 'user.restore',
        targetType: 'User',
        targetId: existing.id,
        before: existing,
        after: updated,
      });
      return updated;
    });

    res.json(user);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// --- Booking mutations -----------------------------------------------------

// PATCH /api/v2/admin/bookings/:id — correct a booking's status/time/price.
router.patch('/bookings/:id', async (req, res) => {
  try {
    const existing = await prisma.booking.findUnique({
      where: { id: req.params.id },
      select: bookingAuditSelect,
    });
    if (!existing) return res.status(404).json({ error: 'Booking not found' });

    const { status, slotStart, slotEnd, price } = req.body ?? {};
    const data: {
      status?: BookingStatus;
      slotStart?: Date;
      slotEnd?: Date;
      price?: number;
    } = {};

    if (status != null) {
      if (!Object.values(BookingStatus).includes(status)) {
        return res
          .status(400)
          .json({ error: `status must be one of ${Object.values(BookingStatus).join(', ')}` });
      }
      data.status = status;
    }
    if (slotStart != null) {
      const value = new Date(slotStart);
      if (Number.isNaN(value.getTime())) {
        return res.status(400).json({ error: 'slotStart is not a valid date' });
      }
      data.slotStart = value;
    }
    if (slotEnd != null) {
      const value = new Date(slotEnd);
      if (Number.isNaN(value.getTime())) {
        return res.status(400).json({ error: 'slotEnd is not a valid date' });
      }
      data.slotEnd = value;
    }
    if (price != null) {
      const value = Number(price);
      if (!Number.isInteger(value) || value < 0) {
        return res.status(400).json({ error: 'price must be a non-negative integer' });
      }
      data.price = value;
    }

    if (Object.keys(data).length === 0) {
      return res.status(400).json({ error: 'No editable fields provided' });
    }

    const nextStart = data.slotStart ?? existing.slotStart;
    const nextEnd = data.slotEnd ?? existing.slotEnd;
    if (nextEnd <= nextStart) {
      return res.status(400).json({ error: 'slotEnd must be after slotStart' });
    }

    const booking = await prisma.$transaction(async (tx) => {
      const updated = await tx.booking.update({
        where: { id: existing.id },
        data,
        select: bookingAuditSelect,
      });
      await writeAudit(tx, {
        actorId: req.user!.id,
        action: 'booking.update',
        targetType: 'Booking',
        targetId: existing.id,
        before: existing,
        after: updated,
      });
      return updated;
    });

    res.json(booking);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// DELETE /api/v2/admin/bookings/:id — HARD delete (guardrail #2, the one model
// allowed to hard-delete). BookingServiceItem rows cascade; the optional Review
// has no cascade, so remove it first or the FK blocks the delete.
router.delete('/bookings/:id', async (req, res) => {
  try {
    const existing = await prisma.booking.findUnique({
      where: { id: req.params.id },
      select: bookingAuditSelect,
    });
    if (!existing) return res.status(404).json({ error: 'Booking not found' });

    await prisma.$transaction(async (tx) => {
      await tx.review.deleteMany({ where: { bookingId: existing.id } });
      await tx.booking.delete({ where: { id: existing.id } });
      await writeAudit(tx, {
        actorId: req.user!.id,
        action: 'booking.delete',
        targetType: 'Booking',
        targetId: existing.id,
        before: existing,
      });
    });

    res.json({ ok: true });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// --- Service mutations -----------------------------------------------------

// PATCH /api/v2/admin/services/:id — edit a service's catalog fields.
router.patch('/services/:id', async (req, res) => {
  try {
    const existing = await prisma.service.findUnique({
      where: { id: req.params.id },
      select: serviceAuditSelect,
    });
    if (!existing) return res.status(404).json({ error: 'Service not found' });

    const { name, category, duration, basePrice } = req.body ?? {};
    const data: { name?: string; category?: string; duration?: number; basePrice?: number } = {};

    if (name != null) {
      const trimmed = String(name).trim();
      if (!trimmed) return res.status(400).json({ error: 'name cannot be empty' });
      data.name = trimmed;
    }
    if (category != null) {
      const trimmed = String(category).trim();
      if (!trimmed) return res.status(400).json({ error: 'category cannot be empty' });
      data.category = trimmed;
    }
    if (duration != null) {
      const value = Number(duration);
      if (!Number.isInteger(value) || value <= 0) {
        return res.status(400).json({ error: 'duration must be a positive integer (minutes)' });
      }
      data.duration = value;
    }
    if (basePrice != null) {
      const value = Number(basePrice);
      if (!Number.isInteger(value) || value < 0) {
        return res.status(400).json({ error: 'basePrice must be a non-negative integer' });
      }
      data.basePrice = value;
    }

    if (Object.keys(data).length === 0) {
      return res.status(400).json({ error: 'No editable fields provided' });
    }

    const service = await prisma.$transaction(async (tx) => {
      const updated = await tx.service.update({
        where: { id: existing.id },
        data,
        select: serviceAuditSelect,
      });
      await writeAudit(tx, {
        actorId: req.user!.id,
        action: 'service.update',
        targetType: 'Service',
        targetId: existing.id,
        before: existing,
        after: updated,
      });
      return updated;
    });

    res.json(service);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// DELETE /api/v2/admin/services/:id — HARD delete. A service still referenced by
// bookings can't be removed (FK RESTRICT); surface that as 409, not 500.
router.delete('/services/:id', async (req, res) => {
  try {
    const existing = await prisma.service.findUnique({
      where: { id: req.params.id },
      select: serviceAuditSelect,
    });
    if (!existing) return res.status(404).json({ error: 'Service not found' });

    await prisma.$transaction(async (tx) => {
      await tx.service.delete({ where: { id: existing.id } });
      await writeAudit(tx, {
        actorId: req.user!.id,
        action: 'service.delete',
        targetType: 'Service',
        targetId: existing.id,
        before: existing,
      });
    });

    res.json({ ok: true });
  } catch (e: any) {
    if (e.code === 'P2003') {
      return res
        .status(409)
        .json({ error: 'Service is referenced by existing bookings and cannot be deleted' });
    }
    res.status(500).json({ error: e.message });
  }
});

// --- Customer (SalonCustomer) mutations ------------------------------------

const customerInclude = {
  ...customerAuditSelect,
  customer: { select: { id: true, name: true, phone: true } },
} as const;

// PATCH /api/v2/admin/customers/:id — edit the salon-customer link (notes, tags)
// and, through it, the underlying User's name/phone. :id is the SalonCustomer id.
router.patch('/customers/:id', async (req, res) => {
  try {
    const existing = await prisma.salonCustomer.findUnique({
      where: { id: req.params.id },
      select: customerInclude,
    });
    if (!existing) return res.status(404).json({ error: 'Customer not found' });

    const { notes, tags, name, phone } = req.body ?? {};
    const linkData: { notes?: string; tags?: string[] } = {};
    const userData: { name?: string | null; phone?: string } = {};

    if (notes != null) {
      linkData.notes = String(notes);
    }
    if (tags != null) {
      if (!Array.isArray(tags) || tags.some((t) => typeof t !== 'string')) {
        return res.status(400).json({ error: 'tags must be an array of strings' });
      }
      linkData.tags = tags;
    }
    if (name !== undefined) {
      const trimmed = name == null ? null : String(name).trim();
      userData.name = trimmed && trimmed.length > 0 ? trimmed : null;
    }
    if (phone != null) {
      const trimmed = String(phone).trim();
      if (trimmed.length < 6) {
        return res.status(400).json({ error: 'Phone must be at least 6 digits' });
      }
      userData.phone = trimmed;
    }

    if (Object.keys(linkData).length === 0 && Object.keys(userData).length === 0) {
      return res.status(400).json({ error: 'No editable fields provided' });
    }

    const result = await prisma.$transaction(async (tx) => {
      if (Object.keys(linkData).length > 0) {
        await tx.salonCustomer.update({ where: { id: existing.id }, data: linkData });
      }
      if (Object.keys(userData).length > 0) {
        await tx.user.update({ where: { id: existing.customerId }, data: userData });
      }
      const updated = await tx.salonCustomer.findUnique({
        where: { id: existing.id },
        select: customerInclude,
      });
      await writeAudit(tx, {
        actorId: req.user!.id,
        action: 'customer.update',
        targetType: 'SalonCustomer',
        targetId: existing.id,
        before: existing,
        after: updated,
      });
      return updated;
    });

    res.json(result);
  } catch (e: any) {
    if (e.code === 'P2002') {
      return res.status(409).json({ error: 'Phone is already registered' });
    }
    res.status(500).json({ error: e.message });
  }
});

// DELETE /api/v2/admin/customers/:id — remove the salon-customer link. Per spec
// the join row carries no history, so this is a hard delete of the link only;
// the underlying User (and their bookings) is untouched. The before-snapshot in
// the audit log makes it recoverable.
router.delete('/customers/:id', async (req, res) => {
  try {
    const existing = await prisma.salonCustomer.findUnique({
      where: { id: req.params.id },
      select: customerInclude,
    });
    if (!existing) return res.status(404).json({ error: 'Customer not found' });

    await prisma.$transaction(async (tx) => {
      await tx.salonCustomer.delete({ where: { id: existing.id } });
      await writeAudit(tx, {
        actorId: req.user!.id,
        action: 'customer.delete',
        targetType: 'SalonCustomer',
        targetId: existing.id,
        before: existing,
      });
    });

    res.json({ ok: true });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// --- Stylist (staff) mutations ---------------------------------------------

// PATCH /api/v2/admin/stylists/:id — edit staff-config fields.
router.patch('/stylists/:id', async (req, res) => {
  try {
    const existing = await prisma.stylist.findFirst({
      where: { id: req.params.id, deletedAt: null },
      select: stylistAuditSelect,
    });
    if (!existing) return res.status(404).json({ error: 'Stylist not found' });

    const { basePrice, homeServiceEnabled, independentBookingEnabled } = req.body ?? {};
    const data: {
      basePrice?: number | null;
      homeServiceEnabled?: boolean;
      independentBookingEnabled?: boolean;
    } = {};

    if (basePrice !== undefined) {
      if (basePrice === null) {
        data.basePrice = null;
      } else {
        const value = Number(basePrice);
        if (!Number.isInteger(value) || value < 0) {
          return res.status(400).json({ error: 'basePrice must be a non-negative integer or null' });
        }
        data.basePrice = value;
      }
    }
    if (homeServiceEnabled != null) {
      if (typeof homeServiceEnabled !== 'boolean') {
        return res.status(400).json({ error: 'homeServiceEnabled must be a boolean' });
      }
      data.homeServiceEnabled = homeServiceEnabled;
    }
    if (independentBookingEnabled != null) {
      if (typeof independentBookingEnabled !== 'boolean') {
        return res.status(400).json({ error: 'independentBookingEnabled must be a boolean' });
      }
      data.independentBookingEnabled = independentBookingEnabled;
    }

    if (Object.keys(data).length === 0) {
      return res.status(400).json({ error: 'No editable fields provided' });
    }

    const stylist = await prisma.$transaction(async (tx) => {
      const updated = await tx.stylist.update({
        where: { id: existing.id },
        data,
        select: stylistAuditSelect,
      });
      await writeAudit(tx, {
        actorId: req.user!.id,
        action: 'stylist.update',
        targetType: 'Stylist',
        targetId: existing.id,
        before: existing,
        after: updated,
      });
      return updated;
    });

    res.json(stylist);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// DELETE /api/v2/admin/stylists/:id — soft delete. The stylist drops out of
// discovery, salon rosters, and new-booking eligibility; existing bookings and
// their User account stay put.
router.delete('/stylists/:id', async (req, res) => {
  try {
    const existing = await prisma.stylist.findFirst({
      where: { id: req.params.id, deletedAt: null },
      select: stylistAuditSelect,
    });
    if (!existing) return res.status(404).json({ error: 'Stylist not found' });

    const stylist = await prisma.$transaction(async (tx) => {
      const updated = await tx.stylist.update({
        where: { id: existing.id },
        data: { deletedAt: new Date() },
        select: stylistAuditSelect,
      });
      await writeAudit(tx, {
        actorId: req.user!.id,
        action: 'stylist.delete',
        targetType: 'Stylist',
        targetId: existing.id,
        before: existing,
        after: updated,
      });
      return updated;
    });

    res.json(stylist);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// POST /api/v2/admin/stylists/:id/restore — clear the soft-delete timestamp.
router.post('/stylists/:id/restore', async (req, res) => {
  try {
    const existing = await prisma.stylist.findUnique({
      where: { id: req.params.id },
      select: stylistAuditSelect,
    });
    if (!existing) return res.status(404).json({ error: 'Stylist not found' });
    if (!existing.deletedAt) return res.status(400).json({ error: 'Stylist is not deleted' });

    const stylist = await prisma.$transaction(async (tx) => {
      const updated = await tx.stylist.update({
        where: { id: existing.id },
        data: { deletedAt: null },
        select: stylistAuditSelect,
      });
      await writeAudit(tx, {
        actorId: req.user!.id,
        action: 'stylist.restore',
        targetType: 'Stylist',
        targetId: existing.id,
        before: existing,
        after: updated,
      });
      return updated;
    });

    res.json(stylist);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// --- Deleted items ----------------------------------------------------------

// GET /api/v2/admin/deleted — soft-deleted salons and users, for the restore UI.
router.get('/deleted', async (_req, res) => {
  try {
    const [salons, users] = await Promise.all([
      prisma.salon.findMany({
        where: { deletedAt: { not: null } },
        orderBy: { deletedAt: 'desc' },
        select: {
          id: true,
          name: true,
          address: true,
          saasPlan: true,
          deletedAt: true,
          owner: { select: { name: true, phone: true } },
        },
      }),
      prisma.user.findMany({
        where: { deletedAt: { not: null } },
        orderBy: { deletedAt: 'desc' },
        select: { id: true, name: true, phone: true, email: true, role: true, deletedAt: true },
      }),
    ]);

    res.json({ salons, users });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// --- Audit ------------------------------------------------------------------

// GET /api/v2/admin/audit?targetType=&targetId=&limit=50 — recent admin actions,
// newest first. Optional filters narrow to a single entity's history.
router.get('/audit', async (req, res) => {
  try {
    const limit = Math.min(Math.max(Number(req.query.limit) || 50, 1), 200);
    const targetType = typeof req.query.targetType === 'string' ? req.query.targetType : undefined;
    const targetId = typeof req.query.targetId === 'string' ? req.query.targetId : undefined;

    const rows = await prisma.adminAuditLog.findMany({
      where: {
        ...(targetType ? { targetType } : {}),
        ...(targetId ? { targetId } : {}),
      },
      orderBy: { createdAt: 'desc' },
      take: limit,
    });

    res.json(rows);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

export default router;
