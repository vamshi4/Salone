'use client';

import { useState } from 'react';
import { useTranslations, useLocale } from 'next-intl';
import { PageLayout } from '@/components/PageLayout';
import { CustomerProfileModal } from '@/components/CustomerProfileModal';
import { useAppStore } from '@/lib/store';
import { formatCurrency, type Customer } from '@/lib/salon-api';
import {
  useAtRisk,
  useDownloadEarningsCsv,
  useEarnings,
  useRetention,
  useSelectedSalonId,
} from '@/lib/salon-queries';
import { ArrowUp, ArrowDown, Download, MessageCircle, PartyPopper, BellRing } from 'lucide-react';

type CohortKey = 'retained' | 'new' | 'reactivated' | 'churned';

const COHORT_META: { key: CohortKey; labelKey: string; color: string }[] = [
  { key: 'retained', labelKey: 'cohortRetained', color: '#1B8A8A' },
  { key: 'new', labelKey: 'cohortNew', color: '#639922' },
  { key: 'reactivated', labelKey: 'cohortReactivated', color: '#7F77DD' },
  { key: 'churned', labelKey: 'cohortChurned', color: '#E24B4A' },
];

function whatsappUrl(phone: string, message: string) {
  const digits = phone.replace(/\D/g, '');
  const intl = digits.startsWith('91') ? digits : `91${digits}`;
  return `https://wa.me/${intl}?text=${encodeURIComponent(message)}`;
}

