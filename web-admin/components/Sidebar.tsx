'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import {
  Home,
  Calendar,
  Users,
  BarChart3,
  Zap,
  Package,
  Settings,
  LogOut,
  ChevronLeft,
} from 'lucide-react';
import { useAppStore } from '@/lib/store';
import { useState, useEffect } from 'react';

export function Sidebar() {
  const pathname = usePathname();
  const logout = useAppStore((state) => state.logout);
  const [collapsed, setCollapsed] = useState(false);

  useEffect(() => {
    const saved = localStorage.getItem('sidebar-collapsed');
    if (saved) setCollapsed(JSON.parse(saved));
  }, []);

  const toggleCollapse = () => {
    const newState = !collapsed;
    setCollapsed(newState);
    localStorage.setItem('sidebar-collapsed', JSON.stringify(newState));
  };

  const mainItems = [
    { href: '/dashboard', label: 'Home', icon: Home },
    { href: '/bookings', label: 'Bookings', icon: Calendar },
    { href: '/staff', label: 'Staff', icon: Users },
    { href: '/insights', label: 'Insights', icon: BarChart3 },
    { href: '/services', label: 'Services', icon: Zap },
  ];

  const managementItems = [
    { href: '/products', label: 'Inventory', icon: Package },
  ];

  const isActive = (href: string) => pathname === href;

  return (
    <aside className={`bg-gradient-to-b from-primary-light to-primary-light/80 border-r border-primary/15 flex flex-col min-h-screen transition-all duration-300 ${collapsed ? 'w-16' : 'w-56'}`}>
      {/* Header with Logo & Collapse Button */}
      <div className={`border-b border-primary/10 flex items-center justify-between ${collapsed ? 'py-3 px-0 justify-center' : 'px-4 py-3'}`}>
        {!collapsed && (
          <div>
            <h1 className="text-sm font-bold text-primary">Salone</h1>
            <p className="text-xs text-primary/60 mt-0.5">Salon Admin</p>
          </div>
        )}
        <button
          onClick={toggleCollapse}
          className="p-1.5 hover:bg-primary/15 rounded-lg text-primary transition-colors flex-shrink-0"
          title={collapsed ? 'Expand' : 'Collapse'}
        >
          <ChevronLeft size={16} className={`transition-transform ${collapsed ? 'rotate-180' : ''}`} />
        </button>
      </div>

      {/* Navigation */}
      <nav className="flex-1 overflow-y-auto p-3 space-y-1">
        {/* MAIN */}
        {!collapsed && <div className="px-3 pt-2 pb-1.5">
          <p className="text-xs font-bold text-primary/60 uppercase tracking-wider">Main</p>
        </div>}
        <div className={collapsed ? 'space-y-1.5' : 'space-y-1'}>
          {mainItems.map((item) => {
            const Icon = item.icon;
            const active = isActive(item.href);
            return (
              <Link
                key={item.href}
                href={item.href}
                title={collapsed ? item.label : ''}
                className={`flex items-center rounded-lg text-sm transition-all ${
                  collapsed ? 'justify-center p-2.5' : 'gap-3 px-3 py-2.5'
                } ${
                  active
                    ? 'bg-white text-primary font-semibold shadow-sm'
                    : 'text-primary/70 hover:text-primary hover:bg-white/40'
                }`}
              >
                <Icon size={18} />
                {!collapsed && <span>{item.label}</span>}
              </Link>
            );
          })}
        </div>

        {/* MANAGEMENT */}
        {!collapsed && <div className="px-3 pt-3 pb-1.5">
          <p className="text-xs font-bold text-primary/60 uppercase tracking-wider">Management</p>
        </div>}
        <div className={collapsed ? 'space-y-1.5' : 'space-y-1'}>
          {managementItems.map((item) => {
            const Icon = item.icon;
            const active = isActive(item.href);
            return (
              <Link
                key={item.href}
                href={item.href}
                title={collapsed ? item.label : ''}
                className={`flex items-center rounded-lg text-sm transition-all ${
                  collapsed ? 'justify-center p-2.5' : 'gap-3 px-3 py-2.5'
                } ${
                  active
                    ? 'bg-white text-primary font-semibold shadow-sm'
                    : 'text-primary/70 hover:text-primary hover:bg-white/40'
                }`}
              >
                <Icon size={18} />
                {!collapsed && <span>{item.label}</span>}
              </Link>
            );
          })}
        </div>

        {/* SETTINGS */}
        {!collapsed && <div className="px-3 pt-3 pb-1.5">
          <p className="text-xs font-bold text-primary/60 uppercase tracking-wider">Account</p>
        </div>}
        <div className={collapsed ? 'space-y-1.5' : 'space-y-1'}>
          <Link
            href="/account"
            title={collapsed ? 'Account' : ''}
            className={`flex items-center rounded-lg text-sm transition-all ${
              collapsed ? 'justify-center p-2.5' : 'gap-3 px-3 py-2.5'
            } ${
              isActive('/account')
                ? 'bg-white text-primary font-semibold shadow-sm'
                : 'text-primary/70 hover:text-primary hover:bg-white/40'
            }`}
          >
            <Settings size={18} />
            {!collapsed && <span>Account</span>}
          </Link>
        </div>
      </nav>

      {/* Logout */}
      <div className="p-3 border-t border-primary/10">
        <button
          onClick={() => {
            logout();
            window.location.href = '/login';
          }}
          title={collapsed ? 'Logout' : ''}
          className={`flex items-center rounded-lg text-sm transition-all text-red-600 hover:bg-red-50 w-full ${
            collapsed ? 'justify-center p-2.5' : 'gap-3 px-3 py-2.5'
          }`}
        >
          <LogOut size={18} />
          {!collapsed && <span className="font-medium">Logout</span>}
        </button>
      </div>
    </aside>
  );
}
