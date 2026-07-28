'use client';

import { Sidebar } from '@/components/Sidebar';
import { TopBar } from '@/components/TopBar';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useAppStore } from '@/lib/store';
import { useEffect } from 'react';

const queryClient = new QueryClient();

function ShellContent({ children }: { children: React.ReactNode }) {
  const setUser = useAppStore((state) => state.setUser);
  const setSalons = useAppStore((state) => state.setSalons);

  useEffect(() => {
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
        address: '123 MG Road, Bengaluru',
        phone: '9876543210',
        email: 'salon@example.com',
        currency: 'INR',
        countryCode: 'IN',
        todayStats: { revenue: 0, count: 0 },
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
        todayStats: { revenue: 0, count: 0 },
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

export function AppShell({ children }: { children: React.ReactNode }) {
  return (
    <QueryClientProvider client={queryClient}>
      <ShellContent>{children}</ShellContent>
    </QueryClientProvider>
  );
}
