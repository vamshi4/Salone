'use client';

import { useMemo, useState } from 'react';
import { PageLayout } from '@/components/PageLayout';
import { NewBookingModal } from '@/components/NewBookingModal';
import { CustomerProfileModal } from '@/components/CustomerProfileModal';
import { BookingRow } from '@/components/BookingRow';
import {
  useDataStore,
  formatINR,
  formatDay,
  formatTime,
  startOfDay,
  needsAction,
  todaySchedule,
  repeatCustomerIds,
  bookingServiceNames,
  type Booking,
  type Customer,
} from '@/lib/data';
import { Search, Plus, Check, X } from 'lucide-react';

function Chip({ label, selected, onClick }: { label: string; selected: boolean; onClick: () => void }) {
  return (
    <button
      onClick={onClick}
      className={selected ? 'chip-on' : 'chip-off'}
    >
      {label}
    </button>
  );
}

/** Pending / scheduled item with confirm–cancel actions. */
function ActionCard({ booking }: { booking: Booking }) {
  const { services, staff, customers, setBookingStatus } = useDataStore();
  const customer = customers.find((c) => c.id === booking.customerId);
  const isPending = booking.status === 'PENDING';

  return (
    <div className="flex items-center justify-between px-3.5 py-2.5 bg-white border border-amber-200 rounded-lg">
      <div className="flex-1 min-w-0">
        <p className="text-xs text-gray-900">
          <span className="font-medium">{bookingServiceNames(booking, services)}</span>
          <span className="text-gray-400"> · </span>
          <span className="text-gray-600">{staff.find((s) => s.id === booking.stylistId)?.name}</span>
        </p>
        <p className="text-xs text-gray-400 mt-0.5">
          {customer?.name} · {formatDay(new Date(booking.time))} {formatTime(booking.time)} ·{' '}
          {formatINR(booking.price)}
        </p>
      </div>
      <div className="flex items-center gap-1.5 ml-3">
        {isPending && (
          <button
            onClick={() => setBookingStatus(booking.id, 'CONFIRMED')}
            className="inline-flex items-center gap-1 px-2.5 py-1.5 rounded-md text-xs font-medium bg-primary text-white hover:bg-primary-dark transition-colors"
          >
            <Check size={12} />
            Confirm
          </button>
        )}
        {!isPending && (
          <button
            onClick={() => setBookingStatus(booking.id, 'COMPLETED')}
            className="inline-flex items-center gap-1 px-2.5 py-1.5 rounded-md text-xs font-medium bg-primary text-white hover:bg-primary-dark transition-colors"
          >
            <Check size={12} />
            Done
          </button>
        )}
        <button
          onClick={() => setBookingStatus(booking.id, 'CANCELLED')}
          className="inline-flex items-center gap-1 px-2.5 py-1.5 rounded-md text-xs font-medium text-gray-600 hover:bg-gray-100 transition-colors"
        >
          <X size={12} />
          Cancel
        </button>
      </div>
    </div>
  );
}

