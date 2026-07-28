'use client';

import { create } from 'zustand';

// ---------- Types ----------

export type BookingStatus = 'COMPLETED' | 'PENDING' | 'CONFIRMED' | 'CANCELLED';
export type PaymentMethod = 'CASH' | 'UPI' | 'CARD';

export interface Staff {
  id: string;
  name: string;
  phone: string;
  serviceIds: string[];
  status: 'ACTIVE' | 'INACTIVE';
  commissionPct: number;
}

export interface Service {
  id: string;
  name: string;
  category: string;
  duration: number; // minutes
  price: number; // rupees
  stylistId?: string | null;
}

export interface Product {
  id: string;
  name: string;
  category: string;
  retailPrice: number;
  stockQty: number;
  lowStockThreshold: number;
}

export interface Customer {
  id: string;
  name: string;
  phone: string;
  notes: string;
  tags: string[];
}

export interface Booking {
  id: string;
  customerId: string;
  stylistId: string;
  serviceIds: string[];
  price: number;
  status: BookingStatus;
  time: string; // ISO
  paymentMethod?: PaymentMethod;
}

export interface SalonProfile {
  name: string;
  address: string;
  ownerName: string;
  ownerPhone: string;
  ownerEmail: string;
  dailyRevenueGoal: number; // rupees, 0 = unset
  plan: 'FREE' | 'PRO';
  joined: string;
}

// ---------- Mock dataset (deterministic) ----------

