import { Card } from '../components/Card';
import { useAppStore } from '../stores/appStore';
import { useGetProducts } from '../api/queries';
import { useState } from 'react';

export function Inventory() {
  const { selectedSalonId } = useAppStore();
  const [searchQuery, setSearchQuery] = useState('');
  const { data: products, isLoading } = useGetProducts(selectedSalonId || '');

  const filteredProducts = products?.filter((p) =>
    p.name.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const lowStockProducts = filteredProducts?.filter((p) => p.stockQty < 10) || [];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-extrabold text-salone-ink mb-1">Inventory</h1>
        <p className="text-sm font-semibold text-salone-ink-muted">Manage your products and stock</p>
      </div>

      {/* Low Stock Alert */}
      {lowStockProducts.length > 0 && (
        <div className="bg-salone-amber-soft border-l-4 border-salone-amber p-4 rounded-lg">
          <p className="font-semibold text-salone-amber">⚠️ {lowStockProducts.length} products low on stock</p>
        </div>
      )}

      {/* Filters */}
      <div className="flex gap-3">
        <div className="flex-1 max-w-md">
          <input
            type="text"
            placeholder="Search products..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full px-4 py-2 bg-salone-surface-alt border border-salone-border rounded-full text-sm font-semibold text-salone-ink"
          />
        </div>
        <button className="px-5 py-2 bg-salone-accent text-white text-sm font-bold rounded-full hover:opacity-90 transition-opacity">
          + Add Product
        </button>
      </div>

      {/* Products List */}
      <Card title="All Products">
        {isLoading ? (
          <div className="text-center py-8 text-salone-ink-muted">Loading products...</div>
        ) : !filteredProducts || filteredProducts.length === 0 ? (
          <div className="text-center py-8 text-salone-ink-muted">No products found</div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="bg-salone-surface-alt">
                  <th className="px-4 py-3 text-left text-xs font-semibold uppercase text-salone-ink-muted tracking-wide">
                    Product
                  </th>
                  <th className="px-4 py-3 text-left text-xs font-semibold uppercase text-salone-ink-muted tracking-wide">
                    Category
                  </th>
                  <th className="px-4 py-3 text-left text-xs font-semibold uppercase text-salone-ink-muted tracking-wide">
                    Stock
                  </th>
                  <th className="px-4 py-3 text-left text-xs font-semibold uppercase text-salone-ink-muted tracking-wide">
                    Cost
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-salone-border">
                {filteredProducts.map((product) => (
                  <tr key={product.id} className="hover:bg-salone-surface-alt transition-colors">
                    <td className="px-4 py-3 text-sm font-semibold text-salone-ink">
                      {product.name}
                    </td>
                    <td className="px-4 py-3 text-sm font-semibold text-salone-ink">
                      {product.category}
                    </td>
                    <td className="px-4 py-3">
                      <div
                        className={`text-sm font-semibold inline-block px-2 py-1 rounded ${
                          product.stockQty < 10
                            ? 'bg-salone-danger-soft text-salone-danger'
                            : 'bg-salone-success-soft text-salone-success'
                        }`}
                      >
                        {product.stockQty} {product.unit}
                      </div>
                    </td>
                    <td className="px-4 py-3 text-sm font-semibold text-salone-ink">
                      ₹{product.costPrice}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </Card>
    </div>
  );
}
