import apiClient from './api';

// All money fields on the backend are stored in paise (minor units) — see
// mobile's formatMoney(). Every function here accepts/returns plain rupees;
// the /100 and *100 conversions happen at this boundary only, so page
// components never have to think about it.
const toRupees = (paise: number) => Math.round(paise) / 100;
const toPaise = (rupees: number) => Math.round(rupees * 100);

export const formatINR = (n: number) => `₹${n.toLocaleString('en-IN')}`;

// ---------- Types (rupee-denominated) ----------

export type BookingStatus =
  | 'PENDING'
  | 'PENDING_RESCHEDULE'
  | 'CONFIRMED'
  | 'IN_PROGRESS'
  | 'COMPLETED'
  | 'CANCELLED'
  | 'NO_SHOW';

export type PaymentMethod = 'CASH' | 'CARD' | 'UPI';

export interface Customer {
  id: string;
  name: string;
  phone: string;
}

export interface Service {
  id: string;
  name: string;
  category: string;
  duration: number;
  price: number;
  stylistId: string | null;
  stylistName: string | null;
}

export interface Product {
  id: string;
  name: string;
  category: string;
  retailPrice: number;
  stockQty: number;
  lowStockThreshold: number;
}

export interface Staff {
  id: string; // SalonStylist relation id
  stylistId: string;
  name: string;
  phone: string;
  status: 'ACTIVE' | 'PENDING' | 'TERMINATED';
  commissionRate: number;
  payType: 'COMMISSION' | 'SALARY' | 'BOTH';
  salaryAmount: number;
  canSetOwnPrice: boolean;
  canCancelBooking: boolean;
  serviceIds: string[];
}

export interface BookingProduct {
  productId: string;
  name: string;
  quantity: number;
  price: number; // rupees, per unit, snapshot at time of sale
}

export interface Booking {
  id: string;
  customerId: string;
  customerName: string;
  customerPhone: string;
  stylistId: string;
  stylistName: string;
  serviceIds: string[];
  serviceNames: string[];
  price: number;
  products: BookingProduct[];
  retailTotal: number;
  status: BookingStatus;
  time: string; // ISO
  paymentMethod: PaymentMethod | null;
}

export interface SalonSummary {
  id: string;
  name: string;
  address: string;
  currency: string;
  countryCode: string;
  dailyRevenueGoal: number;
  upiId: string | null;
  gstEnabled: boolean;
  gstRate: number;
  services: Service[];
  products: Product[];
  staff: Staff[];
  todayStats: { count: number; revenue: number };
}

// ---------- Mappers ----------

function mapService(s: any): Service {
  return {
    id: s.id,
    name: s.name,
    category: s.category,
    duration: s.duration,
    price: toRupees(s.basePrice ?? 0),
    stylistId: s.stylistId ?? null,
    stylistName: s.stylist?.user?.name ?? null,
  };
}

function mapProduct(p: any): Product {
  return {
    id: p.id,
    name: p.name,
    category: p.category,
    retailPrice: toRupees(p.retailPrice ?? 0),
    stockQty: p.stockQty ?? 0,
    lowStockThreshold: p.lowStockThreshold ?? 0,
  };
}

function mapStaff(rel: any): Staff {
  const stylist = rel.stylist ?? {};
  return {
    id: rel.id,
    stylistId: rel.stylistId ?? stylist.id,
    name: stylist.user?.name ?? 'Staff',
    phone: stylist.user?.phone ?? '',
    status: rel.status,
    commissionRate: rel.commissionRate ?? 70,
    payType: rel.payType ?? 'COMMISSION',
    salaryAmount: toRupees(rel.salaryAmount ?? 0),
    canSetOwnPrice: !!rel.canSetOwnPrice,
    canCancelBooking: !!rel.canCancelBooking,
    serviceIds: (stylist.services ?? []).map((s: any) => s.id),
  };
}

function mapBooking(b: any): Booking {
  const items = (b.services ?? []).length
    ? b.services.map((x: any) => x.service).filter(Boolean)
    : b.service
      ? [b.service]
      : [];
  const products: BookingProduct[] = (b.products ?? [])
    .filter((x: any) => x.product)
    .map((x: any) => ({
      productId: x.productId,
      name: x.product.name,
      quantity: x.quantity,
      price: toRupees(x.price ?? 0),
    }));
  return {
    id: b.id,
    customerId: b.customerId,
    customerName: b.customer?.name ?? b.customer?.phone ?? 'Customer',
    customerPhone: b.customer?.phone ?? '',
    stylistId: b.stylistId ?? '',
    stylistName: b.stylist?.user?.name ?? 'Staff',
    serviceIds: items.map((s: any) => s.id),
    serviceNames: items.map((s: any) => s.name),
    price: toRupees(b.price ?? 0),
    products,
    retailTotal: products.reduce((sum, p) => sum + p.quantity * p.price, 0),
    status: b.status,
    time: b.slotStart,
    paymentMethod: b.paymentMethod ?? null,
  };
}

