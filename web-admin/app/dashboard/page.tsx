'use client';

import { useAppStore } from '@/lib/store';
import { StatusBadge, formatINR } from '@/components/StatusBadge';
import { Plus } from 'lucide-react';

function greeting() {
  const h = new Date().getHours();
  if (h < 12) return 'Good morning';
  if (h < 17) return 'Good afternoon';
  return 'Good evening';
}

function StatCard({
  label,
  value,
  trend,
  trendPositive,
}: {
  label: string;
  value: string | number;
  trend?: string;
  trendPositive?: boolean;
}) {
  return (
    <div className="bg-white border border-gray-200 rounded-lg px-3.5 py-3">
      <p className="text-xs text-gray-500">{label}</p>
      <p className="text-xl font-semibold text-gray-900 tabular-nums mt-0.5">{value}</p>
      {trend && (
        <p className={`text-xs mt-0.5 ${trendPositive ? 'text-green-700' : 'text-gray-400'}`}>
          {trend}
        </p>
      )}
    </div>
  );
}

export default function DashboardPage() {
  const user = useAppStore((state) => state.user);
  const selectedSalonId = useAppStore((state) => state.selectedSalonId);
  const salons = useAppStore((state) => state.salons);

  const selectedSalon = salons.find((s) => s.id === selectedSalonId);
  const todayRevenue = selectedSalon?.todayStats?.revenue || 0;

  const today = new Date().toLocaleDateString('en-IN', {
    weekday: 'long',
    day: 'numeric',
    month: 'long',
  });

  // Mock bookings
  const bookings = [
    {
      id: '1',
      serviceName: 'Haircut & style',
      stylistName: 'Kabir M.',
      customerName: 'Priya Sharma',
      bookingTime: '3:00 pm',
      totalAmount: 399,
      status: 'PENDING',
    },
    {
      id: '2',
      serviceName: 'Full body spa',
      stylistName: 'Arjun Verma',
      customerName: 'Neha T.',
      bookingTime: '6:00 pm',
      totalAmount: 2999,
      status: 'CONFIRMED',
    },
    {
      id: '3',
      serviceName: 'Beard trim',
      stylistName: 'Sana R.',
      customerName: 'Priya Sharma',
      bookingTime: '11:30 am',
      totalAmount: 199,
      status: 'COMPLETED',
    },
  ];

  const firstName = user?.name?.split(' ')[0];

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="p-4 space-y-4 max-w-7xl mx-auto">
        {/* Header */}
        <div>
          <h1 className="text-lg font-semibold text-gray-900">
            {greeting()}{firstName ? `, ${firstName}` : ''}
          </h1>
          <p className="text-xs text-gray-400 mt-0.5">
            {today} · {salons.length} salons
          </p>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-4 gap-3">
          <StatCard
            label="Revenue today"
            value={formatINR(todayRevenue)}
            trend="↑ 12% vs last Mon"
            trendPositive
          />
          <StatCard label="Bookings" value={bookings.length} trend="2 upcoming" />
          <StatCard label="Staff on duty" value="2" trend="of 3 scheduled" />
          <StatCard label="Rating" value="4.8" trend="284 reviews" />
        </div>

        {/* Today's bookings */}
        <div>
          <div className="flex items-center justify-between mb-2">
            <h2 className="text-sm font-semibold text-gray-900">Today's bookings</h2>
            <button className="btn-primary">
              <Plus size={13} />
              New booking
            </button>
          </div>

          <div className="bg-white border border-gray-200 rounded-lg divide-y divide-gray-100">
            {bookings.map((booking) => (
              <div
                key={booking.id}
                className="flex items-center justify-between px-3.5 py-2.5 hover:bg-gray-50 transition-colors cursor-pointer"
              >
                <div className="flex-1 min-w-0">
                  <p className="text-xs text-gray-900">
                    <span className="font-medium">{booking.serviceName}</span>
                    <span className="text-gray-400"> · </span>
                    <span className="text-gray-600">{booking.stylistName}</span>
                  </p>
                  <p className="text-xs text-gray-400 mt-0.5">
                    {booking.customerName} · {booking.bookingTime}
                  </p>
                </div>
                <div className="flex items-center gap-4 flex-shrink-0 ml-3">
                  <span className="text-xs text-gray-900 tabular-nums">
                    {formatINR(booking.totalAmount)}
                  </span>
                  <StatusBadge status={booking.status} />
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
