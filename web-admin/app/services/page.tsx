'use client';

import { useState } from 'react';
import { PageLayout } from '@/components/PageLayout';
import { ServiceModal } from '@/components/ServiceModal';
import { useDataStore, formatINR, categoryIcon, type Service } from '@/lib/data';
import { Plus, Search, Sparkles } from 'lucide-react';

function Chip({ label, selected, onClick }: { label: string; selected: boolean; onClick: () => void }) {
  return (
    <button
      onClick={onClick}
      className={`px-2.5 py-1.5 rounded-md text-xs font-medium whitespace-nowrap transition-colors ${
        selected ? 'bg-primary-light text-primary-dark' : 'text-gray-600 hover:bg-gray-100'
      }`}
    >
      {label}
    </button>
  );
}

export default function ServicesPage() {
  const { services, staff, addStarterServices } = useDataStore();
  const [query, setQuery] = useState('');
  const [category, setCategory] = useState<string | null>(null);
  const [showAdd, setShowAdd] = useState(false);
  const [edit, setEdit] = useState<Service | undefined>();

  const categories = [...new Set(services.map((s) => s.category))].sort();

  const filtered = services.filter((s) => {
    if (category && s.category !== category) return false;
    const q = query.trim().toLowerCase();
    return !q || s.name.toLowerCase().includes(q);
  });

  const grouped = new Map<string, Service[]>();
  for (const s of filtered) grouped.set(s.category, [...(grouped.get(s.category) ?? []), s]);
  const sortedCategories = [...grouped.keys()].sort();

  return (
    <PageLayout
      title="Services"
      subtitle="Your service catalog"
      action={
        <button onClick={() => setShowAdd(true)} className="btn-primary">
          <Plus size={13} />
          Add service
        </button>
      }
    >
      <div className="space-y-4">
        <div className="space-y-2">
          <div className="relative max-w-xs">
            <Search size={13} className="absolute left-2.5 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              className="w-full pl-8 pr-3 py-1.5 rounded-md text-xs bg-white border border-gray-200 placeholder-gray-500 focus:outline-none focus:ring-1 focus:ring-primary/40"
              placeholder="Search services"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
            />
          </div>
          <div className="flex gap-1 overflow-x-auto">
            <Chip label="All categories" selected={category === null} onClick={() => setCategory(null)} />
            {categories.map((c) => (
              <Chip key={c} label={c} selected={category === c} onClick={() => setCategory(c)} />
            ))}
          </div>
        </div>

        {filtered.length === 0 ? (
          <div className="card px-4 py-8 text-center space-y-3">
            <p className="text-xs text-gray-400">No services in the catalog yet.</p>
            {services.length === 0 && (
              <button onClick={addStarterServices} className="btn-secondary mx-auto">
                <Sparkles size={13} />
                Add a starter set of common services
              </button>
            )}
          </div>
        ) : (
          sortedCategories.map((cat) => (
            <div key={cat}>
              <p className="text-xs font-semibold text-gray-500 mb-1.5">{cat}</p>
              <div className="card divide-y divide-gray-100">
                {grouped.get(cat)!.map((s) => {
                  const assignee = s.stylistId ? staff.find((m) => m.id === s.stylistId)?.name : null;
                  return (
                    <button
                      key={s.id}
                      onClick={() => setEdit(s)}
                      className="flex items-center gap-3 w-full text-left px-3.5 py-2.5 hover:bg-gray-50 transition-colors"
                    >
                      <span className="w-8 h-8 bg-primary-light rounded-md flex items-center justify-center text-sm flex-shrink-0">
                        {categoryIcon(s.category)}
                      </span>
                      <span className="flex-1 min-w-0">
                        <span className="block text-xs font-medium text-gray-900">{s.name}</span>
                        <span className="block text-xs text-gray-400">
                          {s.duration} min{assignee ? ` · ${assignee}` : ''}
                        </span>
                      </span>
                      <span className="text-xs font-medium text-gray-900 tabular-nums">{formatINR(s.price)}</span>
                    </button>
                  );
                })}
              </div>
            </div>
          ))
        )}
      </div>

      {showAdd && <ServiceModal onClose={() => setShowAdd(false)} />}
      {edit && <ServiceModal service={edit} onClose={() => setEdit(undefined)} />}
    </PageLayout>
  );
}
