'use client';

import { Sidebar } from '@/components/Sidebar';
import { TopBar } from '@/components/TopBar';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useAppStore } from '@/lib/store';
import { useEffect } from 'react';

const queryClient = new QueryClient();

function DashboardContent({ children }: { children: React.ReactNode }) {
  const setUser = useAppStore((state) => state.setUser);
  const setSalons = useAppStore((state) => state.setSalons);

  useEffect(() => {
    // Mock data for testing (bypass login)
    setUser({
      id: '1',
      name: 'Priya Sharma',
      email: 'priya@salone.com',
      phone: '9876543210',
      role: 'SALON_OWNER',
      salons: [],
    });
    setSalons([
      {
        id: '1',
        name: 'Lotus Salon & Spa',
        ownerId: '1',
        address: '123 Main St',
        phone: '9876543210',
        email: 'salon@example.com',
        currency: 'INR',
        countryCode: 'IN',
        todayStats: { revenue: 5096, count: 4 },
      },
      {
        id: '2',
        name: 'Elegance Beauty Studio',
        ownerId: '1',
        address: '456 Park Ave',
        phone: '9876543211',
        email: 'elegance@example.com',
        currency: 'INR',
        countryCode: 'IN',
        todayStats: { revenue: 3200, count: 3 },
      },
    ]);
  }, [setUser, setSalons]);

  return (
    <div className="flex h-screen bg-gray-50">
      <Sidebar />
      <div className="flex-1 flex flex-col overflow-hidden">
        <TopBar />
        <main className="flex-1 overflow-y-auto">{children}</main>
      </div>
    </div>
  );
}

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  return (
    <QueryClientProvider client={queryClient}>
      <DashboardContent>{children}</DashboardContent>
    </QueryClientProvider>
  );
}
