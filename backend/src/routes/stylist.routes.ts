import { Router } from 'express';
import { prisma } from '../index';

const router = Router();

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

function parseClock(value: string): number {
  const [hours, minutes] = value.split(':').map(Number);
  return hours * 60 + (minutes || 0);
}

function sameDate(value: Date) {
  return new Date(value.getFullYear(), value.getMonth(), value.getDate());
}

function minutesToDate(day: Date, minutes: number) {
  return new Date(
    day.getFullYear(),
    day.getMonth(),
    day.getDate(),
    Math.floor(minutes / 60),
    minutes % 60,
  );
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
  const date = sameDate(new Date(dateText));
  if (Number.isNaN(date.getTime())) throw new Error('Invalid date');

  const bundle = await getServiceBundle(stylistId, serviceIds);

  const weekday = date.getDay();
  const nextDay = new Date(date.getTime() + 24 * 60 * 60 * 1000);

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
      const start = minutesToDate(date, minutes);
      const end = new Date(start.getTime() + bundle.duration * 60 * 1000);
      if (start <= now) continue;

      const blocked = blocks.some((block) => {
        const blockStart = minutesToDate(date, parseClock(block.startTime));
        const blockEnd = minutesToDate(date, parseClock(block.endTime));
        return start < blockEnd && end > blockStart;
      });

      const busy = bookings.some(
        (booking) => start < booking.slotEnd && end > booking.slotStart,
      );

      if (!blocked && !busy) {
        slots.push({
          dateTime: start.toISOString(),
          label: start.toLocaleTimeString('en-IN', {
            hour: 'numeric',
            minute: '2-digit',
          }),
        });
      }
    }
  }

  return slots;
}

// GET /api/v2/stylists - List all stylists for customer app.
router.get('/', async (_req, res) => {
  try {
    const stylists = await prisma.stylist.findMany({
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
router.post('/:id/availability', async (req, res) => {
  try {
    const { id } = req.params;
    const { dayOfWeek, date, startTime, endTime, isBlocked = false } = req.body;

    if (!startTime || !endTime) {
      return res.status(400).json({ error: 'startTime and endTime are required' });
    }

    if (parseClock(startTime) >= parseClock(endTime)) {
      return res.status(400).json({ error: 'startTime must be before endTime' });
    }

    const stylist = await prisma.stylist.findUnique({ where: { id } });
    if (!stylist) return res.status(404).json({ error: 'Stylist not found' });

    const availability = await prisma.stylistAvailability.create({
      data: {
        stylistId: id,
        dayOfWeek: date ? null : Number(dayOfWeek ?? new Date().getDay()),
        date: date ? sameDate(new Date(date)) : null,
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

// POST /api/v2/stylists/:id/block - Block a specific date/time.
router.post('/:id/block', async (req, res) => {
  try {
    const { id } = req.params;
    const { date, startTime, endTime } = req.body;

    if (!date || !startTime || !endTime) {
      return res.status(400).json({ error: 'date, startTime and endTime are required' });
    }

    const block = await prisma.stylistAvailability.create({
      data: {
        stylistId: id,
        date: sameDate(new Date(date)),
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
router.post('/', async (req, res) => {
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
      data: { phone, name, role: 'STYLIST', lat, lng },
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
router.post('/:id/services', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, category = 'Salon', duration = 60, basePrice } = req.body;

    if (!name || String(name).trim().length < 2) {
      return res.status(400).json({ error: 'Service name is required' });
    }

    const stylist = await prisma.stylist.findUnique({
      where: { id },
      include: stylistInclude,
    });

    if (!stylist) return res.status(404).json({ error: 'Stylist not found' });

    const priceAllowed = canSetServicePrice(stylist);
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
router.patch('/:id/services/:serviceId', async (req, res) => {
  try {
    const { id, serviceId } = req.params;
    const { name, category, duration, basePrice } = req.body;

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
    if (basePrice != null && canSetServicePrice(stylist)) {
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
router.delete('/:id/services/:serviceId', async (req, res) => {
  try {
    const { id, serviceId } = req.params;

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
router.patch('/:id', async (req, res) => {
  try {
    const { id } = req.params;
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

    const stylist = await prisma.stylist.update({
      where: { id },
      data,
      include: stylistInclude,
    });

    res.json(withMobileFields(stylist));
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// POST /api/v2/stylists/:id/make-independent - Revert an exclusive stylist.
router.post('/:id/make-independent', async (req, res) => {
  try {
    const { id } = req.params;

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
