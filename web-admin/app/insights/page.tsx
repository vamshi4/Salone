'use client';

import { PageLayout } from '@/components/PageLayout';
import { TrendingUp, Users, DollarSign, Calendar } from 'lucide-react';

export default function InsightsPage() {
  const metrics = [
    {
      label: 'Total Revenue',
      value: 'Rs 45,230',
      change: '+12.5%',
      trend: 'up',
      icon: DollarSign,
    },
    {
      label: 'Total Bookings',
      value: '284',
      change: '+8.2%',
      trend: 'up',
      icon: Calendar,
    },
    {
      label: 'Customer Growth',
      value: '+45',
      change: '+5.3%',
      trend: 'up',
      icon: Users,
    },
    {
      label: 'Avg Rating',
      value: '4.7/5',
      change: '+0.2',
      trend: 'up',
      icon: TrendingUp,
    },
  ];

  const topServices = [
    { name: 'Haircut & Style', bookings: 156, revenue: 'Rs 62,244' },
    { name: 'Full Body Spa', bookings: 89, revenue: 'Rs 2,66,911' },
    { name: 'Facial Treatment', bookings: 72, revenue: 'Rs 93,528' },
    { name: 'Beard Trim', bookings: 201, revenue: 'Rs 39,999' },
  ];

  const topStaff = [
    { name: 'Sana R.', bookings: 156, rating: 4.9 },
    { name: 'Kabir M.', bookings: 142, rating: 4.8 },
    { name: 'Arjun Verma', bookings: 98, rating: 4.6 },
  ];

  return (
    <PageLayout
      title="Insights"
      subtitle="Performance analytics and metrics"
    >
      {/* Key Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        {metrics.map((metric, idx) => {
          const Icon = metric.icon;
          return (
            <div key={idx} className="card p-5">
              <div className="flex items-start justify-between mb-3">
                <div className="bg-primary/10 p-2 rounded-lg">
                  <Icon size={20} className="text-primary" />
                </div>
                <span className="text-xs font-bold text-green-600">{metric.change}</span>
              </div>
              <p className="text-xs text-gray-600 font-medium mb-1">{metric.label}</p>
              <p className="text-2xl font-bold text-gray-900">{metric.value}</p>
            </div>
          );
        })}
      </div>

      {/* Top Services & Staff */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
        <div className="card p-6">
          <h3 className="text-lg font-bold text-gray-900 mb-4">Top Services</h3>
          <div className="space-y-3">
            {topServices.map((service, idx) => (
              <div
                key={idx}
                className="flex items-start justify-between p-3 bg-gray-50 rounded-lg"
              >
                <div>
                  <p className="font-medium text-gray-900">{service.name}</p>
                  <p className="text-xs text-gray-600">{service.bookings} bookings</p>
                </div>
                <p className="font-semibold text-primary">{service.revenue}</p>
              </div>
            ))}
          </div>
        </div>

        <div className="card p-6">
          <h3 className="text-lg font-bold text-gray-900 mb-4">Top Staff</h3>
          <div className="space-y-3">
            {topStaff.map((staff, idx) => (
              <div
                key={idx}
                className="flex items-start justify-between p-3 bg-gray-50 rounded-lg"
              >
                <div>
                  <p className="font-medium text-gray-900">{staff.name}</p>
                  <p className="text-xs text-gray-600">{staff.bookings} bookings</p>
                </div>
                <div className="flex items-center gap-1">
                  <span className="font-semibold text-gray-900">{staff.rating}</span>
                  <span className="text-yellow-500">★</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Booking Trend */}
      <div className="card p-6">
        <h3 className="text-lg font-bold text-gray-900 mb-4">Weekly Trend</h3>
        <div className="space-y-3">
          {['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].map(
            (day, idx) => {
              const bookings = [45, 52, 48, 61, 55, 68, 42][idx];
              const percentage = (bookings / 70) * 100;
              return (
                <div key={day} className="flex items-center gap-3">
                  <div className="w-20 text-sm font-medium text-gray-700">{day}</div>
                  <div className="flex-1 h-8 bg-gray-100 rounded-lg overflow-hidden">
                    <div
                      className="h-full bg-gradient-to-r from-primary to-primary-dark transition-all"
                      style={{ width: `${percentage}%` }}
                    ></div>
                  </div>
                  <div className="w-12 text-right text-sm font-semibold text-gray-900">{bookings}</div>
                </div>
              );
            }
          )}
        </div>
      </div>
    </PageLayout>
  );
}
