import { useState } from 'react';
import { Bell, Settings } from 'lucide-react';
import { useAppStore } from '../stores/appStore';

export function TopBar() {
  const [searchQuery, setSearchQuery] = useState('');
  const { user } = useAppStore();

  const initials = user?.name
    ?.split(' ')
    .map((n) => n[0])
    .join('')
    .toUpperCase() || 'SA';

  return (
    <div
      className="flex justify-between items-center px-6 py-4 bg-salone-surface border-b border-salone-border"
      style={{ boxShadow: '0 3px 16px rgba(26, 26, 26, 0.06)' }}
    >
      {/* Search */}
      <div className="flex-1 max-w-md">
        <div className="flex items-center gap-2 px-4 py-3 bg-salone-surface-alt rounded-full">
          <span className="text-lg">🔍</span>
          <input
            type="text"
            placeholder="Search bookings, staff..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="flex-1 bg-transparent text-sm font-semibold text-salone-ink outline-none"
          />
        </div>
      </div>

      {/* Actions */}
      <div className="flex items-center gap-3 ml-6">
        <button className="w-10 h-10 bg-salone-surface-alt rounded-sm flex items-center justify-center hover:bg-salone-border transition-colors">
          <Bell size={18} className="text-salone-ink" />
        </button>
        <button className="w-10 h-10 bg-salone-surface-alt rounded-sm flex items-center justify-center hover:bg-salone-border transition-colors">
          <Settings size={18} className="text-salone-ink" />
        </button>

        {/* Avatar */}
        <div className="flex items-center gap-2 ml-2">
          <div className="w-9 h-9 bg-salone-accent rounded-sm flex items-center justify-center">
            <span className="text-xs font-extrabold text-white">{initials}</span>
          </div>
        </div>
      </div>
    </div>
  );
}
