import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  console.log('Seeding...');

  // Create test salon
  const salonUser = await prisma.user.create({
    data: { phone: '9000000001', name: 'Glamour Salon Owner', role: 'SALON_OWNER' },
  });

  const salon = await prisma.salon.create({
    data: {
      ownerId: salonUser.id,
      name: 'Glamour Salon',
      address: 'Chanda Nagar, Hyderabad',
      lat: 17.4933,
      lng: 78.3915,
    },
  });

  // Create test stylist
  const stylistUser = await prisma.user.create({
    data: { phone: '9999999999', name: 'Ravi', role: 'STYLIST', lat: 17.456, lng: 78.349 },
  });

  await prisma.stylist.create({
    data: {
      userId: stylistUser.id,
      lat: 17.456,
      lng: 78.349,
      homeServiceEnabled: true,
      basePrice: 50000,
    },
  });

  console.log('Seed complete');
}

main().catch(console.error).finally(() => prisma.$disconnect());