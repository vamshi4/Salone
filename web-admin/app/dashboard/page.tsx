'use client';

import { useState } from 'react';
import Link from 'next/link';
import {
  useDataStore,
  formatINR,
  loggedToday,
  repeatCustomerIds,
  atRiskCustomers,
  type Booking,
  type Customer,
} from '@/lib/data';
import { NewBookingModal } from '@/components/NewBookingModal';
import { CustomerProfileModal } from '@/components/CustomerProfileModal';
import { AddStaffModal } from '@/components/StaffModals';
import { ServiceModal } from '@/components/ServiceModal';
import { BookingRow } from '@/components/BookingRow';
import { Plus, UserPlus, Scissors, Package, AlertTriangle, ChevronRight } from 'lucide-react';

function greeting() {
  const h = new Date().getHours();
  if (h < 12) return 'Good morning';
  if (h < 17) return 'Good afternoon';
  return 'Good evening';
}

export default function DashboardPage() {
  const { bookings, customers, products, salon } = useDataStore();
  const [modal, setModal] = useState<'booking' | 'staff' | 'service' | null>(null);
  const [rebook, setRebook] = useState<Booking | undefined>();
  const [profileCustomer, setProfileCustomer] = useState<Customer | undefined>();

  const logged = loggedToday(bookings);
  const todayRevenue = logged.reduce((s, b) => s + b.price, 0);
  const repeats = repeatCustomerIds(bookings);
  const repeatCount = logged.filter((b) => repeats.has(b.customerId)).length;
  const atRisk = atRiskCustomers(customers, bookings).slice(0, 2);
  const lowStock = products.filter((p) => p.stockQty <= p.lowStockThreshold);
  const goal = salon.dailyRevenueGoal;
  const pace = goal > 0 ? Math.min(1, todayRevenue / goal) : 0;

  const today = new Date().toLocaleDateString('en-IN', { weekday: 'long', day: 'numeric', month: 'long' });

  const openCustomer = (b: Booking) => {
    const c = customers.find((x) => x.id === b.customerId);
    if (c) setProfileCustomer(c);
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="p-4 space-y-4 max-w-5xl mx-auto">
        {/* Header */}
        <div>
          <p className="text-xs text-gray-400">{today}</p>
          <h1 className="text-lg font-semibold text-gray-900 mt-0.5">
            {greeting()}, {salon.ownerName.split(' ')[0]}
          </h1>
        </div>

        {/* Morning briefing */}
        <div className="card p-4">
          <h2 className="text-sm font-semibold text-gray-900">Here's your day</h2>
          <p className="text-xs text-gray-500 mt-1">
            {logged.length} services logged today · {formatINR(todayRevenue)} so far
          </p>
          {goal > 0 && (
            <div className="mt-2.5">
              <div className="h-1.5 bg-gray-100 rounded-full overflow-hidden">
                <div className="h-full bg-primary rounded-full transition-all" style={{ width: `${pace * 100}%` }} />
              </div>
              <p className="text-xs text-gray-400 mt-1">
                {formatINR(todayRevenue)} of {formatINR(goal)} daily goal
              </p>
            </div>
          )}
          {atRisk.length > 0 && (
            <div className="mt-3 pt-3 border-t border-gray-100">
              <p className="text-xs font-semibold text-amber-700">Worth reaching out today</p>
              {atRisk.map((h) => (
                <button
                  key={h.customer.id}
                  onClick={() => setProfileCustomer(h.customer)}
                  className="block text-xs text-gray-900 mt-1 hover:underline"
                >
                  {h.customer.name}
                  <span className="text-gray-400"> · {h.overdueDays} days overdue</span>
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Primary action + quick actions */}
        <div className="flex items-center gap-2">
          <button onClick={() => setModal('booking')} className="btn-primary">
            <Plus size={13} />
            New booking
          </button>
          <button onClick={() => setModal('staff')} className="btn-secondary">
            <UserPlus size={13} />
            Add staff
          </button>
          <button onClick={() => setModal('service')} className="btn-secondary">
            <Scissors size={13} />
            Add service
          </button>
          <Link href="/products" className="btn-secondary">
            <Package size={13} />
            Inventory
          </Link>
        </div>

        {/* Low stock alert */}
        {lowStock.length > 0 && (
          <Link
            href="/products?low=1"
            className="flex items-center gap-2.5 px-3.5 py-2.5 rounded-lg border border-red-200 bg-red-50 hover:bg-red-100 transition-colors"
          >
            <AlertTriangle size={15} className="text-red-600 flex-shrink-0" />
            <span className="flex-1 text-xs font-medium text-red-700">
              {lowStock.length} {lowStock.length === 1 ? 'product is' : 'products are'} low on stock
            </span>
            <ChevronRight size={15} className="text-red-400" />
          </Link>
        )}

        {/* Stats */}
        <div className="grid grid-cols-3 gap-3">
          <div className="bg-white border border-gray-200 rounded-lg px-3.5 py-3">
            <p className="text-xs text-gray-500">Services today</p>
            <p className="text-xl font-semibold text-gray-900 tabular-nums mt-0.5">{logged.length}</p>
            <p className="text-xs text-gray-400 mt-0.5">logged so far</p>
          </div>
          <div className="bg-white border border-gray-200 rounded-lg px-3.5 py-3">
            <p className="text-xs text-gray-500">Revenue today</p>
            <p className="text-xl font-semibold text-gray-900 tabular-nums mt-0.5">{formatINR(todayRevenue)}</p>
            <p className="text-xs text-gray-400 mt-0.5">all staff</p>
          </div>
          <div className="bg-white border border-gray-200 rounded-lg px-3.5 py-3">
            <p className="text-xs text-gray-500">Repeat customers</p>
            <p className="text-xl font-semibold text-gray-900 tabular-nums mt-0.5">{repeatCount}</p>
            <p className="text-xs text-gray-400 mt-0.5">came back today</p>
          </div>
        </div>

        {/* Logged today */}
        <div>
          <h2 className="text-sm font-semibold text-gray-900 mb-2">Logged today</h2>
          {logged.length === 0 ? (
            <div className="card px-4 py-6 text-center">
              <p className="text-xs text-gray-400">Nothing logged today yet.</p>
            </div>
          ) : (
            <div className="card divide-y divide-gray-100">
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
