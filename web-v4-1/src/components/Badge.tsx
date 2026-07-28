interface BadgeProps {
  label: string;
  status?: 'pending' | 'confirmed' | 'completed' | 'cancelled' | 'no-show';
}

export default function Badge({ label, status }: BadgeProps) {
  const statusClasses = {
    pending: 'bg-warning/10 text-warning font-semibold',
    confirmed: 'bg-primary/10 text-primary font-semibold',
    completed: 'bg-success/10 text-success font-semibold',
    cancelled: 'bg-danger/10 text-danger font-semibold',
    'no-show': 'bg-gray-100 text-text-muted font-semibold',
  };

  const bgColor = status ? statusClasses[status] : 'bg-gray-100 text-text-primary font-semibold';

  return (
    <span className={`px-3 py-1 rounded-md text-xs uppercase tracking-wide ${bgColor}`}>
      {label}
    </span>
  );
}
