'use client';

import { useState } from 'react';
import { PageLayout } from '@/components/PageLayout';
import { AddStaffModal, ManageStaffModal, PayoutModal } from '@/components/StaffModals';
import { Avatar } from '@/components/Avatar';
import { useDataStore, formatINR, isSameDay, type Staff } from '@/lib/data';
import { Plus, Search, Wallet, MoreHorizontal } from 'lucide-react';

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

export default function StaffPage() {
  const { staff, services, bookings } = useDataStore();
  const [query, setQuery] = useState('');
  const [filter, setFilter] = useState<'all' | 'active' | 'inactive'>('all');
  const [showAdd, setShowAdd] = useState(false);
  const [manage, setManage] = useState<Staff | undefined>();
  const [payout, setPayout] = useState<Staff | undefined>();

  const todayTally = (id: string) => {
    const list = bookings.filter(
      (b) => b.status === 'COMPLETED' && b.stylistId === id && isSameDay(new Date(b.time), new Date())
    );
    return { count: list.length, revenue: list.reduce((s, b) => s + b.price, 0) };
  };

  const activeCount = staff.filter((s) => s.status === 'ACTIVE').length;
  const todayTotal = staff.reduce((s, m) => s + todayTally(m.id).revenue, 0);

  const filtered = staff.filter((m) => {
    if (filter === 'active' && m.status !== 'ACTIVE') return false;
    if (filter === 'inactive' && m.status === 'ACTIVE') return false;
    const q = query.trim().toLowerCase();
    return !q || m.name.toLowerCase().includes(q) || m.phone.includes(q);
  });

  return (
    <PageLayout
      title="Staff"
      subtitle="Your team"
      action={
        <button onClick={() => setShowAdd(true)} className="btn-primary">
          <Plus size={13} />
          Add staff
        </button>
      }
    >
      <div className="space-y-4">
        {/* Stats */}
        <div className="grid grid-cols-3 gap-3">
          <div className="stat-tile">
            <p className="text-xs text-gray-500">Staff</p>
            <p className="text-xl font-semibold text-gray-900 tabular-nums mt-0.5">{staff.length}</p>
          </div>
          <div className="stat-tile">
            <p className="text-xs text-gray-500">Active</p>
            <p className="text-xl font-semibold text-gray-900 tabular-nums mt-0.5">{activeCount}</p>
          </div>
          <div className="stat-tile">
            <p className="text-xs text-gray-500">Today's total</p>
            <p className="text-xl font-semibold text-gray-900 tabular-nums mt-0.5">{formatINR(todayTotal)}</p>
          </div>
        </div>

        {/* Search + filter */}
        <div className="flex items-center gap-2">
          <div className="relative max-w-xs flex-1">
            <Search size={13} className="absolute left-2.5 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              className="w-full pl-8 pr-3 py-1.5 rounded-md text-xs bg-white border border-gray-200 placeholder-gray-500 focus:outline-none focus:ring-1 focus:ring-primary/40"
              placeholder="Search name or phone"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
            />
          </div>
          <Chip label="All" selected={filter === 'all'} onClick={() => setFilter('all')} />
          <Chip label="Active" selected={filter === 'active'} onClick={() => setFilter('active')} />
          <Chip label="Inactive" selected={filter === 'inactive'} onClick={() => setFilter('inactive')} />
        </div>

        {/* Staff cards */}
        <div className="space-y-2.5">
          {filtered.map((m) => {
            const tally = todayTally(m.id);
            const svcNames = m.serviceIds
              .map((id) => services.find((s) => s.id === id)?.name)
              .filter(Boolean)
              .join(' · ');
            const isActive = m.status === 'ACTIVE';
            return (
              <div key={m.id} className={`card p-3.5 ${isActive ? '' : 'opacity-60'}`}>
                <div className="flex items-center gap-3">
                  <Avatar name={m.name} />
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-medium text-gray-900">{m.name}</p>
                    <p className="text-xs text-gray-400 truncate">
                      {isActive ? (svcNames || 'No services yet') : 'Not active'}
                    </p>
                  </div>
                  <button
                    title="Payouts"
                    onClick={() => setPayout(m)}
                    className="p-1.5 hover:bg-gray-100 rounded-md transition-colors"
                  >
                    <Wallet size={15} className="text-gray-400" />
                  </button>
                  <button
                    title="Manage"
                    onClick={() => setManage(m)}
                    className="p-1.5 hover:bg-gray-100 rounded-md transition-colors"
                  >
                    <MoreHorizontal size={15} className="text-gray-400" />
                  </button>
                </div>
                {isActive && (
                  <div className="mt-2.5 pt-2.5 border-t border-gray-100 flex items-center gap-2 text-xs">
                    <span className="text-gray-400">Today</span>
                    <span className="font-medium text-gray-900 tabular-nums">
                      {tally.count} services · {formatINR(tally.revenue)}
                    </span>
                  </div>
                )}
              </div>
            );
          })}
          {filtered.length === 0 && (
            <div className="card px-4 py-6 text-center">
              <p className="text-xs text-gray-400">No staff match this filter.</p>
            </div>
          )}
        </div>
      </div>

      {showAdd && <AddStaffModal onClose={() => setShowAdd(false)} />}
      {manage && <ManageStaffModal member={manage} onClose={() => setManage(undefined)} />}
      {payout && <PayoutModal member={payout} onClose={() => setPayout(undefined)} />}
    </PageLayout>
  );
}
