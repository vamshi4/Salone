export interface Salon {
  id: string;
  name: string;
  ownerId: string;
  address: string;
  phone?: string;
  email?: string;
  currency: string;
  countryCode: string;
  dailyRevenueGoal?: number | null;
  upiId?: string | null;
  gstEnabled?: boolean;
  gstRate?: number;
  todayStats?: {
    count: number;
    revenue: number;
  };
}

export interface User {
  id: string;
  phone: string;
  email: string;
  name: string;
  role: 'SALON_OWNER' | 'STYLIST' | 'SUPER_ADMIN';
  salons: Salon[];
  createdAt?: string;
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
  status: 'PENDING' | 'CONFIRMED' | 'IN_PROGRESS' | 'COMPLETED' | 'CANCELLED' | 'NO_SHOW';
  notes?: string;
  totalAmount: number;
  bookedVia: 'ADMIN' | 'APP' | 'PUBLIC_PAGE' | 'WALK_IN';
  createdAt: string;
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
}

export interface Service {
  id: string;
  name: string;
  category: string;
  basePrice: number;
  duration: number;
}

export interface Product {
  id: string;
  name: string;
  category: string;
  stockQty: number;
  unit: string;
  costPrice: number;
}
