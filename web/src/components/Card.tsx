interface CardProps {
  title: string;
  children: React.ReactNode;
  action?: React.ReactNode;
}

export function Card({ title, children, action }: CardProps) {
  return (
    <div className="bg-white rounded p-1.5 border border-salone-border hover:shadow-sm transition-shadow">
      <div className="flex justify-between items-center mb-2">
        <h3 className="text-xs font-semibold text-salone-ink">{title}</h3>
        {action}
      </div>
      {children}
    </div>
  );
}
