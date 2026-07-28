import { useState } from 'react';
import { useAppStore } from '../stores/appStore';
import { ChevronDown } from 'lucide-react';

export function BranchSwitcher() {
  const [isOpen, setIsOpen] = useState(false);
  const { salons, selectedSalonId, setSelectedSalon } = useAppStore();

  const currentSalon = salons.find((s) => s.id === selectedSalonId);

  return (
    <div
      className="bg-salone-surface border-b border-salone-border px-6 py-3 flex items-center gap-3"
      style={{ boxShadow: '0 3px 16px rgba(26, 26, 26, 0.06)' }}
    >
      <span className="text-xs font-semibold uppercase text-salone-ink-muted tracking-wide">
        Salon
      </span>
      <div className="relative">
        <button
          onClick={() => setIsOpen(!isOpen)}
          className="flex items-center gap-2 px-3 py-2 bg-salone-surface-alt rounded-full text-sm font-bold text-salone-ink hover:bg-salone-border transition-colors"
        >
          <span>{currentSalon?.name || 'Select Salon'}</span>
          <ChevronDown size={16} className={`transition-transform ${isOpen ? 'rotate-180' : ''}`} />
        </button>

        {/* Dropdown */}
        {isOpen && (
          <div className="absolute top-full mt-2 left-0 bg-salone-surface border border-salone-border rounded-lg shadow-lg z-50 min-w-[240px]">
            {salons.map((salon) => (
              <button
                key={salon.id}
                onClick={() => {
                  setSelectedSalon(salon.id);
                  setIsOpen(false);
                }}
                className={`w-full text-left px-4 py-3 text-sm font-semibold transition-colors ${
                  selectedSalonId === salon.id
                    ? 'bg-salone-accent-soft text-salone-accent'
                    : 'text-salone-ink hover:bg-salone-surface-alt'
                }`}
              >
                <div className="font-bold">{salon.name}</div>
                <div className="text-xs text-salone-ink-muted mt-1">
                  ₹{salon.todayStats?.revenue || 0} • {salon.todayStats?.count || 0} bookings today
                </div>
              </button>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
