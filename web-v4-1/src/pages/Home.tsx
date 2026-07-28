import { useAppStore } from '../stores/appStore';
import StatCard from '../components/StatCard';
import Badge from '../components/Badge';
import { DollarSign, Calendar, Users, Star, Plus } from 'lucide-react';
import { Loader } from 'lucide-react';

export default function Home() {
  const user = useAppStore((state) => state.user);

  if (!user) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <Loader className="animate-spin" size={32} />
      </div>
    );
  }

  return (
    <div className="bg-gray-50 min-h-screen p-6 space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-2xl font-bold text-text-primary">Home</h1>
        <p className="text-sm text-text-muted">Today's business overview</p>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard
          label="Today's revenue"
          value="Rs 5,096"
          subtitle="today, all staff"
          icon={<DollarSign size={24} />}
          color="primary"
        />
        <StatCard
          label="Bookings today"
          value="4"
          subtitle="across all staff"
          icon={<Calendar size={24} />}
          color="primary"
        />
        <StatCard
          label="Active staff"
          value="2"
          subtitle="on schedule"
          icon={<Users size={24} />}
          color="primary"
        />
        <StatCard
          label="Rating"
          value="4.8"
          subtitle="284 reviews"
          icon={<Star size={24} />}
          color="primary"
        />
      </div>

      {/* Today's Bookings Section */}
      <div className="bg-white rounded-lg border border-gray-100 shadow-sm p-6">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-lg font-semibold text-text-primary">Today's bookings</h2>
          <button className="flex items-center gap-2 bg-primary hover:bg-primary-dark text-white px-4 py-2 rounded-lg transition-colors font-medium text-sm">
            <Plus size={18} />
            New booking
          </button>
        </div>

        <div className="space-y-3">
          {/* Booking Item 1 */}
          <div className="flex items-center justify-between p-4 border border-gray-100 rounded-lg hover:bg-gray-50 transition-colors">
            <div>
              <p className="font-medium text-text-primary">Haircut & Style · Kabir M.</p>
              <p className="text-sm text-text-muted">Priya Sharma · Today, 3:00 PM</p>
            </div>
            <div className="flex items-center gap-4">
              <span className="text-primary font-semibold text-sm">Rs 399</span>
              <Badge label="PENDING" status="pending" />
            </div>
          </div>

          {/* Booking Item 2 */}
          <div className="flex items-center justify-between p-4 border border-gray-100 rounded-lg hover:bg-gray-50 transition-colors">
            <div>
              <p className="font-medium text-text-primary">Full body spa · Neha T.</p>
              <p className="text-sm text-text-muted">Arjun Verma · Today, 6:00 PM</p>
            </div>
            <div className="flex items-center gap-4">
              <span className="text-primary font-semibold text-sm">Rs 2,999</span>
              <Badge label="CONFIRMED" status="confirmed" />
            </div>
          </div>

          {/* Booking Item 3 */}
          <div className="flex items-center justify-between p-4 border border-gray-100 rounded-lg hover:bg-gray-50 transition-colors">
            <div>
              <p className="font-medium text-text-primary">Beard trim · Sana R.</p>
              <p className="text-sm text-text-muted">Priya Sharma · Today, 11:30 AM</p>
            </div>
            <div className="flex items-center gap-4">
              <span className="text-success font-semibold text-sm">Rs 199</span>
              <Badge label="COMPLETED" status="completed" />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
