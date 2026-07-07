import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('Seeding...');

  const salonUser = await prisma.user.upsert({
    where: { phone: '9000000001' },
    update: {
      name: 'Glamour Salon Owner',
      role: 'SALON_OWNER',
    },
    create: {
      phone: '9000000001',
      name: 'Glamour Salon Owner',
      role: 'SALON_OWNER',
    },
  });

  const salon = await prisma.salon.upsert({
    where: { ownerId: salonUser.id },
    update: {
      name: 'Glamour Salon',
      address: 'Chanda Nagar, Hyderabad',
      lat: 17.4933,
      lng: 78.3915,
    },
    create: {
      ownerId: salonUser.id,
      name: 'Glamour Salon',
      address: 'Chanda Nagar, Hyderabad',
      lat: 17.4933,
      lng: 78.3915,
    },
  });

  const stylistUser = await prisma.user.upsert({
    where: { phone: '9999999999' },
    update: {
      name: 'Ravi',
      role: 'STYLIST',
      lat: 17.456,
      lng: 78.349,
    },
    create: {
      phone: '9999999999',
      name: 'Ravi',
      role: 'STYLIST',
      lat: 17.456,
      lng: 78.349,
    },
  });

  const stylist = await prisma.stylist.upsert({
    where: { userId: stylistUser.id },
    update: {
      registrationType: 'SALON_EXCLUSIVE',
      primarySalonId: salon.id,
      independentBookingEnabled: false,
      homeServiceEnabled: false,
      basePrice: 50000,
      lat: 17.456,
      lng: 78.349,
    },
    create: {
      userId: stylistUser.id,
      registrationType: 'SALON_EXCLUSIVE',
      primarySalonId: salon.id,
      independentBookingEnabled: false,
      homeServiceEnabled: false,
      basePrice: 50000,
      lat: 17.456,
      lng: 78.349,
    },
  });

  await prisma.salonStylist.upsert({
    where: {
      salonId_stylistId: {
        salonId: salon.id,
        stylistId: stylist.id,
      },
    },
    update: {
      status: 'ACTIVE',
      exclusive: true,
      canSetOwnPrice: true,
      canCancelBooking: true,
      commissionRate: 70,
    },
    create: {
      salonId: salon.id,
      stylistId: stylist.id,
      status: 'ACTIVE',
      exclusive: true,
      canSetOwnPrice: true,
      canCancelBooking: true,
      commissionRate: 70,
    },
  });

  const services = [
    { name: 'Haircut', duration: 45, basePrice: 50000 },
    { name: 'Hair Spa', duration: 60, basePrice: 90000 },
    { name: 'Beard Trim', duration: 30, basePrice: 30000 },
  ];

  for (const service of services) {
    await prisma.service.upsert({
      where: {
        id: `${salon.id}:${stylist.id}:${service.name}`,
      },
      update: {
        name: service.name,
        category: 'Salon',
        duration: service.duration,
        basePrice: service.basePrice,
        salonId: salon.id,
        stylistId: stylist.id,
      },
      create: {
        id: `${salon.id}:${stylist.id}:${service.name}`,
        name: service.name,
        category: 'Salon',
        duration: service.duration,
        basePrice: service.basePrice,
        salonId: salon.id,
        stylistId: stylist.id,
      },
    });
  }

  console.log('Seed complete');
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