function SegTabs({ tab, onChange }: { tab: number; onChange: (i: number) => void }) {
  const t = useTranslations('insights');
  return (
    <div className="flex gap-1 bg-gray-100 p-0.5 rounded-md w-fit">
      {[t('tabEarnings'), t('tabRetention')].map((label, i) => (
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

function EarningsTab({ salonId }: { salonId: string }) {
  const t = useTranslations('insights');
  const locale = useLocale();
  const salon = useAppStore((s) => s.salons.find((x) => x.id === salonId));
  const [period, setPeriod] = useState<'day' | 'week' | 'month'>('day');
  const { data, isLoading, isError } = useEarnings(salonId, period);
  const downloadCsv = useDownloadEarningsCsv();

  const change =
    data && data.previousTotal > 0
      ? Math.round(((data.total - data.previousTotal) / data.previousTotal) * 100)
      : data && data.total > 0
        ? 100
        : 0;
  const isUp = change >= 0;
  const vsLabel = period === 'day' ? t('vsYesterday') : period === 'week' ? t('vsLastWeek') : t('vsLastMonth');
  const periodLabel = period === 'day' ? t('periodLabelToday') : period === 'week' ? t('periodLabelWeek') : t('periodLabelMonth');

  const daily = data?.daily ?? [];
  const maxDaily = Math.max(1, ...daily.map((d) => d.total));
  const labelStep = Math.max(1, Math.ceil(daily.length / 6));

  return (
    <div className="space-y-4">
      {/* Period toggle + export */}
      <div className="flex items-center justify-between">
        <div className="flex gap-1 bg-gray-100 p-0.5 rounded-md w-fit">
          {([['day', t('periodToday')], ['week', t('periodWeek')], ['month', t('periodMonth')]] as const).map(([value, label]) => (
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
        <button
          onClick={() => downloadCsv.mutate({ salonId, period })}
          disabled={downloadCsv.isPending}
          className="btn-secondary disabled:opacity-60"
          title={t('exportCsv')}
        >
          <Download size={13} />
          {downloadCsv.isPending ? t('exporting') : t('exportCsv')}
        </button>
      </div>

      {isLoading && <p className="text-xs text-gray-400">{t('loadingEarnings')}</p>}
      {isError && <p className="text-xs text-red-600">{t('loadErrorEarnings')}</p>}

      {data && (
        <>
          {/* Hero total */}
          <div className="relative overflow-hidden rounded-2xl bg-gradient-to-br from-[#2FB0B0] via-primary to-primary-dark px-5 py-5 text-white shadow-hero">
            <div className="absolute -top-14 -right-14 w-48 h-48 rounded-full bg-white/10" />
            <div className="absolute -bottom-20 right-16 w-36 h-36 rounded-full bg-white/5" />
            <div className="relative">
              <p className="text-xs text-teal-100/80">{periodLabel}</p>
              <p className="text-3xl font-bold tabular-nums mt-1">{formatCurrency(data.total, salon?.currency)}</p>
              <div className="flex items-center gap-3 mt-2">
                <p className="text-xs text-teal-100/80">{t('completedServicesCount', { count: data.count })}</p>
                {(data.total > 0 || data.previousTotal > 0) && (
                  <span
                    className={`inline-flex items-center gap-1 text-[11px] font-bold px-2 py-0.5 rounded-full ${
                      isUp ? 'bg-emerald-400/20 text-emerald-200' : 'bg-red-400/20 text-red-200'
                    }`}
                  >
                    {isUp ? <ArrowUp size={11} /> : <ArrowDown size={11} />}
                    {Math.abs(change)}% {vsLabel}
                  </span>
                )}
              </div>
            </div>
          </div>

          {/* Daily bars */}
          {period !== 'day' && daily.length > 0 && (
            <div className="card p-4">
              <p className="text-xs font-semibold text-gray-900 mb-3">{t('dailyEarnings')}</p>
              <div className="flex items-end gap-1 h-24">
                {daily.map((d, i) => {
                  const date = new Date(d.date);
                  return (
                    <div key={i} className="flex-1 flex flex-col items-center gap-1">
                      <div
                        className="w-full bg-primary/70 rounded-t"
                        style={{ height: `${Math.max(4, (d.total / maxDaily) * 100)}%` }}
                        title={`${date.getDate()}: ${formatCurrency(d.total, salon?.currency)}`}
                      />
                      <span className="text-[10px] text-gray-400 h-3">
                        {i % labelStep === 0 || i === daily.length - 1 ? date.getDate() : ''}
                      </span>
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {/* Leaderboards */}
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-3">
            {data.topServices.length > 0 && (
              <div className="card p-4">
                <p className="text-xs font-semibold text-gray-900 mb-2">{t('topServices')}</p>
                <div className="divide-y divide-gray-100">
                  {data.topServices.map((s) => (
                    <div key={s.name} className="flex items-center justify-between py-2">
                      <div>
                        <p className="text-xs font-medium text-gray-900">{s.name}</p>
                        <p className="text-xs text-gray-400">{t('serviceCount', { count: s.count })}</p>
                      </div>
                      <p className="text-xs text-gray-900 tabular-nums">{formatCurrency(s.total, salon?.currency)}</p>
                    </div>
                  ))}
                </div>
              </div>
            )}
            {data.byStylist.length > 0 && (
              <div className="card p-4">
                <p className="text-xs font-semibold text-gray-900 mb-2">{t('byStaff')}</p>
                <div className="divide-y divide-gray-100">
                  {data.byStylist.map((s) => (
                    <div key={s.stylistId} className="flex items-center justify-between py-2">
                      <div>
                        <p className="text-xs font-medium text-gray-900">{s.name}</p>
                        <p className="text-xs text-gray-400">{t('serviceCount', { count: s.count })}</p>
                      </div>
                      <p className="text-xs text-gray-900 tabular-nums">{formatCurrency(s.total, salon?.currency)}</p>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>

          {/* Completed list */}
          <div>
            <p className="text-xs font-semibold text-gray-900 mb-1.5">{t('completedServices')}</p>
            {data.bookings.length === 0 ? (
              <div className="card px-4 py-6 text-center">
                <p className="text-xs text-gray-400">{t('noCompletedInPeriod')}</p>
              </div>
            ) : (
              <div className="card divide-y divide-gray-100">
                {data.bookings.map((b) => (
                  <div key={b.id} className="flex items-center justify-between px-3.5 py-2">
                    <div>
                      <p className="text-xs text-gray-900">
                        <span className="font-medium">{b.customerName}</span>
                        <span className="text-gray-400"> · {b.serviceName}</span>
                      </p>
                      {b.paymentMethod && (
                        <p className="text-xs text-gray-400">
                          {b.paymentMethod === 'CASH' ? t('cash') : b.paymentMethod === 'UPI' ? t('upi') : t('card')}
                        </p>
                      )}
                    </div>
                    <span className="text-xs text-gray-900 tabular-nums">{formatCurrency(b.price, salon?.currency)}</span>
                  </div>
                ))}
              </div>
            )}
          </div>
        </>
      )}
    </div>
  );
}

function CohortDonut({
  slices,
  selected,
  onSelect,
  customersLabel,
}: {
  slices: { key: CohortKey; label: string; color: string; count: number }[];
  selected: CohortKey | null;
  onSelect: (k: CohortKey) => void;
  customersLabel: string;
}) {
  const total = slices.reduce((s, x) => s + x.count, 0) || 1;
  const R = 48;
  const C = 2 * Math.PI * R;
  let offset = 0;
  const sel = selected ? slices.find((s) => s.key === selected) : null;

  return (
    <div className="relative w-32 h-32 flex-shrink-0">
      <svg viewBox="0 0 120 120" className="w-full h-full -rotate-90">
        {slices.map((s) => {
          const frac = Math.max(0.002, s.count / total);
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
          {sel ? sel.count : total}
        </span>
        <span className="text-[10px] text-gray-400">{sel ? sel.label.toLowerCase() : customersLabel}</span>
      </div>
    </div>
  );
}

function RetentionTab({ salonId, onOpenCustomer }: { salonId: string; onOpenCustomer: (c: Customer) => void }) {
  const t = useTranslations('insights');
  const salon = useAppStore((s) => s.salons.find((x) => x.id === salonId));
  const { data: retention, isLoading, isError } = useRetention(salonId);
  const { data: atRiskData } = useAtRisk(salonId);
  const [selected, setSelected] = useState<CohortKey | null>(null);

  if (isLoading) return <p className="text-xs text-gray-400">{t('loadingRetention')}</p>;
  if (isError || !retention) return <p className="text-xs text-red-600">{t('loadErrorRetention')}</p>;

  const atRisk = atRiskData?.customers ?? [];
  const reactivated = retention.summary.reactivatedCustomers;

  const slices = COHORT_META.map((m) => ({ key: m.key, label: t(m.labelKey), color: m.color, count: retention.cohorts[m.key].length }));
  const selMembers = selected ? retention.cohorts[selected] : [];
  const selMeta = selected ? slices.find((s) => s.key === selected) : null;
  const missed = retention.missed;

  const remind = (name: string | null, phone: string) => {
    const message = t('whatsappGreeting', { name: name ?? t('customerFallback'), salonName: salon?.name ?? '' });
    window.open(whatsappUrl(phone, message), '_blank');
  };

  return (
    <div className="space-y-4">
      {/* At-risk: reach out now */}
      {atRisk.length > 0 && (
        <div className="rounded-lg border border-primary/20 bg-primary-light/50 p-4">
          <div className="flex items-center gap-2">
            <BellRing size={15} className="text-primary-dark" />
            <p className="text-sm font-semibold text-gray-900">{t('reachOutNow')}</p>
          </div>
          <p className="text-xs text-gray-500 mt-0.5">
            {t('overdueAtStake', { count: atRisk.length, amount: formatCurrency(atRiskData?.atRiskRevenue ?? 0, salon?.currency) })}
          </p>
          <div className="mt-2.5 space-y-2">
            {atRisk.slice(0, 2).map((c) => (
              <div key={c.customerId} className="flex items-center justify-between bg-white border border-gray-200 rounded-md px-3 py-2">
                <button
                  className="text-left"
                  onClick={() => onOpenCustomer({ id: c.customerId, name: c.name ?? t('customerFallback'), phone: c.phone })}
                >
                  <p className="text-xs font-medium text-gray-900">
                    {c.name ?? t('customerFallback')}
                    <span className="ml-1.5 px-1.5 py-px rounded bg-red-50 text-red-600 text-[10px] font-medium">
                      {t('daysOverdue', { days: c.overdueDays })}
                    </span>
                  </p>
                  <p className="text-xs text-gray-400">{t('visitsEvery', { days: c.cadenceDays })}</p>
                </button>
                <button onClick={() => remind(c.name, c.phone)} className="btn-primary">
                  <MessageCircle size={12} />
                  {t('remind')}
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
            <p className="text-xs font-semibold text-gray-900">{t('winsThisMonth')}</p>
            <p className="text-xs text-gray-500">{t('cameBackAfterGap', { count: reactivated })}</p>
          </div>
        </div>
      )}

      {/* Cohorts */}
      <div className="card p-4">
        <p className="text-xs font-semibold text-gray-900 mb-3">{t('customerCohorts')}</p>
        <div className="flex items-center gap-5">
          <CohortDonut
            slices={slices}
            selected={selected}
            onSelect={(k) => setSelected(selected === k ? null : k)}
            customersLabel={t('customers')}
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
                <span className="text-xs font-medium text-gray-900 tabular-nums">{s.count}</span>
              </button>
            ))}
          </div>
        </div>

        {selMeta && (
          <div className="mt-3 pt-3 border-t border-gray-100">
            <p className="text-xs font-semibold mb-1.5" style={{ color: selMeta.color }}>
              {selMeta.label} · {selMembers.length}
            </p>
            {selMembers.length === 0 ? (
              <p className="text-xs text-gray-400">{t('noCustomersHere')}</p>
            ) : (
              <div className="divide-y divide-gray-100">
                {selMembers.map((m) => (
                  <div key={m.customerId} className="flex items-center justify-between py-2">
                    <button
                      className="text-left"
                      onClick={() => onOpenCustomer({ id: m.customerId, name: m.name ?? t('customerFallback'), phone: m.phone })}
                    >
                      <p className="text-xs font-medium text-gray-900">{m.name ?? t('customerFallback')}</p>
                      <p className="text-xs text-gray-400">{t('visitsSpent', { count: m.visits, amount: formatCurrency(m.totalSpend, salon?.currency) })}</p>
                    </button>
                    {selected === 'churned' && (
                      <button
                        onClick={() => remind(m.name, m.phone)}
                        className="p-1.5 hover:bg-gray-100 rounded-md transition-colors"
                        title={t('remindWhatsApp')}
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
          <p className="text-sm font-semibold text-gray-900">{t('missedCustomers')}</p>
          <span className="px-1.5 py-px rounded bg-gray-100 text-gray-500 text-xs tabular-nums">{missed.length}</span>
        </div>
        <p className="text-xs text-gray-400 mb-2">{t('missedHelper')}</p>
        {missed.length === 0 ? (
          <div className="card px-4 py-6 text-center">
            <p className="text-xs text-gray-400">{t('noSlipped')}</p>
          </div>
        ) : (
          <div className="card divide-y divide-gray-100">
            {missed.slice(0, 10).map((m) => (
              <div key={m.customerId} className="flex items-center justify-between px-3.5 py-2">
                <button
                  className="text-left"
                  onClick={() => onOpenCustomer({ id: m.customerId, name: m.name ?? t('customerFallback'), phone: m.phone })}
                >
                  <p className="text-xs font-medium text-gray-900">{m.name ?? t('customerFallback')}</p>
                  <p className="text-xs text-gray-400">{t('visitsSpent', { count: m.visits, amount: formatCurrency(m.totalSpend, salon?.currency) })}</p>
                </button>
                <button
                  onClick={() => remind(m.name, m.phone)}
                  className="p-1.5 hover:bg-gray-100 rounded-md transition-colors"
                  title={t('remindWhatsApp')}
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
  const t = useTranslations('insights');
  const salonId = useSelectedSalonId();
  const [tab, setTab] = useState(0);
  const [profileCustomer, setProfileCustomer] = useState<Customer | undefined>();

  if (!salonId) {
    return (
      <PageLayout title={t('title')} subtitle={t('subtitle')}>
        <div className="card px-4 py-6 text-center">
          <p className="text-xs text-gray-400">{t('noSalonYet')}</p>
        </div>
      </PageLayout>
    );
  }

  return (
    <PageLayout title={t('title')} subtitle={t('subtitle')}>
      <div className="space-y-4">
        <SegTabs tab={tab} onChange={setTab} />
        {tab === 0 ? (
          <EarningsTab salonId={salonId} />
        ) : (
          <RetentionTab salonId={salonId} onOpenCustomer={setProfileCustomer} />
        )}
      </div>
      {profileCustomer && (
        <CustomerProfileModal customer={profileCustomer} onClose={() => setProfileCustomer(undefined)} />
      )}
    </PageLayout>
  );
}
