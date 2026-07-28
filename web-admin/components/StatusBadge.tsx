'use client';

const STATUS_STYLES: Record<string, { dot: string; text: string; label: string }> = {
  PENDING: { dot: 'bg-amber-500', text: 'text-amber-700', label: 'Pending' },
  CONFIRMED: { dot: 'bg-green-600', text: 'text-green-700', label: 'Confirmed' },
  IN_PROGRESS: { dot: 'bg-blue-500', text: 'text-blue-700', label: 'In progress' },
  COMPLETED: { dot: 'bg-gray-400', text: 'text-gray-500', label: 'Completed' },
  CANCELLED: { dot: 'bg-red-500', text: 'text-red-600', label: 'Cancelled' },
  NO_SHOW: { dot: 'bg-gray-400', text: 'text-gray-500', label: 'No show' },
};

export function StatusBadge({ status }: { status: string }) {
  const style = STATUS_STYLES[status] ?? {
    dot: 'bg-gray-400',
    text: 'text-gray-500',
    label: status,
  };

  return (
    <span className={`inline-flex items-center gap-1.5 text-xs font-medium ${style.text}`}>
      <span className={`w-1.5 h-1.5 rounded-full ${style.dot}`} />
      {style.label}
    </span>
  );
}

export function formatINR(amount: number) {
  return `₹${amount.toLocaleString('en-IN')}`;
}
