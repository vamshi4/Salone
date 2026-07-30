'use client';

import { useState } from 'react';
import Link from 'next/link';
import { useAppStore } from '@/lib/store';
import { formatINR, type Booking, type Customer } from '@/lib/salon-api';
import { loggedToday, needsAction, repeatCustomerIds } from '@/lib/booking-helpers';
import {
  useAtRisk,
  useBookings,
  useCurrentSalon,
  useSelectedSalonId,
} from '@/lib/salon-queries';
import { NewBookingModal } from '@/components/NewBookingModal';
import { CustomerProfileModal } from '@/components/CustomerProfileModal';
import { AddStaffModal } from '@/components/StaffModals';
import { ServiceModal } from '@/components/ServiceModal';
import { BookingRow } from '@/components/BookingRow';
import {
  Plus,
  UserPlus,
  Scissors,
  Package,
  AlertTriangle,
  ChevronRight,
  Sparkles,
  IndianRupee,
  Repeat,
  CalendarCheck,
} from 'lucide-react';

function greeting() {
  const h = new Date().getHours();
  if (h < 12) return 'Good morning';
  if (h < 17) return 'Good afternoon';
  return 'Good evening';
}

function StatTile({
  label,
  value,
  helper,
  icon: Icon,
  iconClass,
}: {
  label: string;
  value: string | number;
  helper: string;
  icon: React.ComponentType<{ size?: number | string; className?: string }>;
  iconClass: string;
}) {
  return (
    <div className="stat-tile flex items-start gap-3">
      {/* Hidden below sm — at 3-per-row on a ~360-412px phone, a fixed
          36px icon + gap left almost no room for the number itself,
          causing it to overflow the tile (confirmed via a real device
          screenshot: ₹2,497 spilling past its column). */}
      <div className={`hidden sm:flex w-9 h-9 rounded-lg items-center justify-center flex-shrink-0 ${iconClass}`}>
        <Icon size={17} />
      </div>
      <div className="min-w-0 flex-1">
        <p className="text-xs text-gray-500 break-words">{label}</p>
        <p className="text-lg sm:text-xl font-bold text-gray-900 tabular-nums leading-tight break-words">{value}</p>
        <p className="text-[11px] text-gray-400 break-words">{helper}</p>
      </div>
    </div>
  );
}

