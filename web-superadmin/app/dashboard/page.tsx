'use client';

import { useState } from 'react';
import {
  Line,
  LineChart,
  CartesianGrid,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
  Legend,
} from 'recharts';
import { PageLayout } from '@/components/PageLayout';
import { useGrowth, useStats } from '@/lib/admin-queries';
import { Building2, Users, User, CalendarCheck, TrendingUp, AlertTriangle } from 'lucide-react';

function StatTile({
  label,
  value,
  helper,
  icon: Icon,
  iconClass,
}: {
  label: string;
  value: string | number;
  helper?: string;
  icon: React.ComponentType<{ size?: number | string; className?: string }>;
  iconClass: string;
}) {
  return (
    <div className="stat-tile flex items-start gap-3">
      <div className={`hidden sm:flex w-9 h-9 rounded-lg items-center justify-center flex-shrink-0 ${iconClass}`}>
        <Icon size={17} />
      </div>
      <div className="min-w-0 flex-1">
        <p className="text-xs text-gray-500 break-words">{label}</p>
        <p className="text-lg sm:text-xl font-bold text-gray-900 tabular-nums leading-tight break-words">{value}</p>
        {helper && <p className="text-[11px] text-gray-400 break-words">{helper}</p>}
      </div>
    </div>
  );
}

function formatDay(date: string) {
  return new Date(date).toLocaleDateString('en-IN', { day: 'numeric', month: 'short' });
}

export default function DashboardPage() {
  const { data: stats, isLoading, isError } = useStats();
  const [days, setDays] = useState(30);
  const { data: growth = [] } = useGrowth(days);

  const chartData = growth.map((g) => ({ ...g, label: formatDay(g.date) }));

  return (
    <PageLayout title="Dashboard" subtitle="Platform-wide insights">
      <div className="space-y-4">
        {isLoading && <p className="text-xs text-gray-400">Loading stats…</p>}
        {isError && <p className="text-xs text-red-600">Could not load stats. Try refreshing.</p>}

        {stats && (
          <>
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
              <StatTile label="Salons" value={stats.salons} icon={Building2} iconClass="bg-primary-light text-primary" />
              <StatTile label="Owners" value={stats.owners} icon={User} iconClass="bg-emerald-50 text-emerald-600" />
              <StatTile label="Customers" value={stats.customers} icon={Users} iconClass="bg-violet-50 text-violet-600" />
              <StatTile
                label="Total bookings"
                value={stats.bookings}
                helper={`${stats.bookings30} in last 30d`}
                icon={CalendarCheck}
                iconClass="bg-amber-50 text-amber-600"
              />
            </div>
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
              <StatTile
                label="New salons (7d)"
                value={stats.newSalons7}
                icon={TrendingUp}
                iconClass="bg-emerald-50 text-emerald-600"
              />
              <StatTile
                label="New salons (30d)"
                value={stats.newSalons30}
                icon={TrendingUp}
                iconClass="bg-emerald-50 text-emerald-600"
              />
              <StatTile
                label="Active salons"
                value={stats.activeSalons}
                helper="booked in last 30d"
                icon={Building2}
                iconClass="bg-primary-light text-primary"
              />
              <StatTile
                label="Dormant salons"
                value={stats.dormantSalons}
                helper="no booking in 30d"
                icon={AlertTriangle}
                iconClass="bg-red-50 text-danger"
              />
            </div>
          </>
        )}

        <div className="card p-4">
          <div className="flex items-center justify-between mb-3">
            <h2 className="text-sm font-semibold text-gray-900">Signups &amp; bookings over time</h2>
            <div className="flex gap-1 bg-gray-100 p-0.5 rounded-md">
              {[7, 30, 90].map((d) => (
                <button
                  key={d}
                  onClick={() => setDays(d)}
                  className={`px-3 py-1.5 rounded text-xs font-medium transition-colors ${
                    days === d ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-500'
                  }`}
                >
                  {d}d
                </button>
              ))}
            </div>
          </div>
          <div className="h-64">
            <ResponsiveContainer width="100%" height="100%">
              <LineChart data={chartData} margin={{ top: 4, right: 8, left: -20, bottom: 0 }}>
                <CartesianGrid strokeDasharray="3 3" stroke="#F1F2F4" />
                <XAxis dataKey="label" tick={{ fontSize: 11, fill: '#9CA3AF' }} interval="preserveStartEnd" />
                <YAxis tick={{ fontSize: 11, fill: '#9CA3AF' }} allowDecimals={false} />
                <Tooltip
                  contentStyle={{ fontSize: 12, borderRadius: 8, border: '1px solid #E5E7EB' }}
                  labelStyle={{ fontWeight: 600 }}
                />
                <Legend wrapperStyle={{ fontSize: 12 }} />
                <Line type="monotone" dataKey="signups" name="Salon signups" stroke="#4338CA" strokeWidth={2} dot={false} />
                <Line type="monotone" dataKey="bookings" name="Bookings" stroke="#10B981" strokeWidth={2} dot={false} />
              </LineChart>
            </ResponsiveContainer>
          </div>
        </div>
      </div>
    </PageLayout>
  );
}
