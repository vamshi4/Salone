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
    <div
      className="bg-white rounded-xl p-6 border border-salone-border hover:border-salone-ink-faint transition-all hover:shadow-lg cursor-pointer group"
      onClick={onClick}
      role={onClick ? "button" : undefined}
      tabIndex={onClick ? 0 : undefined}
    >
      <div className="flex items-start justify-between mb-4">
        <div className="flex-1">
          <div className="text-xs font-semibold uppercase text-salone-ink-muted mb-3 tracking-tight letter-spacing-wide">
            {label}
          </div>
        </div>
        {icon && (
          <div className="text-salone-accent ml-3 p-2 bg-salone-accent-soft rounded-lg group-hover:bg-salone-accent-light transition-colors">
            {icon}
          </div>
        )}
      </div>
      <div className="text-3xl font-bold text-salone-ink mb-3">{value}</div>
      {change && (
        <div
          className={`text-xs font-semibold flex items-center gap-1.5 ${
            change.type === 'positive' ? 'text-salone-success' : 'text-salone-danger'
          }`}
        >
          <span className="inline-block">{change.type === 'positive' ? '↗' : '↘'}</span>
          <span>{change.value}% {change.label}</span>
        </div>
      )}
    </div>
  );
}
