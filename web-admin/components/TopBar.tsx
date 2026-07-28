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
      <div className="px-4 py-2.5 flex items-center justify-between gap-3">
        {/* Left */}
        <div className="flex items-center gap-2">
          <span className="text-xs font-bold text-gray-500 uppercase">Salon</span>
          <div className="relative">
            <button
              onClick={() => setShowDropdown(!showDropdown)}
              className="flex items-center gap-1.5 px-2.5 py-1.5 rounded text-xs bg-primary-light/40 hover:bg-primary-light/60 transition-all border border-primary/10"
            >
              <span className="font-semibold text-primary">{selectedSalon?.name}</span>
              <ChevronDown size={14} className="text-primary" />
            </button>
            {showDropdown && (
              <div className="absolute top-full mt-1 w-56 bg-white rounded shadow-lg border border-gray-200 z-50 overflow-hidden">
                {salons.map((salon) => (
                  <button
                    key={salon.id}
                    onClick={() => {
                      setSelectedSalon(salon.id);
                      setShowDropdown(false);
                    }}
                    className={`block w-full text-left px-3 py-1.5 text-xs hover:bg-gray-50 transition-colors border-b border-gray-100 last:border-b-0 ${
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
        <div className="flex-1 max-w-md">
          <div className="relative">
            <Search size={14} className="absolute left-2.5 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              type="text"
              placeholder="Search..."
              className="w-full pl-8 pr-3 py-1.5 rounded text-xs bg-gray-100 border-0 placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-primary/40 focus:bg-white transition-all"
            />
          </div>
        </div>

        {/* Right */}
        <div className="flex items-center gap-3">
          <button className="p-1 hover:bg-gray-100 rounded transition-colors relative">
            <Bell size={16} className="text-gray-600" />
            <span className="absolute top-0.5 right-0.5 w-1.5 h-1.5 bg-primary rounded-full"></span>
          </button>

          <div className="flex items-center gap-2 pl-3 border-l border-gray-200">
            <div className="text-right hidden sm:block">
              <p className="text-xs font-semibold text-gray-900">{user?.name}</p>
              <p className="text-xs text-gray-500">{user?.role}</p>
            </div>
            <div className="w-8 h-8 bg-gradient-to-br from-primary to-primary-dark rounded-full flex items-center justify-center text-white font-bold text-xs">
              {user?.name?.charAt(0).toUpperCase()}
            </div>
          </div>
        </div>
      </div>
    </header>
  );
}
