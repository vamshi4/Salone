'use client';

import { useMemo, useState } from 'react';
import Link from 'next/link';
import { PageLayout } from '@/components/PageLayout';
import { useSalons } from '@/lib/admin-queries';
import { Search, ChevronRight } from 'lucide-react';

function formatDate(iso: string | null) {
  if (!iso) return '—';
  return new Date(iso).toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric' });
}

type SortKey = 'signedUpAt' | 'lastBookingAt' | 'bookings';

export default function SalonsPage() {
  const { data: salons = [], isLoading, isError } = useSalons();
  const [query, setQuery] = useState('');
  const [sortKey, setSortKey] = useState<SortKey>('signedUpAt');

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    let rows = salons;
    if (q) {
      rows = rows.filter(
        (s) =>
          s.name.toLowerCase().includes(q) ||
          (s.ownerName ?? '').toLowerCase().includes(q) ||
          s.ownerPhone.includes(q)
      );
    }
    return [...rows].sort((a, b) => {
      if (sortKey === 'bookings') return b.bookings - a.bookings;
      const av = sortKey === 'signedUpAt' ? a.signedUpAt : a.lastBookingAt;
      const bv = sortKey === 'signedUpAt' ? b.signedUpAt : b.lastBookingAt;
      if (!av) return 1;
      if (!bv) return -1;
      return new Date(bv).getTime() - new Date(av).getTime();
    });
  }, [salons, query, sortKey]);

  return (
    <PageLayout title="Salons" subtitle={`${salons.length} total`}>
      <div className="space-y-3">
        <div className="flex items-center gap-2">
          <div className="relative max-w-xs flex-1">
            <Search size={13} className="absolute left-2.5 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              className="w-full pl-8 pr-3 py-1.5 rounded-md text-xs bg-white border border-gray-200 placeholder-gray-500 focus:outline-none focus:ring-1 focus:ring-primary/40"
              placeholder="Search by salon, owner, or phone"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
            />
          </div>
          <select
            value={sortKey}
            onChange={(e) => setSortKey(e.target.value as SortKey)}
            className="text-xs py-1.5"
          >
            <option value="signedUpAt">Newest signup</option>
            <option value="lastBookingAt">Last booking</option>
            <option value="bookings">Most bookings</option>
          </select>
        </div>

        {isLoading && <p className="text-xs text-gray-400">Loading salons…</p>}
        {isError && <p className="text-xs text-red-600">Could not load salons. Try refreshing.</p>}

        {!isLoading && filtered.length === 0 && (
          <div className="card px-4 py-6 text-center">
            <p className="text-xs text-gray-400">No salons match this search.</p>
          </div>
        )}

        {filtered.length > 0 && (
          <div className="card overflow-x-auto">
            <table className="w-full text-xs">
              <thead>
                <tr className="border-b border-gray-100 text-left text-gray-500">
                  <th className="px-3 py-2 font-medium">Salon</th>
                  <th className="px-3 py-2 font-medium">Owner</th>
                  <th className="px-3 py-2 font-medium">Plan</th>
                  <th className="px-3 py-2 font-medium text-right">Bookings</th>
                  <th className="px-3 py-2 font-medium text-right">Customers</th>
                  <th className="px-3 py-2 font-medium text-right">Stylists</th>
                  <th className="px-3 py-2 font-medium">Signed up</th>
                  <th className="px-3 py-2 font-medium">Last booking</th>
                  <th className="px-3 py-2 w-8" />
                </tr>
              </thead>
              <tbody>
                {filtered.map((s) => (
                  <tr key={s.id} className="border-b border-gray-50 last:border-0 hover:bg-gray-50">
                    <td className="px-3 py-2">
                      <Link href={`/salons/${s.id}`} className="font-medium text-gray-900 hover:text-primary">
                        {s.name}
                      </Link>
                      <p className="text-gray-400 truncate max-w-[220px]">{s.address}</p>
                    </td>
                    <td className="px-3 py-2">
                      <p className="text-gray-900">{s.ownerName || '—'}</p>
                      <p className="text-gray-400">{s.ownerPhone}</p>
                    </td>
                    <td className="px-3 py-2">
                      <span
                        className={`inline-block px-2 py-0.5 rounded text-[11px] font-medium ${
                          s.saasPlan === 'PREMIUM' ? 'bg-primary-light text-primary' : 'bg-gray-100 text-gray-500'
                        }`}
                      >
                        {s.saasPlan}
                      </span>
                    </td>
                    <td className="px-3 py-2 text-right tabular-nums">{s.bookings}</td>
                    <td className="px-3 py-2 text-right tabular-nums">{s.customers}</td>
                    <td className="px-3 py-2 text-right tabular-nums">{s.stylists}</td>
                    <td className="px-3 py-2 text-gray-500">{formatDate(s.signedUpAt)}</td>
                    <td className="px-3 py-2 text-gray-500">{formatDate(s.lastBookingAt)}</td>
                    <td className="px-3 py-2">
                      <Link href={`/salons/${s.id}`}>
                        <ChevronRight size={14} className="text-gray-300" />
                      </Link>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </PageLayout>
  );
}
