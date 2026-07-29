'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { LayoutDashboard, Building2, Trash2, ScrollText, LogOut, ChevronLeft, ShieldCheck, X } from 'lucide-react';
import { useAppStore } from '@/lib/store';
import { logoutLocal } from '@/lib/auth';
import { APP_BASE_PATH } from '@/lib/api';
import { useState, useEffect } from 'react';

// Same responsive-drawer pattern as web-admin/components/Sidebar.tsx (a
// fixed-width rail with no width-awareness cramped every page on a real
// phone there — built in from the start here instead of as a fast-follow).
const MOBILE_BREAKPOINT = 768;

export function Sidebar({
  mobileOpen,
  onCloseMobile,
}: {
  mobileOpen: boolean;
  onCloseMobile: () => void;
}) {
  const pathname = usePathname();
  const logout = useAppStore((state) => state.logout);
  const [collapsed, setCollapsed] = useState(false);
  const [isMobile, setIsMobile] = useState(false);

  useEffect(() => {
    const saved = localStorage.getItem('superadmin-sidebar-collapsed');
    if (saved) setCollapsed(JSON.parse(saved));
  }, []);

  useEffect(() => {
    const check = () => setIsMobile(window.innerWidth < MOBILE_BREAKPOINT);
    check();
    window.addEventListener('resize', check);
    return () => window.removeEventListener('resize', check);
  }, []);

  useEffect(() => {
    if (isMobile && mobileOpen) {
      document.body.style.overflow = 'hidden';
      return () => {
        document.body.style.overflow = '';
      };
    }
  }, [isMobile, mobileOpen]);

  const toggleCollapse = () => {
    const newState = !collapsed;
    setCollapsed(newState);
    localStorage.setItem('superadmin-sidebar-collapsed', JSON.stringify(newState));
  };

  const effectiveCollapsed = isMobile ? false : collapsed;

  const closeOnMobileNav = () => {
    if (isMobile) onCloseMobile();
  };

  const items = [
    { href: '/dashboard', label: 'Dashboard', icon: LayoutDashboard },
    { href: '/salons', label: 'Salons', icon: Building2 },
    { href: '/deleted', label: 'Deleted', icon: Trash2 },
    { href: '/audit', label: 'Audit log', icon: ScrollText },
  ];

  const isActive = (href: string) => pathname === href || pathname.startsWith(href + '/');

  const itemClass = (active: boolean) =>
    `flex items-center rounded-lg text-xs transition-all ${
      effectiveCollapsed ? 'justify-center p-2' : 'gap-2 px-2 py-1.5'
    } ${
      active
        ? 'bg-white/15 text-white font-semibold shadow-sm'
        : 'text-indigo-100/70 hover:text-white hover:bg-white/10'
    }`;

  return (
    <>
      {isMobile && mobileOpen && (
        <div className="fixed inset-0 z-40 bg-gray-900/40" onClick={onCloseMobile} />
      )}
      <aside
        className={`bg-gradient-to-b from-primary to-primary-dark flex flex-col min-h-screen flex-shrink-0 ${
          isMobile
            ? `fixed inset-y-0 left-0 z-50 w-64 transform transition-transform duration-300 ${
                mobileOpen ? 'translate-x-0' : '-translate-x-full'
              }`
            : `relative transition-all duration-300 ${collapsed ? 'w-14' : 'w-40'}`
        }`}
      >
        <div className={`flex items-center ${effectiveCollapsed ? 'justify-center py-3' : 'justify-between px-2.5 py-3'}`}>
          {!effectiveCollapsed && (
            <div className="flex items-center gap-2">
              <div className="w-7 h-7 rounded-lg bg-white/15 flex items-center justify-center">
                <ShieldCheck size={13} className="text-white" />
              </div>
              <h1 className="text-sm font-bold text-white leading-tight">Super Admin</h1>
            </div>
          )}
          <button
            onClick={isMobile ? onCloseMobile : toggleCollapse}
            className="p-1 hover:bg-white/10 rounded-md text-indigo-100/60 hover:text-white transition-colors flex-shrink-0"
            title={isMobile ? 'Close' : collapsed ? 'Expand' : 'Collapse'}
          >
            {isMobile ? (
              <X size={16} />
            ) : (
              <ChevronLeft size={14} className={`transition-transform ${collapsed ? 'rotate-180' : ''}`} />
            )}
          </button>
        </div>

        <nav className="flex-1 overflow-y-auto no-scrollbar px-2 pb-2 pt-2">
          <div className="space-y-1">
            {items.map((item) => {
              const Icon = item.icon;
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  title={effectiveCollapsed ? item.label : ''}
                  onClick={closeOnMobileNav}
                  className={itemClass(isActive(item.href))}
                >
                  <Icon size={16} />
                  {!effectiveCollapsed && <span>{item.label}</span>}
                </Link>
              );
            })}
          </div>
        </nav>

        <div className="p-2 border-t border-white/10">
          <button
            onClick={() => {
              logoutLocal();
              logout();
              window.location.href = `${APP_BASE_PATH}/login`;
            }}
            title={effectiveCollapsed ? 'Logout' : ''}
            className={`flex items-center rounded-lg text-xs transition-colors text-indigo-100/60 hover:text-white hover:bg-white/10 w-full ${
              effectiveCollapsed ? 'justify-center p-2' : 'gap-2 px-2 py-1.5'
            }`}
          >
            <LogOut size={16} />
            {!effectiveCollapsed && <span>Logout</span>}
          </button>
        </div>
      </aside>
    </>
  );
}