function mapSalonSummary(s: any): SalonSummary {
  return {
    id: s.id,
    name: s.name,
    address: s.address,
    currency: s.currency,
    countryCode: s.countryCode,
    dailyRevenueGoal: toRupees(s.dailyRevenueGoal ?? 0),
    upiId: s.upiId ?? null,
    gstEnabled: s.gstEnabled ?? false,
    gstRate: s.gstRate ?? 18,
    services: (s.services ?? []).map(mapService),
    products: (s.products ?? []).map(mapProduct),
    staff: (s.stylists ?? []).map(mapStaff),
    todayStats: {
      count: s.todayStats?.count ?? 0,
      revenue: toRupees(s.todayStats?.revenue ?? 0),
    },
  };
}

// ---------- Salons ----------

export async function fetchSalons(): Promise<SalonSummary[]> {
  const res = await apiClient.get('/salons');
  return (res.data as any[]).map(mapSalonSummary);
}

export interface CreateSalonPayload {
  name: string;
  address: string;
  countryCode?: string;
  currency?: string;
}

export async function createSalon(payload: CreateSalonPayload): Promise<SalonSummary> {
  const res = await apiClient.post('/salons', payload);
  // POST /salons returns the bare Salon row (no nested services/products/
  // stylists/todayStats yet, since it's brand new) — map through the same
  // function with sensible empty defaults for those.
  return mapSalonSummary({ ...res.data, services: [], products: [], stylists: [], todayStats: { count: 0, revenue: 0 } });
}

// ---------- Bookings ----------

export async function fetchBookings(salonId: string): Promise<Booking[]> {
  const res = await apiClient.get(`/salons/${salonId}/bookings`);
  return (res.data as any[]).map(mapBooking);
}

export interface ProductSaleItem {
  productId: string;
  quantity: number;
}

export interface LogBookingPayload {
  salonId: string;
  stylistId: string;
  serviceIds: string[];
  customerName: string;
  customerPhone: string;
  completed: boolean;
  dateTime?: string; // ISO, required unless completed
  paymentMethod?: PaymentMethod;
  products?: ProductSaleItem[];
}

export async function logBooking(payload: LogBookingPayload): Promise<Booking> {
  const res = await apiClient.post('/bookings/salon-manual', {
    salonId: payload.salonId,
    stylistId: payload.stylistId,
    serviceIds: payload.serviceIds,
    customerName: payload.customerName,
    customerPhone: payload.customerPhone,
    completed: payload.completed,
    dateTime: payload.dateTime,
    paymentMethod: payload.paymentMethod,
    products: payload.products,
  });
  return mapBooking(res.data);
}

export async function setBookingStatus(
  bookingId: string,
  status: BookingStatus,
  paymentMethod?: PaymentMethod,
  products?: ProductSaleItem[]
): Promise<Booking> {
  const res = await apiClient.patch(`/bookings/${bookingId}/status`, { status, paymentMethod, products });
  return mapBooking(res.data);
}

// ---------- Services ----------

export async function saveService(
  salonId: string,
  svc: { id?: string; name: string; category: string; duration: number; price: number; stylistId: string | null }
): Promise<Service> {
  const body = {
    name: svc.name,
    category: svc.category,
    duration: svc.duration,
    basePrice: toPaise(svc.price),
    stylistId: svc.stylistId,
  };
  const res = svc.id
    ? await apiClient.patch(`/salons/${salonId}/services/${svc.id}`, body)
    : await apiClient.post(`/salons/${salonId}/services`, body);
  return mapService(res.data);
}

export async function deleteService(salonId: string, serviceId: string): Promise<void> {
  await apiClient.delete(`/salons/${salonId}/services/${serviceId}`);
}

// ---------- Products ----------

