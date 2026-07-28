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
  Scissors,
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

  const itemClass = (active: boolean) =>
    `flex items-center rounded-lg text-xs transition-all ${
      collapsed ? 'justify-center p-2' : 'gap-2.5 px-3 py-2'
    } ${
      active
        ? 'bg-white/15 text-white font-semibold shadow-sm'
        : 'text-teal-100/70 hover:text-white hover:bg-white/10'
    }`;

  const sectionLabel = (label: string) =>
    !collapsed && (
      <p className="px-3 pt-4 pb-1 text-[10px] font-semibold uppercase tracking-wider text-teal-100/40">{label}</p>
    );

  return (
    <aside
      className={`bg-gradient-to-b from-primary to-primary-dark flex flex-col min-h-screen transition-all duration-300 ${collapsed ? 'w-14' : 'w-52'}`}
    >
      {/* Brand */}
      <div className={`flex items-center ${collapsed ? 'justify-center py-3' : 'justify-between px-3.5 py-3.5'}`}>
        {!collapsed && (
          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-lg bg-white/15 flex items-center justify-center">
              <Scissors size={15} className="text-white" />
            </div>
            <div>
              <h1 className="text-sm font-bold text-white leading-tight">Salone</h1>
              <p className="text-[10px] text-teal-100/50 leading-tight">Salon admin</p>
            </div>
          </div>
        )}
        <button
          onClick={toggleCollapse}
          className="p-1 hover:bg-white/10 rounded-md text-teal-100/60 hover:text-white transition-colors flex-shrink-0"
          title={collapsed ? 'Expand' : 'Collapse'}
        >
          <ChevronLeft size={14} className={`transition-transform ${collapsed ? 'rotate-180' : ''}`} />
        </button>
      </div>

      {/* Navigation */}
      <nav className="flex-1 overflow-y-auto px-2 pb-2">
        {sectionLabel('Main')}
        <div className="space-y-1">
          {mainItems.map((item) => {
            const Icon = item.icon;
            return (
              <Link
                key={item.href}
                href={item.href}
                title={collapsed ? item.label : ''}
                className={itemClass(isActive(item.href))}
              >
                <Icon size={16} />
                {!collapsed && <span>{item.label}</span>}
              </Link>
            );
          })}
        </div>

        {sectionLabel('Management')}
        <div className="space-y-1">
          {managementItems.map((item) => {
            const Icon = item.icon;
            return (
              <Link
                key={item.href}
                href={item.href}
                title={collapsed ? item.label : ''}
                className={itemClass(isActive(item.href))}
              >
                <Icon size={16} />
                {!collapsed && <span>{item.label}</span>}
              </Link>
            );
          })}
        </div>

        {sectionLabel('Account')}
        <div className="space-y-1">
          <Link
            href="/account"
            title={collapsed ? 'Account' : ''}
            className={itemClass(isActive('/account'))}
          >
            <Settings size={16} />
            {!collapsed && <span>Account</span>}
          </Link>
        </div>
      </nav>

      {/* Logout */}
      <div className="p-2 border-t border-white/10">
        <button
          onClick={() => {
            logout();
            window.location.href = '/login';
          }}
          title={collapsed ? 'Logout' : ''}
          className={`flex items-center rounded-lg text-xs transition-colors text-teal-100/60 hover:text-white hover:bg-white/10 w-full ${
            collapsed ? 'justify-center p-2' : 'gap-2.5 px-3 py-2'
          }`}
        >
          <LogOut size={16} />
          {!collapsed && <span>Logout</span>}
        </button>
      </div>
    </aside>
  );
}
