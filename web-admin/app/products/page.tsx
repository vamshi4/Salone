'use client';

import { PageLayout } from '@/components/PageLayout';
import { formatINR } from '@/components/StatusBadge';
import { Plus, MoreVertical } from 'lucide-react';

export default function ProductsPage() {
  const products = [
    {
      id: '1',
      name: 'Hair shampoo premium',
      category: 'Hair care',
      quantity: 45,
      price: 599,
      stock: 'In stock',
      status: 'Active',
    },
    {
      id: '2',
      name: 'Deep conditioner',
      category: 'Hair care',
      quantity: 12,
      price: 799,
      stock: 'Low stock',
      status: 'Active',
    },
    {
      id: '3',
      name: 'Facial cleanser',
      category: 'Skin care',
      quantity: 28,
      price: 449,
      stock: 'In stock',
      status: 'Active',
    },
    {
      id: '4',
      name: 'Body lotion',
      category: 'Body care',
      quantity: 3,
      price: 399,
      stock: 'Out of stock',
      status: 'Inactive',
    },
  ];

  const stockStyle = (stock: string) => {
    switch (stock) {
      case 'In stock':
        return { dot: 'bg-green-600', text: 'text-green-700' };
      case 'Low stock':
        return { dot: 'bg-amber-500', text: 'text-amber-700' };
      default:
        return { dot: 'bg-red-500', text: 'text-red-600' };
    }
  };

  return (
    <PageLayout
      title="Inventory"
      subtitle="Manage your salon products"
      action={
        <button className="btn-primary">
          <Plus size={13} />
          Add product
        </button>
      }
    >
      <div className="card overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="border-b border-gray-200">
              <tr>
                <th className="px-4 py-2.5 text-left text-xs font-medium text-gray-400">Product</th>
                <th className="px-4 py-2.5 text-left text-xs font-medium text-gray-400">Category</th>
                <th className="px-4 py-2.5 text-right text-xs font-medium text-gray-400">Quantity</th>
                <th className="px-4 py-2.5 text-right text-xs font-medium text-gray-400">Price</th>
                <th className="px-4 py-2.5 text-left text-xs font-medium text-gray-400">Stock</th>
                <th className="px-4 py-2.5"></th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {products.map((product) => {
                const stock = stockStyle(product.stock);
                return (
                  <tr key={product.id} className="hover:bg-gray-50 transition-colors">
                    <td className="px-4 py-2.5 text-xs font-medium text-gray-900">{product.name}</td>
                    <td className="px-4 py-2.5">
                      <span className="px-2 py-0.5 rounded text-xs bg-gray-100 text-gray-600">
                        {product.category}
                      </span>
                    </td>
                    <td className="px-4 py-2.5 text-right text-xs text-gray-600 tabular-nums">{product.quantity}</td>
                    <td className="px-4 py-2.5 text-right text-xs text-gray-900 tabular-nums">{formatINR(product.price)}</td>
                    <td className="px-4 py-2.5">
                      <span className={`inline-flex items-center gap-1.5 text-xs font-medium ${stock.text}`}>
                        <span className={`w-1.5 h-1.5 rounded-full ${stock.dot}`} />
                        {product.stock}
                      </span>
                    </td>
                    <td className="px-4 py-2.5 text-right">
                      <button className="p-1 hover:bg-gray-200 rounded transition-colors">
                        <MoreVertical size={14} className="text-gray-400" />
                      </button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>
    </PageLayout>
  );
}