function mulberry32(seed: number) {
  return function () {
    let t = (seed += 0x6d2b79f5);
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

const STAFF: Staff[] = [
  { id: 'st1', name: 'Kabir M.', phone: '9876500011', serviceIds: ['sv1', 'sv2', 'sv7'], status: 'ACTIVE', commissionPct: 40 },
  { id: 'st2', name: 'Arjun Verma', phone: '9876500012', serviceIds: ['sv6', 'sv8'], status: 'ACTIVE', commissionPct: 35 },
  { id: 'st3', name: 'Sana R.', phone: '9876500013', serviceIds: ['sv4', 'sv5', 'sv6'], status: 'ACTIVE', commissionPct: 40 },
  { id: 'st4', name: 'Ravi K.', phone: '9876500014', serviceIds: [], status: 'INACTIVE', commissionPct: 30 },
];

const SERVICES: Service[] = [
  { id: 'sv1', name: 'Haircut', category: 'Hair', duration: 30, price: 300, stylistId: 'st1' },
  { id: 'sv2', name: 'Hair colour', category: 'Hair', duration: 60, price: 1200, stylistId: 'st1' },
  { id: 'sv3', name: 'Hair spa', category: 'Hair', duration: 45, price: 900 },
  { id: 'sv4', name: 'Manicure', category: 'Nails', duration: 30, price: 400, stylistId: 'st3' },
  { id: 'sv5', name: 'Pedicure', category: 'Nails', duration: 40, price: 500, stylistId: 'st3' },
  { id: 'sv6', name: 'Facial', category: 'Skin', duration: 45, price: 800 },
  { id: 'sv7', name: 'Beard trim', category: 'Grooming', duration: 20, price: 200, stylistId: 'st1' },
  { id: 'sv8', name: 'Full body spa', category: 'Spa', duration: 90, price: 2999, stylistId: 'st2' },
];

const PRODUCTS: Product[] = [
  { id: 'p1', name: 'Argan oil shampoo', category: 'Hair care', retailPrice: 599, stockQty: 45, lowStockThreshold: 10 },
  { id: 'p2', name: 'Deep conditioner', category: 'Hair care', retailPrice: 799, stockQty: 4, lowStockThreshold: 8 },
  { id: 'p3', name: 'Facial cleanser', category: 'Skin care', retailPrice: 449, stockQty: 28, lowStockThreshold: 10 },
  { id: 'p4', name: 'Vitamin C serum', category: 'Skin care', retailPrice: 1299, stockQty: 2, lowStockThreshold: 5 },
  { id: 'p5', name: 'Body lotion', category: 'Body care', retailPrice: 399, stockQty: 15, lowStockThreshold: 6 },
];

const CUSTOMERS: Customer[] = [
  { id: 'c1', name: 'Priya Sharma', phone: '9876543210', notes: 'Prefers Kabir. Allergic to ammonia colour.', tags: ['vip'] },
  { id: 'c2', name: 'Neha T.', phone: '9876543211', notes: '', tags: [] },
  { id: 'c3', name: 'Anjali K.', phone: '9876543212', notes: '', tags: ['new'] },
  { id: 'c4', name: 'Rohit Mehta', phone: '9876543213', notes: 'Monthly beard trim regular.', tags: [] },
  { id: 'c5', name: 'Divya S.', phone: '9876543214', notes: '', tags: [] },
  { id: 'c6', name: 'Farhan A.', phone: '9876543215', notes: '', tags: [] },
  { id: 'c7', name: 'Meera Iyer', phone: '9876543216', notes: 'Bridal package enquiry in March.', tags: ['vip'] },
  { id: 'c8', name: 'Sunil P.', phone: '9876543217', notes: '', tags: [] },
  { id: 'c9', name: 'Kavya N.', phone: '9876543218', notes: '', tags: [] },
  { id: 'c10', name: 'Aarav J.', phone: '9876543219', notes: '', tags: [] },
];

function dayAt(daysAgo: number, hour: number, minute = 0) {
  const d = new Date();
  d.setDate(d.getDate() - daysAgo);
  d.setHours(hour, minute, 0, 0);
  return d.toISOString();
}

function generateBookings(): Booking[] {
  const rand = mulberry32(42);
  const bookings: Booking[] = [];
  let id = 1;
  const payments: PaymentMethod[] = ['CASH', 'UPI', 'UPI', 'CARD'];

  // Customer visit patterns: regulars visit often, some churned (only old
  // visits), one reactivated (old visits + recent), some new (recent only).
  const patterns: Record<string, number[]> = {
    c1: [1, 8, 15, 22, 29, 36], // regular
    c2: [12, 20, 28, 36],       // regular but overdue → at risk
    c4: [16, 26, 36, 46],       // regular but overdue → at risk
    c5: [5, 75, 100, 130],      // came back after a long gap (reactivated)
    c6: [65, 80, 95],           // churned
    c7: [70, 85],               // churned
    c8: [4, 11],                // new-ish repeat
    c9: [6],                    // new
    c10: [13],                  // new
  };

  for (const [customerId, days] of Object.entries(patterns)) {
    for (const daysAgo of days) {
      const staff = STAFF[Math.floor(rand() * 3)];
      const pool = SERVICES.filter((s) => !s.stylistId || s.stylistId === staff.id);
      const svc = pool[Math.floor(rand() * pool.length)] ?? SERVICES[0];
      const extra = rand() > 0.75 ? SERVICES.find((s) => s.id === 'sv7' && svc.id !== 'sv7') : undefined;
      const serviceIds = extra ? [svc.id, extra.id] : [svc.id];
      const price = serviceIds.reduce((sum, sid) => sum + (SERVICES.find((s) => s.id === sid)?.price ?? 0), 0);
      bookings.push({
        id: `b${id++}`,
        customerId,
        stylistId: staff.id,
        serviceIds,
        price,
        status: 'COMPLETED',
        time: dayAt(daysAgo, 10 + Math.floor(rand() * 8), rand() > 0.5 ? 30 : 0),
        paymentMethod: payments[Math.floor(rand() * payments.length)],
      });
    }
  }

  // Today: completed walk-ins
  bookings.push(
    { id: `b${id++}`, customerId: 'c1', stylistId: 'st3', serviceIds: ['sv4'], price: 400, status: 'COMPLETED', time: dayAt(0, 11, 30), paymentMethod: 'UPI' },
    { id: `b${id++}`, customerId: 'c4', stylistId: 'st1', serviceIds: ['sv7'], price: 200, status: 'COMPLETED', time: dayAt(0, 10, 0), paymentMethod: 'CASH' },
    { id: `b${id++}`, customerId: 'c3', stylistId: 'st1', serviceIds: ['sv1'], price: 300, status: 'COMPLETED', time: dayAt(0, 12, 15), paymentMethod: 'CASH' },
  );

  // Needs action: a pending request
  bookings.push({
    id: `b${id++}`, customerId: 'c2', stylistId: 'st1', serviceIds: ['sv2'], price: 1200, status: 'PENDING', time: dayAt(-1, 15, 0),
  });

  // Today's schedule: confirmed future appointments
  bookings.push(
    { id: `b${id++}`, customerId: 'c7', stylistId: 'st2', serviceIds: ['sv8'], price: 2999, status: 'CONFIRMED', time: dayAt(0, 18, 0) },
    { id: `b${id++}`, customerId: 'c5', stylistId: 'st3', serviceIds: ['sv6'], price: 800, status: 'CONFIRMED', time: dayAt(0, 17, 0) },
  );

  return bookings;
}

// ---------- Store ----------

interface DataStore {
  staff: Staff[];
  services: Service[];
  products: Product[];
  customers: Customer[];
  bookings: Booking[];
  salon: SalonProfile;

  logBooking: (b: {
    customerName: string;
    customerPhone: string;
    stylistId: string;
    serviceIds: string[];
    completed: boolean;
    time?: string;
    paymentMethod?: PaymentMethod;
  }) => void;
  setBookingStatus: (id: string, status: BookingStatus) => void;
  addStaff: (name: string, phone: string, serviceIds: string[]) => void;
  updateStaff: (id: string, patch: Partial<Staff>) => void;
  saveService: (svc: Omit<Service, 'id'> & { id?: string }) => void;
  deleteService: (id: string) => void;
  addStarterServices: () => void;
  saveProduct: (p: Omit<Product, 'id'> & { id?: string }) => void;
  deleteProduct: (id: string) => void;
  saveCustomerProfile: (id: string, notes: string, tags: string[]) => void;
  updateSalon: (patch: Partial<SalonProfile>) => void;
}

const STARTER_SERVICES: Omit<Service, 'id'>[] = [
  { name: 'Haircut', category: 'Hair', duration: 30, price: 300 },
  { name: 'Hair colour', category: 'Hair', duration: 60, price: 1200 },
  { name: 'Hair spa', category: 'Hair', duration: 45, price: 900 },
  { name: 'Manicure', category: 'Nails', duration: 30, price: 400 },
  { name: 'Pedicure', category: 'Nails', duration: 40, price: 500 },
  { name: 'Facial', category: 'Skin', duration: 45, price: 800 },
  { name: 'Beard trim', category: 'Grooming', duration: 20, price: 200 },
];

let nextId = 1000;
const genId = (prefix: string) => `${prefix}${nextId++}`;

export const useDataStore = create<DataStore>((set, get) => ({
  staff: STAFF,
  services: SERVICES,
  products: PRODUCTS,
  customers: CUSTOMERS,
  bookings: generateBookings(),
  salon: {
    name: 'Lotus Salon & Spa',
    address: '123 MG Road, Bengaluru',
    ownerName: 'Priya Sharma',
    ownerPhone: '9876543210',
    ownerEmail: 'priya@salone.com',
    dailyRevenueGoal: 6000,
    plan: 'FREE',
    joined: '15 January 2026',
  },

  logBooking: ({ customerName, customerPhone, stylistId, serviceIds, completed, time, paymentMethod }) => {
    const state = get();
    let customer = state.customers.find(
      (c) => c.phone === customerPhone.trim() || c.name.toLowerCase() === customerName.trim().toLowerCase()
    );
    let customers = state.customers;
    if (!customer) {
      customer = { id: genId('c'), name: customerName.trim(), phone: customerPhone.trim(), notes: '', tags: [] };
      customers = [...customers, customer];
    }
    const price = serviceIds.reduce(
      (sum, sid) => sum + (state.services.find((s) => s.id === sid)?.price ?? 0), 0
    );
    const booking: Booking = {
      id: genId('b'),
      customerId: customer.id,
      stylistId,
      serviceIds,
      price,
      status: completed ? 'COMPLETED' : 'CONFIRMED',
      time: time ?? new Date().toISOString(),
      paymentMethod: completed ? paymentMethod : undefined,
    };
    set({ customers, bookings: [...state.bookings, booking] });
  },

  setBookingStatus: (id, status) =>
    set((s) => ({ bookings: s.bookings.map((b) => (b.id === id ? { ...b, status } : b)) })),

  addStaff: (name, phone, serviceIds) =>
    set((s) => ({
      staff: [...s.staff, { id: genId('st'), name, phone, serviceIds, status: 'ACTIVE', commissionPct: 40 }],
    })),

  updateStaff: (id, patch) =>
    set((s) => ({ staff: s.staff.map((m) => (m.id === id ? { ...m, ...patch } : m)) })),

  saveService: (svc) =>
    set((s) => ({
      services: svc.id
        ? s.services.map((x) => (x.id === svc.id ? { ...x, ...svc, id: svc.id! } : x))
        : [...s.services, { ...svc, id: genId('sv') }],
    })),

  deleteService: (id) => set((s) => ({ services: s.services.filter((x) => x.id !== id) })),

  addStarterServices: () =>
    set((s) => ({
      services: [...s.services, ...STARTER_SERVICES.map((x) => ({ ...x, id: genId('sv') }))],
    })),

  saveProduct: (p) =>
    set((s) => ({
      products: p.id
        ? s.products.map((x) => (x.id === p.id ? { ...x, ...p, id: p.id! } : x))
        : [...s.products, { ...p, id: genId('p') }],
    })),

  deleteProduct: (id) => set((s) => ({ products: s.products.filter((x) => x.id !== id) })),

  saveCustomerProfile: (id, notes, tags) =>
    set((s) => ({ customers: s.customers.map((c) => (c.id === id ? { ...c, notes, tags } : c)) })),

  updateSalon: (patch) => set((s) => ({ salon: { ...s.salon, ...patch } })),
}));

// ---------- Derived helpers ----------

export const formatINR = (n: number) => `₹${n.toLocaleString('en-IN')}`;

export const isSameDay = (a: Date, b: Date) =>
  a.getFullYear() === b.getFullYear() && a.getMonth() === b.getMonth() && a.getDate() === b.getDate();

export const startOfDay = (d: Date) => new Date(d.getFullYear(), d.getMonth(), d.getDate());

export function bookingsToday(bookings: Booking[]) {
  const now = new Date();
  return bookings.filter((b) => isSameDay(new Date(b.time), now));
}

export function loggedToday(bookings: Booking[]) {
  return bookingsToday(bookings)
    .filter((b) => b.status === 'COMPLETED')
    .sort((a, b) => b.time.localeCompare(a.time));
}

export function needsAction(bookings: Booking[]) {
  return bookings.filter((b) => b.status === 'PENDING');
}

export function todaySchedule(bookings: Booking[]) {
  const now = new Date();
  return bookingsToday(bookings)
    .filter((b) => b.status === 'CONFIRMED' && new Date(b.time) > now)
    .sort((a, b) => a.time.localeCompare(b.time));
}

export function repeatCustomerIds(bookings: Booking[]) {
  const counts = new Map<string, number>();
  for (const b of bookings) {
    if (b.status !== 'COMPLETED') continue;
    counts.set(b.customerId, (counts.get(b.customerId) ?? 0) + 1);
  }
  return new Set([...counts.entries()].filter(([, n]) => n >= 2).map(([id]) => id));
}

export interface CustomerHistory {
  customer: Customer;
  visits: number;
  totalSpend: number;
  lastVisit: Date | null;
  avgTicket: number;
  cadenceDays: number | null; // avg days between visits (needs >= 2)
  overdueDays: number;
}

export function customerHistories(customers: Customer[], bookings: Booking[]): CustomerHistory[] {
  return customers.map((customer) => {
    const done = bookings
      .filter((b) => b.customerId === customer.id && b.status === 'COMPLETED')
      .sort((a, b) => a.time.localeCompare(b.time));
    const visits = done.length;
    const totalSpend = done.reduce((s, b) => s + b.price, 0);
    const lastVisit = visits ? new Date(done[visits - 1].time) : null;
    let cadenceDays: number | null = null;
    if (visits >= 2) {
      const first = new Date(done[0].time);
      cadenceDays = Math.max(1, Math.round((lastVisit!.getTime() - first.getTime()) / 86400000 / (visits - 1)));
    }
    const daysSince = lastVisit ? Math.floor((Date.now() - lastVisit.getTime()) / 86400000) : 0;
    const overdueDays = cadenceDays ? Math.max(0, daysSince - cadenceDays) : 0;
    return { customer, visits, totalSpend, lastVisit, avgTicket: visits ? Math.round(totalSpend / visits) : 0, cadenceDays, overdueDays };
  });
}

export function atRiskCustomers(customers: Customer[], bookings: Booking[]) {
  return customerHistories(customers, bookings)
    .filter((h) => h.visits >= 2 && h.overdueDays > 0 && h.overdueDays < 45)
    .sort((a, b) => b.overdueDays - a.overdueDays);
}

export type CohortKey = 'retained' | 'new' | 'reactivated' | 'churned';

export function cohorts(customers: Customer[], bookings: Booking[]): Record<CohortKey, CustomerHistory[]> {
  const out: Record<CohortKey, CustomerHistory[]> = { retained: [], new: [], reactivated: [], churned: [] };
  for (const h of customerHistories(customers, bookings)) {
    if (!h.lastVisit) continue;
    const daysSince = Math.floor((Date.now() - h.lastVisit.getTime()) / 86400000);
    const done = bookings
      .filter((b) => b.customerId === h.customer.id && b.status === 'COMPLETED')
      .sort((a, b) => a.time.localeCompare(b.time));
    const firstVisitDays = Math.floor((Date.now() - new Date(done[0].time).getTime()) / 86400000);

    if (daysSince > 60) out.churned.push(h);
    else if (firstVisitDays <= 30) out.new.push(h);
    else if (done.length >= 2) {
      const prev = new Date(done[done.length - 2].time);
      const gap = Math.floor((h.lastVisit.getTime() - prev.getTime()) / 86400000);
      if (gap > 60 && daysSince <= 30) out.reactivated.push(h);
      else out.retained.push(h);
    } else out.retained.push(h);
  }
  return out;
}

export interface EarningsData {
  total: number;
  count: number;
  previousTotal: number;
  daily: { date: Date; total: number }[];
  topServices: { name: string; count: number; total: number }[];
  byStylist: { name: string; count: number; total: number }[];
  completed: Booking[];
}

export function earnings(
  bookings: Booking[],
  services: Service[],
  staff: Staff[],
  period: 'day' | 'week' | 'month'
): EarningsData {
  const days = period === 'day' ? 1 : period === 'week' ? 7 : 30;
  const now = new Date();
  const from = startOfDay(new Date(now.getTime() - (days - 1) * 86400000));
  const prevFrom = new Date(from.getTime() - days * 86400000);

  const done = bookings.filter((b) => b.status === 'COMPLETED');
  const inPeriod = done.filter((b) => new Date(b.time) >= from);
  const inPrev = done.filter((b) => {
    const t = new Date(b.time);
    return t >= prevFrom && t < from;
  });

  const daily: { date: Date; total: number }[] = [];
  for (let i = 0; i < days; i++) {
    const date = new Date(from.getTime() + i * 86400000);
    const total = inPeriod
      .filter((b) => isSameDay(new Date(b.time), date))
      .reduce((s, b) => s + b.price, 0);
    daily.push({ date, total });
  }

  const svcAgg = new Map<string, { count: number; total: number }>();
  const styAgg = new Map<string, { count: number; total: number }>();
  for (const b of inPeriod) {
    for (const sid of b.serviceIds) {
      const name = services.find((s) => s.id === sid)?.name ?? 'Service';
      const cur = svcAgg.get(name) ?? { count: 0, total: 0 };
      const share = Math.round(b.price / b.serviceIds.length);
      svcAgg.set(name, { count: cur.count + 1, total: cur.total + share });
    }
    const styName = staff.find((s) => s.id === b.stylistId)?.name ?? 'Staff';
    const cur = styAgg.get(styName) ?? { count: 0, total: 0 };
    styAgg.set(styName, { count: cur.count + 1, total: cur.total + b.price });
  }

  const rank = (m: Map<string, { count: number; total: number }>) =>
    [...m.entries()].map(([name, v]) => ({ name, ...v })).sort((a, b) => b.total - a.total).slice(0, 5);

  return {
    total: inPeriod.reduce((s, b) => s + b.price, 0),
    count: inPeriod.length,
    previousTotal: inPrev.reduce((s, b) => s + b.price, 0),
    daily,
    topServices: rank(svcAgg),
    byStylist: rank(styAgg),
    completed: [...inPeriod].sort((a, b) => b.time.localeCompare(a.time)),
  };
}

export function whatsappReminderUrl(customer: Customer, salonName: string) {
  const digits = customer.phone.replace(/\D/g, '');
  const intl = digits.startsWith('91') ? digits : `91${digits}`;
  const text = encodeURIComponent(
    `Hi ${customer.name}! It's been a while since your last visit to ${salonName}. We'd love to see you again — reply here to book your next appointment.`
  );
  return `https://wa.me/${intl}?text=${text}`;
}

export function bookingServiceNames(b: Booking, services: Service[]) {
  return b.serviceIds
    .map((sid) => services.find((s) => s.id === sid)?.name ?? 'Service')
    .join(' + ');
}

export function formatTime(iso: string) {
  return new Date(iso).toLocaleTimeString('en-IN', { hour: 'numeric', minute: '2-digit', hour12: true }).toLowerCase();
}

export function formatDay(d: Date) {
  const today = startOfDay(new Date());
  const day = startOfDay(d);
  const diff = Math.round((today.getTime() - day.getTime()) / 86400000);
  if (diff === 0) return 'Today';
  if (diff === 1) return 'Yesterday';
  return d.toLocaleDateString('en-IN', { weekday: 'short', day: 'numeric', month: 'short' });
}

export function categoryIcon(category: string): string {
  const c = category.toLowerCase();
  if (c.includes('nail')) return '💅';
  if (c.includes('skin') || c.includes('facial')) return '✨';
  if (c.includes('groom') || c.includes('beard')) return '🪒';
  if (c.includes('spa') || c.includes('massage')) return '🧖';
  if (c.includes('hair')) return '✂️';
  return '✂️';
}
