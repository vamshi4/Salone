'use client';

import { useAppStore } from '@/lib/store';
import { PageLayout } from '@/components/PageLayout';
import { DollarSign, Calendar, Users, Star, Plus } from 'lucide-react';

function StatCard({
  label,
  value,
  subtitle,
  icon: Icon,
}: {
  label: string;
  value: string | number;
  subtitle?: string;
  icon: React.ComponentType<{ size: number }>;
}) {
  return (
    <div className="card p-3 bg-gradient-to-br from-white to-gray-50 hover:shadow-lg transition-all">
      <div className="flex items-start justify-between gap-2">
        <div className="flex-1 min-w-0">
          <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">{label}</p>
          <p className="text-2xl font-bold text-gray-900">{value}</p>
          {subtitle && <p className="text-xs text-gray-500 font-medium mt-0.5">{subtitle}</p>}
        </div>
        <div className="bg-primary/8 p-2 rounded-lg flex-shrink-0">
          <Icon size={18} className="text-primary" />
        </div>
      </div>
    </div>
  );
}

function Badge({ status }: { status: string }) {
  const statusStyles = {
    PENDING: 'badge-pending',
    CONFIRMED: 'badge-confirmed',
    COMPLETED: 'badge-completed',
    CANCELLED: 'bg-gray-100 text-gray-600',
    NO_SHOW: 'bg-gray-100 text-gray-600',
    IN_PROGRESS: 'badge-confirmed',
  };

  return <span className={`${statusStyles[status as keyof typeof statusStyles] || 'badge'} text-xs`}>{status}</span>;
}

export default function DashboardPage() {
  const selectedSalonId = useAppStore((state) => state.selectedSalonId);
  const salons = useAppStore((state) => state.salons);

  const selectedSalon = salons.find((s) => s.id === selectedSalonId);
  const todayRevenue = selectedSalon?.todayStats?.revenue || 0;

  // Mock bookings
  const bookings = [
    {
      id: '1',
      serviceName: 'Haircut & Style',
      stylistName: 'Kabir M.',
      customerName: 'Priya Sharma',
      bookingTime: '3:00 PM',
      totalAmount: 399,
      status: 'PENDING',
    },
    {
      id: '2',
      serviceName: 'Full body spa',
      stylistName: 'Arjun Verma',
      customerName: 'Neha T.',
      bookingTime: '6:00 PM',
      totalAmount: 2999,
      status: 'CONFIRMED',
    },
    {
      id: '3',
      serviceName: 'Beard trim',
      stylistName: 'Sana R.',
      customerName: 'Priya Sharma',
      bookingTime: '11:30 AM',
      totalAmount: 199,
      status: 'COMPLETED',
    },
  ];

  return (
    <PageLayout
      title="Welcome back"
      subtitle="Here's what's happening at your salons today"
    >
      {/* Stats Grid - 4 columns, one line */}
      <div className="grid grid-cols-4 gap-3">
        <StatCard
          label="Today's revenue"
          value={`Rs ${todayRevenue}`}
          subtitle="all staff"
          icon={DollarSign}
        />
        <StatCard
          label="Bookings today"
          value={bookings.length}
          subtitle="across all staff"
          icon={Calendar}
        />
        <StatCard label="Active staff" value="2" subtitle="on schedule" icon={Users} />
        <StatCard label="Rating" value="4.8" subtitle="284 reviews" icon={Star} />
      </div>

      {/* Today's Bookings */}
      <div className="card p-3">
        <div className="flex items-center justify-between mb-3">
          <div>
            <h2 className="text-sm font-bold text-gray-900">Today's bookings</h2>
            <p className="text-xs text-gray-500 mt-0">Manage your appointments</p>
          </div>
          <button className="btn-primary">
            <Plus size={14} />
            New booking
          </button>
        </div>

        <div className="space-y-2">
          {bookings.map((booking) => (
            <div
              key={booking.id}
              className="flex items-center justify-between p-2.5 bg-gray-50 border border-gray-200 rounded hover:bg-white hover:shadow-sm transition-all"
            >
              <div className="flex-1 min-w-0">
                <p className="font-semibold text-gray-900 text-xs">
                  {booking.serviceName}
                </p>
                <div className="flex items-center gap-1.5 mt-0.5 text-xs text-gray-600">
                  <span className="font-medium">{booking.stylistName}</span>
                  <span className="text-gray-400">·</span>
                  <span>{booking.customerName}</span>
                  <span className="text-gray-400">·</span>
                  <span>{booking.bookingTime}</span>
                </div>
              </div>
              <div className="flex items-center gap-2 flex-shrink-0 ml-3">
                <span className="text-primary font-bold text-xs whitespace-nowrap">Rs {booking.totalAmount}</span>
                <Badge status={booking.status} />
              </div>
            </div>
          ))}
        </div>
      </div>
    </PageLayout>
  );
}
