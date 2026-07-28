interface CardProps {
  title: string;
  children: React.ReactNode;
  action?: React.ReactNode;
}

export function Card({ title, children, action }: CardProps) {
  return (
    <div className="bg-white rounded-xl p-4 border border-salone-border hover:shadow-md transition-shadow">
      <div className="flex justify-between items-center mb-4">
        <h3 className="text-base font-semibold text-salone-ink">{title}</h3>
        {action}
      </div>
      {children}
    </div>
  );
}
