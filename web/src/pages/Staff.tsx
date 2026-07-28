import { Card } from '../components/Card';
import { useAppStore } from '../stores/appStore';
import { useGetStaff } from '../api/queries';
import { useState } from 'react';

export function Staff() {
  const { selectedSalonId } = useAppStore();
  const [searchQuery, setSearchQuery] = useState('');
  const { data: staff, isLoading } = useGetStaff(selectedSalonId || '');

  const filteredStaff = staff?.filter((s) =>
    s.name.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div>
        <h1 className="text-3xl font-extrabold text-salone-ink mb-1">Staff</h1>
        <p className="text-sm font-semibold text-salone-ink-muted">Manage your team members</p>
      </div>

      {/* Filters */}
      <div className="flex gap-3">
        <div className="flex-1 max-w-md">
          <input
            type="text"
            placeholder="Search staff..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full px-4 py-2 bg-salone-surface-alt border border-salone-border rounded-full text-sm font-semibold text-salone-ink"
          />
        </div>
        <button className="px-5 py-2 bg-salone-accent text-white text-sm font-bold rounded-full hover:opacity-90 transition-opacity">
          + Add Staff
        </button>
      </div>

      {/* Staff List */}
      <Card title="All Staff">
        {isLoading ? (
          <div className="text-center py-8 text-salone-ink-muted">Loading staff...</div>
        ) : !filteredStaff || filteredStaff.length === 0 ? (
          <div className="text-center py-8 text-salone-ink-muted">No staff members found</div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {filteredStaff.map((member) => (
              <div
                key={member.id}
                className="p-4 bg-salone-surface-alt rounded-lg border border-salone-border hover:border-salone-accent transition-colors"
              >
                <div className="flex items-start justify-between mb-3">
                  <div>
                    <div className="font-semibold text-salone-ink">{member.name}</div>
                    <div className="text-xs text-salone-ink-muted mt-1">{member.phone}</div>
                  </div>
                  <div
                    className={`text-xs font-extrabold px-2 py-1 rounded-full ${
                      member.isActive
                        ? 'bg-salone-success-soft text-salone-success'
                        : 'bg-salone-danger-soft text-salone-danger'
                    }`}
                  >
                    {member.isActive ? 'Active' : 'Inactive'}
                  </div>
                </div>
                <div className="mb-3 pb-3 border-b border-salone-border">
                  <div className="text-xs text-salone-ink-muted font-semibold">Pay Type</div>
                  <div className="text-sm font-semibold text-salone-ink capitalize">
                    {member.payType.toLowerCase()}
                  </div>
                </div>
                <div className="text-xs text-salone-ink-muted">
                  {member.services.length} services
                </div>
              </div>
            ))}
          </div>
        )}
      </Card>
    </div>
  );
}