export async function saveProduct(
  salonId: string,
  p: {
    id?: string;
    name: string;
    category: string;
    retailPrice: number;
    stockQty: number;
    lowStockThreshold: number;
  }
): Promise<Product> {
  const body = {
    name: p.name,
    category: p.category,
    retailPrice: toPaise(p.retailPrice),
    stockQty: p.stockQty,
    lowStockThreshold: p.lowStockThreshold,
  };
  const res = p.id
    ? await apiClient.patch(`/salons/${salonId}/products/${p.id}`, body)
    : await apiClient.post(`/salons/${salonId}/products`, body);
  return mapProduct(res.data);
}

export async function deleteProduct(salonId: string, productId: string): Promise<void> {
  await apiClient.delete(`/salons/${salonId}/products/${productId}`);
}

// ---------- Staff ----------

export interface AddStaffPayload {
  name: string;
  phone: string;
  serviceName: string;
  price: number; // rupees
  startTime?: string;
  endTime?: string;
  days?: number[];
}

export async function addStaff(salonId: string, payload: AddStaffPayload): Promise<{ stylistId: string }> {
  const res = await apiClient.post(`/salons/${salonId}/staff-setup`, {
    name: payload.name,
    phone: payload.phone,
    serviceName: payload.serviceName,
    basePrice: toPaise(payload.price),
    startTime: payload.startTime,
    endTime: payload.endTime,
    days: payload.days,
  });
  return { stylistId: res.data.id };
}

export interface UpdateStaffPayload {
  status?: 'ACTIVE' | 'TERMINATED';
  canSetOwnPrice?: boolean;
  canCancelBooking?: boolean;
  payType?: 'COMMISSION' | 'SALARY' | 'BOTH';
  commissionRate?: number;
  salaryAmount?: number; // rupees
}

export async function updateStaff(salonId: string, stylistId: string, payload: UpdateStaffPayload): Promise<void> {
  await apiClient.patch(`/salons/${salonId}/stylists/${stylistId}`, {
    ...payload,
    salaryAmount: payload.salaryAmount != null ? toPaise(payload.salaryAmount) : undefined,
  });
}

export interface StylistEarnings {
  count: number;
  grossRevenue: number;
  totalPayout: number;
  unpaidTotal: number;
  unpaidCount: number;
  payType: 'COMMISSION' | 'SALARY' | 'BOTH';
  salaryAmount: number;
  salaryPaidThisMonth: boolean;
}

export async function fetchStylistEarnings(
  salonId: string,
  stylistId: string,
  period: 'day' | 'week' | 'month'
): Promise<StylistEarnings> {
  const res = await apiClient.get(`/salons/${salonId}/stylists/${stylistId}/earnings`, { params: { period } });
  return {
    count: res.data.count ?? 0,
    grossRevenue: toRupees(res.data.grossRevenue ?? 0),
    totalPayout: toRupees(res.data.totalPayout ?? 0),
    unpaidTotal: toRupees(res.data.unpaidTotal ?? 0),
    unpaidCount: res.data.unpaidCount ?? 0,
    payType: res.data.payType ?? 'COMMISSION',
    salaryAmount: toRupees(res.data.salaryAmount ?? 0),
    salaryPaidThisMonth: !!res.data.salaryPaidThisMonth,
  };
}

// Updates the underlying Stylist's name/phone — a different record from the
// SalonStylist relation (payType/commissionRate/etc, see updateStaff above).
export async function updateStylistProfile(
  stylistId: string,
  payload: { name: string; phone: string }
): Promise<void> {
  await apiClient.patch(`/stylists/${stylistId}`, payload);
}

// ---------- Working hours (per-stylist availability rules) ----------

export interface AvailabilityRule {
  id: string;
  dayOfWeek: number; // 0=Sun .. 6=Sat
  startTime: string; // HH:MM
  endTime: string;
}

export async function fetchAvailabilityRules(stylistId: string): Promise<AvailabilityRule[]> {
  const res = await apiClient.get(`/stylists/${stylistId}/availability-rules`);
  return (res.data as any[]).map((r) => ({
    id: r.id,
    dayOfWeek: r.dayOfWeek,
    startTime: r.startTime,
    endTime: r.endTime,
  }));
}

export async function addAvailabilityRule(
  stylistId: string,
  rule: { dayOfWeek: number; startTime: string; endTime: string }
): Promise<AvailabilityRule> {
  const res = await apiClient.post(`/stylists/${stylistId}/availability`, rule);
  return { id: res.data.id, dayOfWeek: res.data.dayOfWeek, startTime: res.data.startTime, endTime: res.data.endTime };
}

