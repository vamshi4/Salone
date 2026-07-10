import { Router } from 'express';
import { requireRole } from '../auth';
import { prisma } from '../index';

const router = Router();

// Every route here is platform-wide across all salons. SUPER_ADMIN only.
// Never widen this guard.
router.use(requireRole('SUPER_ADMIN'));

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
        prisma.salon.count(),
        prisma.user.count({ where: { role: 'SALON_OWNER' } }),
        prisma.user.count({ where: { role: 'CUSTOMER' } }),
        prisma.booking.count(),
        prisma.booking.count({ where: { createdAt: { gte: last30 } } }),
        prisma.user.count({ where: { role: 'SALON_OWNER', createdAt: { gte: last7 } } }),
        prisma.user.count({ where: { role: 'SALON_OWNER', createdAt: { gte: last30 } } }),
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
    const salon = await prisma.salon.findUnique({
      where: { id: req.params.salonId },
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
        where: { role: 'SALON_OWNER', createdAt: { gte: since } },
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

export default router;
