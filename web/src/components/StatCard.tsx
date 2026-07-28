interface StatCardProps {
  label: string;
  description?: string;
  value: string | number;
  change?: {
    value: number;
    type: 'positive' | 'negative';
    label: string;
  };
  icon?: React.ReactNode;
  onClick?: () => void;
}

export function StatCard({ label, description, value, change, icon, onClick }: StatCardProps) {
  return (
    <div
      className="bg-white rounded-lg p-3 border border-salone-border hover:shadow-sm transition-all cursor-pointer"
      onClick={onClick}
      role={onClick ? "button" : undefined}
      tabIndex={onClick ? 0 : undefined}
    >
      <div className="flex items-start justify-between mb-2">
        {icon && (
          <div className="text-salone-accent mr-1.5 flex-shrink-0">
            {icon}
          </div>
        )}
        <div className="flex-1 min-w-0">
          <div className="text-xs font-medium text-salone-ink-muted mb-0.5">
            {label}
          </div>
          {description && (
            <div className="text-xs text-salone-ink-faint leading-tight">
              {description}
            </div>
          )}
        </div>
      </div>
      <div className="text-xl font-bold text-salone-ink">{value}</div>
    </div>
  );
}
