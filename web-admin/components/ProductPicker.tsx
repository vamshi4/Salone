import { Minus, Plus } from 'lucide-react';
import { formatINR, type Product, type ProductSaleItem } from '@/lib/salon-api';

export function productsTotal(products: Product[], selected: Map<string, number>): number {
  let total = 0;
  for (const [id, qty] of selected) {
    const p = products.find((x) => x.id === id);
    if (p) total += p.retailPrice * qty;
  }
  return total;
}

export function toProductSaleItems(selected: Map<string, number>): ProductSaleItem[] {
  return [...selected.entries()]
    .filter(([, qty]) => qty > 0)
    .map(([productId, quantity]) => ({ productId, quantity }));
}

/** Optional add-on retail sale, picked alongside completing a booking.
 * Only in-stock products are selectable; the stepper is capped at the
 * current stockQty so the completion request can't oversell. */
export function ProductPicker({
  products,
  selected,
  onChange,
}: {
  products: Product[];
  selected: Map<string, number>;
  onChange: (next: Map<string, number>) => void;
}) {
  const inStock = products.filter((p) => p.stockQty > 0);
  if (inStock.length === 0) return null;

  const setQty = (id: string, qty: number, max: number) => {
    const next = new Map(selected);
    if (qty <= 0) next.delete(id);
    else next.set(id, Math.min(qty, max));
    onChange(next);
  };

  return (
    <div className="space-y-1">
      {inStock.map((p) => {
        const qty = selected.get(p.id) ?? 0;
        return (
          <div
            key={p.id}
            className="flex items-center justify-between px-2.5 py-1.5 rounded-md border border-gray-200 text-xs"
          >
            <div className="min-w-0">
              <span className="font-medium text-gray-900">{p.name}</span>
              <span className="text-gray-400 ml-1.5">{formatINR(p.retailPrice)}</span>
            </div>
            <div className="flex items-center gap-2 flex-shrink-0">
              <button
                type="button"
                onClick={() => setQty(p.id, qty - 1, p.stockQty)}
                disabled={qty === 0}
                className="p-1 rounded hover:bg-gray-100 disabled:opacity-30"
              >
                <Minus size={12} />
              </button>
              <span className="w-4 text-center tabular-nums">{qty}</span>
              <button
                type="button"
                onClick={() => setQty(p.id, qty + 1, p.stockQty)}
                disabled={qty >= p.stockQty}
                className="p-1 rounded hover:bg-gray-100 disabled:opacity-30"
              >
                <Plus size={12} />
              </button>
            </div>
          </div>
        );
      })}
    </div>
  );
}
