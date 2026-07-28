'use client';

import { useMemo, useState } from 'react';
import { PageLayout } from '@/components/PageLayout';
import { CustomerProfileModal } from '@/components/CustomerProfileModal';
import {
  useDataStore,
  earnings,
  cohorts,
  atRiskCustomers,
  whatsappReminderUrl,
  formatINR,
  bookingServiceNames,
  type Customer,
  type CohortKey,
  type CustomerHistory,
} from '@/lib/data';
import { ArrowUp, ArrowDown, Download, MessageCircle, PartyPopper, BellRing } from 'lucide-react';

const COHORT_META: { key: CohortKey; label: string; color: string; soft: string }[] = [
  { key: 'retained', label: 'Regulars', color: '#1B8A8A', soft: 'bg-primary-light text-primary-dark' },
  { key: 'new', label: 'New', color: '#639922', soft: 'bg-green-50 text-green-700' },
  { key: 'reactivated', label: 'Came back', color: '#7F77DD', soft: 'bg-violet-50 text-violet-700' },
  { key: 'churned', label: 'Stopped coming', color: '#E24B4A', soft: 'bg-red-50 text-red-600' },
];

function SegTabs({ tab, onChange }: { tab: number; onChange: (i: number) => void }) {
  return (
    <div className="flex gap-1 bg-gray-100 p-0.5 rounded-md w-fit">
      {['Earnings', 'Retention'].map((label, i) => (
        <button
          key={label}
          onClick={() => onChange(i)}
          className={`px-4 py-1.5 rounded text-xs font-medium transition-colors ${
            tab === i ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-500'
          }`}
        >
          {label}
        </button>
      ))}
    </div>
  );
}

