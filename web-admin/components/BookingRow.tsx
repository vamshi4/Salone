'use client';

import { StatusBadge } from './StatusBadge';
import {
  useDataStore,
  formatINR,
  formatTime,
  bookingServiceNames,
  type Booking,
} from '@/lib/data';
import { RotateCcw } from 'lucide-react';

/** One row in a booking log list. Click opens the customer profile;
 * the rebook button pre-fills a new scheduled booking. */
export function BookingRow({
  booking,
  isRepeat,
  onOpenCustomer,
  onRebook,
}: {
  booking: Booking;
  isRepeat?: boolean;
  onOpenCustomer: (b: Booking) => void;
  onRebook: (b: Booking) => void;
}) {
  const { services, staff, customers } = useDataStore();
  const customer = customers.find((c) => c.id === booking.customerId);
  const stylist = staff.find((s) => s.id === booking.stylistId);

  return (
    <div
      className="flex items-center justify-between px-3.5 py-2.5 hover:bg-gray-50 transition-colors cursor-pointer"
      onClick={() => onOpenCustomer(booking)}
    >
      <div className="flex-1 min-w-0">
        <p className="text-xs text-gray-900 truncate">
          <span className="font-medium">{bookingServiceNames(booking, services)}</span>
          <span className="text-gray-400"> · </span>
          <span className="text-gray-600">{stylist?.name ?? ''}</span>
        </p>
        <p className="text-xs text-gray-400 mt-0.5">
          {customer?.name ?? 'Customer'}
          {isRepeat && (
            <span className="ml-1.5 px-1.5 py-px rounded bg-primary-light text-primary-dark font-medium">
              repeat
            </span>
          )}
          <span> · {formatTime(booking.time)}</span>
        </p>
      </div>
      <div className="flex items-center gap-3 flex-shrink-0 ml-3">
        <span className="text-xs text-gray-900 tabular-nums">{formatINR(booking.price)}</span>
        <StatusBadge status={booking.status} />
        <button
          title="Rebook"
          onClick={(e) => {
            e.stopPropagation();
            onRebook(booking);
          }}
          className="p-1 hover:bg-gray-200 rounded transition-colors"
        >
          <RotateCcw size={13} className="text-gray-400" />
        </button>
      </div>
    </div>
  );
}
