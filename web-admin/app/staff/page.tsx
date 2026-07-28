'use client';

import { PageLayout } from '@/components/PageLayout';
import { Plus, MoreVertical, Phone, Mail, Star } from 'lucide-react';

export default function StaffPage() {
  const staff = [
    {
      id: '1',
      name: 'Kabir M.',
      role: 'Senior stylist',
      email: 'kabir@salone.com',
      phone: '9876543210',
      rating: 4.8,
      reviewCount: 142,
      status: 'Active',
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
    },
    {
      id: '3',
      name: 'Sana R.',
      role: 'Makeup artist',
      email: 'sana@salone.com',
      phone: '9876543212',
      rating: 4.9,
      reviewCount: 167,
      status: 'Active',
    },
  ];

  return (
    <PageLayout
      title="Staff"
      subtitle="Manage your team members"
      action={
        <button className="btn-primary">
          <Plus size={13} />
          Add staff
        </button>
      }
    >
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
        {staff.map((member) => (
          <div key={member.id} className="card p-4">
            <div className="flex items-start justify-between mb-3">
              <div className="flex items-center gap-2.5">
                <div className="w-9 h-9 bg-primary-light rounded-full flex items-center justify-center text-primary-dark font-medium text-sm">
                  {member.name.charAt(0)}
                </div>
                <div>
                  <h3 className="text-sm font-medium text-gray-900">{member.name}</h3>
                  <p className="text-xs text-gray-400">{member.role}</p>
                </div>
              </div>
              <button className="p-1 hover:bg-gray-100 rounded transition-colors">
                <MoreVertical size={14} className="text-gray-400" />
              </button>
            </div>

            <div className="space-y-1.5 mb-3 pb-3 border-b border-gray-100">
              <div className="flex items-center gap-2 text-xs text-gray-600">
                <Phone size={12} className="text-gray-400" />
                {member.phone}
              </div>
              <div className="flex items-center gap-2 text-xs text-gray-600">
                <Mail size={12} className="text-gray-400" />
                {member.email}
              </div>
            </div>

            <div className="flex items-center justify-between">
              <div className="flex items-center gap-1 text-xs">
                <Star size={13} className="text-amber-500 fill-amber-500" />
                <span className="font-medium text-gray-900 tabular-nums">{member.rating}</span>
                <span className="text-gray-400">({member.reviewCount})</span>
              </div>
              <span className="inline-flex items-center gap-1.5 text-xs font-medium text-green-700">
                <span className="w-1.5 h-1.5 rounded-full bg-green-600" />
                {member.status}
              </span>
            </div>
          </div>
        ))}
      </div>
    </PageLayout>
  );
}