function EarningsTab() {
  const { bookings, services, staff, customers } = useDataStore();
  const [period, setPeriod] = useState<'day' | 'week' | 'month'>('day');
  const data = useMemo(() => earnings(bookings, services, staff, period), [bookings, services, staff, period]);

  const change =
    data.previousTotal > 0
      ? Math.round(((data.total - data.previousTotal) / data.previousTotal) * 100)
      : data.total > 0
        ? 100
        : 0;
  const isUp = change >= 0;
  const vsLabel = period === 'day' ? 'vs yesterday' : period === 'week' ? 'vs last week' : 'vs last month';
  const periodLabel = period === 'day' ? 'Today' : period === 'week' ? 'Last 7 days' : 'Last 30 days';

  const exportCsv = () => {
    const rows = [
      ['Date', 'Customer', 'Service', 'Staff', 'Payment', 'Amount'],
      ...data.completed.map((b) => [
        new Date(b.time).toLocaleDateString('en-IN'),
        customers.find((c) => c.id === b.customerId)?.name ?? '',
        bookingServiceNames(b, services),
        staff.find((s) => s.id === b.stylistId)?.name ?? '',
        b.paymentMethod ?? '',
        String(b.price),
      ]),
    ];
    const csv = rows.map((r) => r.map((cell) => `"${cell.replace(/"/g, '""')}"`).join(',')).join('\n');
    const url = URL.createObjectURL(new Blob([csv], { type: 'text/csv' }));
    const a = document.createElement('a');
    a.href = url;
    a.download = `earnings-${period}.csv`;
    a.click();
    URL.revokeObjectURL(url);
  };

  const maxDaily = Math.max(1, ...data.daily.map((d) => d.total));
  const labelStep = Math.max(1, Math.ceil(data.daily.length / 6));

  return (
    <div className="space-y-4">
      {/* Period toggle + export */}
      <div className="flex items-center justify-between">
        <div className="flex gap-1 bg-gray-100 p-0.5 rounded-md w-fit">
          {([['day', 'Today'], ['week', 'Week'], ['month', 'Month']] as const).map(([value, label]) => (
            <button
              key={value}
              onClick={() => setPeriod(value)}
              className={`px-3 py-1.5 rounded text-xs font-medium transition-colors ${
                period === value ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-500'
              }`}
            >
              {label}
            </button>
          ))}
        </div>
        <button onClick={exportCsv} className="btn-secondary" title="Export CSV">
          <Download size={13} />
          Export CSV
        </button>
      </div>

      {/* Hero total */}
      <div className="rounded-lg bg-primary-dark px-5 py-4 text-white">
        <p className="text-xs text-white/70">{periodLabel}</p>
        <p className="text-3xl font-semibold tabular-nums mt-1">{formatINR(data.total)}</p>
        <div className="flex items-center gap-3 mt-1.5">
          <p className="text-xs text-white/70">{data.count} completed services</p>
          {(data.total > 0 || data.previousTotal > 0) && (
            <span className={`inline-flex items-center gap-0.5 text-xs font-medium ${isUp ? 'text-green-300' : 'text-red-300'}`}>
              {isUp ? <ArrowUp size={12} /> : <ArrowDown size={12} />}
              {Math.abs(change)}% {vsLabel}
            </span>
          )}
        </div>
      </div>

      {/* Daily bars */}
      {period !== 'day' && (
        <div className="card p-4">
          <p className="text-xs font-semibold text-gray-900 mb-3">Daily earnings</p>
          <div className="flex items-end gap-1 h-24">
            {data.daily.map((d, i) => (
              <div key={i} className="flex-1 flex flex-col items-center gap-1">
                <div
                  className="w-full bg-primary/70 rounded-t"
                  style={{ height: `${Math.max(4, (d.total / maxDaily) * 100)}%` }}
                  title={`${d.date.getDate()}: ${formatINR(d.total)}`}
                />
                <span className="text-[10px] text-gray-400 h-3">
                  {i % labelStep === 0 || i === data.daily.length - 1 ? d.date.getDate() : ''}
                </span>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Leaderboards */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-3">
        {data.topServices.length > 0 && (
          <div className="card p-4">
            <p className="text-xs font-semibold text-gray-900 mb-2">Top services</p>
            <div className="divide-y divide-gray-100">
              {data.topServices.map((s) => (
                <div key={s.name} className="flex items-center justify-between py-2">
                  <div>
                    <p className="text-xs font-medium text-gray-900">{s.name}</p>
                    <p className="text-xs text-gray-400">{s.count} {s.count === 1 ? 'service' : 'services'}</p>
                  </div>
                  <p className="text-xs text-gray-900 tabular-nums">{formatINR(s.total)}</p>
                </div>
              ))}
            </div>
          </div>
        )}
        {data.byStylist.length > 0 && (
          <div className="card p-4">
            <p className="text-xs font-semibold text-gray-900 mb-2">By staff</p>
            <div className="divide-y divide-gray-100">
              {data.byStylist.map((s) => (
                <div key={s.name} className="flex items-center justify-between py-2">
                  <div>
                    <p className="text-xs font-medium text-gray-900">{s.name}</p>
                    <p className="text-xs text-gray-400">{s.count} {s.count === 1 ? 'service' : 'services'}</p>
                  </div>
                  <p className="text-xs text-gray-900 tabular-nums">{formatINR(s.total)}</p>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>

      {/* Completed list */}
      <div>
        <p className="text-xs font-semibold text-gray-900 mb-1.5">Completed services</p>
        {data.completed.length === 0 ? (
          <div className="card px-4 py-6 text-center">
            <p className="text-xs text-gray-400">No completed services in this period.</p>
          </div>
        ) : (
          <div className="card divide-y divide-gray-100">
            {data.completed.map((b) => (
              <div key={b.id} className="flex items-center justify-between px-3.5 py-2">
                <div>
                  <p className="text-xs text-gray-900">
                    <span className="font-medium">{customers.find((c) => c.id === b.customerId)?.name}</span>
                    <span className="text-gray-400"> · {bookingServiceNames(b, services)}</span>
                  </p>
                  {b.paymentMethod && (
                    <p className="text-xs text-gray-400">
                      {b.paymentMethod === 'CASH' ? 'Cash' : b.paymentMethod === 'UPI' ? 'UPI' : 'Card'}
                    </p>
                  )}
                </div>
                <span className="text-xs text-gray-900 tabular-nums">{formatINR(b.price)}</span>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

function CohortDonut({
  slices,
  selected,
  onSelect,
}: {
  slices: { key: CohortKey; label: string; color: string; members: CustomerHistory[] }[];
  selected: CohortKey | null;
  onSelect: (k: CohortKey) => void;
}) {
  const total = slices.reduce((s, x) => s + x.members.length, 0) || 1;
  const R = 48;
  const C = 2 * Math.PI * R;
  let offset = 0;
  const sel = selected ? slices.find((s) => s.key === selected) : null;

  return (
    <div className="relative w-32 h-32 flex-shrink-0">
      <svg viewBox="0 0 120 120" className="w-full h-full -rotate-90">
        {slices.map((s) => {
          const frac = Math.max(0.002, s.members.length / total);
          const dash = frac * C;
          const el = (
            <circle
              key={s.key}
              cx="60"
              cy="60"
              r={R}
              fill="none"
              stroke={s.color}
              strokeWidth={selected === s.key ? 16 : 12}
              strokeDasharray={`${dash} ${C - dash}`}
              strokeDashoffset={-offset}
              opacity={selected && selected !== s.key ? 0.25 : 1}
              className="cursor-pointer transition-all"
              onClick={() => onSelect(s.key)}
            />
          );
          offset += dash;
          return el;
        })}
      </svg>
      <div className="absolute inset-0 flex flex-col items-center justify-center pointer-events-none">
        <span className="text-lg font-semibold tabular-nums" style={{ color: sel?.color ?? '#111827' }}>
          {sel ? sel.members.length : total}
        </span>
        <span className="text-[10px] text-gray-400">{sel ? sel.label.toLowerCase() : 'customers'}</span>
      </div>
    </div>
  );
}

function RetentionTab({ onOpenCustomer }: { onOpenCustomer: (c: Customer) => void }) {
  const { bookings, customers, salon } = useDataStore();
  const [selected, setSelected] = useState<CohortKey | null>(null);

  const cohortData = useMemo(() => cohorts(customers, bookings), [customers, bookings]);
  const atRisk = useMemo(() => atRiskCustomers(customers, bookings), [customers, bookings]);
  const atRiskRevenue = atRisk.reduce((s, h) => s + h.avgTicket, 0);
  const reactivated = cohortData.reactivated.length;

  const slices = COHORT_META.map((m) => ({ ...m, members: cohortData[m.key] }));
  const sel = selected ? slices.find((s) => s.key === selected)! : null;
  const missed = cohortData.churned;

  const remind = (c: Customer) => {
    window.open(whatsappReminderUrl(c, salon.name), '_blank');
  };

  return (
    <div className="space-y-4">
      {/* At-risk: reach out now */}
      {atRisk.length > 0 && (
        <div className="rounded-lg border border-primary/20 bg-primary-light/50 p-4">
          <div className="flex items-center gap-2">
            <BellRing size={15} className="text-primary-dark" />
            <p className="text-sm font-semibold text-gray-900">Reach out now</p>
          </div>
          <p className="text-xs text-gray-500 mt-0.5">
            {atRisk.length} {atRisk.length === 1 ? 'customer' : 'customers'} overdue · about{' '}
            {formatINR(atRiskRevenue)} at stake
          </p>
          <div className="mt-2.5 space-y-2">
            {atRisk.slice(0, 2).map((h) => (
              <div key={h.customer.id} className="flex items-center justify-between bg-white border border-gray-200 rounded-md px-3 py-2">
                <button className="text-left" onClick={() => onOpenCustomer(h.customer)}>
                  <p className="text-xs font-medium text-gray-900">
                    {h.customer.name}
                    <span className="ml-1.5 px-1.5 py-px rounded bg-red-50 text-red-600 text-[10px] font-medium">
                      {h.overdueDays}d overdue
                    </span>
                  </p>
                  <p className="text-xs text-gray-400">visits every ~{h.cadenceDays} days</p>
                </button>
                <button onClick={() => remind(h.customer)} className="btn-primary">
                  <MessageCircle size={12} />
                  Remind
                </button>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Wins */}
      {reactivated > 0 && (
        <div className="flex items-center gap-2.5 rounded-lg border border-green-200 bg-green-50 px-4 py-3">
          <PartyPopper size={16} className="text-green-700 flex-shrink-0" />
          <div>
            <p className="text-xs font-semibold text-gray-900">Wins this month</p>
            <p className="text-xs text-gray-500">
              {reactivated} {reactivated === 1 ? 'customer' : 'customers'} came back after a long gap.
            </p>
          </div>
        </div>
      )}

      {/* Cohorts */}
      <div className="card p-4">
        <p className="text-xs font-semibold text-gray-900 mb-3">Customer cohorts</p>
        <div className="flex items-center gap-5">
          <CohortDonut
            slices={slices}
            selected={selected}
            onSelect={(k) => setSelected(selected === k ? null : k)}
          />
          <div className="flex-1 space-y-1">
            {slices.map((s) => (
              <button
                key={s.key}
                onClick={() => setSelected(selected === s.key ? null : s.key)}
                className={`flex items-center gap-2 w-full px-2 py-1 rounded-md transition-colors ${
                  selected === s.key ? 'bg-gray-50' : 'hover:bg-gray-50'
                }`}
              >
                <span className="w-2.5 h-2.5 rounded-full flex-shrink-0" style={{ background: s.color }} />
                <span className="flex-1 text-left text-xs text-gray-600">{s.label}</span>
                <span className="text-xs font-medium text-gray-900 tabular-nums">{s.members.length}</span>
              </button>
            ))}
          </div>
        </div>

        {sel && (
          <div className="mt-3 pt-3 border-t border-gray-100">
            <p className="text-xs font-semibold mb-1.5" style={{ color: sel.color }}>
              {sel.label} · {sel.members.length}
            </p>
            {sel.members.length === 0 ? (
              <p className="text-xs text-gray-400">No customers here.</p>
            ) : (
              <div className="divide-y divide-gray-100">
                {sel.members.map((h) => (
                  <div key={h.customer.id} className="flex items-center justify-between py-2">
                    <button className="text-left" onClick={() => onOpenCustomer(h.customer)}>
                      <p className="text-xs font-medium text-gray-900">{h.customer.name}</p>
                      <p className="text-xs text-gray-400">
                        {h.visits} visits · {formatINR(h.totalSpend)} spent
                      </p>
                    </button>
                    {sel.key === 'churned' && (
                      <button
                        onClick={() => remind(h.customer)}
                        className="p-1.5 hover:bg-gray-100 rounded-md transition-colors"
                        title="Remind on WhatsApp"
                      >
                        <MessageCircle size={14} className="text-primary" />
                      </button>
                    )}
                  </div>
                ))}
              </div>
            )}
          </div>
        )}
      </div>

      {/* Missed customers */}
      <div>
        <div className="flex items-center gap-2 mb-1">
          <p className="text-sm font-semibold text-gray-900">Missed customers</p>
          <span className="px-1.5 py-px rounded bg-gray-100 text-gray-500 text-xs tabular-nums">{missed.length}</span>
        </div>
        <p className="text-xs text-gray-400 mb-2">Haven't visited in over 60 days — a WhatsApp nudge often brings them back.</p>
        {missed.length === 0 ? (
          <div className="card px-4 py-6 text-center">
            <p className="text-xs text-gray-400">Nobody has slipped away. Great retention.</p>
          </div>
        ) : (
          <div className="card divide-y divide-gray-100">
            {missed.slice(0, 10).map((h) => (
              <div key={h.customer.id} className="flex items-center justify-between px-3.5 py-2">
                <button className="text-left" onClick={() => onOpenCustomer(h.customer)}>
                  <p className="text-xs font-medium text-gray-900">{h.customer.name}</p>
                  <p className="text-xs text-gray-400">
                    {h.visits} visits · {formatINR(h.totalSpend)} spent
                  </p>
                </button>
                <button
                  onClick={() => remind(h.customer)}
                  className="p-1.5 hover:bg-gray-100 rounded-md transition-colors"
                  title="Remind on WhatsApp"
                >
                  <MessageCircle size={14} className="text-primary" />
                </button>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

export default function InsightsPage() {
  const [tab, setTab] = useState(0);
  const [profileCustomer, setProfileCustomer] = useState<Customer | undefined>();

  return (
    <PageLayout title="Insights" subtitle="Earnings and customer retention">
      <div className="space-y-4">
        <SegTabs tab={tab} onChange={setTab} />
        {tab === 0 ? <EarningsTab /> : <RetentionTab onOpenCustomer={setProfileCustomer} />}
      </div>
      {profileCustomer && (
        <CustomerProfileModal customer={profileCustomer} onClose={() => setProfileCustomer(undefined)} />
      )}
    </PageLayout>
  );
}
