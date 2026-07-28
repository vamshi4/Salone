'use client';

import { PageLayout } from '@/components/PageLayout';
import { formatINR } from '@/components/StatusBadge';
import { Plus, MoreVertical, Clock } from 'lucide-react';

export default function ServicesPage() {
  const services = [
    {
      id: '1',
      name: 'Haircut & style',
      category: 'Hair',
      duration: '45 min',
      price: 399,
      status: 'Active',
      description: 'Professional haircut with styling',
    },
    {
      id: '2',
      name: 'Full body spa',
      category: 'Spa',
      duration: '90 min',
      price: 2999,
      status: 'Active',
      description: 'Complete relaxation with aromatherapy',
    },
    {
      id: '3',
      name: 'Beard trim',
      category: 'Men',
      duration: '20 min',
      price: 199,
      status: 'Active',
      description: 'Professional beard grooming',
    },
    {
      id: '4',
      name: 'Facial treatment',
      category: 'Skin care',
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
        <button className="btn-primary">
          <Plus size={13} />
          Add service
        </button>
      }
    >
      <div className="card overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="border-b border-gray-200">
              <tr>
                <th className="px-4 py-2.5 text-left text-xs font-medium text-gray-400">Service</th>
                <th className="px-4 py-2.5 text-left text-xs font-medium text-gray-400">Category</th>
                <th className="px-4 py-2.5 text-left text-xs font-medium text-gray-400">Duration</th>
                <th className="px-4 py-2.5 text-right text-xs font-medium text-gray-400">Price</th>
                <th className="px-4 py-2.5 text-left text-xs font-medium text-gray-400">Status</th>
                <th className="px-4 py-2.5"></th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {services.map((service) => (
                <tr key={service.id} className="hover:bg-gray-50 transition-colors">
                  <td className="px-4 py-2.5">
                    <div className="text-xs font-medium text-gray-900">{service.name}</div>
                    <div className="text-xs text-gray-400">{service.description}</div>
                  </td>
                  <td className="px-4 py-2.5">
                    <span className="px-2 py-0.5 rounded text-xs bg-gray-100 text-gray-600">
                      {service.category}
                    </span>
                  </td>
                  <td className="px-4 py-2.5">
                    <div className="flex items-center gap-1 text-xs text-gray-600">
                      <Clock size={12} className="text-gray-400" />
                      {service.duration}
                    </div>
                  </td>
                  <td className="px-4 py-2.5 text-right text-xs text-gray-900 tabular-nums">
                    {formatINR(service.price)}
                  </td>
                  <td className="px-4 py-2.5">
                    <span className="inline-flex items-center gap-1.5 text-xs font-medium text-green-700">
                      <span className="w-1.5 h-1.5 rounded-full bg-green-600" />
                      {service.status}
                    </span>
                  </td>
                  <td className="px-4 py-2.5 text-right">
                    <button className="p-1 hover:bg-gray-200 rounded transition-colors">
                      <MoreVertical size={14} className="text-gray-400" />
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
