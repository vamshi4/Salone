import { Menu, Search, Bell, ChevronDown } from 'lucide-react';
import { useAppStore } from '../stores/appStore';
import { useState } from 'react';

interface TopBarProps {
  onMenuClick?: () => void;
}

export default function TopBar({ onMenuClick }: TopBarProps) {
  const user = useAppStore((state) => state.user);
  const selectedSalonId = useAppStore((state) => state.selectedSalonId);
  const setSelectedSalon = useAppStore((state) => state.setSelectedSalon);
  const salons = useAppStore((state) => state.salons);
  const [showSalonDropdown, setShowSalonDropdown] = useState(false);

  const selectedSalon = salons.find((s) => s.id === selectedSalonId);

  return (
    <div className="bg-white border-b border-gray-100 sticky top-0 z-40">
      <div className="px-6 py-4 flex items-center justify-between gap-6">
        <div className="flex items-center gap-4">
          <button onClick={onMenuClick} className="lg:hidden p-2">
            <Menu size={20} />
          </button>

          {/* Salon Selector */}
          <div className="flex items-center gap-2">
            <span className="text-xs font-semibold text-text-muted uppercase">Salon</span>
            <div className="relative">
              <button
                onClick={() => setShowSalonDropdown(!showSalonDropdown)}
                className="flex items-center gap-2 px-3 py-2 rounded-lg bg-primary-light hover:bg-primary/10 transition-colors"
              >
                <span className="font-medium text-primary text-sm">{selectedSalon?.name}</span>
                <ChevronDown size={16} className="text-primary" />
              </button>
              {showSalonDropdown && (
                <div className="absolute top-full mt-2 w-56 bg-white rounded-lg shadow-lg border border-gray-100 z-50">
                  {salons.map((salon) => (
                    <button
                      key={salon.id}
                      onClick={() => {
                        setSelectedSalon(salon.id);
                        setShowSalonDropdown(false);
                      }}
                      className={`block w-full text-left px-4 py-2.5 text-sm hover:bg-primary-light transition-colors first:rounded-t-lg last:rounded-b-lg ${
                        salon.id === selectedSalonId ? 'bg-primary/10 text-primary font-medium' : 'text-text-primary'
                      }`}
                    >
                      {salon.name}
                    </button>
                  ))}
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Search Bar */}
        <div className="flex-1 max-w-md">
          <div className="relative">
            <Search size={18} className="absolute left-3 top-1/2 transform -translate-y-1/2 text-text-muted" />
            <input
              type="text"
              placeholder="Search bookings, staff, services"
              className="w-full pl-10 pr-4 py-2 rounded-lg bg-gray-100 border-0 text-sm placeholder-text-muted focus:outline-none focus:ring-2 focus:ring-primary/30"
            />
          </div>
        </div>

        {/* Right Section */}
        <div className="flex items-center gap-4">
          <button className="p-2 hover:bg-gray-100 rounded-lg transition-colors relative">
            <Bell size={20} className="text-text-muted" />
            <span className="absolute top-1 right-1 w-2 h-2 bg-primary rounded-full"></span>
          </button>

          <div className="flex items-center gap-3">
            <div className="text-right">
              <p className="text-sm font-medium text-text-primary">{user?.name}</p>
              <p className="text-xs text-text-muted">{user?.role}</p>
            </div>
            <div className="w-9 h-9 bg-primary rounded-full flex items-center justify-center text-white font-semibold text-sm">
              {user?.name?.charAt(0).toUpperCase()}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
