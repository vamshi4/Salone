import { Router } from 'express';
import { prisma } from '../index';
import { requireRole } from '../auth';

const router = Router();
const disabledPassword = 'disabled';

const stylistInclude = {
  user: true,
  primarySalon: true,
  services: true,
  salonStylists: {
    include: {
      salon: true,
    },
  },
};

function withMobileFields(stylist: any) {
  const servicePrices = stylist.services
    .map((service: any) => service.basePrice)
    .filter((price: unknown): price is number => typeof price === 'number');

  return {
    ...stylist,
    salonName: stylist.primarySalon?.name ?? null,
    canSetOwnPrice:
      stylist.salonStylists?.some(
        (relation: any) => relation.status === 'ACTIVE' && relation.canSetOwnPrice,
      ) ?? false,
    salonPrice: stylist.registrationType === 'SALON_EXCLUSIVE' ? stylist.basePrice : null,
    minPrice:
      stylist.registrationType === 'INDEPENDENT'
        ? Math.min(...servicePrices, stylist.basePrice ?? 999999)
        : null,
  };
}

function canSetServicePrice(stylist: any) {
  if (stylist.registrationType === 'INDEPENDENT') return true;

  return (
    stylist.salonStylists?.some(
      (relation: any) => relation.status === 'ACTIVE' && relation.canSetOwnPrice,
    ) ?? false
  );
}

// Returns true when the acting user may modify this specific stylist record:
// the stylist themself, the owner of a salon they're primary/active-affiliated
// with, or a SUPER_ADMIN. Every mutating route below previously had NO check
// here at all — any SALON_OWNER could edit/delete any stylist in the system.
async function ownsStylist(
  stylistId: string,
  user: { id: string; role: string },
): Promise<boolean> {
  if (user.role === 'SUPER_ADMIN') return true;

  const stylist = await prisma.stylist.findUnique({
    where: { id: stylistId },
    include: {
      primarySalon: true,
      salonStylists: { where: { status: 'ACTIVE' }, include: { salon: true } },
    },
  });
  if (!stylist) return false;

  if (user.role === 'STYLIST') return stylist.userId === user.id;

  if (stylist.primarySalon?.ownerId === user.id) return true;
  return stylist.salonStylists.some((rel) => rel.salon.ownerId === user.id);
}

function parseClock(value: string): number {
  if (!/^\d{2}:\d{2}$/.test(value)) {
    throw new Error('Time must use HH:mm format');
  }
  const [hours, minutes] = value.split(':').map(Number);
  if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
    throw new Error('Time must be a valid 24-hour value');
  }
  return hours * 60 + (minutes || 0);
}

// Salon timezone is India (Asia/Kolkata, no DST). Build slot instants explicitly
// in IST so availability doesn't depend on the server's timezone — the k8s pod
// runs in UTC, which shifted every slot by +5:30 (9:00 showed as 2:30 PM).
const IST_OFFSET_MIN = 330;

function istWallToUtc(y: number, mo: number, d: number, minutes: number) {
  return new Date(Date.UTC(y, mo - 1, d, 0, minutes - IST_OFFSET_MIN));
}

function sameDate(value: Date) {
  return new Date(value.getFullYear(), value.getMonth(), value.getDate());
}

async function getServiceBundle(stylistId: string, serviceIds: string[]) {
  const stylist = await prisma.stylist.findUnique({
    where: { id: stylistId },
    select: { primarySalonId: true },
  });

  const services = await prisma.service.findMany({
    where: {
      id: { in: serviceIds },
      OR: [
        { stylistId },
        ...(stylist?.primarySalonId ? [{ salonId: stylist.primarySalonId }] : []),
      ],
    },
  });

  if (services.length !== serviceIds.length) {
    throw new Error('One or more services were not found for stylist');
  }

  return {
    services,
    duration: services.reduce((total, service) => total + service.duration, 0),
  };
}

