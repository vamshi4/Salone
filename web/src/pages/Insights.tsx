import { Card } from '../components/Card';
import { useAppStore } from '../stores/appStore';
import { useGetInsights, useGetEarnings } from '../api/queries';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

export function Insights() {
  const { selectedSalonId } = useAppStore();
  const { data: insights, isLoading: insightsLoading } = useGetInsights(selectedSalonId || '');
  const { data: earnings, isLoading: earningsLoading } = useGetEarnings(selectedSalonId || '');

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div>
        <h1 className="text-3xl font-extrabold text-salone-ink mb-1">Insights</h1>
        <p className="text-sm font-semibold text-salone-ink-muted">Analytics and performance data</p>
      </div>

      {/* Key Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <Card title="Total Revenue">
          <div className="text-3xl font-extrabold text-salone-accent">
            ₹{insights?.totalRevenue?.toLocaleString() || '0'}
          </div>
        </Card>
        <Card title="Total Bookings">
          <div className="text-3xl font-extrabold text-salone-success">
            {insights?.totalBookings || '0'}
          </div>
        </Card>
        <Card title="Avg Rating">
          <div className="text-3xl font-extrabold text-salone-amber">
            {insights?.averageRating || '0'}★
          </div>
        </Card>
        <Card title="Retention Rate">
          <div className="text-3xl font-extrabold text-salone-violet">
            {Math.round((insights?.retentionRate || 0) * 100)}%
          </div>
        </Card>
      </div>

      {/* Charts */}
      <Card title="Earnings by Service">
        {earningsLoading ? (
          <div className="text-center py-8 text-salone-ink-muted">Loading chart...</div>
        ) : (
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={insights?.earningsByService || []}>
              <CartesianGrid strokeDasharray="3 3" stroke="#ECECEE" />
              <XAxis dataKey="serviceName" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Bar dataKey="amount" fill="#E91E76" name="Revenue" />
            </BarChart>
          </ResponsiveContainer>
        )}
      </Card>

      <Card title="Earnings by Staff">
        {earningsLoading ? (
          <div className="text-center py-8 text-salone-ink-muted">Loading chart...</div>
        ) : (
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={insights?.earningsByStaff || []}>
              <CartesianGrid strokeDasharray="3 3" stroke="#ECECEE" />
              <XAxis dataKey="staffName" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Bar dataKey="amount" fill="#2D7D46" name="Earnings" />
            </BarChart>
          </ResponsiveContainer>
        )}
      </Card>
    </div>
  );
}
