interface StatCardProps {
  label: string;
  value: string | number;
  change?: {
    value: number;
    type: 'positive' | 'negative';
    label: string;
  };
  icon?: React.ReactNode;
  onClick?: () => void;
}

export function StatCard({ label, value, change, icon, onClick }: StatCardProps) {
  return (
    <button
      onClick={onClick}
      className="bg-white rounded-lg p-6 text-left transition-all hover:shadow-lg border border-salone-border hover:border-salone-accent-lighter cursor-pointer"
      style={{ boxShadow: '0 2px 8px rgba(0, 121, 107, 0.08)' }}
    >
      <div className="flex items-start justify-between mb-4">
        <div className="flex-1">
          <div className="text-xs font-semibold uppercase text-salone-ink-muted mb-2 tracking-wide">
            {label}
          </div>
        </div>
        {icon && (
          <div className="text-salone-accent ml-2">
            {icon}
          </div>
        )}
      </div>
      <div className="text-4xl font-extrabold text-salone-ink mb-3">{value}</div>
      {change && (
        <div
          className={`text-sm font-semibold flex items-center gap-2 ${
            change.type === 'positive' ? 'text-salone-success' : 'text-salone-danger'
          }`}
        >
          <span className="text-lg">{change.type === 'positive' ? '↑' : '↓'}</span>
          <span>{change.value} {change.label}</span>
        </div>
      )}
    </button>
  );
}
