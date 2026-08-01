'use client';

import { useState } from 'react';
import { useTranslations } from 'next-intl';
import { PageLayout } from '@/components/PageLayout';
import { ServiceModal } from '@/components/ServiceModal';
import { formatCurrency, categoryIcon, type Service } from '@/lib/salon-api';
import { useAddStarterServices, useCurrentSalon, useSelectedSalonId } from '@/lib/salon-queries';
import { Plus, Search, Sparkles } from 'lucide-react';

function Chip({ label, selected, onClick }: { label: string; selected: boolean; onClick: () => void }) {
  return (
    <button onClick={onClick} className={selected ? 'chip-on' : 'chip-off'}>
      {label}
    </button>
  );
}

export default function ServicesPage() {
  const t = useTranslations('services');
  const salonId = useSelectedSalonId();
  const salon = useCurrentSalon();
  const addStarter = useAddStarterServices(salonId ?? '');

  const services = salon?.services ?? [];
  const staff = salon?.staff ?? [];

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

  if (!salonId) {
    return (
      <PageLayout title={t('title')} subtitle={t('subtitle')}>
        <div className="card px-4 py-6 text-center">
          <p className="text-xs text-gray-400">{t('noSalonYet')}</p>
        </div>
      </PageLayout>
    );
  }

  return (
    <PageLayout
      title={t('title')}
      subtitle={t('subtitle')}
      action={
        <button onClick={() => setShowAdd(true)} className="btn-primary">
          <Plus size={13} />
          {t('addService')}
        </button>
      }
    >
      <div className="space-y-4">
        <div className="space-y-2">
          <div className="relative max-w-xs">
            <Search size={13} className="absolute left-2.5 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              className="w-full pl-8 pr-3 py-1.5 rounded-md text-xs bg-white border border-gray-200 placeholder-gray-500 focus:outline-none focus:ring-1 focus:ring-primary/40"
              placeholder={t('searchPlaceholder')}
              value={query}
              onChange={(e) => setQuery(e.target.value)}
            />
          </div>
          <div className="flex gap-1 overflow-x-auto">
            <Chip label={t('allCategories')} selected={category === null} onClick={() => setCategory(null)} />
            {categories.map((c) => (
              <Chip key={c} label={c} selected={category === c} onClick={() => setCategory(c)} />
            ))}
          </div>
        </div>

        {filtered.length === 0 ? (
          <div className="card px-4 py-8 text-center space-y-3">
            <p className="text-xs text-gray-400">{t('noCatalogYet')}</p>
            {services.length === 0 && (
              <button onClick={() => addStarter.mutate()} disabled={addStarter.isPending} className="btn-secondary mx-auto disabled:opacity-60">
                <Sparkles size={13} />
                {addStarter.isPending ? t('adding') : t('addStarterSet')}
              </button>
            )}
          </div>
        ) : (
          sortedCategories.map((cat) => (
            <div key={cat}>
              <p className="text-xs font-semibold text-gray-500 mb-1.5">{cat}</p>
              <div className="card divide-y divide-gray-100">
                {grouped.get(cat)!.map((s) => {
                  const assignee = s.stylistId ? staff.find((m) => m.stylistId === s.stylistId)?.name : null;
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
                          {t('minutes', { count: s.duration })}{assignee ? ` · ${assignee}` : ''}
                        </span>
                      </span>
                      <span className="text-xs font-medium text-gray-900 tabular-nums">{formatCurrency(s.price, salon?.currency)}</span>
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
