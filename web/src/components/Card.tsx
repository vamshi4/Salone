interface CardProps {
  title: string;
  children: React.ReactNode;
  action?: React.ReactNode;
}

export function Card({ title, children, action }: CardProps) {
  return (
    <div
      className="bg-white rounded-lg p-6 border border-salone-border"
      style={{ boxShadow: '0 2px 8px rgba(0, 121, 107, 0.08)' }}
    >
      <div className="flex justify-between items-center mb-6">
        <h3 className="text-xl font-bold text-salone-ink">{title}</h3>
        {action}
      </div>
      {children}
    </div>
  );
}
