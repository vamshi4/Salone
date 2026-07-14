import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// Seeds realistic multi-month data into an EXISTING salon owner's account
// (does not create the owner/salon, and never touches anything the owner
// already created manually — only adds new stylists/services/customers/
// bookings with deterministic `:seed:`-prefixed IDs so re-running this is
// idempotent and safe). Mirrors seed-demo.ts's retention-pattern design,
// targeted at a real dev/test account instead of the separate demo salon.
const OWNER_PHONE = process.env.SEED_OWNER_PHONE || '7989698923';

function daysAgo(days: number, hour = 11, minute = 0) {
  const d = new Date();
  d.setDate(d.getDate() - days);
  d.setHours(hour, minute, 0, 0);
  return d;
}

function firstOfMonthsAgo(monthsAgo: number, day: number, hour = 11) {
  const now = new Date();
  return new Date(now.getFullYear(), now.getMonth() - monthsAgo, day, hour, 0, 0, 0);
}

async function main() {
  const owner = await prisma.user.findUnique({ where: { phone: OWNER_PHONE } });
  if (!owner) throw new Error(`No user found with phone ${OWNER_PHONE} — sign up first, then re-run this.`);

  const salon = await prisma.salon.findFirst({ where: { ownerId: owner.id, deletedAt: null } });
  if (!salon) throw new Error(`User ${OWNER_PHONE} has no salon — sign up as a salon owner first.`);

  console.log(`Seeding into existing salon "${salon.name}" (${salon.id})...`);

  // ---- Stylists (added alongside whatever you already have) ----
  const stylistDefs = [
    { phone: '9710000011', name: 'Ravi', base: 50000 },
    { phone: '9710000012', name: 'Priya', base: 60000 },
    { phone: '9710000013', name: 'Sana', base: 55000 },
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
      update: { status: 'ACTIVE', commissionRate: 70, canSetOwnPrice: false },
      create: { salonId: salon.id, stylistId: st.id, status: 'ACTIVE', commissionRate: 70 },
    });
    stylists.push({ ...st, name: s.name });
  }

  // ---- Services (deterministic IDs distinct from anything you added by hand) ----
  const serviceDefs = [
    { name: 'Haircut', category: 'Hair', duration: 45, basePrice: 50000 },
    { name: 'Hair Spa', category: 'Hair', duration: 60, basePrice: 90000 },
    { name: 'Beard Trim', category: 'Grooming', duration: 30, basePrice: 30000 },
    { name: 'Facial', category: 'Skin', duration: 60, basePrice: 120000 },
    { name: 'Hair Colour', category: 'Hair', duration: 90, basePrice: 180000 },
    { name: 'Manicure', category: 'Nails', duration: 40, basePrice: 60000 },
    { name: 'Pedicure', category: 'Nails', duration: 50, basePrice: 80000 },
  ];
  const services: Record<string, any> = {};
  for (const svc of serviceDefs) {
    const id = `${salon.id}:seed:svc:${svc.name}`;
    services[svc.name] = await prisma.service.upsert({
      where: { id },
      update: { name: svc.name, category: svc.category, duration: svc.duration, basePrice: svc.basePrice, salonId: salon.id },
      create: { id, name: svc.name, category: svc.category, duration: svc.duration, basePrice: svc.basePrice, salonId: salon.id },
    });
  }

  // ---- Customers with intentional retention patterns ----
  // months-ago legend: 0 = this month, 1 = last month, 2 = two months ago
  const customerDefs = [
    // Retained (visit every month incl. this month)
    { phone: '8810000001', name: 'Anjali', tags: ['VIP', 'Regular'], visits: [2, 1, 0, 0] },
    { phone: '8810000002', name: 'Rohan', tags: ['Regular'], visits: [2, 1, 0] },
    { phone: '8810000003', name: 'Meera', tags: ['Regular'], visits: [1, 0] },
    { phone: '8810000004', name: 'Karthik', tags: ['VIP'], visits: [2, 1, 0, 0] },
    // Churned (visited before, NOT this month) -> the "missed" list
    { phone: '8810000005', name: 'Divya', tags: ['Regular'], visits: [2, 1] },
    { phone: '8810000006', name: 'Suresh', tags: [], visits: [2, 1] },
    { phone: '8810000007', name: 'Farhan', tags: ['VIP'], visits: [2, 1, 1] },
    { phone: '8810000008', name: 'Lakshmi', tags: ['Regular'], visits: [1] },
    { phone: '8810000030', name: 'Ramesh', tags: [], visits: [1] },
    { phone: '8810000031', name: 'Sunita', tags: [], visits: [1] },
    { phone: '8810000032', name: 'Vijay', tags: [], visits: [2, 1] },
    // New this month
    { phone: '8810000009', name: 'Naveen', tags: ['New'], visits: [0] },
    { phone: '8810000010', name: 'Pooja', tags: ['New'], visits: [0, 0] },
    { phone: '8810000011', name: 'Imran', tags: ['New'], visits: [0] },
    // Reactivated (skipped last month, back this month) -> drives the "wins" card
    { phone: '8810000012', name: 'Sneha', tags: ['Winback'], visits: [2, 0] },
    { phone: '8810000014', name: 'Arjun', tags: ['Winback'], visits: [2, 0] },
    // At-risk regulars: tight visit rhythm, now well past due
    { phone: '8810000020', name: 'Priyanka', tags: ['VIP', 'Regular'], visits: [], daysAgo: [70, 56, 42] },
    { phone: '8810000021', name: 'Rahul', tags: ['Regular'], visits: [], daysAgo: [95, 63, 49] },
    { phone: '8810000022', name: 'Aisha', tags: ['VIP'], visits: [], daysAgo: [84, 56, 44] },
    { phone: '8810000023', name: 'Kiran', tags: [], visits: [], daysAgo: [66, 52, 40] },
  ];

  await prisma.booking.deleteMany({ where: { id: { startsWith: `${salon.id}:seed:bk:` } } });

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
      const bookingId = `${salon.id}:seed:bk:${c.phone}:${i}`;
      let slotStart: Date;
      if (explicitDays) {
        slotStart = daysAgo(explicitDays[i], 11 + (bookingSeq % 6));
      } else {
        const monthsBack = c.visits[i];
        const day = 8 + ((bookingSeq * 3) % 18);
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
          completedAt: slotStart,
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

  console.log(`Seed complete: salon=${salon.id}, stylists=${stylists.length}, customers=${customerDefs.length}, bookings=${bookingSeq}`);
  console.log(`Login: phone ${OWNER_PHONE} (your existing password)`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
