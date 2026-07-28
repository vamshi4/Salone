import { useState } from 'react';
import { Card } from '../components/Card';
import { useAppStore } from '../stores/appStore';
import { useGetServices } from '../api/queries';

export function Services() {
  const { selectedSalonId } = useAppStore();
  const [searchQuery, setSearchQuery] = useState('');
  const { data: services, isLoading } = useGetServices(selectedSalonId || '');

  const filteredServices = services?.filter((s) =>
    s.name.toLowerCase().includes(searchQuery.toLowerCase())
  );

  // Group by category
  const groupedServices = filteredServices?.reduce(
    (acc, service) => {
      const category = service.category || 'Other';
      if (!acc[category]) {
        acc[category] = [];
      }
      acc[category].push(service);
      return acc;
    },
    {} as Record<string, typeof services>
  );

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div>
        <h1 className="text-3xl font-extrabold text-salone-ink mb-1">Services</h1>
        <p className="text-sm font-semibold text-salone-ink-muted">Manage your service catalog</p>
      </div>

      {/* Filters */}
      <div className="flex gap-3">
        <div className="flex-1 max-w-md">
          <input
            type="text"
            placeholder="Search services..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full px-4 py-2 bg-salone-surface-alt border border-salone-border rounded-full text-sm font-semibold text-salone-ink"
          />
        </div>
        <button className="px-5 py-2 bg-salone-accent text-white text-sm font-bold rounded-full hover:opacity-90 transition-opacity">
          + Add Service
        </button>
      </div>

      {/* Services by Category */}
      {isLoading ? (
        <Card title="Services">
          <div className="text-center py-8 text-salone-ink-muted">Loading services...</div>
        </Card>
      ) : !groupedServices || Object.keys(groupedServices).length === 0 ? (
        <Card title="Services">
          <div className="text-center py-8 text-salone-ink-muted">No services found</div>
        </Card>
      ) : (
        <div className="space-y-6">
          {Object.entries(groupedServices).map(([category, categoryServices]) => (
            <Card key={category} title={category}>
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead>
                    <tr className="bg-salone-surface-alt">
                      <th className="px-4 py-3 text-left text-xs font-semibold uppercase text-salone-ink-muted tracking-wide">
                        Service Name
                      </th>
                      <th className="px-4 py-3 text-left text-xs font-semibold uppercase text-salone-ink-muted tracking-wide">
                        Price
                      </th>
                      <th className="px-4 py-3 text-left text-xs font-semibold uppercase text-salone-ink-muted tracking-wide">
                        Duration
                      </th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-salone-border">
                    {categoryServices.map((service) => (
                      <tr key={service.id} className="hover:bg-salone-surface-alt transition-colors">
                        <td className="px-4 py-3 text-sm font-semibold text-salone-ink">
                          {service.name}
                        </td>
                        <td className="px-4 py-3 text-sm font-semibold text-salone-accent">
                          ₹{service.basePrice.toLocaleString()}
                        </td>
                        <td className="px-4 py-3 text-sm font-semibold text-salone-ink">
                          {service.duration} min
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
