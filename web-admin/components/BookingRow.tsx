'use client';

import { StatusBadge } from './StatusBadge';
import { formatINR, type Booking } from '@/lib/salon-api';
import { RotateCcw } from 'lucide-react';
import { Avatar } from './Avatar';

function formatTime(iso: string) {
  return new Date(iso).toLocaleTimeString('en-IN', { hour: 'numeric', minute: '2-digit', hour12: true }).toLowerCase();
}

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
  return (
    <div
      className="flex items-center gap-3 px-3.5 py-2.5 hover:bg-primary-50/60 transition-colors cursor-pointer"
      onClick={() => onOpenCustomer(booking)}
    >
      <Avatar name={booking.customerName || '?'} size="sm" />
      <div className="flex-1 min-w-0">
        <p className="text-xs text-gray-900 truncate">
          <span className="font-semibold">{booking.serviceNames.join(' + ') || 'Service'}</span>
          <span className="text-gray-400"> · </span>
          <span className="text-gray-600">{booking.stylistName}</span>
        </p>
        <p className="text-xs text-gray-400 mt-0.5">
          {booking.customerName}
          {isRepeat && (
            <span className="ml-1.5 px-1.5 py-px rounded-full bg-primary-light text-primary-dark font-semibold text-[10px]">
              repeat
            </span>
          )}
          <span> · {formatTime(booking.time)}</span>
          {booking.products.length > 0 && (
            <span> · + {booking.products.map((p) => p.name).join(', ')}</span>
          )}
        </p>
      </div>
      <div className="flex items-center gap-3 flex-shrink-0 ml-3">
        <span className="text-xs text-gray-900 tabular-nums">{formatINR(booking.price + booking.retailTotal)}</span>
        <StatusBadge status={booking.status} />
        <button
          title="Rebook"
          onClick={(e) => {
            e.stopPropagation();
            onRebook(booking);
          }}
          className="p-1.5 hover:bg-gray-200 rounded-md transition-colors"
        >
          <RotateCcw size={13} className="text-gray-400" />
        </button>
      </div>
    </div>
  );
}
