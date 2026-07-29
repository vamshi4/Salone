import apiClient from './api';

// Same convention as web-admin/lib/salon-api.ts — money is stored in paise
// (minor units) on the backend; every rupee<->paise conversion happens at
// this one boundary so pages never have to think about it.
const toRupees = (paise: number) => Math.round(paise) / 100;
const toPaise = (rupees: number) => Math.round(rupees * 100);

export const formatINR = (n: number) => `₹${n.toLocaleString('en-IN')}`;

// ---------- Stats / growth ----------

export interface PlatformStats {
  salons: number;
  owners: number;
  customers: number;
  bookings: number;
  bookings30: number;
  newSalons7: number;
  newSalons30: number;
  activeSalons: number;
  dormantSalons: number;
}

export async function fetchStats(): Promise<PlatformStats> {
  const res = await apiClient.get('/admin/stats');
  return res.data;
}

export interface GrowthPoint {
  date: string;
  signups: number;
  bookings: number;
}

export async function fetchGrowth(days: number): Promise<GrowthPoint[]> {
  const res = await apiClient.get('/admin/growth', { params: { days } });
  return res.data;
}

// ---------- Salons ----------

export interface SalonListItem {
  id: string;
  name: string;
  address: string;
  saasPlan: string;
  ownerName: string | null;
  ownerPhone: string;
  signedUpAt: string;
  bookings: number;
  customers: number;
  stylists: number;
  lastBookingAt: string | null;
}

export async function fetchSalons(): Promise<SalonListItem[]> {
  const res = await apiClient.get('/admin/salons');
  return res.data;
}

export interface SalonOwner {
  id: string;
  name: string | null;
  phone: string;
  email: string | null;
  role: string;
  createdAt: string;
}

export interface SalonService {
  id: string;
  name: string;
  category: string;
  duration: number;
  basePrice: number; // rupees
}

export interface SalonStylistRow {
  status: 'ACTIVE' | 'PENDING' | 'TERMINATED';
  stylist: {
    id: string;
    basePrice: number | null; // rupees
    homeServiceEnabled: boolean;
    independentBookingEnabled: boolean;
    deletedAt: string | null;
    user: { id: string; name: string | null; phone: string };
  };
}

export interface SalonCustomerRow {
  id: string; // SalonCustomer id
  notes: string;
  tags: string[];
  customer: { id: string; name: string | null; phone: string };
}

export interface SalonRecentBooking {
  id: string;
  slotStart: string;
  status: string;
  price: number; // rupees
  customer: { name: string | null; phone: string };
  service: { name: string } | null;
}

export interface SalonDetail {
  salon: {
    id: string;
    name: string;
    address: string;
    saasPlan: string;
    commissionRate: number;
    lat: number | null;
    lng: number | null;
    deletedAt: string | null;
    owner: SalonOwner;
    _count: { bookings: number; customers: number; stylists: number };
    services: SalonService[];
    stylists: SalonStylistRow[];
    customers: SalonCustomerRow[];
  };
  bookings: SalonRecentBooking[];
}

function toRupeesOrNull(v: number | null): number | null {
  return v == null ? null : toRupees(v);
}

export async function fetchSalonDetail(salonId: string): Promise<SalonDetail> {
  const res = await apiClient.get(`/admin/salons/${salonId}`);
  const s = res.data.salon;
  return {
    salon: {
      ...s,
      services: (s.services as any[]).map((svc) => ({ ...svc, basePrice: toRupees(svc.basePrice ?? 0) })),
      stylists: (s.stylists as any[]).map((row) => ({
        ...row,
        stylist: { ...row.stylist, basePrice: toRupeesOrNull(row.stylist.basePrice) },
      })),
    },
    bookings: (res.data.bookings as any[]).map((b) => ({ ...b, price: toRupees(b.price ?? 0) })),
  };
}

export interface UpdateSalonPayload {
  name?: string;
  address?: string;
  saasPlan?: string;
  commissionRate?: number;
  lat?: number;
  lng?: number;
}

export async function updateSalon(salonId: string, payload: UpdateSalonPayload) {
  const res = await apiClient.patch(`/admin/salons/${salonId}`, payload);
  return res.data;
}

export async function deleteSalon(salonId: string) {
  await apiClient.delete(`/admin/salons/${salonId}`);
}

