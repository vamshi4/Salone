import { Link, useLocation } from 'react-router-dom';
import { Home, Calendar, Users, Zap, Package, BarChart3, DollarSign, Link2, Settings, LogOut, ChevronDown } from 'lucide-react';
import { useAppStore } from '../stores/appStore';
import { useState } from 'react';

interface SidebarProps {
  isOpen?: boolean;
  onClose?: () => void;
}

export default function Sidebar({ isOpen = true, onClose }: SidebarProps) {
  const location = useLocation();
  const logout = useAppStore((state) => state.logout);
  const [showSettings, setShowSettings] = useState(false);

  const mainItems = [
    { path: '/home', icon: Home, label: 'Home' },
    { path: '/bookings', icon: Calendar, label: 'Bookings' },
    { path: '/staff', icon: Users, label: 'Staff' },
    { path: '/insights', icon: BarChart3, label: 'Insights' },
    { path: '/services', icon: Zap, label: 'Services' },
  ];

  const managementItems = [
    { path: '/inventory', icon: Package, label: 'Inventory' },
    { path: '/payouts', icon: DollarSign, label: 'Payouts' },
    { path: '/booking-link', icon: Link2, label: 'Booking link' },
  ];

  const isActive = (path: string) => location.pathname === path;

  return (
    <div className={`bg-primary-light border-r border-primary/20 h-screen flex flex-col transition-all duration-300 ${isOpen ? 'w-64' : 'w-0'} overflow-hidden`}>
      <div className="p-6 border-b border-primary/20">
        <h1 className="text-xl font-bold text-primary flex items-center gap-2">🏪 Salone</h1>
      </div>

      <nav className="flex-1 overflow-y-auto">
        {/* MAIN Section */}
        <div className="px-4 pt-6 pb-3">
          <p className="text-xs font-semibold text-text-muted uppercase tracking-wider">Main</p>
        </div>
        <div className="px-2 space-y-1">
          {mainItems.map(({ path, icon: Icon, label }) => (
            <Link
              key={path}
              to={path}
              className={`flex items-center gap-3 px-4 py-2.5 rounded-lg transition-colors text-sm ${
                isActive(path)
                  ? 'bg-primary/15 text-primary font-medium'
                  : 'text-text-muted hover:text-text-primary hover:bg-primary/10'
              }`}
            >
              <Icon size={18} />
              <span>{label}</span>
            </Link>
          ))}
        </div>

        {/* MANAGEMENT Section */}
        <div className="px-4 pt-6 pb-3">
          <p className="text-xs font-semibold text-text-muted uppercase tracking-wider">Management</p>
        </div>
        <div className="px-2 space-y-1">
          {managementItems.map(({ path, icon: Icon, label }) => (
            <Link
              key={path}
              to={path}
              className={`flex items-center gap-3 px-4 py-2.5 rounded-lg transition-colors text-sm ${
                isActive(path)
                  ? 'bg-primary/15 text-primary font-medium'
                  : 'text-text-muted hover:text-text-primary hover:bg-primary/10'
              }`}
            >
              <Icon size={18} />
              <span>{label}</span>
            </Link>
          ))}
        </div>

        {/* SETTINGS Section */}
        <div className="px-4 pt-6 pb-3">
          <p className="text-xs font-semibold text-text-muted uppercase tracking-wider">Settings</p>
        </div>
        <div className="px-2">
          <button
            onClick={() => setShowSettings(!showSettings)}
            className="w-full flex items-center justify-between px-4 py-2.5 rounded-lg transition-colors text-sm text-text-muted hover:text-text-primary hover:bg-primary/10"
          >
            <div className="flex items-center gap-3">
              <Settings size={18} />
              <span>Account</span>
            </div>
            <ChevronDown size={16} className={`transition-transform ${showSettings ? 'rotate-180' : ''}`} />
          </button>
        </div>
      </nav>

      <div className="p-4 border-t border-primary/20">
        <button
          onClick={() => {
            logout();
            window.location.href = '/login';
          }}
          className="flex items-center gap-3 w-full px-4 py-2.5 rounded-lg text-danger hover:bg-danger/10 transition-colors text-sm"
        >
          <LogOut size={18} />
          <span className="font-medium">Logout</span>
        </button>
      </div>
    </div>
  );
}
