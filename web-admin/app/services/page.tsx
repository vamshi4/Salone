'use client';

import { PageLayout } from '@/components/PageLayout';
import { Plus, MoreVertical, Clock, IndianRupee } from 'lucide-react';

export default function ServicesPage() {
  const services = [
    {
      id: '1',
      name: 'Haircut & Style',
      category: 'Hair',
      duration: '45 min',
      price: 399,
      status: 'Active',
      description: 'Professional haircut with styling',
    },
    {
      id: '2',
      name: 'Full Body Spa',
      category: 'Spa',
      duration: '90 min',
      price: 2999,
      status: 'Active',
      description: 'Complete relaxation with aromatherapy',
    },
    {
      id: '3',
      name: 'Beard Trim',
      category: 'Men',
      duration: '20 min',
      price: 199,
      status: 'Active',
      description: 'Professional beard grooming',
    },
    {
      id: '4',
      name: 'Facial Treatment',
      category: 'Skin Care',
      duration: '60 min',
      price: 1299,
      status: 'Active',
      description: 'Deep cleansing and rejuvenation',
    },
  ];

  return (
    <PageLayout
      title="Services"
      subtitle="Manage your salon services"
      action={
        <button className="btn-primary flex items-center gap-2">
          <Plus size={18} />
          Add Service
        </button>
      }
    >
      <div className="card p-0 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Service</th>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Category</th>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Duration</th>
                <th className="px-6 py-3 text-right text-xs font-semibold text-gray-700 uppercase tracking-wider">Price</th>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Status</th>
                <th className="px-6 py-3 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider">Action</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {services.map((service) => (
                <tr key={service.id} className="hover:bg-gray-50 transition-colors">
                  <td className="px-6 py-4">
                    <div className="text-sm font-medium text-gray-900">{service.name}</div>
                    <div className="text-xs text-gray-600">{service.description}</div>
                  </td>
                  <td className="px-6 py-4">
                    <span className="px-3 py-1 rounded-full text-xs font-medium bg-primary/10 text-primary">
                      {service.category}
                    </span>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-1 text-sm text-gray-700">
                      <Clock size={14} className="text-gray-500" />
                      {service.duration}
                    </div>
                  </td>
                  <td className="px-6 py-4 text-right">
                    <div className="flex items-center justify-end gap-1 text-sm font-semibold text-primary">
                      <IndianRupee size={14} />
                      {service.price}
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <span className="px-3 py-1 rounded-full text-xs font-semibold bg-green-100 text-green-700">
                      {service.status}
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