export default function DashboardPage() {
  const user = useAppStore((s) => s.user);
  const salonId = useSelectedSalonId();
  const salon = useCurrentSalon();
  const { data: bookings = [], isLoading, isError } = useBookings(salonId);
  const { data: atRiskData } = useAtRisk(salonId);

  const [modal, setModal] = useState<'booking' | 'staff' | 'service' | null>(null);
  const [rebook, setRebook] = useState<Booking | undefined>();
  const [profileCustomer, setProfileCustomer] = useState<Customer | undefined>();

  const logged = loggedToday(bookings);
  const todayRevenue = logged.reduce((s, b) => s + b.price, 0);
  const repeats = repeatCustomerIds(bookings);
  const repeatCount = logged.filter((b) => repeats.has(b.customerId)).length;
  const pending = needsAction(bookings);
  const atRisk = (atRiskData?.customers ?? []).slice(0, 2);
  const lowStock = (salon?.products ?? []).filter((p) => p.stockQty <= p.lowStockThreshold);
  const alertCount = [pending.length > 0, atRisk.length > 0, lowStock.length > 0].filter(Boolean).length;
  const goal = salon?.dailyRevenueGoal ?? 0;
  const pace = goal > 0 ? Math.min(1, todayRevenue / goal) : 0;

  const today = new Date().toLocaleDateString('en-IN', { weekday: 'long', day: 'numeric', month: 'long' });

  const openCustomer = (b: Booking) => {
    setProfileCustomer({ id: b.customerId, name: b.customerName, phone: b.customerPhone });
  };

  if (!salonId) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="card px-4 py-6 text-center">
          <p className="text-xs text-gray-400">No salon on your account yet.</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen">
      <div className="p-5 space-y-5 max-w-5xl mx-auto">
        {/* Hero briefing */}
        <div className="relative overflow-hidden rounded-2xl bg-gradient-to-br from-[#2FB0B0] via-primary to-primary-dark text-white shadow-hero">
          <div className="absolute -top-16 -right-16 w-56 h-56 rounded-full bg-white/10" />
          <div className="absolute -bottom-24 -right-2 w-40 h-40 rounded-full bg-white/5" />
          <div className="relative p-5">
            <p className="text-xs text-teal-100/80">{today}</p>
            <h1 className="text-xl font-bold mt-0.5">
              {greeting()}{user?.name ? `, ${user.name.split(' ')[0]}` : ''} 👋
            </h1>
            <p className="text-sm text-teal-50/90 mt-2">
              <span className="font-semibold text-white">
                {logged.length} {logged.length === 1 ? 'service' : 'services'}
              </span>{' '}
              logged today ·{' '}
              <span className="font-semibold text-white">{formatINR(todayRevenue)}</span> earned so far
            </p>
            {goal > 0 && (
              <div className="mt-3 max-w-sm">
                <div className="h-2 bg-white/20 rounded-full overflow-hidden">
                  <div
                    className="h-full bg-gradient-to-r from-teal-200 to-white rounded-full transition-all"
                    style={{ width: `${pace * 100}%` }}
                  />
                </div>
                <p className="text-[11px] text-teal-100/80 mt-1.5">
                  {Math.round(pace * 100)}% of your {formatINR(goal)} daily goal
                </p>
              </div>
            )}
            {/* overflow-x-auto: on a narrow phone these 4 buttons don't fit
                the card's width, and the card's own overflow-hidden (for the
                decorative background blob) was clipping "Inventory" with no
                way to reach it — confirmed on a real device screenshot. Now
                swipeable instead of silently cut off. */}
            <div className="flex items-center gap-2 mt-4 overflow-x-auto no-scrollbar">
              <button
                onClick={() => setModal('booking')}
                className="inline-flex items-center gap-1.5 rounded-lg bg-white text-primary-dark px-3.5 py-2 text-xs font-bold shadow-md hover:shadow-lg hover:-translate-y-px transition-all flex-shrink-0"
              >
                <Plus size={14} />
                New booking
              </button>
              <button
                onClick={() => setModal('staff')}
                className="inline-flex items-center gap-1.5 rounded-lg bg-white/15 text-white px-3.5 py-2 text-xs font-semibold hover:bg-white/25 transition-colors flex-shrink-0"
              >
                <UserPlus size={13} />
                Add staff
              </button>
              <button
                onClick={() => setModal('service')}
                className="inline-flex items-center gap-1.5 rounded-lg bg-white/15 text-white px-3.5 py-2 text-xs font-semibold hover:bg-white/25 transition-colors flex-shrink-0"
              >
                <Scissors size={13} />
                Add service
              </button>
              <Link
                href="/products"
                className="inline-flex items-center gap-1.5 rounded-lg bg-white/15 text-white px-3.5 py-2 text-xs font-semibold hover:bg-white/25 transition-colors flex-shrink-0"
              >
                <Package size={13} />
                Inventory
              </Link>
            </div>
          </div>
        </div>

        {isLoading && <p className="text-xs text-gray-400">Loading your day…</p>}
        {isError && <p className="text-xs text-red-600">Could not load bookings. Try refreshing.</p>}

        {/* Alerts row */}
        {alertCount > 0 && (
          <div
            className="grid gap-3"
            style={{ gridTemplateColumns: `repeat(${alertCount}, minmax(0, 1fr))` }}
          >
            {pending.length > 0 && (
              <Link href="/bookings" className="card p-4 border-l-4 border-l-primary flex items-center gap-3 hover:shadow-md transition-shadow">
                <div className="w-9 h-9 rounded-lg bg-primary-light flex items-center justify-center flex-shrink-0">
                  <CalendarCheck size={16} className="text-primary-dark" />
                </div>
                <div className="flex-1">
                  <p className="text-xs font-bold text-gray-900">Needs your response</p>
                  <p className="text-[11px] text-gray-500">
                    {pending.length} {pending.length === 1 ? 'booking needs' : 'bookings need'} confirmation
                  </p>
                </div>
                <ChevronRight size={16} className="text-gray-300" />
              </Link>
            )}
            {atRisk.length > 0 && (
              <div className="card p-4 border-l-4 border-l-amber-400">
                <div className="flex items-center gap-2">
                  <Sparkles size={14} className="text-amber-500" />
                  <p className="text-xs font-bold text-gray-900">Worth reaching out today</p>
                </div>
                <div className="mt-2 space-y-1.5">
                  {atRisk.map((c) => (
                    <button
                      key={c.customerId}
                      onClick={() => setProfileCustomer({ id: c.customerId, name: c.name ?? 'Customer', phone: c.phone })}
                      className="flex items-center justify-between w-full text-left group py-1 -mx-1 px-1 rounded hover:bg-amber-50/60 transition-colors"
                    >
                      <span className="text-xs font-medium text-gray-800 group-hover:text-primary-dark">
                        {c.name ?? 'Customer'}
                      </span>
                      <span className="text-[11px] px-2 py-0.5 rounded-full bg-amber-50 text-amber-700 font-semibold">
                        {c.overdueDays}d overdue
                      </span>
                    </button>
                  ))}
                </div>
              </div>
            )}
            {lowStock.length > 0 && (
              <Link href="/products?low=1" className="card p-4 border-l-4 border-l-red-400 flex items-center gap-3 hover:shadow-md transition-shadow">
                <div className="w-9 h-9 rounded-lg bg-red-50 flex items-center justify-center flex-shrink-0">
                  <AlertTriangle size={16} className="text-red-500" />
                </div>
                <div className="flex-1">
                  <p className="text-xs font-bold text-gray-900">Low stock</p>
                  <p className="text-[11px] text-gray-500">
                    {lowStock.length} {lowStock.length === 1 ? 'product needs' : 'products need'} a restock
                  </p>
                </div>
                <ChevronRight size={16} className="text-gray-300" />
              </Link>
            )}
          </div>
        )}

        {/* Stats */}
        <div className="grid grid-cols-3 gap-3">
          <StatTile
            label="Services today"
            value={logged.length}
            helper="logged so far"
            icon={CalendarCheck}
            iconClass="bg-primary-light text-primary-dark"
          />
          <StatTile
            label="Revenue today"
            value={formatINR(todayRevenue)}
            helper="all staff"
            icon={IndianRupee}
            iconClass="bg-emerald-50 text-emerald-600"
          />
          <StatTile
            label="Repeat customers"
            value={repeatCount}
            helper="came back today"
            icon={Repeat}
            iconClass="bg-violet-50 text-violet-600"
          />
        </div>

        {/* Logged today */}
        <div>
          <div className="flex items-center justify-between mb-2">
            <h2 className="text-sm font-bold text-gray-900">Logged today</h2>
            <Link href="/bookings" className="text-xs font-medium text-primary hover:text-primary-dark flex items-center gap-0.5">
              View all
              <ChevronRight size={13} />
            </Link>
          </div>
          {logged.length === 0 ? (
            <div className="card px-4 py-8 text-center">
              <p className="text-xs text-gray-400">Nothing logged today yet — tap "New booking" to log a walk-in.</p>
            </div>
          ) : (
            <div className="card divide-y divide-gray-100 overflow-hidden">
              {logged.map((b) => (
                <BookingRow
                  key={b.id}
                  booking={b}
                  isRepeat={repeats.has(b.customerId)}
                  onOpenCustomer={openCustomer}
                  onRebook={(bk) => setRebook(bk)}
                />
              ))}
            </div>
          )}
        </div>
      </div>

      {modal === 'booking' && <NewBookingModal onClose={() => setModal(null)} />}
      {modal === 'staff' && <AddStaffModal onClose={() => setModal(null)} />}
      {modal === 'service' && <ServiceModal onClose={() => setModal(null)} />}
      {rebook && <NewBookingModal prefill={rebook} onClose={() => setRebook(undefined)} />}
      {profileCustomer && (
        <CustomerProfileModal customer={profileCustomer} onClose={() => setProfileCustomer(undefined)} />
      )}
    </div>
  );
}
