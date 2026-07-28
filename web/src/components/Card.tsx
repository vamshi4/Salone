interface CardProps {
  title: string;
  children: React.ReactNode;
  action?: React.ReactNode;
}

export function Card({ title, children, action }: CardProps) {
  return (
    <div className="bg-white rounded-lg p-3 border border-salone-border hover:shadow-sm transition-shadow">
      <div className="flex justify-between items-center mb-3">
        <h3 className="text-sm font-semibold text-salone-ink">{title}</h3>
        {action}
      </div>
      {children}
    </div>
  );
}
