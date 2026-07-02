import { Router } from 'express';
import { prisma } from '../index';

const router = Router();

// GET /api/v2/salons
router.get('/', async (req, res) => {
  const salons = await prisma.salon.findMany({
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
router.get('/:salonId/bookings', async (req, res) => {
  try {
    const bookings = await prisma.booking.findMany({
      where: { salonId: req.params.salonId },
      orderBy: { slotStart: 'desc' },
      include: {
        customer: true,
        stylist: { include: { user: true } },
        service: true,
      },
    });

    res.json(bookings);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// POST /api/v2/salons/:salonId/stylists/:stylistId/make-exclusive
router.post('/:salonId/stylists/:stylistId/make-exclusive', async (req, res) => {
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
router.patch('/:salonId/stylists/:stylistId', async (req, res) => {
  try {
    const { salonId, stylistId } = req.params;
    const { canSetOwnPrice } = req.body;

    const updated = await prisma.salonStylist.update({
      where: { salonId_stylistId: { salonId, stylistId } },
      data: { canSetOwnPrice },
    });

    res.json(updated);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

export default router;
