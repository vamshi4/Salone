import { Link, useLocation } from 'react-router-dom';
import { useAppStore } from '../stores/appStore';
import { Menu, X } from 'lucide-react';

const navItems = [
  { label: 'Home', href: '/', icon: '🏠' },
  { label: 'Bookings', href: '/bookings', icon: '📅' },
  { label: 'Staff', href: '/staff', icon: '👥' },
  { label: 'Insights', href: '/insights', icon: '📊' },
  { label: 'Services', href: '/services', icon: '✂️' },
];

const managementItems = [
  { label: 'Inventory', href: '/inventory', icon: '📦' },
  { label: 'Payouts', href: '/payouts', icon: '💳' },
  { label: 'Booking Link', href: '/booking-link', icon: '🔗' },
];

const settingItems = [
  { label: 'Account', href: '/account', icon: '⚙️' },
  { label: 'Help', href: '/help', icon: '❓' },
];

export function Sidebar() {
  const location = useLocation();
  const { sidebarOpen, setSidebarOpen } = useAppStore();

  const isActive = (href: string) => {
    if (href === '/') return location.pathname === '/';
    return location.pathname.startsWith(href);
  };

  return (
    <>
      {/* Mobile toggle */}
      <button
        onClick={() => setSidebarOpen(!sidebarOpen)}
        className="fixed top-4 left-4 z-50 md:hidden bg-salone-surface rounded-sm p-2 border border-salone-border"
      >
        {sidebarOpen ? (
          <X size={20} className="text-salone-ink" />
        ) : (
          <Menu size={20} className="text-salone-ink" />
        )}
      </button>

      {/* Overlay */}
      {sidebarOpen && (
        <div
          className="fixed inset-0 bg-black/20 z-40 md:hidden"
          onClick={() => setSidebarOpen(false)}
        />
      )}

      {/* Sidebar */}
      <div
        className={`fixed md:relative left-0 top-0 h-full w-[280px] bg-white border-r border-salone-border overflow-y-auto z-40 transform transition-transform md:transform-none ${
          sidebarOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        <div className="p-2">
          {/* Logo */}
          <div className="flex items-center gap-3 mb-8">
            <div className="w-12 h-12 bg-salone-accent rounded-md flex items-center justify-center flex-shrink-0">
              <svg
                className="w-7 h-7"
                viewBox="0 0 100 100"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  d="M30 40C25 40 20 45 20 50V70C20 75 25 80 30 80H70C75 80 80 75 80 70V50C80 45 75 40 70 40M40 25V40M60 25V40M35 80C35 85 32 90 28 90M65 80C65 85 68 90 72 90"
                  stroke="white"
                  strokeWidth="5"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </svg>
            </div>
            <div className="font-extrabold text-lg text-salone-ink">Salone</div>
          </div>

          {/* Main Navigation */}
          <div className="mb-6">
            <div className="text-xs font-semibold uppercase text-salone-ink-muted mb-2 px-3 tracking-wide">
              Main
            </div>
            <nav className="space-y-1">
              {navItems.map((item) => (
                <Link
                  key={item.href}
                  to={item.href}
                  className={`flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-all ${
                    isActive(item.href)
                      ? 'bg-salone-accent-soft text-salone-accent'
                      : 'text-salone-ink-muted hover:bg-salone-surface-alt hover:text-salone-ink'
                  }`}
                  onClick={() => setSidebarOpen(false)}
                >
                  <span className="text-lg w-5 h-5 flex items-center justify-center">
                    {item.icon}
                  </span>
                  <span>{item.label}</span>
                </Link>
              ))}
            </nav>
          </div>

          {/* Management */}
          <div className="mb-6">
            <div className="text-xs font-semibold uppercase text-salone-ink-muted mb-2 px-3 tracking-wide">
              Management
            </div>
            <nav className="space-y-1">
              {managementItems.map((item) => (
                <Link
                  key={item.href}
                  to={item.href}
                  className={`flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-all ${
                    isActive(item.href)
                      ? 'bg-salone-accent-soft text-salone-accent'
                      : 'text-salone-ink-muted hover:bg-salone-surface-alt hover:text-salone-ink'
                  }`}
                  onClick={() => setSidebarOpen(false)}
                >
                  <span className="text-lg w-5 h-5 flex items-center justify-center">
                    {item.icon}
                  </span>
                  <span>{item.label}</span>
                </Link>
              ))}
            </nav>
          </div>

          {/* Settings */}
          <div>
            <div className="text-xs font-semibold uppercase text-salone-ink-muted mb-2 px-3 tracking-wide">
              Settings
            </div>
            <nav className="space-y-1">
              {settingItems.map((item) => (
                <Link
                  key={item.href}
                  to={item.href}
                  className={`flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-all ${
                    isActive(item.href)
                      ? 'bg-salone-accent-soft text-salone-accent'
                      : 'text-salone-ink-muted hover:bg-salone-surface-alt hover:text-salone-ink'
                  }`}
                  onClick={() => setSidebarOpen(false)}
                >
                  <span className="text-lg w-5 h-5 flex items-center justify-center">
                    {item.icon}
                  </span>
                  <span>{item.label}</span>
                </Link>
              ))}
            </nav>
          </div>
        </div>
      </div>
    </>
  );
}
