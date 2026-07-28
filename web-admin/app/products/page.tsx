'use client';

import { PageLayout } from '@/components/PageLayout';
import { Plus, MoreVertical, AlertCircle } from 'lucide-react';

export default function ProductsPage() {
  const products = [
    {
      id: '1',
      name: 'Hair Shampoo Premium',
      category: 'Hair Care',
      quantity: 45,
      price: 599,
      stock: 'In Stock',
      status: 'Active',
    },
    {
      id: '2',
      name: 'Deep Conditioner',
      category: 'Hair Care',
      quantity: 12,
      price: 799,
      stock: 'Low Stock',
      status: 'Active',
    },
    {
      id: '3',
      name: 'Facial Cleanser',
      category: 'Skin Care',
      quantity: 28,
      price: 449,
      stock: 'In Stock',
      status: 'Active',
    },
    {
      id: '4',
      name: 'Body Lotion',
      category: 'Body Care',
      quantity: 3,
      price: 399,
      stock: 'Out of Stock',
      status: 'Inactive',
    },
  ];

  const getStockColor = (stock: string) => {
    switch (stock) {
      case 'In Stock':
        return 'bg-green-100 text-green-700';
      case 'Low Stock':
        return 'bg-yellow-100 text-yellow-700';
      case 'Out of Stock':
        return 'bg-red-100 text-red-700';
      default:
        return 'bg-gray-100 text-gray-700';
    }
  };

  return (
    <PageLayout
      title="Inventory"
      subtitle="Manage your salon products"
      action={
        <button className="btn-primary flex items-center gap-2">
          <Plus size={18} />
          Add Product
        </button>
      }
    >
      <div className="card p-0 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Product</th>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Category</th>
                <th className="px-6 py-3 text-right text-xs font-semibold text-gray-700 uppercase tracking-wider">Quantity</th>
                <th className="px-6 py-3 text-right text-xs font-semibold text-gray-700 uppercase tracking-wider">Price</th>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Stock Status</th>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Status</th>
                <th className="px-6 py-3 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider">Action</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {products.map((product) => (
                <tr key={product.id} className="hover:bg-gray-50 transition-colors">
                  <td className="px-6 py-4 text-sm font-medium text-gray-900">{product.name}</td>
                  <td className="px-6 py-4">
                    <span className="px-3 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-700">
                      {product.category}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-right text-sm text-gray-700">{product.quantity}</td>
                  <td className="px-6 py-4 text-right text-sm font-semibold text-primary">Rs {product.price}</td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-2">
                      {product.stock === 'Low Stock' && <AlertCircle size={14} className="text-yellow-600" />}
                      <span className={`px-3 py-1 rounded-full text-xs font-semibold ${getStockColor(product.stock)}`}>
                        {product.stock}
                      </span>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <span className={`px-3 py-1 rounded-full text-xs font-semibold ${
                      product.status === 'Active'
                        ? 'bg-green-100 text-green-700'
                        : 'bg-gray-100 text-gray-700'
                    }`}>
                      {product.status}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-center">
                    <button className="p-1 hover:bg-gray-200 rounded transition-colors">
                      <MoreVertical size={16} className="text-gray-600" />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </PageLayout>
  );
}
