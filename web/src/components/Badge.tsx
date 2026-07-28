interface BadgeProps {
  status: 'PENDING' | 'CONFIRMED' | 'COMPLETED' | 'CANCELLED' | 'NO_SHOW';
}

const statusConfig = {
  PENDING: {
    bg: 'bg-salone-amber-soft',
    text: 'text-salone-amber',
    label: 'Pending',
  },
  CONFIRMED: {
    bg: 'bg-salone-success-soft',
    text: 'text-salone-success',
    label: 'Confirmed',
  },
  COMPLETED: {
    bg: 'bg-salone-success-soft',
    text: 'text-salone-success',
    label: 'Completed',
  },
  CANCELLED: {
    bg: 'bg-salone-danger-soft',
    text: 'text-salone-danger',
    label: 'Cancelled',
  },
  NO_SHOW: {
    bg: 'bg-salone-danger-soft',
    text: 'text-salone-danger',
    label: 'No Show',
  },
};

export function Badge({ status }: BadgeProps) {
  const config = statusConfig[status];
  return (
    <span className={`inline-flex items-center px-2.5 py-1 rounded-full text-xs font-extrabold ${config.bg} ${config.text}`}>
      {config.label}
    </span>
  );
}
