'use client';

import { PageLayout } from '@/components/PageLayout';
import { Plus, MoreVertical, Phone, Mail, Star } from 'lucide-react';

export default function StaffPage() {
  const staff = [
    {
      id: '1',
      name: 'Kabir M.',
      role: 'Senior Stylist',
      email: 'kabir@salone.com',
      phone: '9876543210',
      rating: 4.8,
      reviewCount: 142,
      status: 'Active',
      joinDate: '2024-01-15',
    },
    {
      id: '2',
      name: 'Arjun Verma',
      role: 'Therapist',
      email: 'arjun@salone.com',
      phone: '9876543211',
      rating: 4.6,
      reviewCount: 98,
      status: 'Active',
      joinDate: '2024-02-20',
    },
    {
      id: '3',
      name: 'Sana R.',
      role: 'Makeup Artist',
      email: 'sana@salone.com',
      phone: '9876543212',
      rating: 4.9,
      reviewCount: 167,
      status: 'Active',
      joinDate: '2024-03-10',
    },
  ];

  return (
    <PageLayout
      title="Staff"
      subtitle="Manage your team members"
      action={
        <button className="btn-primary flex items-center gap-2">
          <Plus size={18} />
          Add Staff
        </button>
      }
    >
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {staff.map((member) => (
          <div key={member.id} className="card p-6 hover:shadow-lg transition-all">
            <div className="flex items-start justify-between mb-4">
              <div className="w-12 h-12 bg-gradient-to-br from-primary to-primary-dark rounded-full flex items-center justify-center text-white font-bold">
                {member.name.charAt(0)}
              </div>
              <button className="p-1 hover:bg-gray-100 rounded transition-colors">
                <MoreVertical size={16} className="text-gray-600" />
              </button>
            </div>

            <h3 className="text-lg font-bold text-gray-900">{member.name}</h3>
            <p className="text-sm text-primary font-medium mb-3">{member.role}</p>

            <div className="space-y-2 mb-4 pb-4 border-b border-gray-200">
              <div className="flex items-center gap-2 text-sm text-gray-600">
                <Phone size={14} className="text-gray-500" />
                {member.phone}
              </div>
              <div className="flex items-center gap-2 text-sm text-gray-600">
                <Mail size={14} className="text-gray-500" />
                {member.email}
              </div>
            </div>

            <div className="flex items-center justify-between">
              <div className="flex items-center gap-1">
                <Star size={16} className="text-yellow-500 fill-yellow-500" />
                <span className="font-semibold text-gray-900">{member.rating}</span>
                <span className="text-xs text-gray-600">({member.reviewCount})</span>
              </div>
              <span className="px-3 py-1 rounded-full text-xs font-semibold bg-green-100 text-green-700">
                {member.status}
              </span>
            </div>
          </div>
        ))}
      </div>
    </PageLayout>
  );
}
