'use client';

import { PageLayout } from '@/components/PageLayout';
import { StatusBadge, formatINR } from '@/components/StatusBadge';
import { Search, Plus, MoreVertical } from 'lucide-react';
import { useState } from 'react';

export default function BookingsPage() {
  const [selectedStatus, setSelectedStatus] = useState('ALL');

  const bookings = [
    {
      id: '1',
      serviceName: 'Haircut & style',
      stylistName: 'Kabir M.',
      customerName: 'Priya Sharma',
      time: '3:00 pm',
      amount: 399,
      status: 'PENDING',
      customerPhone: '9876543210',
    },
    {
      id: '2',
      serviceName: 'Full body spa',
      stylistName: 'Arjun Verma',
      customerName: 'Neha T.',
      time: '6:00 pm',
      amount: 2999,
      status: 'CONFIRMED',
      customerPhone: '9876543211',
    },
    {
      id: '3',
      serviceName: 'Beard trim',
      stylistName: 'Sana R.',
      customerName: 'Priya Sharma',
      time: '11:30 am',
      amount: 199,
      status: 'COMPLETED',
      customerPhone: '9876543212',
    },
    {
      id: '4',
      serviceName: 'Facial treatment',
      stylistName: 'Arjun Verma',
      customerName: 'Anjali K.',
      time: '2:00 pm',
      amount: 1299,
      status: 'CANCELLED',
      customerPhone: '9876543213',
    },
  ];

  const statusOptions = [
    { label: 'All', value: 'ALL' },
    { label: 'Pending', value: 'PENDING' },
    { label: 'Confirmed', value: 'CONFIRMED' },
    { label: 'Completed', value: 'COMPLETED' },
    { label: 'Cancelled', value: 'CANCELLED' },
  ];

  const filteredBookings =
    selectedStatus === 'ALL'
      ? bookings
      : bookings.filter((b) => b.status === selectedStatus);

  return (
    <PageLayout
      title="Bookings"
      subtitle="Manage all your salon appointments"
      action={
        <button className="btn-primary">
          <Plus size={13} />
          New booking
        </button>
      }
    >
      <div className="space-y-3">
        {/* Search and filters */}
        <div className="flex items-center gap-2">
          <div className="flex-1 max-w-xs">
            <div className="relative">
              <Search size={13} className="absolute left-2.5 top-1/2 -translate-y-1/2 text-gray-400" />
              <input
                type="text"
                placeholder="Search bookings"
                className="w-full pl-8 pr-3 py-1.5 rounded-md text-xs bg-white border border-gray-200 placeholder-gray-500 focus:outline-none focus:ring-1 focus:ring-primary/40 transition-colors"
              />
            </div>
          </div>
          <div className="flex gap-1">
            {statusOptions.map((option) => (
              <button
                key={option.value}
                onClick={() => setSelectedStatus(option.value)}
                className={`px-2.5 py-1.5 rounded-md text-xs font-medium transition-colors ${
                  selectedStatus === option.value
                    ? 'bg-primary-light text-primary-dark'
                    : 'text-gray-600 hover:bg-gray-100'
                }`}
              >
                {option.label}
              </button>
            ))}
          </div>
        </div>

        {/* Bookings table */}
        <div className="card overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="border-b border-gray-200">
                <tr>
                  <th className="px-4 py-2.5 text-left text-xs font-medium text-gray-400">Service</th>
                  <th className="px-4 py-2.5 text-left text-xs font-medium text-gray-400">Customer</th>
                  <th className="px-4 py-2.5 text-left text-xs font-medium text-gray-400">Stylist</th>
                  <th className="px-4 py-2.5 text-left text-xs font-medium text-gray-400">Time</th>
                  <th className="px-4 py-2.5 text-right text-xs font-medium text-gray-400">Amount</th>
                  <th className="px-4 py-2.5 text-left text-xs font-medium text-gray-400">Status</th>
                  <th className="px-4 py-2.5"></th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {filteredBookings.map((booking) => (
                  <tr key={booking.id} className="hover:bg-gray-50 transition-colors">
                    <td className="px-4 py-2.5 text-xs font-medium text-gray-900">{booking.serviceName}</td>
                    <td className="px-4 py-2.5">
                      <div className="text-xs text-gray-900">{booking.customerName}</div>
                      <div className="text-xs text-gray-400">{booking.customerPhone}</div>
                    </td>
                    <td className="px-4 py-2.5 text-xs text-gray-600">{booking.stylistName}</td>
                    <td className="px-4 py-2.5 text-xs text-gray-600">{booking.time}</td>
                    <td className="px-4 py-2.5 text-right text-xs text-gray-900 tabular-nums">{formatINR(booking.amount)}</td>
                    <td className="px-4 py-2.5">
                      <StatusBadge status={booking.status} />
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
      </div>
    </PageLayout>
  );
}