export default function BookingsPage() {
  const { bookings, staff, customers } = useDataStore();
  const [query, setQuery] = useState('');
  const [staffId, setStaffId] = useState<string | null>(null);
  const [periodDays, setPeriodDays] = useState(7); // 7 = this week, 0 = all time
  const [showNew, setShowNew] = useState(false);
  const [rebook, setRebook] = useState<Booking | undefined>();
  const [profileCustomer, setProfileCustomer] = useState<Customer | undefined>();

  const pending = needsAction(bookings);
  const schedule = todaySchedule(bookings);
  const repeats = repeatCustomerIds(bookings);
  const { services } = useDataStore();

  const byDay = useMemo(() => {
    const cutoff = periodDays === 0 ? null : new Date(Date.now() - periodDays * 86400000);
    const done = bookings.filter((b) => {
      if (b.status !== 'COMPLETED') return false;
      if (cutoff && new Date(b.time) < startOfDay(cutoff)) return false;
      if (staffId && b.stylistId !== staffId) return false;
      if (query.trim()) {
        const q = query.trim().toLowerCase();
        const cName = customers.find((c) => c.id === b.customerId)?.name.toLowerCase() ?? '';
        const sNames = bookingServiceNames(b, services).toLowerCase();
        if (!cName.includes(q) && !sNames.includes(q)) return false;
      }
      return true;
    });
    const groups = new Map<number, Booking[]>();
    for (const b of done) {
      const key = startOfDay(new Date(b.time)).getTime();
      groups.set(key, [...(groups.get(key) ?? []), b]);
    }
    return [...groups.entries()]
      .sort((a, b) => b[0] - a[0])
      .map(([ts, list]) => ({
        day: new Date(ts),
        bookings: list.sort((a, b) => b.time.localeCompare(a.time)),
      }));
  }, [bookings, customers, services, query, staffId, periodDays]);

  const periodTotal = byDay.reduce((s, d) => s + d.bookings.reduce((x, b) => x + b.price, 0), 0);
  const periodCount = byDay.reduce((s, d) => s + d.bookings.length, 0);
  const avgTicket = periodCount ? Math.round(periodTotal / periodCount) : 0;

  const openCustomer = (b: Booking) => {
    const c = customers.find((x) => x.id === b.customerId);
    if (c) setProfileCustomer(c);
  };

  return (
    <PageLayout
      title="Bookings"
      subtitle="The full service log"
      action={
        <button onClick={() => setShowNew(true)} className="btn-primary">
          <Plus size={13} />
          New booking
        </button>
      }
    >
      <div className="space-y-4">
        {/* Search + filters */}
        <div className="space-y-2">
          <div className="relative max-w-xs">
            <Search size={13} className="absolute left-2.5 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              className="w-full pl-8 pr-3 py-1.5 rounded-md text-xs bg-white border border-gray-200 placeholder-gray-500 focus:outline-none focus:ring-1 focus:ring-primary/40"
              placeholder="Search customer or service"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
            />
          </div>
          <div className="flex gap-1 overflow-x-auto">
            <Chip label="This week" selected={periodDays === 7} onClick={() => setPeriodDays(7)} />
            <Chip label="All time" selected={periodDays === 0} onClick={() => setPeriodDays(0)} />
            <span className="w-px bg-gray-200 mx-1" />
            <Chip label="All staff" selected={staffId === null} onClick={() => setStaffId(null)} />
            {staff.filter((s) => s.status === 'ACTIVE').map((s) => (
              <Chip key={s.id} label={s.name} selected={staffId === s.id} onClick={() => setStaffId(s.id)} />
            ))}
          </div>
        </div>

        {/* Needs action */}
        {pending.length > 0 && (
          <div>
            <h2 className="text-sm font-semibold text-gray-900 mb-2">
              Needs your response <span className="text-amber-600">({pending.length})</span>
            </h2>
            <div className="space-y-2">
              {pending.map((b) => (
                <ActionCard key={b.id} booking={b} />
              ))}
            </div>
          </div>
        )}

        {/* Today's schedule */}
        {schedule.length > 0 && (
          <div>
            <h2 className="text-sm font-semibold text-gray-900 mb-2">
              Today's schedule <span className="text-gray-400">({schedule.length})</span>
            </h2>
            <div className="space-y-2">
              {schedule.map((b) => (
                <ActionCard key={b.id} booking={b} />
              ))}
            </div>
          </div>
        )}

        {/* Period stats */}
        <div className="grid grid-cols-3 gap-3">
          <div className="stat-tile">
            <p className="text-xs text-gray-500">Total</p>
            <p className="text-xl font-semibold text-gray-900 tabular-nums mt-0.5">{formatINR(periodTotal)}</p>
          </div>
          <div className="stat-tile">
            <p className="text-xs text-gray-500">Services</p>
            <p className="text-xl font-semibold text-gray-900 tabular-nums mt-0.5">{periodCount}</p>
          </div>
          <div className="stat-tile">
            <p className="text-xs text-gray-500">Avg ticket</p>
            <p className="text-xl font-semibold text-gray-900 tabular-nums mt-0.5">{formatINR(avgTicket)}</p>
          </div>
        </div>

        {/* Grouped log */}
        {byDay.length === 0 ? (
          <div className="card px-4 py-6 text-center">
            <p className="text-xs text-gray-400">No bookings match this filter.</p>
          </div>
        ) : (
          byDay.map(({ day, bookings: list }) => (
            <div key={day.getTime()}>
              <div className="flex items-center justify-between mb-1.5">
                <p className="text-xs font-semibold text-gray-500">{formatDay(day)}</p>
                <p className="text-xs text-gray-400 tabular-nums">
                  {formatINR(list.reduce((s, b) => s + b.price, 0))} · {list.length}{' '}
                  {list.length === 1 ? 'service' : 'services'}
                </p>
              </div>
              <div className="card divide-y divide-gray-100">
                {list.map((b) => (
                  <BookingRow
                    key={b.id}
                    booking={b}
                    isRepeat={repeats.has(b.customerId)}
                    onOpenCustomer={openCustomer}
                    onRebook={setRebook}
                  />
                ))}
              </div>
            </div>
          ))
        )}
      </div>

      {showNew && <NewBookingModal onClose={() => setShowNew(false)} />}
      {rebook && <NewBookingModal prefill={rebook} onClose={() => setRebook(undefined)} />}
      {profileCustomer && (
        <CustomerProfileModal customer={profileCustomer} onClose={() => setProfileCustomer(undefined)} />
      )}
    </PageLayout>
  );
}
