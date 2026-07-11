import { Router } from 'express';
import { prisma } from '../index';
import { requireRole } from '../auth';

const router = Router();
const disabledPassword = 'disabled';

async function findOwnedSalon(salonId: string, user: any) {
  return prisma.salon.findFirst({
    where: {
      id: salonId,
      deletedAt: null,
      ...(user?.role === 'SUPER_ADMIN' ? {} : { ownerId: user?.id }),
    },
  });
}

// GET /api/v2/salons
router.get('/', requireRole('CUSTOMER', 'SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  const salons = await prisma.salon.findMany({
    where: {
      deletedAt: null,
      ...(req.user?.role === 'SALON_OWNER' ? { ownerId: req.user.id } : {}),
    },
    include: {
      services: true,
      owner: true,
      stylists: {
        where: { status: 'ACTIVE' },
        include: {
          stylist: {
            include: {
              user: true,
              primarySalon: true,
              services: true,
            },
          },
        },
      },
    },
  });
  res.json(salons);
});

// GET /api/v2/salons/:salonId/bookings - Salon admin booking dashboard.
router.get('/:salonId/bookings', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const salon = await findOwnedSalon(req.params.salonId, req.user);
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const bookings = await prisma.booking.findMany({
      where: { salonId: req.params.salonId },
      orderBy: { slotStart: 'desc' },
      include: {
        customer: true,
        stylist: { include: { user: true } },
        service: true,
        services: {
          include: { service: true },
          orderBy: { sortOrder: 'asc' },
        },
      },
    });

    res.json(bookings);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// GET /api/v2/salons/:salonId/retention - Month-end retention analytics.
// Splits customers into new / retained (constant) / churned (dropped) / reactivated,
// and returns the "missed" list (active last month but not this month) to re-engage.
router.get('/:salonId/retention', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const salon = await findOwnedSalon(req.params.salonId, req.user);
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    // A booking counts as a "visit" if the customer attended or is committed.
    const bookings = await prisma.booking.findMany({
      where: { salonId: req.params.salonId, status: { in: ['COMPLETED', 'CONFIRMED'] } },
      include: { customer: true },
      orderBy: { slotStart: 'asc' },
    });

    const now = new Date();
    const monthKey = (d: Date) => `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`;
    const thisKey = monthKey(now);
    const lastKey = monthKey(new Date(now.getFullYear(), now.getMonth() - 1, 1));

    type Agg = {
      id: string; name: string | null; phone: string;
      months: Set<string>; firstVisit: Date; lastVisit: Date;
      visits: number; totalSpend: number;
    };
    const byCustomer = new Map<string, Agg>();

    for (const b of bookings) {
      const key = b.customerId;
      const mk = monthKey(b.slotStart);
      const existing = byCustomer.get(key);
      if (!existing) {
        byCustomer.set(key, {
          id: b.customerId,
          name: b.customer?.name ?? null,
          phone: b.customer?.phone ?? '',
          months: new Set([mk]),
          firstVisit: b.slotStart,
          lastVisit: b.slotStart,
          visits: 1,
          totalSpend: b.price,
        });
      } else {
        existing.months.add(mk);
        existing.visits += 1;
        existing.totalSpend += b.price;
        if (b.slotStart < existing.firstVisit) existing.firstVisit = b.slotStart;
        if (b.slotStart > existing.lastVisit) existing.lastVisit = b.slotStart;
      }
    }

    const all = [...byCustomer.values()];
    const activeThis = all.filter((c) => c.months.has(thisKey));
    const activeLast = all.filter((c) => c.months.has(lastKey));

    const newCustomers = activeThis.filter((c) => monthKey(c.firstVisit) === thisKey);
    const retained = activeThis.filter((c) => c.months.has(lastKey)); // came both months
    const reactivated = activeThis.filter(
      (c) => !c.months.has(lastKey) && monthKey(c.firstVisit) !== thisKey,
    );
    const churned = activeLast.filter((c) => !c.months.has(thisKey)); // missed this month

    // Also surface longer-lapsed customers (last visit before last month, still gone).
    const lapsed = all.filter(
      (c) => !c.months.has(thisKey) && !c.months.has(lastKey),
    );

    const pct = (n: number, d: number) => (d > 0 ? Math.round((n / d) * 1000) / 10 : 0);
    const revenueIn = (key: string) =>
      bookings.filter((b) => monthKey(b.slotStart) === key).reduce((t, b) => t + b.price, 0);
    const revThis = revenueIn(thisKey);
    const revLast = revenueIn(lastKey);

    const missed = [...churned, ...lapsed]
      .map((c) => ({
        customerId: c.id,
        name: c.name,
        phone: c.phone,
        lastVisit: c.lastVisit,
        visits: c.visits,
        totalSpend: c.totalSpend,
        status: c.months.has(lastKey) ? 'DROPPED' : 'LAPSED',
      }))
      .sort((a, b) => b.totalSpend - a.totalSpend);

    const member = (c: any) => ({
      customerId: c.id,
      name: c.name,
      phone: c.phone,
      totalSpend: c.totalSpend,
      lastVisit: c.lastVisit,
      visits: c.visits,
    });
    const bySpend = (a: any, b: any) => b.totalSpend - a.totalSpend;

    const churnRate = pct(churned.length, activeLast.length);

    res.json({
      month: thisKey,
      previousMonth: lastKey,
      summary: {
        activeThisMonth: activeThis.length,
        activeLastMonth: activeLast.length,
        newCustomers: newCustomers.length,
        retainedCustomers: retained.length,
        reactivatedCustomers: reactivated.length,
        churnedCustomers: churned.length,
        newPct: pct(newCustomers.length, activeThis.length),
        retainedPct: pct(retained.length, activeThis.length),
        reactivatedPct: pct(reactivated.length, activeThis.length),
        churnRate, // churned as % of last month's active base
        retentionRate: pct(retained.length, activeLast.length),
        revenueThisMonth: revThis,
        revenueLastMonth: revLast,
        revenueDropPct: revLast > 0 ? Math.round(((revLast - revThis) / revLast) * 1000) / 10 : 0,
        customerDropPct: pct(activeLast.length - activeThis.length, activeLast.length),
        alert: churnRate >= 10,
      },
      missed,
      cohorts: {
        new: newCustomers.map(member).sort(bySpend),
        retained: retained.map(member).sort(bySpend),
        reactivated: reactivated.map(member).sort(bySpend),
        churned: churned.map(member).sort(bySpend),
      },
    });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// GET /api/v2/salons/:salonId/at-risk - Customers overdue vs their own visit cadence.
// Ranks a "reach out now" list: each customer's average gap between visits vs days
// since last seen. High value + most overdue floats to the top.
router.get('/:salonId/at-risk', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const salon = await findOwnedSalon(req.params.salonId, req.user);
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const bookings = await prisma.booking.findMany({
      where: { salonId: req.params.salonId, status: { in: ['COMPLETED', 'CONFIRMED'] } },
      include: { customer: true },
      orderBy: { slotStart: 'asc' },
    });

    const DAY = 24 * 60 * 60 * 1000;
    const DEFAULT_CADENCE = 45; // for single-visit customers with no rhythm yet
    const OVERDUE_FACTOR = 1.3; // overdue once past 1.3x their normal gap
    const now = Date.now();

    type C = { id: string; name: string | null; phone: string; dates: number[]; spend: number };
    const byCustomer = new Map<string, C>();
    for (const b of bookings) {
      const c = byCustomer.get(b.customerId) ?? {
        id: b.customerId, name: b.customer?.name ?? null, phone: b.customer?.phone ?? '',
        dates: [], spend: 0,
      };
      c.dates.push(b.slotStart.getTime());
      c.spend += b.price;
      byCustomer.set(b.customerId, c);
    }

    const atRisk = [];
    for (const c of byCustomer.values()) {
      const last = Math.max(...c.dates);
      const daysSince = Math.round((now - last) / DAY);
      if (daysSince <= 0 || daysSince > 400) continue; // seen today / ancient → skip

      let cadence = DEFAULT_CADENCE;
      if (c.dates.length >= 2) {
        const sorted = [...c.dates].sort((a, b) => a - b);
        let gapSum = 0;
        for (let i = 1; i < sorted.length; i++) gapSum += (sorted[i] - sorted[i - 1]) / DAY;
        cadence = Math.max(7, Math.round(gapSum / (sorted.length - 1)));
      }

      const overdueRatio = daysSince / cadence;
      if (overdueRatio < OVERDUE_FACTOR) continue; // still within their normal rhythm

      atRisk.push({
        customerId: c.id,
        name: c.name,
        phone: c.phone,
        visits: c.dates.length,
        totalSpend: c.spend,
        lastVisit: new Date(last).toISOString(),
        daysSince,
        cadenceDays: cadence,
        overdueDays: Math.max(0, daysSince - cadence),
        overdueRatio: Math.round(overdueRatio * 10) / 10,
        // priority = value weighted by how overdue (capped so one whale can't hog the list)
        score: c.spend * Math.min(overdueRatio, 3),
      });
    }

    atRisk.sort((a, b) => b.score - a.score);

    res.json({
      count: atRisk.length,
      atRiskRevenue: atRisk.reduce((t, c) => t + c.totalSpend, 0),
      customers: atRisk.slice(0, 40),
    });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// GET /api/v2/salons/:salonId/customers/:customerId - Salon-owned customer notes/tags.
router.get('/:salonId/customers/:customerId', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { salonId, customerId } = req.params;
    const salon = await findOwnedSalon(salonId, req.user);
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const record = await prisma.salonCustomer.findUnique({
      where: { salonId_customerId: { salonId, customerId } },
    });

    res.json(record ?? { salonId, customerId, notes: '', tags: [] });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// PATCH /api/v2/salons/:salonId/customers/:customerId - Save salon-owned customer notes/tags.
router.patch('/:salonId/customers/:customerId', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { salonId, customerId } = req.params;
    const salon = await findOwnedSalon(salonId, req.user);
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const tags = Array.isArray(req.body.tags)
      ? req.body.tags.map((tag: unknown) => String(tag).trim()).filter(Boolean)
      : [];

    const record = await prisma.salonCustomer.upsert({
      where: { salonId_customerId: { salonId, customerId } },
      update: {
        notes: String(req.body.notes ?? ''),
        tags,
      },
      create: {
        salonId,
        customerId,
        notes: String(req.body.notes ?? ''),
        tags,
      },
    });

    res.json(record);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// POST /api/v2/salons/:salonId/stylists/:stylistId/make-exclusive
router.post('/:salonId/stylists/:stylistId/make-exclusive', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { salonId, stylistId } = req.params;

    const result = await prisma.$transaction(async (tx) => {
      // 1. Update SalonStylist
      await tx.salonStylist.upsert({
        where: { salonId_stylistId: { salonId, stylistId } },
        update: { exclusive: true, status: 'ACTIVE' },
        create: { salonId, stylistId, exclusive: true, status: 'ACTIVE' },
      });

      // 2. Update Stylist - disable independent + home service
      const stylist = await tx.stylist.update({
        where: { id: stylistId },
        data: {
          registrationType: 'SALON_EXCLUSIVE',
          primarySalonId: salonId,
          independentBookingEnabled: false,
          homeServiceEnabled: false,
        },
        include: { user: true, primarySalon: true },
      });

      // 3. Terminate other salon relationships
      await tx.salonStylist.updateMany({
        where: { stylistId, salonId: { not: salonId } },
        data: { status: 'TERMINATED' },
      });

      return stylist;
    });

    res.json(result);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// PATCH /api/v2/salons/:salonId/stylists/:stylistId
router.patch('/:salonId/stylists/:stylistId', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { salonId, stylistId } = req.params;
    const { canSetOwnPrice } = req.body;

    const salon = await findOwnedSalon(salonId, req.user);
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const updated = await prisma.salonStylist.update({
      where: { salonId_stylistId: { salonId, stylistId } },
      data: { canSetOwnPrice },
    });

    res.json(updated);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// POST /api/v2/salons/:salonId/staff-setup - Create a staff member with a
// starter service and default Mon-Sat hours in one atomic step. Replaces a
// client-side chain of ~9 sequential requests (create stylist, make
// exclusive, add service, add 6 availability rows) that had no rollback: if
// any request after the first failed, the phone number was left "used up"
// by a half-created stylist with no service or hours, and the admin had no
// way to finish or retry with the same phone.
router.post('/:salonId/staff-setup', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { salonId } = req.params;
    const { name, phone, serviceName, basePrice, startTime, endTime, days } = req.body;

    if (
      !name || String(name).trim().length < 2 ||
      !phone || String(phone).trim().length < 6 ||
      !serviceName || String(serviceName).trim().length < 2 ||
      typeof basePrice !== 'number' || basePrice < 1
    ) {
      return res.status(400).json({
        error: 'name, phone, serviceName and basePrice are required',
      });
    }

    // Working hours are now owner-settable; fall back to Mon-Sat 09:00-18:00.
    const clock = /^([01]\d|2[0-3]):[0-5]\d$/;
    const openTime = clock.test(String(startTime)) ? String(startTime) : '09:00';
    const closeTime = clock.test(String(endTime)) ? String(endTime) : '18:00';
    const workDays: number[] = Array.isArray(days) && days.length
      ? [...new Set(days.filter((d: any) => Number.isInteger(d) && d >= 0 && d <= 6))] as number[]
      : [1, 2, 3, 4, 5, 6];

    const salon = await findOwnedSalon(salonId, req.user);
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const normalizedPhone = String(phone).trim();
    const existingUser = await prisma.user.findUnique({ where: { phone: normalizedPhone } });
    if (existingUser) {
      return res.status(409).json({ error: 'That staff phone is already in use' });
    }

    const stylist = await prisma.$transaction(async (tx) => {
      const user = await tx.user.create({
        data: {
          phone: normalizedPhone,
          name: String(name).trim(),
          role: 'STYLIST',
          password: disabledPassword,
        },
      });

      const createdStylist = await tx.stylist.create({
        data: {
          userId: user.id,
          registrationType: 'SALON_EXCLUSIVE',
          primarySalonId: salonId,
          independentBookingEnabled: false,
          homeServiceEnabled: false,
          basePrice,
        },
      });

      await tx.salonStylist.create({
        data: { salonId, stylistId: createdStylist.id, exclusive: true, status: 'ACTIVE' },
      });

      await tx.service.create({
        data: {
          name: String(serviceName).trim(),
          category: 'Salon',
          duration: 60,
          stylistId: createdStylist.id,
          salonId,
          basePrice,
        },
      });

      for (const dayOfWeek of workDays) {
        await tx.stylistAvailability.create({
          data: { stylistId: createdStylist.id, dayOfWeek, startTime: openTime, endTime: closeTime },
        });
      }

      return tx.stylist.findUniqueOrThrow({
        where: { id: createdStylist.id },
        include: { user: true, services: true },
      });
    });

    res.status(201).json(stylist);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

export default router;
