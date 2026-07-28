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
    <div className="space-y-8">
      {/* Page Header */}
      <div className="flex justify-between items-start">
        <div>
          <h1 className="text-4xl font-extrabold text-salone-ink mb-2">Dashboard</h1>
          <p className="text-base font-medium text-salone-ink-muted">
            Welcome back! Here's your salon's performance overview
          </p>
        </div>
        <button className="px-6 py-3 bg-salone-accent text-white font-bold rounded-lg hover:opacity-90 transition-opacity shadow-md">
          + New Booking
        </button>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        <StatCard
          label="Today's Revenue"
          value={`₹${todayRevenue.toLocaleString()}`}
          change={{ value: 12, type: 'positive', label: 'from yesterday' }}
          icon={<DollarSign size={24} />}
        />
        <StatCard
          label="Total Bookings"
          value={bookings?.length || 0}
          change={{ value: 8, type: 'positive', label: 'from yesterday' }}
          icon={<Calendar size={24} />}
        />
        <StatCard
          label="Active Staff"
          value="8"
          change={{ value: 2, type: 'positive', label: 'available' }}
          icon={<Users size={24} />}
        />
        <StatCard
          label="Rating"
          value="4.8★"
          change={{ value: 284, type: 'positive', label: 'reviews' }}
          icon={<Star size={24} />}
        />
      </div>

      {/* Today's Bookings */}
      <Card
        title="Today's Bookings"
      >
        {isLoading ? (
          <div className="text-center py-8 text-salone-ink-muted">Loading bookings...</div>
        ) : !bookings || bookings.length === 0 ? (
          <div className="text-center py-12">
            <div className="text-salone-ink-muted mb-2">No bookings today</div>
          </div>
        ) : (
          <div className="space-y-3">
            {bookings.map((booking) => (
              <div
                key={booking.id}
                className="flex items-center justify-between p-4 bg-salone-surface-alt rounded-lg border border-salone-border hover:bg-white transition-all hover:shadow-sm"
              >
                <div className="flex-1">
                  <div className="flex items-center gap-3 mb-2">
                    <div>
                      <div className="text-sm font-semibold text-salone-ink">
                        {booking.serviceName} • {booking.stylistName}
                      </div>
                      <div className="text-xs text-salone-ink-muted">
                        {booking.customerName} • {booking.bookingTime}
                      </div>
                    </div>
                  </div>
                </div>
                <div className="flex items-center gap-4">
                  <div className="text-right">
                    <div className="text-sm font-bold text-salone-accent">
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
