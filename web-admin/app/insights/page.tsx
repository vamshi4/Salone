'use client';

import { PageLayout } from '@/components/PageLayout';

export default function InsightsPage() {
  const metrics = [
    { label: 'Total revenue', value: '₹45,230', change: '+12.5%' },
    { label: 'Total bookings', value: '284', change: '+8.2%' },
    { label: 'New customers', value: '45', change: '+5.3%' },
    { label: 'Average rating', value: '4.7', change: '+0.2' },
  ];

  const topServices = [
    { name: 'Haircut & style', bookings: 156, revenue: '₹62,244' },
    { name: 'Full body spa', bookings: 89, revenue: '₹2,66,911' },
    { name: 'Facial treatment', bookings: 72, revenue: '₹93,528' },
    { name: 'Beard trim', bookings: 201, revenue: '₹39,999' },
  ];

  const topStaff = [
    { name: 'Sana R.', bookings: 156, rating: 4.9 },
    { name: 'Kabir M.', bookings: 142, rating: 4.8 },
    { name: 'Arjun Verma', bookings: 98, rating: 4.6 },
  ];

  const weekly = [
    { day: 'Mon', bookings: 45 },
    { day: 'Tue', bookings: 52 },
    { day: 'Wed', bookings: 48 },
    { day: 'Thu', bookings: 61 },
    { day: 'Fri', bookings: 55 },
    { day: 'Sat', bookings: 68 },
    { day: 'Sun', bookings: 42 },
  ];

  return (
    <PageLayout title="Insights" subtitle="Performance analytics and metrics">
      {/* Key metrics */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-3">
        {metrics.map((metric, idx) => (
          <div key={idx} className="bg-white border border-gray-200 rounded-lg px-3.5 py-3">
            <p className="text-xs text-gray-500">{metric.label}</p>
            <p className="text-xl font-semibold text-gray-900 tabular-nums mt-0.5">{metric.value}</p>
            <p className="text-xs text-green-700 mt-0.5">↑ {metric.change} this month</p>
          </div>
        ))}
      </div>

      {/* Top services & staff */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-3">
        <div className="card p-4">
          <h3 className="text-sm font-semibold text-gray-900 mb-2">Top services</h3>
          <div className="divide-y divide-gray-100">
            {topServices.map((service, idx) => (
              <div key={idx} className="flex items-center justify-between py-2">
                <div>
                  <p className="text-xs font-medium text-gray-900">{service.name}</p>
                  <p className="text-xs text-gray-400">{service.bookings} bookings</p>
                </div>
                <p className="text-xs text-gray-900 tabular-nums">{service.revenue}</p>
              </div>
            ))}
          </div>
        </div>

        <div className="card p-4">
          <h3 className="text-sm font-semibold text-gray-900 mb-2">Top staff</h3>
          <div className="divide-y divide-gray-100">
            {topStaff.map((staff, idx) => (
              <div key={idx} className="flex items-center justify-between py-2">
                <div>
                  <p className="text-xs font-medium text-gray-900">{staff.name}</p>
                  <p className="text-xs text-gray-400">{staff.bookings} bookings</p>
                </div>
                <p className="text-xs text-gray-900 tabular-nums">
                  {staff.rating} <span className="text-amber-500">★</span>
                </p>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Weekly trend */}
      <div className="card p-4">
        <h3 className="text-sm font-semibold text-gray-900 mb-3">Weekly trend</h3>
        <div className="space-y-2">
          {weekly.map(({ day, bookings }) => {
            const percentage = (bookings / 70) * 100;
            return (
              <div key={day} className="flex items-center gap-3">
                <div className="w-8 text-xs text-gray-500">{day}</div>
                <div className="flex-1 h-4 bg-gray-100 rounded overflow-hidden">
                  <div
                    className="h-full bg-primary/70 rounded"
                    style={{ width: `${percentage}%` }}
                  ></div>
                </div>
                <div className="w-8 text-right text-xs text-gray-900 tabular-nums">{bookings}</div>
              </div>
            );
          })}
        </div>
      </div>
    </PageLayout>
  );
}
