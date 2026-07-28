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
      <div>
        <h1 className="text-2xl font-bold text-salone-ink mb-1">Home</h1>
        <p className="text-xs font-medium text-salone-ink-muted">
          Today's business overview
        </p>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard
          label="Today's revenue"
          description="today, all staff"
          value={`₹${todayRevenue.toLocaleString()}`}
          icon={<DollarSign size={18} />}
        />
        <StatCard
          label="Bookings today"
          description="across all staff"
          value={bookings?.length || 0}
          icon={<Calendar size={18} />}
        />
        <StatCard
          label="Active staff"
          description="on schedule"
          value="2"
          icon={<Users size={18} />}
        />
        <StatCard
          label="Rating"
          description="284 reviews"
          value="4.8"
          icon={<Star size={18} />}
        />
      </div>

      {/* Today's Bookings */}
      <Card
        title="Today's bookings"
        action={
          <button className="px-3 py-1.5 bg-salone-accent text-white text-xs font-semibold rounded-md hover:opacity-90 transition-opacity">
            + New booking
          </button>
        }
      >
        {isLoading ? (
          <div className="text-center py-8 text-salone-ink-muted text-sm">Loading bookings...</div>
        ) : !bookings || bookings.length === 0 ? (
          <div className="text-center py-8 text-salone-ink-muted text-sm">
            No bookings today
          </div>
        ) : (
          <div className="space-y-4">
            {bookings.map((booking) => (
              <div
                key={booking.id}
                className="flex items-center justify-between py-3 border-b border-salone-border last:border-b-0"
              >
                <div className="flex-1">
                  <div className="text-sm font-medium text-salone-ink">
                    {booking.serviceName} • {booking.stylistName}
                  </div>
                  <div className="text-xs text-salone-ink-muted mt-1">
                    {booking.customerName} • {booking.bookingTime}
                  </div>
                </div>
                <div className="flex items-center gap-4 ml-4">
                  <div className="text-right">
                    <div className="text-sm font-semibold text-salone-ink">
                      Rs {booking.totalAmount}
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