async function buildAvailableSlots(
  stylistId: string,
  serviceIds: string[],
  dateText: string,
) {
  const [yy, mm, dd] = dateText.split('-').map(Number);
  if (!yy || !mm || !dd) throw new Error('Invalid date');

  const bundle = await getServiceBundle(stylistId, serviceIds);

  // IST calendar day expressed as a UTC window.
  const date = istWallToUtc(yy, mm, dd, 0);
  const nextDay = new Date(date.getTime() + 24 * 60 * 60 * 1000);
  const weekday = new Date(Date.UTC(yy, mm - 1, dd)).getUTCDay();

  const availability = await prisma.stylistAvailability.findMany({
    where: {
      stylistId,
      OR: [{ date }, { dayOfWeek: weekday, date: null }],
    },
    orderBy: { startTime: 'asc' },
  });

  const workingWindows = availability.filter((item) => !item.isBlocked);
  const blocks = availability.filter((item) => item.isBlocked);
  const windows = workingWindows.length
    ? workingWindows
    : [{ startTime: '09:00', endTime: '18:00' }];

  const bookings = await prisma.booking.findMany({
    where: {
      stylistId,
      status: { in: ['PENDING', 'PENDING_RESCHEDULE', 'CONFIRMED'] },
      slotStart: { lt: nextDay },
      slotEnd: { gt: date },
    },
    select: { id: true, slotStart: true, slotEnd: true },
  });

  const now = new Date();
  const slots: Array<{ dateTime: string; label: string }> = [];

  for (const window of windows) {
    const windowStart = parseClock(window.startTime);
    const windowEnd = parseClock(window.endTime);

    for (
      let minutes = windowStart;
      minutes + bundle.duration <= windowEnd;
      minutes += 30
    ) {
      const start = istWallToUtc(yy, mm, dd, minutes);
      const end = new Date(start.getTime() + bundle.duration * 60 * 1000);
      if (start <= now) continue;

      const blocked = blocks.some((block) => {
        const blockStart = istWallToUtc(yy, mm, dd, parseClock(block.startTime));
        const blockEnd = istWallToUtc(yy, mm, dd, parseClock(block.endTime));
        return start < blockEnd && end > blockStart;
      });

      const busy = bookings.some(
        (booking) => start < booking.slotEnd && end > booking.slotStart,
      );

      if (!blocked && !busy) {
        slots.push({
          dateTime: start.toISOString(),
          label: start.toLocaleTimeString('en-IN', {
            timeZone: 'Asia/Kolkata',
            hour: 'numeric',
            minute: '2-digit',
          }),
        });
      }
    }
  }

  return slots;
}

async function validateAvailabilityRule({
  stylistId,
  dayOfWeek,
  date,
  startTime,
  endTime,
  isBlocked,
}: {
  stylistId: string;
  dayOfWeek: number | null;
  date: Date | null;
  startTime: string;
  endTime: string;
  isBlocked: boolean;
}) {
  const start = parseClock(startTime);
  const end = parseClock(endTime);

  if (start >= end) {
    return 'Start time must be before end time';
  }

  if (!date && (dayOfWeek == null || dayOfWeek < 0 || dayOfWeek > 6)) {
    return 'Choose a valid day of week';
  }

  if (date && Number.isNaN(date.getTime())) {
    return 'Choose a valid date';
  }

  const existingRules = await prisma.stylistAvailability.findMany({
    where: {
      stylistId,
      isBlocked,
      ...(date
        ? { date }
        : {
            dayOfWeek,
            date: null,
          }),
    },
  });

  const overlaps = existingRules.some((rule) => {
    const existingStart = parseClock(rule.startTime);
    const existingEnd = parseClock(rule.endTime);
    return start < existingEnd && end > existingStart;
  });

  if (overlaps) {
    return isBlocked
      ? 'Blocked time overlaps an existing block'
      : 'Working hours overlap an existing rule';
  }

  return null;
}

