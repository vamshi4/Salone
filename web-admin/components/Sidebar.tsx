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

  const itemClass = (active: boolean) =>
    `flex items-center rounded-md text-xs transition-colors ${
      collapsed ? 'justify-center p-2' : 'gap-2.5 px-2.5 py-1.5'
    } ${
      active
        ? 'bg-primary-light text-primary-dark font-medium'
        : 'text-gray-600 hover:text-gray-900 hover:bg-gray-100'
    }`;

  const sectionLabel = (label: string) =>
    !collapsed && (
      <p className="px-2.5 pt-3 pb-1 text-xs text-gray-400">{label}</p>
    );

  return (
    <aside className={`bg-white border-r border-gray-200 flex flex-col min-h-screen transition-all duration-300 ${collapsed ? 'w-14' : 'w-48'}`}>
      {/* Header with Logo & Collapse Button */}
      <div className={`border-b border-gray-200 flex items-center justify-between ${collapsed ? 'py-2 px-0 justify-center' : 'px-3 py-2'}`}>
        {!collapsed && (
          <div>
            <h1 className="text-sm font-semibold text-primary-dark">Salone</h1>
            <p className="text-xs text-gray-400">Admin</p>
          </div>
        )}
        <button
          onClick={toggleCollapse}
          className="p-1 hover:bg-gray-100 rounded-md text-gray-500 transition-colors flex-shrink-0"
          title={collapsed ? 'Expand' : 'Collapse'}
        >
          <ChevronLeft size={14} className={`transition-transform ${collapsed ? 'rotate-180' : ''}`} />
        </button>
      </div>

      {/* Navigation */}
      <nav className="flex-1 overflow-y-auto p-2">
        {sectionLabel('Main')}
        <div className="space-y-0.5">
          {mainItems.map((item) => {
            const Icon = item.icon;
            return (
              <Link
                key={item.href}
                href={item.href}
                title={collapsed ? item.label : ''}
                className={itemClass(isActive(item.href))}
              >
                <Icon size={15} />
                {!collapsed && <span>{item.label}</span>}
              </Link>
            );
          })}
        </div>

        {sectionLabel('Management')}
        <div className="space-y-0.5">
          {managementItems.map((item) => {
            const Icon = item.icon;
            return (
              <Link
                key={item.href}
                href={item.href}
                title={collapsed ? item.label : ''}
                className={itemClass(isActive(item.href))}
              >
                <Icon size={15} />
                {!collapsed && <span>{item.label}</span>}
              </Link>
            );
          })}
        </div>

        {sectionLabel('Account')}
        <div className="space-y-0.5">
          <Link
            href="/account"
            title={collapsed ? 'Account' : ''}
            className={itemClass(isActive('/account'))}
          >
            <Settings size={15} />
            {!collapsed && <span>Account</span>}
          </Link>
        </div>
      </nav>

      {/* Logout */}
      <div className="p-2 border-t border-gray-200">
        <button
          onClick={() => {
            logout();
            window.location.href = '/login';
          }}
          title={collapsed ? 'Logout' : ''}
          className={`flex items-center rounded-md text-xs transition-colors text-gray-600 hover:text-red-600 hover:bg-red-50 w-full ${
            collapsed ? 'justify-center p-2' : 'gap-2.5 px-2.5 py-1.5'
          }`}
        >
          <LogOut size={15} />
          {!collapsed && <span>Logout</span>}
        </button>
      </div>
    </aside>
  );
}