export async function deleteAvailabilityRule(stylistId: string, ruleId: string): Promise<void> {
  await apiClient.delete(`/stylists/${stylistId}/availability/${ruleId}`);
}

// ---------- Payouts ----------

export interface Payout {
  id: string;
  periodStart: string;
  periodEnd: string;
  grossRevenue: number;
  totalPayout: number;
  bookingCount: number;
  paidAt: string;
  isSalaryPayout: boolean;
  note: string | null;
}

function mapPayout(p: any): Payout {
  return {
    id: p.id,
    periodStart: p.periodStart,
    periodEnd: p.periodEnd,
    grossRevenue: toRupees(p.grossRevenue ?? 0),
    totalPayout: toRupees(p.totalPayout ?? 0),
    bookingCount: p.bookingCount ?? 0,
    paidAt: p.paidAt,
    isSalaryPayout: !!p.isSalaryPayout,
    note: p.note ?? null,
  };
}

export async function fetchPayouts(salonId: string, stylistId: string): Promise<Payout[]> {
  const res = await apiClient.get(`/salons/${salonId}/stylists/${stylistId}/payouts`);
  return (res.data as any[]).map(mapPayout);
}

// Settles every currently-unpaid COMPLETED booking for this stylist (not
// period-filtered — matches unpaidTotal, which is itself "everything unpaid
// right now"). periodStart/End just need to bracket all of it.
export async function settleCommissionPayout(salonId: string, stylistId: string): Promise<Payout> {
  const res = await apiClient.post(`/salons/${salonId}/stylists/${stylistId}/payouts`, {
    periodStart: new Date(2000, 0, 1).toISOString(),
    periodEnd: new Date().toISOString(),
  });
  return mapPayout(res.data);
}

export async function paySalary(salonId: string, stylistId: string): Promise<Payout> {
  const res = await apiClient.post(`/salons/${salonId}/stylists/${stylistId}/payouts`, { type: 'SALARY' });
  return mapPayout(res.data);
}

// ---------- Customers ----------

export async function fetchCustomers(salonId: string): Promise<Customer[]> {
  const res = await apiClient.get(`/salons/${salonId}/customers`);
  return (res.data as any[]).map((c) => ({ id: c.id, name: c.name ?? 'Customer', phone: c.phone ?? '' }));
}

export interface CustomerProfile {
  notes: string;
  tags: string[];
}

export async function fetchCustomerProfile(salonId: string, customerId: string): Promise<CustomerProfile> {
  const res = await apiClient.get(`/salons/${salonId}/customers/${customerId}`);
  return { notes: res.data.notes ?? '', tags: res.data.tags ?? [] };
}

export async function saveCustomerProfile(
  salonId: string,
  customerId: string,
  notes: string,
  tags: string[]
): Promise<void> {
  await apiClient.patch(`/salons/${salonId}/customers/${customerId}`, { notes, tags });
}

// ---------- Earnings ----------

export interface Earnings {
  total: number;
  count: number;
  previousTotal: number;
  daily: { date: string; total: number }[];
  topServices: { name: string; count: number; total: number }[];
  byStylist: { stylistId: string; name: string; count: number; total: number }[];
  bookings: {
    id: string;
    at: string;
    customerName: string;
    serviceName: string;
    price: number;
    paymentMethod: PaymentMethod | null;
  }[];
}

export async function fetchEarnings(salonId: string, period: 'day' | 'week' | 'month'): Promise<Earnings> {
  const res = await apiClient.get(`/salons/${salonId}/earnings`, { params: { period } });
  const d = res.data;
  return {
    total: toRupees(d.total ?? 0),
    count: d.count ?? 0,
    previousTotal: toRupees(d.previousTotal ?? 0),
    daily: (d.daily ?? []).map((x: any) => ({ date: x.date, total: toRupees(x.total ?? 0) })),
    topServices: (d.topServices ?? []).map((x: any) => ({ name: x.name, count: x.count, total: toRupees(x.total ?? 0) })),
    byStylist: (d.byStylist ?? []).map((x: any) => ({
      stylistId: x.stylistId,
      name: x.name,
      count: x.count,
      total: toRupees(x.total ?? 0),
    })),
    bookings: (d.bookings ?? []).map((x: any) => ({
      id: x.id,
      at: x.at,
      customerName: x.customerName,
      serviceName: x.serviceName,
      price: toRupees(x.price ?? 0),
      paymentMethod: x.paymentMethod ?? null,
    })),
  };
}

