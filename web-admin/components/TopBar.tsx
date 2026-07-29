'use client';

import { useAppStore } from '@/lib/store';
import { Search, Bell, ChevronDown, Plus, MapPin, User, Scissors, Zap, X } from 'lucide-react';
import { useMemo, useState } from 'react';
import { useRouter } from 'next/navigation';
import { AddBranchModal } from './AddBranchModal';
import { CustomerProfileModal } from './CustomerProfileModal';
import { useDataStore, needsAction, type Customer } from '@/lib/data';

export function TopBar() {
  const router = useRouter();
  const user = useAppStore((state) => state.user);
  const selectedSalonId = useAppStore((state) => state.selectedSalonId);
  const setSelectedSalon = useAppStore((state) => state.setSelectedSalon);
  const salons = useAppStore((state) => state.salons);
  const [showDropdown, setShowDropdown] = useState(false);
  const [showAddBranch, setShowAddBranch] = useState(false);
  const [showNotifications, setShowNotifications] = useState(false);
  const [query, setQuery] = useState('');
  const [showResults, setShowResults] = useState(false);
  const [profileCustomer, setProfileCustomer] = useState<Customer | undefined>();

  const { customers, staff, services, bookings, products } = useDataStore();

  const selectedSalon = salons.find((s) => s.id === selectedSalonId);

  const pendingCount = needsAction(bookings).length;
  const lowStockCount = products.filter((p) => p.stockQty <= p.lowStockThreshold).length;
  const hasNotifications = pendingCount > 0 || lowStockCount > 0;

  const results = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (q.length < 2) return null;
    return {
      customers: customers.filter((c) => c.name.toLowerCase().includes(q)).slice(0, 4),
      staff: staff.filter((s) => s.name.toLowerCase().includes(q)).slice(0, 3),
      services: services.filter((s) => s.name.toLowerCase().includes(q)).slice(0, 3),
    };
  }, [query, customers, staff, services]);

  const closeSearch = () => {
    setShowResults(false);
    setQuery('');
  };

  return (
    <header className="bg-white border-b border-gray-200 sticky top-0 z-40">
      <div className="px-4 py-2 flex items-center justify-between gap-3">
        {/* Salon switcher — the name is the control */}
        <div className="relative">
          <button
            onClick={() => setShowDropdown(!showDropdown)}
            className="flex items-center gap-1.5 px-2 py-1.5 rounded-md text-xs font-medium text-gray-900 hover:bg-gray-100 transition-colors"
          >
            {selectedSalon?.name}
            <ChevronDown size={13} className="text-gray-400" />
          </button>
          {showDropdown && (
            <>
              <div className="fixed inset-0 z-40" onClick={() => setShowDropdown(false)} />
              <div className="absolute top-full mt-1 w-60 bg-white rounded-md shadow-lg border border-gray-200 z-50 overflow-hidden">
                <div className="py-1">
                  {salons.map((salon) => (
                    <button
                      key={salon.id}
                      onClick={() => {
                        setSelectedSalon(salon.id);
                        setShowDropdown(false);
                      }}
                      className={`flex items-center gap-2 w-full text-left px-3 py-1.5 text-xs hover:bg-gray-50 transition-colors ${
                        salon.id === selectedSalonId
                          ? 'text-primary-dark font-medium'
                          : 'text-gray-700'
                      }`}
                    >
                      <MapPin size={12} className="text-gray-400 flex-shrink-0" />
                      <span className="truncate">{salon.name}</span>
                    </button>
                  ))}
                </div>
                <button
                  onClick={() => {
                    setShowDropdown(false);
                    setShowAddBranch(true);
                  }}
                  className="flex items-center gap-2 w-full text-left px-3 py-1.5 text-xs text-primary-dark font-medium border-t border-gray-100 hover:bg-primary-50 transition-colors"
                >
                  <Plus size={12} />
                  Add branch
                </button>
              </div>
            </>
          )}
        </div>

        {/* Search */}
        <div className="flex-1 max-w-sm relative">
          <div className="relative">
            <Search size={13} className="absolute left-2.5 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              type="text"
              placeholder="Search customers, staff, services"
              value={query}
              onChange={(e) => {
                setQuery(e.target.value);
                setShowResults(true);
              }}
              onFocus={() => setShowResults(true)}
              className="w-full pl-8 pr-7 py-1.5 rounded-md text-xs bg-gray-100 border-0 placeholder-gray-500 focus:outline-none focus:ring-1 focus:ring-primary/40 focus:bg-white transition-colors"
            />
            {query && (
              <button
                onClick={closeSearch}
                className="absolute right-2 top-1/2 -translate-y-1/2 p-0.5 rounded hover:bg-gray-200"
                aria-label="Clear search"
              >
                <X size={12} className="text-gray-400" />
              </button>
            )}
          </div>

          {showResults && results && (
            <>
              <div className="fixed inset-0 z-40" onClick={closeSearch} />
              <div className="absolute top-full mt-1 w-full bg-white rounded-md shadow-lg border border-gray-200 z-50 overflow-hidden max-h-80 overflow-y-auto">
                {results.customers.length === 0 && results.staff.length === 0 && results.services.length === 0 ? (
                  <p className="px-3 py-3 text-xs text-gray-400 text-center">No matches for "{query}"</p>
                ) : (
                  <>
                    {results.customers.length > 0 && (
                      <div className="py-1">
                        <p className="px-3 py-1 text-[10px] font-semibold uppercase tracking-wide text-gray-400">Customers</p>
                        {results.customers.map((c) => (
                          <button
                            key={c.id}
                            onClick={() => {
                              setProfileCustomer(c);
                              closeSearch();
                            }}
                            className="flex items-center gap-2 w-full text-left px-3 py-1.5 text-xs hover:bg-gray-50"
                          >
                            <User size={12} className="text-gray-400 flex-shrink-0" />
                            <span className="text-gray-800">{c.name}</span>
                            <span className="text-gray-400">· {c.phone}</span>
                          </button>
                        ))}
                      </div>
                    )}
                    {results.staff.length > 0 && (
                      <div className="py-1 border-t border-gray-100">
                        <p className="px-3 py-1 text-[10px] font-semibold uppercase tracking-wide text-gray-400">Staff</p>
                        {results.staff.map((s) => (
                          <button
                            key={s.id}
                            onClick={() => {
                              router.push('/staff');
                              closeSearch();
                            }}
                            className="flex items-center gap-2 w-full text-left px-3 py-1.5 text-xs hover:bg-gray-50"
                          >
                            <Scissors size={12} className="text-gray-400 flex-shrink-0" />
                            <span className="text-gray-800">{s.name}</span>
                          </button>
                        ))}
                      </div>
                    )}
                    {results.services.length > 0 && (
                      <div className="py-1 border-t border-gray-100">
                        <p className="px-3 py-1 text-[10px] font-semibold uppercase tracking-wide text-gray-400">Services</p>
                        {results.services.map((s) => (
                          <button
                            key={s.id}
                            onClick={() => {
                              router.push('/services');
                              closeSearch();
                            }}
                            className="flex items-center gap-2 w-full text-left px-3 py-1.5 text-xs hover:bg-gray-50"
                          >
                            <Zap size={12} className="text-gray-400 flex-shrink-0" />
                            <span className="text-gray-800">{s.name}</span>
                          </button>
                        ))}
                      </div>
                    )}
                  </>
                )}
              </div>
            </>
          )}
        </div>

        {/* Right */}
        <div className="flex items-center gap-2">
          <div className="relative">
            <button
              onClick={() => setShowNotifications(!showNotifications)}
              className="p-1.5 hover:bg-gray-100 rounded-md transition-colors relative"
              aria-label="Notifications"
            >
              <Bell size={15} className="text-gray-500" />
              {hasNotifications && (
                <span className="absolute top-1 right-1 w-1.5 h-1.5 bg-primary rounded-full" />
              )}
            </button>
            {showNotifications && (
              <>
                <div className="fixed inset-0 z-40" onClick={() => setShowNotifications(false)} />
                <div className="absolute right-0 top-full mt-1 w-64 bg-white rounded-md shadow-lg border border-gray-200 z-50 overflow-hidden">
                  <p className="px-3 py-2 text-xs font-semibold text-gray-900 border-b border-gray-100">Notifications</p>
                  {!hasNotifications ? (
                    <p className="px-3 py-4 text-xs text-gray-400 text-center">You're all caught up.</p>
                  ) : (
                    <div className="py-1">
                      {pendingCount > 0 && (
                        <button
                          onClick={() => {
                            router.push('/bookings');
                            setShowNotifications(false);
                          }}
                          className="flex items-center justify-between w-full text-left px-3 py-2 text-xs hover:bg-gray-50"
                        >
                          <span className="text-gray-700">
                            {pendingCount} booking{pendingCount === 1 ? '' : 's'}{' '}
                            {pendingCount === 1 ? 'needs' : 'need'} your response
                          </span>
                          <span className="text-primary font-semibold">View</span>
                        </button>
                      )}
                      {lowStockCount > 0 && (
                        <button
                          onClick={() => {
                            router.push('/products?low=1');
                            setShowNotifications(false);
                          }}
                          className="flex items-center justify-between w-full text-left px-3 py-2 text-xs hover:bg-gray-50"
                        >
                          <span className="text-gray-700">
                            {lowStockCount} product{lowStockCount === 1 ? '' : 's'} low on stock
                          </span>
                          <span className="text-primary font-semibold">View</span>
                        </button>
                      )}
                    </div>
                  )}
                </div>
              </>
            )}
          </div>

          <div className="flex items-center gap-2 pl-2 border-l border-gray-200">
            <div className="text-right hidden sm:block">
              <p className="text-xs font-semibold text-gray-900 leading-tight">{user?.name}</p>
              <p className="text-[11px] text-gray-400 leading-tight">Owner</p>
            </div>
            <div className="w-8 h-8 bg-gradient-to-br from-primary to-primary-dark rounded-full flex items-center justify-center text-white font-semibold text-xs shadow-sm">
              {user?.name?.charAt(0).toUpperCase()}
            </div>
          </div>
        </div>
      </div>
      {showAddBranch && <AddBranchModal onClose={() => setShowAddBranch(false)} />}
      {profileCustomer && (
        <CustomerProfileModal customer={profileCustomer} onClose={() => setProfileCustomer(undefined)} />
      )}
    </header>
  );
}
