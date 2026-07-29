'use client';

import { useMemo, useState } from 'react';
import { useRouter } from 'next/navigation';
import { Search, Menu, ShieldCheck } from 'lucide-react';
import { useAppStore } from '@/lib/store';
import { useSalons } from '@/lib/admin-queries';

export function TopBar({ onOpenMobileNav }: { onOpenMobileNav: () => void }) {
  const router = useRouter();
  const admin = useAppStore((s) => s.admin);
  const { data: salons = [] } = useSalons();
  const [query, setQuery] = useState('');
  const [showResults, setShowResults] = useState(false);

  // No dedicated backend search endpoint exists — the salons list already
  // carries owner name/phone, so a client-side filter over it is the fastest
  // way to answer "find this person's account" without a new API.
  const results = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (q.length < 2) return [];
    return salons
      .filter(
        (s) =>
          s.name.toLowerCase().includes(q) ||
          (s.ownerName ?? '').toLowerCase().includes(q) ||
          s.ownerPhone.includes(q)
      )
      .slice(0, 6);
  }, [query, salons]);

  const closeSearch = () => {
    setShowResults(false);
    setQuery('');
  };

  return (
    <header className="bg-white border-b border-gray-200 sticky top-0 z-40">
      <div className="px-4 py-2 flex items-center justify-between gap-3">
        <button
          onClick={onOpenMobileNav}
          className="md:hidden p-1.5 -ml-1 hover:bg-gray-100 rounded-md transition-colors flex-shrink-0"
          aria-label="Open menu"
        >
          <Menu size={18} className="text-gray-600" />
        </button>

        <div className="flex-1 max-w-sm relative">
          <div className="relative">
            <Search size={13} className="absolute left-2.5 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              type="text"
              placeholder="Find a salon or owner by name/phone"
              value={query}
              onChange={(e) => {
                setQuery(e.target.value);
                setShowResults(true);
              }}
              onFocus={() => setShowResults(true)}
              className="w-full pl-8 pr-3 py-1.5 rounded-md text-xs bg-gray-100 border-0 placeholder-gray-500 focus:outline-none focus:ring-1 focus:ring-primary/40 focus:bg-white transition-colors"
            />
          </div>

          {showResults && query.trim().length >= 2 && (
            <>
              <div className="fixed inset-0 z-40" onClick={closeSearch} />
              <div className="absolute top-full mt-1 w-full bg-white rounded-md shadow-lg border border-gray-200 z-50 overflow-hidden max-h-72 overflow-y-auto">
                {results.length === 0 ? (
                  <p className="px-3 py-3 text-xs text-gray-400 text-center">No matches for &quot;{query}&quot;</p>
                ) : (
                  results.map((s) => (
                    <button
                      key={s.id}
                      onClick={() => {
                        router.push(`/salons/${s.id}`);
                        closeSearch();
                      }}
                      className="flex items-center justify-between w-full text-left px-3 py-1.5 text-xs hover:bg-gray-50"
                    >
                      <span>
                        <span className="font-medium text-gray-900">{s.name}</span>
                        <span className="text-gray-400"> · {s.ownerName || 'Owner'} · {s.ownerPhone}</span>
                      </span>
                    </button>
                  ))
                )}
              </div>
            </>
          )}
        </div>

        <div className="flex items-center gap-2 pl-2 border-l border-gray-200">
          <div className="text-right hidden sm:block">
            <p className="text-xs font-semibold text-gray-900 leading-tight">{admin?.name || 'Admin'}</p>
            <p className="text-[11px] text-gray-400 leading-tight">Super Admin</p>
          </div>
          <div className="w-8 h-8 bg-gradient-to-br from-primary to-primary-dark rounded-full flex items-center justify-center text-white shadow-sm">
            <ShieldCheck size={15} />
          </div>
        </div>
      </div>
    </header>
  );
}
