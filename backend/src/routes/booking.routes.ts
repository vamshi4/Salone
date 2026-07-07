import { Router } from 'express';
import { prisma } from '../index';
import { requireRole } from '../auth';

const router = Router();

const bookingInclude = {
  customer: true,
  stylist: { include: { user: true, primarySalon: true } },
  salon: true,
  service: true,
  services: {
    include: { service: true },
    orderBy: { sortOrder: 'asc' as const },
  },
};

// Returns true when the acting user is allowed to view/modify this specific booking.
// SUPER_ADMIN can always act. Otherwise the booking must belong to the requester:
// the customer who made it, the stylist assigned to it, or the owner of its salon.
function canAccessBooking(
  booking: {
    customerId: string;
    stylist?: { userId: string } | null;
    salon?: { ownerId: string } | null;
  },
  user: { id: string; role: string },
): boolean {
  switch (user.role) {
    case 'SUPER_ADMIN':
      return true;
    case 'CUSTOMER':
      return booking.customerId === user.id;
    case 'STYLIST':
      return booking.stylist?.userId === user.id;
    case 'SALON_OWNER':
      return booking.salon?.ownerId === user.id;
    default:
      return false;
  }
}

function haversine(lat1: number, lon1: number, lat2: number, lon2: number): number {
  const R = 6371;
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLon/2) * Math.sin(dLon/2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  return R * c;
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

async function validateStylistSlot(
  stylistId: string,
  serviceIds: string[],
  start: Date,
  ignoreBookingId?: string,
) {
  if (Number.isNaN(start.getTime())) {
    return 'Invalid dateTime';
  }

  const services = await prisma.service.findMany({
    where: { id: { in: serviceIds } },
  });

  if (services.length !== serviceIds.length) {
    return 'One or more services were not found for stylist';
  }

  const stylist = await prisma.stylist.findUnique({
    where: { id: stylistId },
    select: { primarySalonId: true },
  });

  const invalidService = services.some(
    (service) =>
      service.stylistId !== stylistId &&
      (!stylist?.primarySalonId || service.salonId !== stylist.primarySalonId),
  );

  if (invalidService) {
    return 'One or more services are not available for this stylist';
  }

  const totalDuration = services.reduce(
    (total, service) => total + service.duration,
    0,
  );

  const end = new Date(start.getTime() + totalDuration * 60 * 1000);
  const day = sameDate(start);
  const nextDay = new Date(day.getTime() + 24 * 60 * 60 * 1000);

  const availability = await prisma.stylistAvailability.findMany({
    where: {
      stylistId,
      OR: [{ date: day }, { dayOfWeek: day.getDay(), date: null }],
    },
  });

  const workingWindows = availability.filter((item) => !item.isBlocked);
  const blocks = availability.filter((item) => item.isBlocked);
  const windows = workingWindows.length
    ? workingWindows
    : [{ startTime: '09:00', endTime: '18:00' }];

  const insideWorkingHours = windows.some((window) => {
    const windowStart = minutesToDate(day, parseClock(window.startTime));
    const windowEnd = minutesToDate(day, parseClock(window.endTime));
    return start >= windowStart && end <= windowEnd;
  });

  if (!insideWorkingHours) {
    return 'Selected time is too late for the selected services. Pick an earlier slot.';
  }

  const blocked = blocks.some((block) => {
    const blockStart = minutesToDate(day, parseClock(block.startTime));
    const blockEnd = minutesToDate(day, parseClock(block.endTime));
    return start < blockEnd && end > blockStart;
  });

  if (blocked) return 'Selected time is blocked by stylist';

  const conflict = await prisma.booking.findFirst({
    where: {
      stylistId,
      id: ignoreBookingId ? { not: ignoreBookingId } : undefined,
      status: { in: ['PENDING', 'PENDING_RESCHEDULE', 'CONFIRMED'] },
      slotStart: { lt: end },
      slotEnd: { gt: start },
    },
  });

  if (conflict) return 'Selected time conflicts with another booking';

  return null;
}

// GET /api/v2/bookings - Customer booking history.
router.get('/', requireRole('CUSTOMER'), async (req, res) => {
  try {
    const bookings = await prisma.booking.findMany({
      where: { customerId: req.user!.id },
      orderBy: { slotStart: 'desc' },
      include: bookingInclude,
    });

    res.json(bookings);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// GET /api/v2/bookings/stylist/:stylistId - Bookings assigned to a stylist.
router.get(
  '/stylist/:stylistId',
  requireRole('STYLIST', 'SALON_OWNER', 'SUPER_ADMIN'),
  async (req, res) => {
    try {
      const stylistId = req.params.stylistId;

      if (req.user!.role !== 'SUPER_ADMIN') {
        const stylist = await prisma.stylist.findUnique({
          where: { id: stylistId },
          include: { primarySalon: true },
        });
        if (!stylist) return res.status(404).json({ error: 'Stylist not found' });

        const isSelf = req.user!.role === 'STYLIST' && stylist.userId === req.user!.id;
        const ownsSalon =
          req.user!.role === 'SALON_OWNER' &&
          ((stylist.primarySalon && stylist.primarySalon.ownerId === req.user!.id) ||
            (await prisma.salon.findFirst({
              where: {
                ownerId: req.user!.id,
                stylists: { some: { stylistId, status: 'ACTIVE' } },
              },
              select: { id: true },
            })) != null);

        if (!isSelf && !ownsSalon) {
          return res.status(404).json({ error: 'Stylist not found' });
        }
      }

      const bookings = await prisma.booking.findMany({
        where: { stylistId },
        orderBy: { slotStart: 'desc' },
        include: bookingInclude,
      });

      res.json(bookings);
    } catch (e: any) {
      res.status(500).json({ error: e.message });
    }
  },
);

// POST /api/v2/bookings/check-home-service - 5km validation
router.post('/check-home-service', requireRole('CUSTOMER'), async (req, res) => {
  try {
    const { stylistId, customerLat, customerLng } = req.body;

    const stylist = await prisma.stylist.findUnique({
      where: { id: stylistId },
      include: { user: true },
    });

    if (!stylist) return res.status(404).json({ error: 'Stylist not found' });
    if (!stylist.homeServiceEnabled) {
      return res.status(400).json({ error: 'Home service disabled by stylist' });
    }
    if (stylist.registrationType === 'SALON_EXCLUSIVE') {
      return res.status(400).json({ error: 'Exclusive salon stylists cannot offer home service' });
    }
    if (!stylist.lat || !stylist.lng) {
      return res.status(400).json({ error: 'Stylist location not set' });
    }

    const distanceKm = haversine(stylist.lat, stylist.lng, customerLat, customerLng);
    if (distanceKm > 5) {
      return res.status(400).json({ 
        error: `Not serviceable: ${distanceKm.toFixed(1)}km away. Max 5km.` 
      });
    }

    res.json({ eligible: true, travelFee: 10000, distanceKm }); // ₹100
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// POST /api/v2/bookings - Create a simple booking for the mobile demo.
router.post('/', requireRole('CUSTOMER'), async (req, res) => {
  try {
    const {
      stylistId,
      serviceIds = [],
      dateTime,
      isHomeService = false,
      customerLat,
      customerLng,
    } = req.body;

    const stylist = await prisma.stylist.findUnique({
      where: { id: stylistId },
      include: { primarySalon: true, services: true },
    });

    if (!stylist) return res.status(404).json({ error: 'Stylist not found' });

    if (isHomeService) {
      if (!stylist.homeServiceEnabled || stylist.registrationType === 'SALON_EXCLUSIVE') {
        return res.status(400).json({ error: 'Home service is not available for this stylist' });
      }
      if (!stylist.lat || !stylist.lng || customerLat == null || customerLng == null) {
        return res.status(400).json({ error: 'Location is required for home service' });
      }

      const distanceKm = haversine(stylist.lat, stylist.lng, customerLat, customerLng);
      if (distanceKm > 5) {
        return res.status(400).json({
          error: `Not serviceable: ${distanceKm.toFixed(1)}km away. Max 5km.`,
        });
      }
    }

    const requestedServiceIds = Array.isArray(serviceIds)
      ? serviceIds.filter(Boolean)
      : [];

    let selectedServices = requestedServiceIds.length
      ? await prisma.service.findMany({
          where: {
            id: { in: requestedServiceIds },
            OR: [
              { stylistId: stylist.id },
              ...(stylist.primarySalonId ? [{ salonId: stylist.primarySalonId }] : []),
            ],
          },
        })
      : [];

    if (requestedServiceIds.length && selectedServices.length !== requestedServiceIds.length) {
      return res.status(400).json({ error: 'One or more services were not found for stylist' });
    }
    if (requestedServiceIds.length) {
      selectedServices.sort(
        (a, b) => requestedServiceIds.indexOf(a.id) - requestedServiceIds.indexOf(b.id),
      );
    }

    let service = requestedServiceIds.length
      ? selectedServices[0]
      : stylist.services[0];

    if (!service) {
      service = await prisma.service.create({
        data: {
          name: 'Standard Service',
          category: 'Salon',
          duration: 60,
          stylistId: stylist.id,
          basePrice: stylist.basePrice ?? 50000,
        },
      });
      selectedServices = [service];
    } else if (!selectedServices.length) {
      selectedServices = [service];
    }

    const start = dateTime ? new Date(dateTime) : new Date(Date.now() + 60 * 60 * 1000);
    const totalDuration = selectedServices.reduce(
      (total, selectedService) => total + selectedService.duration,
      0,
    );
    const end = new Date(start.getTime() + totalDuration * 60 * 1000);
    const selectedServiceIds = selectedServices.map((selectedService) => selectedService.id);
    const slotError = await validateStylistSlot(stylist.id, selectedServiceIds, start);
    if (slotError) return res.status(400).json({ error: slotError });

    const price = selectedServices.reduce(
      (total, selectedService) => total + selectedService.basePrice,
      0,
    );
    const travelFee = isHomeService ? 10000 : 0;
    const platformFee = 2000;

    const booking = await prisma.booking.create({
      data: {
        customerId: req.user!.id,
        providerType:
          stylist.registrationType === 'SALON_EXCLUSIVE' ? 'STYLIST_AT_SALON' : 'STYLIST_INDEPENDENT',
        salonId: stylist.primarySalonId,
        stylistId: stylist.id,
        serviceId: service.id,
        bookedVia: 'STYLISTS_TAB',
        serviceType: isHomeService ? 'HOME_SERVICE' : 'IN_SALON',
        slotStart: start,
        slotEnd: end,
        originalDateTime: start,
        price,
        travelFee,
        platformFee,
        stylistPayout: Math.round(price * 0.7),
        salonPayout: stylist.primarySalonId ? Math.round(price * 0.3) : 0,
        commissionSnapshot: {
          stylist: 70,
          salon: stylist.primarySalonId ? 30 : 0,
        },
        status: 'PENDING',
        services: {
          create: selectedServices.map((selectedService, index) => ({
            serviceId: selectedService.id,
            sortOrder: index,
          })),
        },
      },
      include: bookingInclude,
    });

    res.status(201).json(booking);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// POST /api/v2/bookings/salon-manual - Salon/admin creates a walk-in or phone booking.
router.post('/salon-manual', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const {
      salonId,
      stylistId,
      serviceId,
      serviceIds = [],
      dateTime,
      customerName,
      customerPhone,
    } = req.body;

    const requestedServiceIds = Array.isArray(serviceIds)
      ? serviceIds.filter(Boolean)
      : serviceId
          ? [serviceId]
          : [];

    if (!salonId || !stylistId || requestedServiceIds.length === 0 || !dateTime || !customerPhone) {
      return res.status(400).json({
        error: 'salonId, stylistId, serviceId/serviceIds, dateTime and customerPhone are required',
      });
    }

    const salon = await prisma.salon.findFirst({
      where: {
        id: salonId,
        ...(req.user!.role === 'SUPER_ADMIN' ? {} : { ownerId: req.user!.id }),
      },
    });
    if (!salon) return res.status(404).json({ error: 'Salon not found' });

    const services = await prisma.service.findMany({
      where: {
        id: { in: requestedServiceIds },
        OR: [{ stylistId }, { salonId }],
      },
      orderBy: { name: 'asc' },
    });
    if (services.length !== requestedServiceIds.length) {
      return res.status(404).json({ error: 'One or more services were not found for this salon/stylist' });
    }
    services.sort(
      (a, b) => requestedServiceIds.indexOf(a.id) - requestedServiceIds.indexOf(b.id),
    );

    const stylist = await prisma.stylist.findFirst({
      where: {
        id: stylistId,
        OR: [
          { primarySalonId: salonId },
          { salonStylists: { some: { salonId, status: 'ACTIVE' } } },
        ],
      },
    });
    if (!stylist) return res.status(404).json({ error: 'Stylist not found for this salon' });

    const start = new Date(dateTime);
    const slotError = await validateStylistSlot(stylistId, requestedServiceIds, start);
    if (slotError) return res.status(400).json({ error: slotError });

    const totalDuration = services.reduce((total, item) => total + item.duration, 0);
    const end = new Date(start.getTime() + totalDuration * 60 * 1000);

    // Look up by phone first instead of upserting: an upsert that always sets
    // role: 'CUSTOMER' would silently downgrade an existing STYLIST/SALON_OWNER
    // account if a walk-in happens to share their phone number.
    const normalizedPhone = String(customerPhone).trim();
    let customer = await prisma.user.findUnique({ where: { phone: normalizedPhone } });
    if (customer) {
      if (customerName && customerName !== customer.name) {
        customer = await prisma.user.update({
          where: { id: customer.id },
          data: { name: customerName },
        });
      }
    } else {
      customer = await prisma.user.create({
        data: {
          phone: normalizedPhone,
          name: customerName || 'Customer',
          role: 'CUSTOMER',
        },
      });
    }

    const primaryService = services[0];
    const price = services.reduce((total, item) => total + item.basePrice, 0);
    const booking = await prisma.booking.create({
      data: {
        customerId: customer.id,
        providerType: 'SALON',
        salonId,
        stylistId,
        serviceId: primaryService.id,
        bookedVia: 'SALONS_TAB',
        serviceType: 'IN_SALON',
        slotStart: start,
        slotEnd: end,
        originalDateTime: start,
        price,
        platformFee: 0,
        travelFee: 0,
        stylistPayout: Math.round(price * 0.7),
        salonPayout: Math.round(price * 0.3),
        commissionSnapshot: { stylist: 70, salon: 30, source: 'SALON_MANUAL' },
        status: 'CONFIRMED',
        services: {
          create: services.map((item, index) => ({
            serviceId: item.id,
            sortOrder: index,
          })),
        },
      },
      include: bookingInclude,
    });

    res.status(201).json(booking);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// PATCH /api/v2/bookings/:id/status - Confirm/cancel a booking request.
router.patch('/:id/status', requireRole('STYLIST', 'SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { status } = req.body;
    if (!['PENDING', 'PENDING_RESCHEDULE', 'CONFIRMED', 'CANCELLED', 'COMPLETED', 'NO_SHOW'].includes(status)) {
      return res.status(400).json({ error: 'Invalid booking status' });
    }

    const existing = await prisma.booking.findUnique({
      where: { id: req.params.id },
      include: bookingInclude,
    });
    if (!existing) return res.status(404).json({ error: 'Booking not found' });
    if (!canAccessBooking(existing, req.user!)) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    const booking = await prisma.booking.update({
      where: { id: req.params.id },
      data: { status },
      include: bookingInclude,
    });

    res.json(booking);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// PATCH /api/v2/bookings/:id/reschedule - Customer or provider suggests a new slot.
router.patch('/:id/reschedule', requireRole('CUSTOMER', 'STYLIST', 'SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { dateTime, proposedBy = 'STYLIST' } = req.body;
    if (!dateTime) return res.status(400).json({ error: 'dateTime is required' });
    if (!['CUSTOMER', 'STYLIST'].includes(proposedBy)) {
      return res.status(400).json({ error: 'Invalid reschedule proposer' });
    }

    const existing = await prisma.booking.findUnique({
      where: { id: req.params.id },
      include: bookingInclude,
    });
    if (!existing) return res.status(404).json({ error: 'Booking not found' });
    if (!canAccessBooking(existing, req.user!)) {
      return res.status(404).json({ error: 'Booking not found' });
    }
    if (proposedBy === 'CUSTOMER' && existing.status !== 'CONFIRMED') {
      return res.status(400).json({ error: 'Only confirmed bookings can be rescheduled by customer' });
    }
    if (proposedBy === 'STYLIST' && !['PENDING', 'CONFIRMED'].includes(existing.status)) {
      return res.status(400).json({ error: 'Booking cannot be rescheduled in current status' });
    }

    const start = new Date(dateTime);
    const selectedServiceIds =
      existing.services.length > 0
        ? existing.services.map((item) => item.serviceId)
        : [existing.serviceId];
    const totalDuration =
      existing.services.length > 0
        ? existing.services.reduce((total, item) => total + item.service.duration, 0)
        : existing.service.duration;
    const end = new Date(start.getTime() + totalDuration * 60 * 1000);
    if (!existing.stylistId) {
      return res.status(400).json({ error: 'Booking has no stylist assigned' });
    }

    const slotError = await validateStylistSlot(
      existing.stylistId,
      selectedServiceIds,
      start,
      existing.id,
    );
    if (slotError) return res.status(400).json({ error: slotError });

    const booking = await prisma.booking.update({
      where: { id: req.params.id },
      data: {
        proposedDateTime: start,
        rescheduleReason: req.body.reason ?? null,
        rescheduleProposedBy: proposedBy,
        status: 'PENDING_RESCHEDULE',
      },
      include: bookingInclude,
    });

    res.json(booking);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// PATCH /api/v2/bookings/:id/accept-reschedule - Opposite party accepts suggested time.
router.patch('/:id/accept-reschedule', requireRole('CUSTOMER', 'STYLIST', 'SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { acceptedBy = 'CUSTOMER' } = req.body;
    if (!['CUSTOMER', 'STYLIST'].includes(acceptedBy)) {
      return res.status(400).json({ error: 'Invalid reschedule accepter' });
    }

    const existing = await prisma.booking.findUnique({
      where: { id: req.params.id },
      include: bookingInclude,
    });
    if (!existing) return res.status(404).json({ error: 'Booking not found' });
    if (!canAccessBooking(existing, req.user!)) {
      return res.status(404).json({ error: 'Booking not found' });
    }
    if (!existing.proposedDateTime) {
      return res.status(400).json({ error: 'No proposed reschedule time found' });
    }
    if (existing.rescheduleProposedBy === acceptedBy) {
      return res.status(400).json({ error: 'Reschedule must be accepted by the other party' });
    }

    const start = existing.proposedDateTime;
    const selectedServiceIds =
      existing.services.length > 0
        ? existing.services.map((item) => item.serviceId)
        : [existing.serviceId];
    const totalDuration =
      existing.services.length > 0
        ? existing.services.reduce((total, item) => total + item.service.duration, 0)
        : existing.service.duration;
    const end = new Date(start.getTime() + totalDuration * 60 * 1000);
    if (existing.stylistId) {
      const slotError = await validateStylistSlot(
        existing.stylistId,
        selectedServiceIds,
        start,
        existing.id,
      );
      if (slotError) return res.status(400).json({ error: slotError });
    }

    const booking = await prisma.booking.update({
      where: { id: req.params.id },
      data: {
        slotStart: start,
        slotEnd: end,
        proposedDateTime: null,
        rescheduleProposedBy: null,
        status: 'CONFIRMED',
      },
      include: bookingInclude,
    });

    res.json(booking);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// PATCH /api/v2/bookings/:id/reject-reschedule - Reject proposed time and keep original booking.
router.patch('/:id/reject-reschedule', requireRole('CUSTOMER', 'STYLIST', 'SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { rejectedBy = 'CUSTOMER' } = req.body;
    if (!['CUSTOMER', 'STYLIST'].includes(rejectedBy)) {
      return res.status(400).json({ error: 'Invalid reschedule rejecter' });
    }

    const existing = await prisma.booking.findUnique({
      where: { id: req.params.id },
      include: bookingInclude,
    });
    if (!existing) return res.status(404).json({ error: 'Booking not found' });
    if (!canAccessBooking(existing, req.user!)) {
      return res.status(404).json({ error: 'Booking not found' });
    }
    if (!existing.proposedDateTime) {
      return res.status(400).json({ error: 'No proposed reschedule time found' });
    }
    if (existing.rescheduleProposedBy === rejectedBy) {
      return res.status(400).json({ error: 'Reschedule must be rejected by the other party' });
    }

    const booking = await prisma.booking.update({
      where: { id: req.params.id },
      data: {
        proposedDateTime: null,
        rescheduleReason: null,
        rescheduleProposedBy: null,
        status: 'CONFIRMED',
      },
      include: bookingInclude,
    });

    res.json(booking);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

export default router;
