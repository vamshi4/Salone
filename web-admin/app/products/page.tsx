'use client';

import { useState, Suspense } from 'react';
import { useSearchParams } from 'next/navigation';
import { PageLayout } from '@/components/PageLayout';
import { ProductModal } from '@/components/ProductModal';
import { useDataStore, formatINR, type Product } from '@/lib/data';
import { Plus, Search, Package } from 'lucide-react';

function Chip({ label, selected, onClick }: { label: string; selected: boolean; onClick: () => void }) {
  return (
    <button
      onClick={onClick}
      className={selected ? 'chip-on' : 'chip-off'}
    >
      {label}
    </button>
  );
}

function ProductsContent() {
  const searchParams = useSearchParams();
  const { products } = useDataStore();
  const [query, setQuery] = useState('');
  const [category, setCategory] = useState<string | null>(null);
  const [lowOnly, setLowOnly] = useState(searchParams.get('low') === '1');
  const [showAdd, setShowAdd] = useState(false);
  const [edit, setEdit] = useState<Product | undefined>();

  const categories = [...new Set(products.map((p) => p.category))].sort();
  const isLow = (p: Product) => p.stockQty <= p.lowStockThreshold;

  const filtered = products.filter((p) => {
    if (lowOnly && !isLow(p)) return false;
    if (category && p.category !== category) return false;
    const q = query.trim().toLowerCase();
    return !q || p.name.toLowerCase().includes(q);
  });

  const grouped = new Map<string, Product[]>();
  for (const p of filtered) grouped.set(p.category, [...(grouped.get(p.category) ?? []), p]);
  const sortedCategories = [...grouped.keys()].sort();

  return (
    <PageLayout
      title="Inventory"
      subtitle="Retail products and stock"
      action={
        <button onClick={() => setShowAdd(true)} className="btn-primary">
          <Plus size={13} />
          Add product
        </button>
      }
    >
      <div className="space-y-4">
        <div className="space-y-2">
          <div className="relative max-w-xs">
            <Search size={13} className="absolute left-2.5 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              className="w-full pl-8 pr-3 py-1.5 rounded-md text-xs bg-white border border-gray-200 placeholder-gray-500 focus:outline-none focus:ring-1 focus:ring-primary/40"
              placeholder="Search products"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
            />
          </div>
          <div className="flex gap-1 overflow-x-auto">
            <Chip
              label="All"
              selected={!lowOnly && category === null}
              onClick={() => {
                setLowOnly(false);
                setCategory(null);
              }}
            />
            <Chip label="Low stock" selected={lowOnly} onClick={() => setLowOnly(!lowOnly)} />
            {categories.map((c) => (
              <Chip
                key={c}
                label={c}
                selected={!lowOnly && category === c}
                onClick={() => {
                  setLowOnly(false);
                  setCategory(c);
                }}
              />
            ))}
          </div>
        </div>

        {filtered.length === 0 ? (
          <div className="card px-4 py-6 text-center">
            <p className="text-xs text-gray-400">
              {lowOnly ? 'No products are low on stock. Nice.' : 'No products in the catalog yet.'}
            </p>
          </div>
        ) : (
          sortedCategories.map((cat) => (
            <div key={cat}>
              <p className="text-xs font-semibold text-gray-500 mb-1.5">{cat}</p>
              <div className="space-y-2">
                {grouped.get(cat)!.map((p) => {
                  const low = isLow(p);
                  return (
                    <button
                      key={p.id}
                      onClick={() => setEdit(p)}
                      className={`flex items-center gap-3 w-full text-left px-3.5 py-2.5 bg-white border rounded-lg hover:bg-gray-50 transition-colors ${
                        low ? 'border-red-200' : 'border-gray-200'
                      }`}
                    >
                      <span className="w-8 h-8 bg-primary-light rounded-md flex items-center justify-center flex-shrink-0">
                        <Package size={15} className="text-primary-dark" />
                      </span>
                      <span className="flex-1 min-w-0">
                        <span className="block text-xs font-medium text-gray-900">{p.name}</span>
                        <span className="text-xs text-gray-400">
                          {p.stockQty} in stock
                          {low && (
                            <span className="ml-1.5 px-1.5 py-px rounded bg-red-50 text-red-600 font-medium">
                              low stock
                            </span>
                          )}
                        </span>
                      </span>
                      <span className="text-xs font-medium text-gray-900 tabular-nums">
                        {formatINR(p.retailPrice)}
                      </span>
                    </button>
                  );
                })}
              </div>
            </div>
          ))
        )}
      </div>

      {showAdd && <ProductModal onClose={() => setShowAdd(false)} />}
      {edit && <ProductModal product={edit} onClose={() => setEdit(undefined)} />}
    </PageLayout>
  );
}

export default function ProductsPage() {
  return (
    <Suspense>
      <ProductsContent />
    </Suspense>
  );
}
