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
    <div className="flex justify-between items-center px-3 py-1.5 bg-white border-b border-salone-border">
      {/* Search */}
      <div className="flex-1 max-w-sm">
        <div className="flex items-center gap-2 px-4 py-2.5 bg-salone-surface-alt rounded-lg border border-transparent hover:border-salone-border transition-all">
          <span className="text-salone-ink-faint">🔍</span>
          <input
            type="text"
            placeholder="Search bookings, staff..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="flex-1 bg-transparent text-sm text-salone-ink placeholder-salone-ink-faint outline-none"
          />
        </div>
      </div>

      {/* Actions */}
      <div className="flex items-center gap-2 ml-6">
        <button className="w-10 h-10 rounded-lg flex items-center justify-center hover:bg-salone-surface-alt transition-colors text-salone-ink-muted hover:text-salone-ink" aria-label="Notifications">
          <Bell size={20} />
        </button>
        <button className="w-10 h-10 rounded-lg flex items-center justify-center hover:bg-salone-surface-alt transition-colors text-salone-ink-muted hover:text-salone-ink" aria-label="Settings">
          <Settings size={20} />
        </button>

        {/* Avatar */}
        <div className="w-10 h-10 bg-salone-accent rounded-lg flex items-center justify-center ml-2 cursor-pointer hover:opacity-90 transition-opacity">
          <span className="text-xs font-bold text-white">{initials}</span>
        </div>
      </div>
    </div>
  );
}
