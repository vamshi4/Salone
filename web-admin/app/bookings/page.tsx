'use client';

import { PageLayout } from '@/components/PageLayout';
import { Search, Plus, MoreVertical, CheckCircle2, Clock, X } from 'lucide-react';
import { useState } from 'react';

export default function BookingsPage() {
  const [selectedStatus, setSelectedStatus] = useState('ALL');

  const bookings = [
    {
      id: '1',
      serviceName: 'Haircut & Style',
      stylistName: 'Kabir M.',
      customerName: 'Priya Sharma',
      time: '3:00 PM',
      amount: 399,
      status: 'PENDING',
      customerPhone: '9876543210',
    },
    {
      id: '2',
      serviceName: 'Full body spa',
      stylistName: 'Arjun Verma',
      customerName: 'Neha T.',
      time: '6:00 PM',
      amount: 2999,
      status: 'CONFIRMED',
      customerPhone: '9876543211',
    },
    {
      id: '3',
      serviceName: 'Beard trim',
      stylistName: 'Sana R.',
      customerName: 'Priya Sharma',
      time: '11:30 AM',
      amount: 199,
      status: 'COMPLETED',
      customerPhone: '9876543212',
    },
    {
      id: '4',
      serviceName: 'Facial treatment',
      stylistName: 'Arjun Verma',
      customerName: 'Anjali K.',
      time: '2:00 PM',
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

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'CONFIRMED':
        return <CheckCircle2 size={16} className="text-green-600" />;
      case 'PENDING':
        return <Clock size={16} className="text-yellow-600" />;
      case 'CANCELLED':
        return <X size={16} className="text-red-600" />;
      default:
        return null;
    }
  };

  return (
    <PageLayout
      title="Bookings"
      subtitle="Manage all your salon appointments"
      action={
        <button className="btn-primary flex items-center gap-2">
          <Plus size={18} />
          New Booking
        </button>
      }
    >
      <div className="space-y-4">
        {/* Search and Filters */}
        <div className="flex items-center gap-3">
          <div className="flex-1 max-w-md">
            <div className="relative">
              <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
              <input
                type="text"
                placeholder="Search bookings..."
                className="w-full pl-9 pr-3 py-2 rounded-lg text-sm bg-white border border-gray-200 placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-primary/40 transition-all"
              />
            </div>
          </div>
          <div className="flex gap-2">
            {statusOptions.map((option) => (
              <button
                key={option.value}
                onClick={() => setSelectedStatus(option.value)}
                className={`px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                  selectedStatus === option.value
                    ? 'bg-primary text-white shadow-md'
                    : 'bg-white text-gray-700 border border-gray-200 hover:border-primary'
                }`}
              >
                {option.label}
              </button>
            ))}
          </div>
        </div>

        {/* Bookings List */}
        <div className="card p-0 overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Service</th>
                  <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Customer</th>
                  <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Stylist</th>
                  <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Time</th>
                  <th className="px-6 py-3 text-right text-xs font-semibold text-gray-700 uppercase tracking-wider">Amount</th>
                  <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Status</th>
                  <th className="px-6 py-3 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider">Action</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200">
                {filteredBookings.map((booking) => (
                  <tr key={booking.id} className="hover:bg-gray-50 transition-colors">
                    <td className="px-6 py-4 text-sm font-medium text-gray-900">{booking.serviceName}</td>
                    <td className="px-6 py-4">
                      <div className="text-sm text-gray-900">{booking.customerName}</div>
                      <div className="text-xs text-gray-500">{booking.customerPhone}</div>
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-700">{booking.stylistName}</td>
                    <td className="px-6 py-4 text-sm text-gray-700">{booking.time}</td>
                    <td className="px-6 py-4 text-right text-sm font-semibold text-primary">Rs {booking.amount}</td>
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-2">
                        {getStatusIcon(booking.status)}
                        <span className={`text-xs font-semibold uppercase tracking-wider ${
                          booking.status === 'PENDING' ? 'text-yellow-700' :
                          booking.status === 'CONFIRMED' ? 'text-green-700' :
                          booking.status === 'COMPLETED' ? 'text-blue-700' :
                          'text-red-700'
                        }`}>
                          {booking.status}
                        </span>
                      </div>
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
      </div>
    </PageLayout>
  );
}
