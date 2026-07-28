import { Card } from '../components/Card';
import { useAppStore } from '../stores/appStore';

export function Account() {
  const { user } = useAppStore();

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-extrabold text-salone-ink mb-1">Account</h1>
        <p className="text-sm font-semibold text-salone-ink-muted">Manage your account settings</p>
      </div>

      {/* Profile Card */}
      <Card title="Profile Information">
        <div className="space-y-4">
          <div>
            <label className="block text-xs font-semibold uppercase text-salone-ink-muted mb-2 tracking-wide">
              Name
            </label>
            <input
              type="text"
              value={user?.name || ''}
              disabled
              className="w-full px-4 py-2 bg-salone-surface-alt border border-salone-border rounded-lg text-salone-ink font-semibold"
            />
          </div>
          <div>
            <label className="block text-xs font-semibold uppercase text-salone-ink-muted mb-2 tracking-wide">
              Email
            </label>
            <input
              type="email"
              value={user?.email || ''}
              disabled
              className="w-full px-4 py-2 bg-salone-surface-alt border border-salone-border rounded-lg text-salone-ink font-semibold"
            />
          </div>
          <div>
            <label className="block text-xs font-semibold uppercase text-salone-ink-muted mb-2 tracking-wide">
              Phone
            </label>
            <input
              type="tel"
              value={user?.phone || ''}
              disabled
              className="w-full px-4 py-2 bg-salone-surface-alt border border-salone-border rounded-lg text-salone-ink font-semibold"
            />
          </div>
        </div>
      </Card>

      {/* Account Type */}
      <Card title="Account Type">
        <div className="space-y-3">
          <div className="p-4 bg-salone-surface-alt rounded-lg">
            <div className="text-xs font-semibold uppercase text-salone-ink-muted mb-1 tracking-wide">
              Role
            </div>
            <div className="font-semibold text-salone-ink capitalize">
              {user?.role.toLowerCase().replace('_', ' ')}
            </div>
          </div>
        </div>
      </Card>

      {/* Security */}
      <Card title="Security">
        <button className="px-6 py-3 bg-salone-accent text-white font-bold rounded-full hover:opacity-90 transition-opacity">
          Change Password
        </button>
      </Card>
    </div>
  );
}