export async function restoreSalon(salonId: string) {
  await apiClient.post(`/admin/salons/${salonId}/restore`);
}

// ---------- Users ----------

export interface UpdateUserPayload {
  name?: string | null;
  phone?: string;
  email?: string | null;
}

export async function updateUser(userId: string, payload: UpdateUserPayload) {
  const res = await apiClient.patch(`/admin/users/${userId}`, payload);
  return res.data;
}

export async function resetUserPassword(userId: string, password: string) {
  await apiClient.post(`/admin/users/${userId}/reset-password`, { password });
}

export async function updateUserRole(userId: string, role: string) {
  const res = await apiClient.patch(`/admin/users/${userId}/role`, { role });
  return res.data;
}

export async function deleteUser(userId: string) {
  await apiClient.delete(`/admin/users/${userId}`);
}

export async function restoreUser(userId: string) {
  await apiClient.post(`/admin/users/${userId}/restore`);
}

// ---------- Bookings ----------

export interface UpdateBookingPayload {
  status?: string;
  slotStart?: string;
  slotEnd?: string;
  price?: number; // rupees
}

export async function updateBooking(bookingId: string, payload: UpdateBookingPayload) {
  const res = await apiClient.patch(`/admin/bookings/${bookingId}`, {
    ...payload,
    price: payload.price != null ? toPaise(payload.price) : undefined,
  });
  return res.data;
}

export async function deleteBooking(bookingId: string) {
  await apiClient.delete(`/admin/bookings/${bookingId}`);
}

// ---------- Services ----------

export interface UpdateServicePayload {
  name?: string;
  category?: string;
  duration?: number;
  basePrice?: number; // rupees
}

export async function updateService(serviceId: string, payload: UpdateServicePayload) {
  const res = await apiClient.patch(`/admin/services/${serviceId}`, {
    ...payload,
    basePrice: payload.basePrice != null ? toPaise(payload.basePrice) : undefined,
  });
  return res.data;
}

export async function deleteService(serviceId: string) {
  await apiClient.delete(`/admin/services/${serviceId}`);
}

// ---------- Customers (SalonCustomer link) ----------

export interface UpdateCustomerPayload {
  notes?: string;
  tags?: string[];
  name?: string | null;
  phone?: string;
}

export async function updateCustomer(salonCustomerId: string, payload: UpdateCustomerPayload) {
  const res = await apiClient.patch(`/admin/customers/${salonCustomerId}`, payload);
  return res.data;
}

export async function deleteCustomer(salonCustomerId: string) {
  await apiClient.delete(`/admin/customers/${salonCustomerId}`);
}

// ---------- Stylists ----------

export interface UpdateStylistPayload {
  basePrice?: number | null; // rupees
  homeServiceEnabled?: boolean;
  independentBookingEnabled?: boolean;
}

export async function updateStylist(stylistId: string, payload: UpdateStylistPayload) {
  const res = await apiClient.patch(`/admin/stylists/${stylistId}`, {
    ...payload,
    basePrice: payload.basePrice !== undefined && payload.basePrice !== null ? toPaise(payload.basePrice) : payload.basePrice,
  });
  return res.data;
}

export async function deleteStylist(stylistId: string) {
  await apiClient.delete(`/admin/stylists/${stylistId}`);
}

export async function restoreStylist(stylistId: string) {
  await apiClient.post(`/admin/stylists/${stylistId}/restore`);
}

// ---------- Deleted items ----------

export interface DeletedSalon {
  id: string;
  name: string;
  address: string;
  saasPlan: string;
  deletedAt: string;
  owner: { name: string | null; phone: string };
}

export interface DeletedUser {
  id: string;
  name: string | null;
  phone: string;
  email: string | null;
  role: string;
  deletedAt: string;
}

export async function fetchDeleted(): Promise<{ salons: DeletedSalon[]; users: DeletedUser[] }> {
  const res = await apiClient.get('/admin/deleted');
  return res.data;
}

// ---------- Audit ----------

export interface AuditEntry {
  id: string;
  actorId: string;
  action: string;
  targetType: string;
  targetId: string;
  before: unknown;
  after: unknown;
  createdAt: string;
}

export async function fetchAudit(params?: { targetType?: string; targetId?: string; limit?: number }): Promise<AuditEntry[]> {
  const res = await apiClient.get('/admin/audit', { params });
  return res.data;
}
