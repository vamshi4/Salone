'use client';

const PALETTES = [
  'bg-teal-100 text-teal-800',
  'bg-violet-100 text-violet-800',
  'bg-amber-100 text-amber-800',
  'bg-rose-100 text-rose-800',
  'bg-sky-100 text-sky-800',
  'bg-emerald-100 text-emerald-800',
];

/** Deterministic pastel avatar — same person always gets the same color. */
export function Avatar({ name, size = 'md' }: { name: string; size?: 'sm' | 'md' | 'lg' }) {
  let hash = 0;
  for (let i = 0; i < name.length; i++) hash = (hash * 31 + name.charCodeAt(i)) >>> 0;
  const palette = PALETTES[hash % PALETTES.length];
  const cls =
    size === 'sm' ? 'w-7 h-7 text-xs' : size === 'lg' ? 'w-12 h-12 text-lg' : 'w-9 h-9 text-sm';
  return (
    <div className={`${cls} ${palette} rounded-full flex items-center justify-center font-semibold flex-shrink-0`}>
      {name.trim().charAt(0).toUpperCase()}
    </div>
  );
}
