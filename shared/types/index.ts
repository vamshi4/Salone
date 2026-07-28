export interface Salon {
  id: string;
  name: string;
  ownerId: string;
  address: string;
  phone: string;
  email: string;
  currency: string;
  countryCode: string;
  commissionRate: number;
  todayStats?: {
    count: number;
    revenue: number;
  };
}

export interface Staff {
  id: string;
  name: string;
  phone: string;
  email?: string;
  payType: 'COMMISSION' | 'SALARY' | 'BOTH';
  commissionRate?: number;
  salaryAmount?: number;
  isActive: boolean;
  services: Service[];
  workingHours: WorkingHours[];
}

export interface Service {
  id: string;
  name: string;
  category: string;
  basePrice: number;
  duration: number;
  salonId?: string;
  stylistId?: string;
}

export interface WorkingHours {
  id: string;
  dayOfWeek: number;
  startTime: string;
  endTime: string;
  isWorking: boolean;
}

export interface Booking {
  id: string;
  customerId: string;
  customerName: string;
  customerPhone: string;
  stylistId: string;
  stylistName: string;
  serviceId: string;
  serviceName: string;
  bookingDate: string;
  bookingTime: string;
  status: 'PENDING' | 'CONFIRMED' | 'COMPLETED' | 'CANCELLED' | 'NO_SHOW';
  notes?: string;
  totalAmount: number;
  commissionAmount?: number;
  bookedVia: 'ADMIN' | 'APP' | 'PUBLIC_PAGE' | 'WALK_IN';
  createdAt: string;
}

export interface Product {
  id: string;
  name: string;
  category: string;
  stockQty: number;
  unit: string;
  costPrice: number;
  salonId: string;
  deletedAt?: string;
}

export interface InsightsData {
  totalRevenue: number;
  totalBookings: number;
  averageRating: number;
  retentionRate: number;
  earningsByService: Array<{
    serviceName: string;
    amount: number;
    bookingCount: number;
  }>;
  earningsByStaff: Array<{
    staffName: string;
    amount: number;
    bookingCount: number;
  }>;
}

export interface DashboardData {
  salon: Salon;
  salons: Salon[];
  stats: {
    todayRevenue: number;
    todayBookings: number;
    activeStaff: number;
    rating: number;
  };
}

export interface User {
  id: string;
  phone: string;
  email: string;
  name: string;
  role: 'SALON_OWNER' | 'STYLIST' | 'SUPER_ADMIN';
  salons: Salon[];
  salon?: Salon;
}

export type ColorSeed = 'magenta' | 'terracotta' | 'teal' | 'blue' | 'violet';
