import { StatCard } from '../components/StatCard';
import { Card } from '../components/Card';
import { Badge } from '../components/Badge';
import { useAppStore } from '../stores/appStore';
import { useGetBookings } from '../api/queries';
import { format } from 'date-fns';
import { DollarSign, Calendar, Users, Star } from 'lucide-react';

export function Home() {
  const { selectedSalonId } = useAppStore();
  const today = format(new Date(), 'yyyy-MM-dd');
  const { data: bookings, isLoading } = useGetBookings(selectedSalonId || '', today);

  const todayRevenue = bookings?.reduce((sum, b) => sum + (b.totalAmount || 0), 0) || 0;
  const confirmedBookings = bookings?.filter((b) => b.status === 'CONFIRMED').length || 0;

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex justify-between items-end">
        <div>
          <h1 className="text-2xl font-bold text-salone-ink mb-1">Dashboard</h1>
          <p className="text-xs font-medium text-salone-ink-muted">
            Welcome back! Monitor your salon's performance
          </p>
        </div>
        <button className="px-4 py-2 bg-salone-accent text-white text-xs font-semibold rounded-md hover:bg-salone-accent-dark active:scale-95 transition-all shadow-sm hover:shadow-md">
          + New Booking
        </button>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard
          label="Today's Revenue"
          value={`₹${todayRevenue.toLocaleString()}`}
          change={{ value: 12, type: 'positive', label: 'vs yesterday' }}
          icon={<DollarSign size={20} />}
        />
        <StatCard
          label="Bookings Today"
          value={bookings?.length || 0}
          change={{ value: 8, type: 'positive', label: 'vs yesterday' }}
          icon={<Calendar size={20} />}
        />
        <StatCard
          label="Available Staff"
          value="8"
          change={{ value: 2, type: 'positive', label: 'on schedule' }}
          icon={<Users size={20} />}
        />
        <StatCard
          label="Rating"
          value="4.8"
          change={{ value: 284, type: 'positive', label: 'reviews' }}
          icon={<Star size={20} />}
        />
      </div>

      {/* Today's Bookings */}
      <Card
        title="Today's Bookings"
      >
        {isLoading ? (
          <div className="text-center py-12 text-salone-ink-muted">Loading bookings...</div>
        ) : !bookings || bookings.length === 0 ? (
          <div className="text-center py-12">
            <div className="inline-flex items-center justify-center w-12 h-12 bg-salone-surface-alt rounded-full mb-3">
              <Calendar className="w-6 h-6 text-salone-ink-faint" />
            </div>
            <p className="text-salone-ink-muted font-medium">No bookings today</p>
            <p className="text-xs text-salone-ink-faint mt-1">Your schedule is clear for now</p>
          </div>
        ) : (
          <div className="space-y-3">
            {bookings.map((booking, idx) => (
              <div
                key={booking.id}
                className={`flex items-center justify-between p-4 rounded-lg border transition-all hover:shadow-sm ${
                  idx % 2 === 0 ? 'bg-white border-salone-border' : 'bg-salone-surface-alt border-transparent'
                } hover:bg-white`}
              >
                <div className="flex-1 min-w-0">
                  <div className="text-sm font-semibold text-salone-ink truncate">
                    {booking.serviceName}
                  </div>
                  <div className="text-xs text-salone-ink-muted mt-0.5">
                    {booking.customerName} • {booking.stylistName} • {booking.bookingTime}
                  </div>
                </div>
                <div className="flex items-center gap-3 ml-4">
                  <div className="text-right">
                    <div className="text-sm font-semibold text-salone-ink">
                      ₹{booking.totalAmount.toLocaleString()}
                    </div>
                  </div>
                  <Badge status={booking.status} />
                </div>
              </div>
            ))}
          </div>
        )}
      </Card>
    </div>
  );
}
