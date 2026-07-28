'use client';

import { useAppStore } from '@/lib/store';
import { Search, Bell, ChevronDown } from 'lucide-react';
import { useState } from 'react';

export function TopBar() {
  const user = useAppStore((state) => state.user);
  const selectedSalonId = useAppStore((state) => state.selectedSalonId);
  const setSelectedSalon = useAppStore((state) => state.setSelectedSalon);
  const salons = useAppStore((state) => state.salons);
  const [showDropdown, setShowDropdown] = useState(false);

  const selectedSalon = salons.find((s) => s.id === selectedSalonId);

  return (
    <header className="bg-white border-b border-gray-200 sticky top-0 z-40 shadow-sm">
      <div className="px-5 py-3.5 flex items-center justify-between gap-4">
        {/* Left */}
        <div className="flex items-center gap-3">
          <span className="text-xs font-bold text-gray-500 uppercase tracking-widest">Salon</span>
          <div className="relative">
            <button
              onClick={() => setShowDropdown(!showDropdown)}
              className="flex items-center gap-2 px-3 py-2 rounded-lg text-sm bg-primary-light/40 hover:bg-primary-light/60 transition-all border border-primary/10"
            >
              <span className="font-semibold text-primary">{selectedSalon?.name}</span>
              <ChevronDown size={16} className="text-primary" />
            </button>
            {showDropdown && (
              <div className="absolute top-full mt-2 w-64 bg-white rounded-lg shadow-lg border border-gray-200 z-50 overflow-hidden">
                {salons.map((salon) => (
                  <button
                    key={salon.id}
                    onClick={() => {
                      setSelectedSalon(salon.id);
                      setShowDropdown(false);
                    }}
                    className={`block w-full text-left px-4 py-2.5 text-sm hover:bg-gray-50 transition-colors border-b border-gray-100 last:border-b-0 ${
                      salon.id === selectedSalonId
                        ? 'bg-primary/5 text-primary font-semibold'
                        : 'text-gray-900'
                    }`}
                  >
                    {salon.name}
                  </button>
                ))}
              </div>
            )}
          </div>
        </div>

        {/* Search */}
        <div className="flex-1 max-w-lg">
          <div className="relative">
            <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              type="text"
              placeholder="Search bookings, staff, services..."
              className="w-full pl-9 pr-3 py-2 rounded-lg text-sm bg-gray-100 border-0 placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-primary/40 focus:bg-white transition-all"
            />
          </div>
        </div>

        {/* Right */}
        <div className="flex items-center gap-4">
          <button className="p-2 hover:bg-gray-100 rounded-lg transition-colors relative group">
            <Bell size={18} className="text-gray-600" />
            <span className="absolute top-1 right-1 w-2 h-2 bg-primary rounded-full"></span>
            <div className="absolute right-0 top-full mt-2 px-2 py-1 bg-gray-900 text-white text-xs rounded opacity-0 group-hover:opacity-100 pointer-events-none whitespace-nowrap">
              Notifications
            </div>
          </button>

          <div className="flex items-center gap-3 pl-4 border-l border-gray-200">
            <div className="text-right hidden sm:block">
              <p className="text-sm font-semibold text-gray-900">{user?.name}</p>
              <p className="text-xs text-gray-500">{user?.role}</p>
            </div>
            <div className="w-9 h-9 bg-gradient-to-br from-primary to-primary-dark rounded-full flex items-center justify-center text-white font-bold text-sm shadow-md">
              {user?.name?.charAt(0).toUpperCase()}
            </div>
          </div>
        </div>
      </div>
    </header>
  );
}
