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
      products: { where: { deletedAt: null } },
      owner: true,
      stylists: {
        // Include TERMINATED relations too — the admin app's Staff tab needs
        // them to let owners re-activate a deactivated stylist (that toggle
        // only lives inside the staff card, so hiding terminated relations
        // here made them permanently unreachable). Consumers that must stay
        // active-only (booking/service staff pickers) filter client-side.
        where: { stylist: { deletedAt: null } },
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

  // Cheap per-branch "today" summary so the branch switcher can show a real
  // comparison (revenue/bookings) between branches without the client
  // fetching each branch's full bookings list just to render the switcher.
  const salonIds = salons.map((s) => s.id);
  const todayStart = istStartOfDay(new Date());
  const todaysBookings = salonIds.length
    ? await prisma.booking.findMany({
        where: {
          salonId: { in: salonIds },
          status: 'COMPLETED',
          OR: [
            { completedAt: { gte: todayStart } },
            { completedAt: null, createdAt: { gte: todayStart } },
          ],
        },
        select: { salonId: true, price: true },
      })
    : [];
  const statsBySalon = new Map<string, { count: number; revenue: number }>();
  for (const b of todaysBookings) {
    if (!b.salonId) continue;
    const existing = statsBySalon.get(b.salonId) ?? { count: 0, revenue: 0 };
    existing.count += 1;
    existing.revenue += b.price;
    statsBySalon.set(b.salonId, existing);
  }

  const withStats = salons.map((s) => ({
    ...s,
    todayStats: statsBySalon.get(s.id) ?? { count: 0, revenue: 0 },
  }));

  res.json(withStats);
});

