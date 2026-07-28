import { ChevronDown } from 'lucide-react';
import { useAppStore } from '../stores/appStore';
import { useState } from 'react';

export default function BranchSwitcher() {
  const salons = useAppStore((state) => state.salons);
  const selectedSalonId = useAppStore((state) => state.selectedSalonId);
  const setSelectedSalon = useAppStore((state) => state.setSelectedSalon);
  const [open, setOpen] = useState(false);

  const selectedSalon = salons.find((s) => s.id === selectedSalonId);

  return (
    <div className="relative">
      <button
        onClick={() => setOpen(!open)}
        className="flex items-center gap-2 px-4 py-2 rounded-lg bg-surface-alt hover:bg-gray-200 transition-colors"
      >
        <span className="font-medium text-text-primary">{selectedSalon?.name}</span>
        <ChevronDown size={16} className={`transition-transform ${open ? 'rotate-180' : ''}`} />
      </button>

      {open && (
        <div className="absolute top-full mt-2 w-48 bg-white rounded-lg shadow-sm border border-gray-100 z-50">
          {salons.map((salon) => (
            <button
              key={salon.id}
              onClick={() => {
                setSelectedSalon(salon.id);
                setOpen(false);
              }}
              className={`block w-full text-left px-4 py-2.5 hover:bg-surface-alt transition-colors first:rounded-t-lg last:rounded-b-lg ${
                salon.id === selectedSalonId ? 'bg-accent/10 text-accent font-medium' : 'text-text-primary'
              }`}
            >
              {salon.name}
            </button>
          ))}
        </div>
      )}
    </div>
  );
}