// GET /api/v2/stylists - List all stylists for customer app.
router.get('/', async (_req, res) => {
  try {
    const stylists = await prisma.stylist.findMany({
      where: { deletedAt: null },
      include: stylistInclude,
      orderBy: {
        user: {
          name: 'asc',
        },
      },
    });

    res.json(stylists.map(withMobileFields));
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// GET /api/v2/stylists/:id/availability?date=YYYY-MM-DD&serviceId=...
// Also supports serviceIds=id1,id2 for multi-service bookings.
router.get('/:id/availability', async (req, res) => {
  try {
    const { id } = req.params;
    const { date, serviceId, serviceIds } = req.query;

    const selectedServiceIds = String(serviceIds || serviceId || '')
      .split(',')
      .map((value) => value.trim())
      .filter(Boolean);

    if (!date || selectedServiceIds.length === 0) {
      return res.status(400).json({ error: 'date and serviceId/serviceIds are required' });
    }

    const slots = await buildAvailableSlots(id, selectedServiceIds, String(date));
    res.json({ date, stylistId: id, serviceIds: selectedServiceIds, slots });
  } catch (e: any) {
    const status = e.message?.includes('not found') ? 404 : 500;
    res.status(status).json({ error: e.message });
  }
});

// POST /api/v2/stylists/:id/availability - Set weekly/specific working hours.
router.post('/:id/availability', requireRole('STYLIST', 'SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { id } = req.params;
    const { dayOfWeek, date, startTime, endTime, isBlocked = false } = req.body;

    if (!startTime || !endTime) {
      return res.status(400).json({ error: 'startTime and endTime are required' });
    }

    const stylist = await prisma.stylist.findUnique({ where: { id } });
    if (!stylist) return res.status(404).json({ error: 'Stylist not found' });

    const normalizedDate = date ? sameDate(new Date(date)) : null;
    const normalizedDay = normalizedDate ? null : Number(dayOfWeek ?? new Date().getDay());
    const validationError = await validateAvailabilityRule({
      stylistId: id,
      dayOfWeek: normalizedDay,
      date: normalizedDate,
      startTime,
      endTime,
      isBlocked,
    });

    if (validationError) return res.status(400).json({ error: validationError });

    const availability = await prisma.stylistAvailability.create({
      data: {
        stylistId: id,
        dayOfWeek: normalizedDay,
        date: normalizedDate,
        startTime,
        endTime,
        isBlocked,
      },
    });

    res.status(201).json(availability);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// GET /api/v2/stylists/:id/availability-rules - List working hours and blocks.
router.get('/:id/availability-rules', async (req, res) => {
  try {
    const rules = await prisma.stylistAvailability.findMany({
      where: { stylistId: req.params.id },
      orderBy: [{ date: 'asc' }, { dayOfWeek: 'asc' }, { startTime: 'asc' }],
    });

    res.json(rules);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// POST /api/v2/stylists/:id/block - Block a specific date/time.
router.post('/:id/block', requireRole('STYLIST', 'SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { id } = req.params;
    const { date, startTime, endTime } = req.body;

    if (!date || !startTime || !endTime) {
      return res.status(400).json({ error: 'date, startTime and endTime are required' });
    }

    const normalizedDate = sameDate(new Date(date));
    const validationError = await validateAvailabilityRule({
      stylistId: id,
      dayOfWeek: null,
      date: normalizedDate,
      startTime,
      endTime,
      isBlocked: true,
    });

    if (validationError) return res.status(400).json({ error: validationError });

    const block = await prisma.stylistAvailability.create({
      data: {
        stylistId: id,
        date: normalizedDate,
        startTime,
        endTime,
        isBlocked: true,
      },
    });

    res.status(201).json(block);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// DELETE /api/v2/stylists/:id/availability/:availabilityId - Remove a rule.
router.delete('/:id/availability/:availabilityId', requireRole('STYLIST', 'SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { id, availabilityId } = req.params;

    const rule = await prisma.stylistAvailability.findFirst({
      where: { id: availabilityId, stylistId: id },
    });

    if (!rule) return res.status(404).json({ error: 'Availability rule not found' });

    await prisma.stylistAvailability.delete({ where: { id: availabilityId } });
    res.json({ ok: true });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// GET /api/v2/stylists/:id - Detail for stylist app.
router.get('/:id', async (req, res) => {
  try {
    const stylist = await prisma.stylist.findUnique({
      where: { id: req.params.id },
      include: stylistInclude,
    });

    if (!stylist) {
      return res.status(404).json({ error: 'Stylist not found' });
    }

    res.json(withMobileFields(stylist));
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// POST /api/v2/stylists - Create stylist for local testing.
router.post('/', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const {
      phone,
      name,
      lat,
      lng,
      registrationType = 'INDEPENDENT',
      homeServiceEnabled = true,
      independentBookingEnabled = true,
      basePrice = 50000,
    } = req.body;

    const user = await prisma.user.create({
      data: { phone, name, role: 'STYLIST', lat, lng, password: disabledPassword },
    });

    const stylist = await prisma.stylist.create({
      data: {
        userId: user.id,
        registrationType,
        independentBookingEnabled,
        lat,
        lng,
        homeServiceEnabled,
        basePrice,
      },
      include: stylistInclude,
    });

    res.json(withMobileFields(stylist));
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// POST /api/v2/stylists/:id/services - Add a bookable service for this stylist.
router.post('/:id/services', requireRole('STYLIST', 'SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { id } = req.params;
    const { name, category = 'Salon', duration = 60, basePrice } = req.body;

    if (!name || String(name).trim().length < 2) {
      return res.status(400).json({ error: 'Service name is required' });
    }

    if (!(await ownsStylist(id, req.user!))) {
      return res.status(404).json({ error: 'Stylist not found' });
    }

    const stylist = await prisma.stylist.findUnique({
      where: { id },
      include: stylistInclude,
    });

    if (!stylist) return res.status(404).json({ error: 'Stylist not found' });

    // canSetServicePrice gates whether the STYLIST's own app may set a
    // price; a salon owner/admin setting it directly is always allowed.
    const priceAllowed = req.user!.role !== 'STYLIST' || canSetServicePrice(stylist);
    const servicePrice = priceAllowed
      ? Math.max(0, Number(basePrice ?? stylist.basePrice ?? 50000))
      : stylist.basePrice ?? Number(basePrice ?? 50000);

    const service = await prisma.service.create({
      data: {
        stylistId: id,
        salonId: stylist.primarySalonId,
        name: String(name).trim(),
        category: String(category || 'Salon').trim(),
        duration: Math.max(15, Number(duration || 60)),
        basePrice: servicePrice,
      },
    });

    res.status(201).json(service);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// PATCH /api/v2/stylists/:id/services/:serviceId - Update service details.
router.patch('/:id/services/:serviceId', requireRole('STYLIST', 'SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { id, serviceId } = req.params;
    const { name, category, duration, basePrice } = req.body;

    if (!(await ownsStylist(id, req.user!))) {
      return res.status(404).json({ error: 'Stylist not found' });
    }

    const stylist = await prisma.stylist.findUnique({
      where: { id },
      include: stylistInclude,
    });

    if (!stylist) return res.status(404).json({ error: 'Stylist not found' });

    const service = await prisma.service.findFirst({
      where: { id: serviceId, stylistId: id },
    });

    if (!service) return res.status(404).json({ error: 'Service not found' });

    const data: any = {};
    if (name != null) data.name = String(name).trim();
    if (category != null) data.category = String(category || 'Salon').trim();
    if (duration != null) data.duration = Math.max(15, Number(duration));
    if (basePrice != null && (req.user!.role !== 'STYLIST' || canSetServicePrice(stylist))) {
      data.basePrice = Math.max(0, Number(basePrice));
    }

    const updated = await prisma.service.update({
      where: { id: serviceId },
      data,
    });

    res.json(updated);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// DELETE /api/v2/stylists/:id/services/:serviceId - Remove an unused service.
router.delete('/:id/services/:serviceId', requireRole('STYLIST', 'SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { id, serviceId } = req.params;

    if (!(await ownsStylist(id, req.user!))) {
      return res.status(404).json({ error: 'Stylist not found' });
    }

    const service = await prisma.service.findFirst({
      where: { id: serviceId, stylistId: id },
    });

    if (!service) return res.status(404).json({ error: 'Service not found' });

    await prisma.service.delete({ where: { id: serviceId } });

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

// PATCH /api/v2/stylists/:id - Update any stylist fields used by local flows.
router.patch('/:id', requireRole('STYLIST', 'SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { id } = req.params;

    if (!(await ownsStylist(id, req.user!))) {
      return res.status(404).json({ error: 'Stylist not found' });
    }

    const { name, phone } = req.body;
    const allowedFields = [
      'registrationType',
      'primarySalonId',
      'independentBookingEnabled',
      'homeServiceEnabled',
      'homeServiceCatalog',
      'basePrice',
      'lat',
      'lng',
      'rating',
      'totalReviews',
    ];

    const data = Object.fromEntries(
      Object.entries(req.body).filter(([key]) => allowedFields.includes(key)),
    );

    const existing = await prisma.stylist.findUnique({
      where: { id },
      include: { user: true },
    });
    if (!existing) return res.status(404).json({ error: 'Stylist not found' });

    const stylist = await prisma.$transaction(async (tx) => {
      if (name != null || phone != null) {
        await tx.user.update({
          where: { id: existing.userId },
          data: {
            ...(name != null ? { name: String(name).trim() } : {}),
            ...(phone != null ? { phone: String(phone).trim() } : {}),
          },
        });
      }

      return tx.stylist.update({
        where: { id },
        data,
        include: stylistInclude,
      });
    });

    res.json(withMobileFields(stylist));
  } catch (e: any) {
    if (e.code === 'P2002') {
      return res.status(409).json({ error: 'Phone is already in use' });
    }
    res.status(500).json({ error: e.message });
  }
});

// POST /api/v2/stylists/:id/make-independent - Revert an exclusive stylist.
router.post('/:id/make-independent', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { id } = req.params;

    if (!(await ownsStylist(id, req.user!))) {
      return res.status(404).json({ error: 'Stylist not found' });
    }

    const stylist = await prisma.$transaction(async (tx) => {
      await tx.salonStylist.updateMany({
        where: { stylistId: id },
        data: {
          exclusive: false,
          status: 'TERMINATED',
        },
      });

      return tx.stylist.update({
        where: { id },
        data: {
          registrationType: 'INDEPENDENT',
          primarySalonId: null,
          independentBookingEnabled: true,
          homeServiceEnabled: true,
        },
        include: stylistInclude,
      });
    });

    res.json(withMobileFields(stylist));
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

export default router;