// POST /api/v2/salons - Add a branch to the current owner's account. Sibling
// to /api/v2/auth/salon-signup's salon-creation half (same required fields),
// but for an owner who already has a User row — no transaction needed here
// since there's no User to create alongside it.
router.post('/', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { name, address, lat = 0, lng = 0, countryCode, currency } = req.body;
    if (!name || !address) {
      return res.status(400).json({ error: 'name and address are required' });
    }

    const salon = await prisma.salon.create({
      data: {
        ownerId: req.user!.id,
        name: String(name).trim(),
        address: String(address).trim(),
        lat: Number(lat) || 0,
        lng: Number(lng) || 0,
        ...(countryCode ? { countryCode: String(countryCode).trim().toUpperCase() } : {}),
        ...(currency ? { currency: String(currency).trim().toUpperCase() } : {}),
      },
    });

    res.status(201).json(salon);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// PATCH /api/v2/salons/:salonId - Update one specific branch's profile.
// Mirrors the salon-scoped PATCH pattern used everywhere else in this file.
// This is what v4_1+ calls for salon fields instead of the legacy combined
// PATCH /api/v2/auth/me body (see the compatibility shim there for why that
// endpoint still accepts these fields too, for single-salon v3 accounts).
router.patch('/:salonId', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { salonId } = req.params;
    const { name, address, lat, lng, countryCode, currency, dailyRevenueGoal } = req.body;

    const salon = await findOwnedSalon(salonId, req.user);
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const nextName = name == null ? salon.name : String(name).trim();
    const nextAddress = address == null ? salon.address : String(address).trim();
    if (!nextName || !nextAddress) {
      return res.status(400).json({ error: 'Salon name and address are required' });
    }

    const updated = await prisma.salon.update({
      where: { id: salonId },
      data: {
        name: nextName,
        address: nextAddress,
        ...(lat != null && Number.isFinite(Number(lat)) ? { lat: Number(lat) } : {}),
        ...(lng != null && Number.isFinite(Number(lng)) ? { lng: Number(lng) } : {}),
        ...(countryCode ? { countryCode: String(countryCode).trim().toUpperCase() } : {}),
        ...(currency ? { currency: String(currency).trim().toUpperCase() } : {}),
        ...(dailyRevenueGoal != null && Number.isFinite(Number(dailyRevenueGoal))
          ? { dailyRevenueGoal: Math.max(0, Math.round(Number(dailyRevenueGoal))) }
          : {}),
      },
    });

    res.json(updated);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
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

// GET /api/v2/salons/:salonId/earnings?period=day|week|month
// Sums COMPLETED bookings by their earned date (completedAt, falling back to
// createdAt for older records). Day buckets are computed in IST (India).
const IST_OFFSET_MS = 330 * 60 * 1000;
function istDayKey(d: Date) {
  return new Date(d.getTime() + IST_OFFSET_MS).toISOString().slice(0, 10);
}
function istStartOfDay(d: Date) {
  const shifted = new Date(d.getTime() + IST_OFFSET_MS);
  shifted.setUTCHours(0, 0, 0, 0);
  return new Date(shifted.getTime() - IST_OFFSET_MS);
}
// Shared by /earnings and /earnings/export: the full (unsliced) set of
// completed bookings within the requested period, plus the same-length
// prior window for a growth comparison. /earnings aggregates+truncates this
// for the dashboard payload; /earnings/export maps the full `inRange` to CSV
// rows so exports aren't silently capped at the dashboard's 50-row display
// limit.
async function getEarningsRange(salonId: string, periodParam: unknown) {
  const period = ['day', 'week', 'month'].includes(String(periodParam)) ? String(periodParam) : 'day';
  const days = period === 'day' ? 1 : period === 'week' ? 7 : 30;

  const now = new Date();
  const from = istStartOfDay(now);
  from.setUTCDate(from.getUTCDate() - (days - 1));

  const completed = await prisma.booking.findMany({
    where: { salonId, status: 'COMPLETED' },
    select: {
      id: true,
      price: true,
      completedAt: true,
      createdAt: true,
      paymentMethod: true,
      customer: { select: { name: true, phone: true } },
      service: { select: { name: true } },
      stylistId: true,
      stylist: { select: { user: { select: { name: true } } } },
      stylistPayout: true,
      payoutId: true,
    },
    orderBy: { createdAt: 'desc' },
  });

  const earnedAt = (b: { completedAt: Date | null; createdAt: Date }) => b.completedAt ?? b.createdAt;
  const inRange = completed.filter((b) => {
    const d = earnedAt(b);
    return d >= from && d <= now;
  });

  // Same-length window immediately before `from`, so the owner can see
  // "am I growing?" at a glance instead of just a raw total in isolation.
  const previousFrom = new Date(from);
  previousFrom.setUTCDate(previousFrom.getUTCDate() - days);
  const previousRange = completed.filter((b) => {
    const d = earnedAt(b);
    return d >= previousFrom && d < from;
  });

  return { period, days, now, from, inRange, previousRange, earnedAt };
}

router.get('/:salonId/earnings', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { salonId } = req.params;
    const salon = await findOwnedSalon(salonId, req.user);
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const { period, days, now, from, inRange, previousRange, earnedAt } = await getEarningsRange(
      salonId,
      req.query.period,
    );

    // Seed every day in the range so the chart has no gaps.
    const byDay = new Map<string, { total: number; count: number }>();
    for (let i = days - 1; i >= 0; i -= 1) {
      const d = new Date(now.getTime() - i * 24 * 60 * 60 * 1000);
      byDay.set(istDayKey(d), { total: 0, count: 0 });
    }
    for (const b of inRange) {
      const bucket = byDay.get(istDayKey(earnedAt(b)));
      if (bucket) {
        bucket.total += b.price;
        bucket.count += 1;
      }
    }

    // Which services actually make money — guides what to promote/staff for.
    const serviceTotals = new Map<string, { total: number; count: number }>();
    for (const b of inRange) {
      const name = b.service?.name ?? 'Service';
      const bucket = serviceTotals.get(name) ?? { total: 0, count: 0 };
      bucket.total += b.price;
      bucket.count += 1;
      serviceTotals.set(name, bucket);
    }
    const topServices = [...serviceTotals.entries()]
      .map(([name, v]) => ({ name, ...v }))
      .sort((a, b) => b.total - a.total)
      .slice(0, 5);

    // Per-stylist leaderboard for the selected period (staff cards on the
    // Staff tab only ever show "today").
    const stylistTotals = new Map<string, { name: string; total: number; count: number }>();
    for (const b of inRange) {
      if (!b.stylistId) continue;
      const bucket = stylistTotals.get(b.stylistId) ?? {
        name: b.stylist?.user?.name ?? 'Staff',
        total: 0,
        count: 0,
      };
      bucket.total += b.price;
      bucket.count += 1;
      stylistTotals.set(b.stylistId, bucket);
    }
    const byStylist = [...stylistTotals.entries()]
      .map(([stylistId, v]) => ({ stylistId, ...v }))
      .sort((a, b) => b.total - a.total);

    res.json({
      period,
      from,
      to: now,
      total: inRange.reduce((sum, b) => sum + b.price, 0),
      count: inRange.length,
      previousTotal: previousRange.reduce((sum, b) => sum + b.price, 0),
      daily: [...byDay.entries()].map(([date, v]) => ({ date, ...v })),
      topServices,
      byStylist,
      bookings: inRange.slice(0, 50).map((b) => ({
        id: b.id,
        at: earnedAt(b),
        customerName: b.customer?.name ?? b.customer?.phone ?? 'Customer',
        serviceName: b.service?.name ?? '',
        price: b.price,
        paymentMethod: b.paymentMethod,
      })),
    });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

function csvCell(value: string | number): string {
  const s = String(value);
  return /[",\n]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s;
}

// GET /api/v2/salons/:salonId/earnings/export?period=day|week|month - Same
// range as /earnings, but the FULL (unsliced) completed-bookings list as a
// downloadable CSV — /earnings truncates its `bookings` field to 50 rows for
// the in-app list, which would silently under-report any period with more
// completed bookings than that.
router.get('/:salonId/earnings/export', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { salonId } = req.params;
    const salon = await findOwnedSalon(salonId, req.user);
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const { period, inRange, earnedAt } = await getEarningsRange(salonId, req.query.period);

    const header = ['Date', 'Time', 'Customer', 'Stylist', 'Service', 'Price', 'Payment method'];
    const rows = inRange.map((b) => {
      const at = new Date(earnedAt(b).getTime() + IST_OFFSET_MS);
      const date = at.toISOString().slice(0, 10);
      const time = at.toISOString().slice(11, 16);
      return [
        date,
        time,
        b.customer?.name ?? b.customer?.phone ?? 'Customer',
        b.stylist?.user?.name ?? '',
        b.service?.name ?? '',
        (b.price / 100).toFixed(2),
        b.paymentMethod ?? '',
      ];
    });

    const csv = [header, ...rows].map((row) => row.map(csvCell).join(',')).join('\n');
    const filename = `earnings-${period}-${new Date().toISOString().slice(0, 10)}.csv`;
    res.type('text/csv').attachment(filename).send(csv);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// GET /api/v2/salons/:salonId/customers/:customerId - Salon-owned customer notes/tags.
// GET /api/v2/salons/:salonId/customers - Distinct customers this salon has served,
// most recent first. Powers customer autocomplete in the manual-booking sheet.
router.get('/:salonId/customers', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { salonId } = req.params;
    const salon = await findOwnedSalon(salonId, req.user);
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const bookings = await prisma.booking.findMany({
      where: { salonId },
      select: {
        customerId: true,
        createdAt: true,
        customer: { select: { name: true, phone: true } },
      },
      orderBy: { createdAt: 'desc' },
    });

    const seen = new Set<string>();
    const customers: { id: string; name: string | null; phone: string }[] = [];
    for (const b of bookings) {
      if (seen.has(b.customerId)) continue;
      seen.add(b.customerId);
      customers.push({
        id: b.customerId,
        name: b.customer?.name ?? null,
        phone: b.customer?.phone ?? '',
      });
    }

    res.json(customers);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

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
      // 1. Update SalonStylist — same salon-default-commission fallback as
      // the add-staff flow (see there for why): use the salon's own
      // admin-set default if one exists, else the long-standing 70%.
      const salonForDefault = await tx.salon.findUnique({ where: { id: salonId }, select: { commissionRate: true } });
      const defaultCommissionRate =
        salonForDefault && salonForDefault.commissionRate > 0 ? salonForDefault.commissionRate : 70;

      await tx.salonStylist.upsert({
        where: { salonId_stylistId: { salonId, stylistId } },
        update: { exclusive: true, status: 'ACTIVE' },
        create: { salonId, stylistId, exclusive: true, status: 'ACTIVE', commissionRate: defaultCommissionRate },
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
    const { canSetOwnPrice, canCancelBooking, status, payType, commissionRate, salaryAmount } = req.body;

    // Only ACTIVE<->TERMINATED is an owner-facing toggle (an "active/inactive"
    // switch on the Staff screen) — PENDING is system-set when a relationship
    // is first created and isn't something the owner flips to directly.
    if (status != null && !['ACTIVE', 'TERMINATED'].includes(status)) {
      return res.status(400).json({ error: 'status must be ACTIVE or TERMINATED' });
    }
    if (payType != null && !['COMMISSION', 'SALARY', 'BOTH'].includes(payType)) {
      return res.status(400).json({ error: 'payType must be COMMISSION, SALARY, or BOTH' });
    }
    if (commissionRate != null && (typeof commissionRate !== 'number' || commissionRate < 0 || commissionRate > 100)) {
      return res.status(400).json({ error: 'commissionRate must be a number between 0 and 100' });
    }
    if (salaryAmount != null && (typeof salaryAmount !== 'number' || salaryAmount < 0)) {
      return res.status(400).json({ error: 'salaryAmount must be a non-negative number' });
    }

    const salon = await findOwnedSalon(salonId, req.user);
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const updated = await prisma.salonStylist.update({
      where: { salonId_stylistId: { salonId, stylistId } },
      data: { canSetOwnPrice, canCancelBooking, status, payType, commissionRate, salaryAmount },
    });

    res.json(updated);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// GET /api/v2/salons/:salonId/stylists/:stylistId/earnings?period=day|week|month
// Per-stylist view of the same range /earnings computes salon-wide, plus
// unpaidTotal — the real gap this fills: /earnings' byStylist leaderboard
// sums gross price, never stylistPayout, so nothing previously showed what a
// stylist is actually owed. unpaidTotal is intentionally NOT period-filtered
// (it's "everything unpaid right now," which can span period boundaries).
router.get(
  '/:salonId/stylists/:stylistId/earnings',
  requireRole('SALON_OWNER', 'SUPER_ADMIN'),
  async (req, res) => {
    try {
      const { salonId, stylistId } = req.params;
      const salon = await findOwnedSalon(salonId, req.user);
      if (!salon) return res.status(404).json({ error: 'Salon not found' });

      const { period, from, now, inRange } = await getEarningsRange(salonId, req.query.period);
      const stylistRange = inRange.filter((b) => b.stylistId === stylistId);

      const unpaid = await prisma.booking.aggregate({
        where: { salonId, stylistId, status: 'COMPLETED', payoutId: null },
        _sum: { stylistPayout: true },
        _count: true,
      });

      const relation = await prisma.salonStylist.findUnique({
        where: { salonId_stylistId: { salonId, stylistId } },
      });
      const salaryMonth = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;
      const salaryPaid = relation
        ? await prisma.stylistPayout.findFirst({
            where: { salonId, stylistId, isSalaryPayout: true, salaryMonth },
          })
        : null;

      res.json({
        period,
        from,
        to: now,
        grossRevenue: stylistRange.reduce((sum, b) => sum + b.price, 0),
        totalPayout: stylistRange.reduce((sum, b) => sum + b.stylistPayout, 0),
        count: stylistRange.length,
        unpaidTotal: unpaid._sum.stylistPayout ?? 0,
        unpaidCount: unpaid._count,
        payType: relation?.payType ?? 'COMMISSION',
        salaryAmount: relation?.salaryAmount ?? 0,
        salaryPaidThisMonth: !!salaryPaid,
      });
    } catch (e: any) {
      res.status(500).json({ error: e.message });
    }
  },
);

// POST /api/v2/salons/:salonId/stylists/:stylistId/payouts - Settle a batch
// of unpaid commission: sums COMPLETED bookings for this stylist with
// payoutId null in [periodStart, periodEnd], creates a StylistPayout, and
// links those bookings to it (payoutId set) so they drop out of "unpaid."
router.post(
  '/:salonId/stylists/:stylistId/payouts',
  requireRole('SALON_OWNER', 'SUPER_ADMIN'),
  async (req, res) => {
    try {
      const { salonId, stylistId } = req.params;
      const { type } = req.body ?? {};

      const salon = await findOwnedSalon(salonId, req.user);
      if (!salon) return res.status(404).json({ error: 'Salon not found' });

      // Fixed-salary settlement — separate from the bookings-based path
      // below: no bookings are involved, it's just "pay this month's
      // salary," settled once per calendar month.
      if (type === 'SALARY') {
        const relation = await prisma.salonStylist.findUnique({
          where: { salonId_stylistId: { salonId, stylistId } },
        });
        if (!relation || relation.salaryAmount <= 0) {
          return res.status(400).json({ error: 'This stylist has no salary amount set' });
        }
        const now = new Date();
        const salaryMonth = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;
        const alreadyPaid = await prisma.stylistPayout.findFirst({
          where: { salonId, stylistId, isSalaryPayout: true, salaryMonth },
        });
        if (alreadyPaid) {
          return res.status(400).json({ error: 'Salary already paid for this month' });
        }
        const payout = await prisma.stylistPayout.create({
          data: {
            salonId,
            stylistId,
            periodStart: new Date(now.getFullYear(), now.getMonth(), 1),
            periodEnd: now,
            grossRevenue: 0,
            totalPayout: relation.salaryAmount,
            bookingCount: 0,
            paidBy: req.user!.id,
            note: `Salary — ${salaryMonth}`,
            isSalaryPayout: true,
            salaryMonth,
          },
        });
        return res.status(201).json(payout);
      }

      const { periodStart, periodEnd, note } = req.body ?? {};

      const start = new Date(periodStart);
      const end = new Date(periodEnd);
      if (Number.isNaN(start.getTime()) || Number.isNaN(end.getTime()) || start > end) {
        return res.status(400).json({ error: 'Valid periodStart and periodEnd are required' });
      }

      const eligible = await prisma.booking.findMany({
        where: {
          salonId,
          stylistId,
          status: 'COMPLETED',
          payoutId: null,
          OR: [
            { completedAt: { gte: start, lte: end } },
            { completedAt: null, createdAt: { gte: start, lte: end } },
          ],
        },
        select: { id: true, price: true, stylistPayout: true },
      });

      if (eligible.length === 0) {
        return res.status(400).json({ error: 'No unpaid bookings in this period' });
      }

      const grossRevenue = eligible.reduce((sum, b) => sum + b.price, 0);
      const totalPayout = eligible.reduce((sum, b) => sum + b.stylistPayout, 0);

      const payout = await prisma.$transaction(async (tx) => {
        const created = await tx.stylistPayout.create({
          data: {
            salonId,
            stylistId,
            periodStart: start,
            periodEnd: end,
            grossRevenue,
            totalPayout,
            bookingCount: eligible.length,
            paidBy: req.user!.id,
            note: note ? String(note).trim() : null,
          },
        });
        await tx.booking.updateMany({
          where: { id: { in: eligible.map((b) => b.id) } },
          data: { payoutId: created.id },
        });
        return created;
      });

      res.status(201).json(payout);
    } catch (e: any) {
      res.status(500).json({ error: e.message });
    }
  },
);

// GET /api/v2/salons/:salonId/stylists/:stylistId/payouts - Settlement history, newest first.
router.get(
  '/:salonId/stylists/:stylistId/payouts',
  requireRole('SALON_OWNER', 'SUPER_ADMIN'),
  async (req, res) => {
    try {
      const { salonId, stylistId } = req.params;
      const salon = await findOwnedSalon(salonId, req.user);
      if (!salon) return res.status(404).json({ error: 'Salon not found' });

      const payouts = await prisma.stylistPayout.findMany({
        where: { salonId, stylistId },
        orderBy: { paidAt: 'desc' },
      });
      res.json(payouts);
    } catch (e: any) {
      res.status(500).json({ error: e.message });
    }
  },
);

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

      // Salon.commissionRate (super-admin-editable) is the salon's own default
      // for newly-added staff, when an admin has actually set one — falls back
      // to the same 70% every SalonStylist relation has always defaulted to
      // otherwise, so this is behavior-neutral for every salon that's never
      // had this field touched.
      const defaultCommissionRate = salon.commissionRate > 0 ? salon.commissionRate : 70;

      await tx.salonStylist.create({
        data: {
          salonId,
          stylistId: createdStylist.id,
          exclusive: true,
          status: 'ACTIVE',
          commissionRate: defaultCommissionRate,
        },
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

// Validates that stylistId (if given) is an active stylist of this salon,
// so a service can't be assigned to staff from a different salon. Returns
// true if stylistId is null/empty (unassigned is always valid) or valid.
async function isActiveStylistOfSalon(salonId: string, stylistId: unknown) {
  if (stylistId == null || stylistId === '') return true;
  const membership = await prisma.salonStylist.findFirst({
    where: { salonId, stylistId: String(stylistId), status: 'ACTIVE' },
  });
  return membership != null;
}

// GET /api/v2/salons/:salonId/services - Salon-wide service catalog (v4
// Services tab). Distinct from the existing stylist-scoped
// /api/v2/stylists/:id/services routes: those manage what one stylist
// personally offers, this manages the salon's catalog independent of staff.
// Optionally assigned to one staff member (stylistId) so the owner can see
// who a given service belongs to; unassigned services are usable by any
// stylist as a booking fallback (see mobile new_booking_sheet.dart).
router.get('/:salonId/services', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const salon = await findOwnedSalon(req.params.salonId, req.user);
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const services = await prisma.service.findMany({
      where: { salonId: req.params.salonId },
      orderBy: [{ category: 'asc' }, { name: 'asc' }],
      include: { stylist: { include: { user: true } } },
    });

    res.json(services);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// POST /api/v2/salons/:salonId/services - Add a salon-wide service.
router.post('/:salonId/services', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const salon = await findOwnedSalon(req.params.salonId, req.user);
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const { name, category = 'Salon', duration = 60, basePrice, stylistId } = req.body ?? {};
    if (!name || String(name).trim().length < 2) {
      return res.status(400).json({ error: 'Service name is required' });
    }
    if (!(await isActiveStylistOfSalon(req.params.salonId, stylistId))) {
      return res.status(400).json({ error: 'Selected staff member is not active at this salon' });
    }

    const service = await prisma.service.create({
      data: {
        salonId: req.params.salonId,
        stylistId: stylistId || null,
        name: String(name).trim(),
        category: String(category || 'Salon').trim(),
        duration: Math.max(15, Number(duration || 60)),
        basePrice: Math.max(0, Number(basePrice ?? 0)),
      },
      include: { stylist: { include: { user: true } } },
    });

    res.status(201).json(service);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// PATCH /api/v2/salons/:salonId/services/:serviceId - Update a catalog service.
router.patch('/:salonId/services/:serviceId', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const salon = await findOwnedSalon(req.params.salonId, req.user);
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const service = await prisma.service.findFirst({
      where: { id: req.params.serviceId, salonId: req.params.salonId },
    });
    if (!service) return res.status(404).json({ error: 'Service not found' });

    const { name, category, duration, basePrice, stylistId } = req.body ?? {};
    if (stylistId !== undefined && !(await isActiveStylistOfSalon(req.params.salonId, stylistId))) {
      return res.status(400).json({ error: 'Selected staff member is not active at this salon' });
    }

    const data: any = {};
    if (name != null) data.name = String(name).trim();
    if (category != null) data.category = String(category || 'Salon').trim();
    if (duration != null) data.duration = Math.max(15, Number(duration));
    if (basePrice != null) data.basePrice = Math.max(0, Number(basePrice));
    if (stylistId !== undefined) data.stylistId = stylistId || null;

    const updated = await prisma.service.update({
      where: { id: req.params.serviceId },
      data,
      include: { stylist: { include: { user: true } } },
    });
    res.json(updated);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// DELETE /api/v2/salons/:salonId/services/:serviceId - Remove a catalog service.
router.delete('/:salonId/services/:serviceId', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const salon = await findOwnedSalon(req.params.salonId, req.user);
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const service = await prisma.service.findFirst({
      where: { id: req.params.serviceId, salonId: req.params.salonId },
    });
    if (!service) return res.status(404).json({ error: 'Service not found' });

    await prisma.service.delete({ where: { id: req.params.serviceId } });
    res.json({ ok: true });
  } catch (e: any) {
    if (e.code === 'P2003') {
      return res.status(400).json({
        error: 'This service already has bookings, so edit it instead of deleting.',
      });
    }
    res.status(500).json({ error: e.message });
  }
});

// GET /api/v2/salons/:salonId/products - Retail inventory catalog.
router.get('/:salonId/products', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const salon = await findOwnedSalon(req.params.salonId, req.user);
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const products = await prisma.product.findMany({
      where: { salonId: req.params.salonId, deletedAt: null },
      orderBy: [{ category: 'asc' }, { name: 'asc' }],
    });

    res.json(products);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// POST /api/v2/salons/:salonId/products - Add a retail product.
router.post('/:salonId/products', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const salon = await findOwnedSalon(req.params.salonId, req.user);
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const { name, category = 'Retail', sku, retailPrice, stockQty = 0, lowStockThreshold = 5 } = req.body ?? {};
    if (!name || String(name).trim().length < 2) {
      return res.status(400).json({ error: 'Product name is required' });
    }
    if (typeof retailPrice !== 'number' || retailPrice < 0) {
      return res.status(400).json({ error: 'retailPrice is required' });
    }

    const product = await prisma.product.create({
      data: {
        salonId: req.params.salonId,
        name: String(name).trim(),
        category: String(category || 'Retail').trim(),
        sku: sku ? String(sku).trim() : null,
        retailPrice: Math.max(0, Number(retailPrice)),
        stockQty: Math.max(0, Number(stockQty || 0)),
        lowStockThreshold: Math.max(0, Number(lowStockThreshold ?? 5)),
      },
    });

    res.status(201).json(product);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// PATCH /api/v2/salons/:salonId/products/:productId - Update a product (incl. restocking).
router.patch('/:salonId/products/:productId', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const salon = await findOwnedSalon(req.params.salonId, req.user);
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const product = await prisma.product.findFirst({
      where: { id: req.params.productId, salonId: req.params.salonId, deletedAt: null },
    });
    if (!product) return res.status(404).json({ error: 'Product not found' });

    const { name, category, sku, retailPrice, stockQty, lowStockThreshold } = req.body ?? {};
    const data: any = {};
    if (name != null) data.name = String(name).trim();
    if (category != null) data.category = String(category || 'Retail').trim();
    if (sku !== undefined) data.sku = sku ? String(sku).trim() : null;
    if (retailPrice != null) data.retailPrice = Math.max(0, Number(retailPrice));
    if (stockQty != null) data.stockQty = Math.max(0, Number(stockQty));
    if (lowStockThreshold != null) data.lowStockThreshold = Math.max(0, Number(lowStockThreshold));

    const updated = await prisma.product.update({ where: { id: req.params.productId }, data });
    res.json(updated);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// DELETE /api/v2/salons/:salonId/products/:productId - Soft-delete a product
// (unlike Service's hard delete — stock/sales history will reference
// products later, so start soft to avoid a second migration for that).
router.delete('/:salonId/products/:productId', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const salon = await findOwnedSalon(req.params.salonId, req.user);
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const product = await prisma.product.findFirst({
      where: { id: req.params.productId, salonId: req.params.salonId, deletedAt: null },
    });
    if (!product) return res.status(404).json({ error: 'Product not found' });

    await prisma.product.update({ where: { id: req.params.productId }, data: { deletedAt: new Date() } });
    res.json({ ok: true });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

export default router;
