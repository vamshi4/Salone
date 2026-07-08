import { PrismaClient } from '@prisma/client';
import crypto from 'crypto';

const prisma = new PrismaClient();

// Mirror backend/src/routes/auth.routes.ts hashing (scrypt$salt$hash).
function hashPassword(password: string) {
  const salt = crypto.randomBytes(16).toString('hex');
  const hash = crypto.scryptSync(password, salt, 64).toString('hex');
  return `scrypt$${salt}$${hash}`;
}

const DEMO_OWNER_PHONE = '9000000001';
const DEMO_OWNER_PASSWORD = 'glamour123';

function daysAgo(days: number, hour = 11, minute = 0) {
  const d = new Date();
  d.setDate(d.getDate() - days);
  d.setHours(hour, minute, 0, 0);
  return d;
}

function firstOfMonthsAgo(monthsAgo: number, day: number, hour = 11) {
  const now = new Date();
  const d = new Date(now.getFullYear(), now.getMonth() - monthsAgo, day, hour, 0, 0, 0);
  return d;
}

async function main() {
  console.log('Seeding demo salon...');

  // ---- Owner + salon ----
  const owner = await prisma.user.upsert({
    where: { phone: DEMO_OWNER_PHONE },
    update: {
      name: 'Glamour Salon Owner',
      role: 'SALON_OWNER',
      password: hashPassword(DEMO_OWNER_PASSWORD),
    },
    create: {
      phone: DEMO_OWNER_PHONE,
      name: 'Glamour Salon Owner',
      role: 'SALON_OWNER',
      password: hashPassword(DEMO_OWNER_PASSWORD),
    },
  });

  const salon = await prisma.salon.upsert({
    where: { ownerId: owner.id },
    update: { name: 'Glamour Salon', address: 'Chanda Nagar, Hyderabad', lat: 17.4933, lng: 78.3915, saasPlan: 'PREMIUM' },
    create: { ownerId: owner.id, name: 'Glamour Salon', address: 'Chanda Nagar, Hyderabad', lat: 17.4933, lng: 78.3915, saasPlan: 'PREMIUM' },
  });

  // ---- Stylists ----
  const stylistDefs = [
    { phone: '9700000011', name: 'Ravi', base: 50000 },
    { phone: '9700000012', name: 'Priya', base: 60000 },
    { phone: '9700000013', name: 'Sana', base: 55000 },
  ];
  const stylists = [];
  for (const s of stylistDefs) {
    const u = await prisma.user.upsert({
      where: { phone: s.phone },
      update: { name: s.name, role: 'STYLIST' },
      create: { phone: s.phone, name: s.name, role: 'STYLIST' },
    });
    const st = await prisma.stylist.upsert({
      where: { userId: u.id },
      update: { registrationType: 'SALON_EXCLUSIVE', primarySalonId: salon.id, independentBookingEnabled: false, basePrice: s.base },
      create: { userId: u.id, registrationType: 'SALON_EXCLUSIVE', primarySalonId: salon.id, independentBookingEnabled: false, basePrice: s.base },
    });
    await prisma.salonStylist.upsert({
      where: { salonId_stylistId: { salonId: salon.id, stylistId: st.id } },
      update: { status: 'ACTIVE', commissionRate: 70 },
      create: { salonId: salon.id, stylistId: st.id, status: 'ACTIVE', commissionRate: 70 },
    });
    stylists.push({ ...st, name: s.name });
  }

  // ---- Services (salon-level) ----
  const serviceDefs = [
    { name: 'Haircut', category: 'Hair', duration: 45, basePrice: 50000 },
    { name: 'Hair Spa', category: 'Hair', duration: 60, basePrice: 90000 },
    { name: 'Beard Trim', category: 'Grooming', duration: 30, basePrice: 30000 },
    { name: 'Facial', category: 'Skin', duration: 60, basePrice: 120000 },
    { name: 'Hair Colour', category: 'Hair', duration: 90, basePrice: 180000 },
    { name: 'Keratin', category: 'Hair', duration: 120, basePrice: 350000 },
    { name: 'Manicure', category: 'Nails', duration: 40, basePrice: 60000 },
    { name: 'Pedicure', category: 'Nails', duration: 50, basePrice: 80000 },
  ];
  const services: Record<string, any> = {};
  for (const svc of serviceDefs) {
    const id = `${salon.id}:svc:${svc.name}`;
    services[svc.name] = await prisma.service.upsert({
      where: { id },
      update: { name: svc.name, category: svc.category, duration: svc.duration, basePrice: svc.basePrice, salonId: salon.id },
      create: { id, name: svc.name, category: svc.category, duration: svc.duration, basePrice: svc.basePrice, salonId: salon.id },
    });
  }

  // ---- Customers with intentional retention patterns ----
  // pattern legend (which months-ago they visit): 0 = this month, 1 = last month, 2 = two months ago
  const customerDefs = [
    // Constant / retained (visit every month incl. this month)
    { phone: '8800000001', name: 'Anjali', tags: ['VIP', 'Regular'], visits: [2, 1, 0, 0] },
    { phone: '8800000002', name: 'Rohan', tags: ['Regular'], visits: [2, 1, 0] },
    { phone: '8800000003', name: 'Meera', tags: ['Regular'], visits: [1, 0] },
    { phone: '8800000004', name: 'Karthik', tags: ['VIP'], visits: [2, 1, 0, 0] },
    // Dropped / churned (visited last month or before, NOT this month) -> the "missed" list
    { phone: '8800000005', name: 'Divya', tags: ['Regular'], visits: [2, 1] },
    { phone: '8800000006', name: 'Suresh', tags: [], visits: [2, 1] },
    { phone: '8800000007', name: 'Farhan', tags: ['VIP'], visits: [2, 1, 1] },
    { phone: '8800000008', name: 'Lakshmi', tags: ['Regular'], visits: [1] },
    // New this month (first ever visit is this month)
    { phone: '8800000009', name: 'Naveen', tags: ['New'], visits: [0] },
    { phone: '8800000010', name: 'Pooja', tags: ['New'], visits: [0, 0] },
    { phone: '8800000011', name: 'Imran', tags: ['New'], visits: [0] },
    // Reactivated (visited 2 months ago, skipped last month, back this month)
    { phone: '8800000012', name: 'Sneha', tags: ['Winback'], visits: [2, 0] },
    // Fully lapsed (only 2 months ago) -> also "missed"
    { phone: '8800000013', name: 'Vikram', tags: [], visits: [2] },
    // At-risk regulars: tight visit rhythm, now well past due (drives the churn-risk list).
    // `daysAgo` = explicit days-before-today per visit (overrides months-ago `visits`).
    { phone: '8800000020', name: 'Priyanka', tags: ['VIP', 'Regular'], visits: [], daysAgo: [70, 56, 42] },
    { phone: '8800000021', name: 'Rahul', tags: ['Regular'], visits: [], daysAgo: [95, 63, 49] },
    { phone: '8800000022', name: 'Aisha', tags: ['VIP'], visits: [], daysAgo: [84, 56, 44] },
    { phone: '8800000023', name: 'Kiran', tags: [], visits: [], daysAgo: [66, 52, 40] },
    { phone: '8800000024', name: 'Deepa', tags: ['Regular'], visits: [], daysAgo: [78, 60, 46] },
    { phone: '8800000025', name: 'Manoj', tags: [], visits: [], daysAgo: [50, 38, 29] },
    // Extra churned (active last month, not this month) so the Churned cohort > 10.
    { phone: '8800000030', name: 'Ramesh', tags: [], visits: [1] },
    { phone: '8800000031', name: 'Sunita', tags: [], visits: [1] },
    { phone: '8800000032', name: 'Vijay', tags: [], visits: [2, 1] },
    { phone: '8800000033', name: 'Neha', tags: [], visits: [1] },
    { phone: '8800000034', name: 'Amit', tags: [], visits: [2, 1] },
    { phone: '8800000035', name: 'Kavya', tags: [], visits: [1] },
    { phone: '8800000036', name: 'Rekha', tags: [], visits: [1] },
    { phone: '8800000037', name: 'Sathya', tags: [], visits: [2, 1] },
  ];

  // Clear previously-seeded demo bookings so slot dates are recomputed for "today".
  await prisma.booking.deleteMany({ where: { id: { startsWith: `${salon.id}:demo:` } } });

  const serviceMenu = Object.values(services);
  let bookingSeq = 0;

  for (const c of customerDefs) {
    const cu = await prisma.user.upsert({
      where: { phone: c.phone },
      update: { name: c.name, role: 'CUSTOMER' },
      create: { phone: c.phone, name: c.name, role: 'CUSTOMER' },
    });
    await prisma.salonCustomer.upsert({
      where: { salonId_customerId: { salonId: salon.id, customerId: cu.id } },
      update: { tags: c.tags, notes: c.tags.includes('VIP') ? 'Prefers senior stylist.' : '' },
      create: { salonId: salon.id, customerId: cu.id, tags: c.tags, notes: c.tags.includes('VIP') ? 'Prefers senior stylist.' : '' },
    });

    const explicitDays: number[] | undefined = (c as any).daysAgo;
    const plan = explicitDays ?? c.visits;
    for (let i = 0; i < plan.length; i++) {
      // deterministic booking id so re-seeding is idempotent
      const bookingId = `${salon.id}:demo:${c.phone}:${i}`;
      let slotStart: Date;
      if (explicitDays) {
        slotStart = daysAgo(explicitDays[i], 11 + (bookingSeq % 6));
      } else {
        const monthsBack = c.visits[i];
        const day = 8 + ((bookingSeq * 3) % 18); // spread within the month (day 8..25)
        // For "this month", stay within the current calendar month (day 1..today),
        // otherwise early-in-the-month visits would spill into last month.
        const dayOfMonth = new Date().getDate();
        slotStart = monthsBack === 0
          ? daysAgo(bookingSeq % Math.max(1, dayOfMonth))
          : firstOfMonthsAgo(monthsBack, day, 10 + (bookingSeq % 8));
      }
      const svc = serviceMenu[bookingSeq % serviceMenu.length] as any;
      const secondSvc = bookingSeq % 3 === 0 ? (serviceMenu[(bookingSeq + 2) % serviceMenu.length] as any) : null;
      const stylist = stylists[bookingSeq % stylists.length];
      const price = svc.basePrice + (secondSvc ? secondSvc.basePrice : 0);
      const platformFee = Math.round(price * 0.05);
      const salonPayout = price - platformFee;
      const stylistPayout = Math.round(salonPayout * 0.7);
      const slotEnd = new Date(slotStart.getTime() + (svc.duration + (secondSvc ? secondSvc.duration : 0)) * 60000);

      await prisma.booking.upsert({
        where: { id: bookingId },
        update: {},
        create: {
          id: bookingId,
          customerId: cu.id,
          providerType: 'SALON',
          salonId: salon.id,
          stylistId: stylist.id,
          serviceId: svc.id,
          bookedVia: 'SALONS_TAB',
          serviceType: 'IN_SALON',
          slotStart,
          slotEnd,
          price,
          platformFee,
          stylistPayout,
          salonPayout,
          commissionSnapshot: { salon: 30, stylist: 70 },
          status: 'COMPLETED',
          createdAt: slotStart,
          services: {
            create: [
              { serviceId: svc.id, sortOrder: 0 },
              ...(secondSvc ? [{ serviceId: secondSvc.id, sortOrder: 1 }] : []),
            ],
          },
        },
      });
      bookingSeq++;
    }
  }

  console.log(`Demo seed complete: salon=${salon.id}, customers=${customerDefs.length}, bookings=${bookingSeq}`);
  console.log(`Login: phone ${DEMO_OWNER_PHONE} / password ${DEMO_OWNER_PASSWORD}`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