// The export endpoint needs the Authorization header like every other
// request, so a plain <a href> download won't work — fetch it as a blob
// through the authed client instead, then trigger the download ourselves.
// This also gets the FULL CSV; /earnings' own `bookings` field is truncated
// to 50 rows for the in-app list.
export async function downloadEarningsCsv(salonId: string, period: 'day' | 'week' | 'month'): Promise<void> {
  const res = await apiClient.get(`/salons/${salonId}/earnings/export`, {
    params: { period },
    responseType: 'blob',
  });
  const url = URL.createObjectURL(res.data as Blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `earnings-${period}.csv`;
  a.click();
  URL.revokeObjectURL(url);
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

// Same India-market starter set the mobile app offers when a catalog is
// completely empty — posted one at a time (no bulk-create endpoint exists).
export const STARTER_SERVICES: { name: string; category: string; duration: number; price: number }[] = [
  { name: 'Haircut', category: 'Hair', duration: 30, price: 300 },
  { name: 'Hair Colour', category: 'Hair', duration: 60, price: 1200 },
  { name: 'Hair Spa', category: 'Hair', duration: 45, price: 900 },
  { name: 'Manicure', category: 'Nails', duration: 30, price: 400 },
  { name: 'Pedicure', category: 'Nails', duration: 40, price: 500 },
  { name: 'Facial', category: 'Skin', duration: 45, price: 800 },
  { name: 'Beard Trim', category: 'Grooming', duration: 20, price: 200 },
];

export async function addStarterServices(salonId: string): Promise<void> {
  for (const s of STARTER_SERVICES) {
    await saveService(salonId, { name: s.name, category: s.category, duration: s.duration, price: s.price, stylistId: null });
  }
}

// ---------- Retention ----------

export interface RetentionMember {
  customerId: string;
  name: string | null;
  phone: string;
  totalSpend: number;
  lastVisit: string;
  visits: number;
}

export interface Retention {
  summary: {
    activeThisMonth: number;
    activeLastMonth: number;
    newCustomers: number;
    retainedCustomers: number;
    reactivatedCustomers: number;
    churnedCustomers: number;
    churnRate: number;
  };
  missed: (RetentionMember & { status: 'DROPPED' | 'LAPSED' })[];
  cohorts: {
    new: RetentionMember[];
    retained: RetentionMember[];
    reactivated: RetentionMember[];
    churned: RetentionMember[];
  };
}

function mapRetentionMember(m: any): RetentionMember {
  return {
    customerId: m.customerId,
    name: m.name,
    phone: m.phone,
    totalSpend: toRupees(m.totalSpend ?? 0),
    lastVisit: m.lastVisit,
    visits: m.visits ?? 0,
  };
}

export async function fetchRetention(salonId: string): Promise<Retention> {
  const res = await apiClient.get(`/salons/${salonId}/retention`);
  const d = res.data;
  return {
    summary: d.summary,
    missed: (d.missed ?? []).map((m: any) => ({ ...mapRetentionMember(m), status: m.status })),
    cohorts: {
      new: (d.cohorts?.new ?? []).map(mapRetentionMember),
      retained: (d.cohorts?.retained ?? []).map(mapRetentionMember),
      reactivated: (d.cohorts?.reactivated ?? []).map(mapRetentionMember),
      churned: (d.cohorts?.churned ?? []).map(mapRetentionMember),
    },
  };
}

export interface AtRiskCustomer {
  customerId: string;
  name: string | null;
  phone: string;
  visits: number;
  cadenceDays: number;
  overdueDays: number;
  overdueRatio: number;
  totalSpend: number;
  lastVisit: string;
}

export async function fetchAtRisk(salonId: string): Promise<{ customers: AtRiskCustomer[]; atRiskRevenue: number }> {
  const res = await apiClient.get(`/salons/${salonId}/at-risk`);
  const customers = (res.data.customers ?? []).map((c: any) => ({
    customerId: c.customerId,
    name: c.name,
    phone: c.phone,
    visits: c.visits ?? 0,
    cadenceDays: c.cadenceDays ?? 0,
    overdueDays: c.overdueDays ?? 0,
    overdueRatio: c.overdueRatio ?? 0,
    totalSpend: toRupees(c.totalSpend ?? 0),
    lastVisit: c.lastVisit,
  }));
  return { customers, atRiskRevenue: toRupees(res.data.atRiskRevenue ?? 0) };
}
