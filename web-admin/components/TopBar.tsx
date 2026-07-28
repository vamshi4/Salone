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
            <div className="absolute top-full mt-1 w-56 bg-white rounded-md shadow-lg border border-gray-200 z-50 overflow-hidden">
              {salons.map((salon) => (
                <button
                  key={salon.id}
                  onClick={() => {
                    setSelectedSalon(salon.id);
                    setShowDropdown(false);
                  }}
                  className={`block w-full text-left px-3 py-1.5 text-xs hover:bg-gray-50 transition-colors ${
                    salon.id === selectedSalonId
                      ? 'text-primary-dark font-medium'
                      : 'text-gray-700'
                  }`}
                >
                  {salon.name}
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Search */}
        <div className="flex-1 max-w-sm">
          <div className="relative">
            <Search size={13} className="absolute left-2.5 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              type="text"
              placeholder="Search bookings, staff, services"
              className="w-full pl-8 pr-3 py-1.5 rounded-md text-xs bg-gray-100 border-0 placeholder-gray-500 focus:outline-none focus:ring-1 focus:ring-primary/40 focus:bg-white transition-colors"
            />
          </div>
        </div>

        {/* Right */}
        <div className="flex items-center gap-2">
          <button className="p-1.5 hover:bg-gray-100 rounded-md transition-colors relative" title="Notifications">
            <Bell size={15} className="text-gray-500" />
            <span className="absolute top-1 right-1 w-1.5 h-1.5 bg-primary rounded-full"></span>
          </button>

          <div className="flex items-center gap-2 pl-2 border-l border-gray-200">
            <div className="text-right hidden sm:block">
              <p className="text-xs font-medium text-gray-900 leading-tight">{user?.name}</p>
              <p className="text-xs text-gray-400 leading-tight">Owner</p>
            </div>
            <div className="w-7 h-7 bg-primary-light rounded-full flex items-center justify-center text-primary-dark font-medium text-xs">
              {user?.name?.charAt(0).toUpperCase()}
            </div>
          </div>
        </div>
      </div>
    </header>
  );
}
