import { useState } from 'react';
import { Card } from '../components/Card';
import { Badge } from '../components/Badge';
import { useAppStore } from '../stores/appStore';
import { useGetBookings } from '../api/queries';
import { format } from 'date-fns';

export function Bookings() {
  const { selectedSalonId } = useAppStore();
  const [selectedDate, setSelectedDate] = useState(format(new Date(), 'yyyy-MM-dd'));
  const { data: bookings, isLoading } = useGetBookings(selectedSalonId || '', selectedDate);

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div>
        <h1 className="text-3xl font-extrabold text-salone-ink mb-1">Bookings</h1>
        <p className="text-sm font-semibold text-salone-ink-muted">Manage all your appointments</p>
      </div>

      {/* Filters */}
      <div className="flex gap-3">
        <input
          type="date"
          value={selectedDate}
          onChange={(e) => setSelectedDate(e.target.value)}
          className="px-4 py-2 bg-salone-surface-alt border border-salone-border rounded-full text-sm font-semibold text-salone-ink"
        />
        <button className="px-5 py-2 bg-salone-accent text-white text-sm font-bold rounded-full hover:opacity-90 transition-opacity">
          + New Booking
        </button>
      </div>

      {/* Bookings List */}
      <Card title="All Bookings">
        {isLoading ? (
          <div className="text-center py-8 text-salone-ink-muted">Loading bookings...</div>
        ) : !bookings || bookings.length === 0 ? (
          <div className="text-center py-8 text-salone-ink-muted">No bookings on this date</div>
        ) : (
          <div className="space-y-3">
            {bookings.map((booking) => (
              <div
                key={booking.id}
                className="flex items-center justify-between p-4 bg-salone-surface-alt rounded-lg hover:bg-salone-border transition-colors"
              >
                <div>
                  <div className="font-semibold text-salone-ink">{booking.customerName}</div>
                  <div className="text-xs text-salone-ink-muted mt-1">
                    {booking.stylistName} • {booking.serviceName}
                  </div>
                </div>
                <div className="flex items-center gap-3">
                  <div className="text-right">
                    <div className="font-semibold text-salone-ink">{booking.bookingTime}</div>
                    <div className="text-xs text-salone-ink-muted">₹{booking.totalAmount}</div>
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
