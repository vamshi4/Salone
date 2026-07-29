'use client';

import { useState } from 'react';
import { PageLayout } from '@/components/PageLayout';
import { useAudit } from '@/lib/admin-queries';

const TARGET_TYPES = ['', 'Salon', 'User', 'Booking', 'Service', 'SalonCustomer', 'Stylist'];

function formatDateTime(iso: string) {
  return new Date(iso).toLocaleString('en-IN', { day: 'numeric', month: 'short', year: 'numeric', hour: 'numeric', minute: '2-digit', second: '2-digit' });
}

function DiffPreview({ before, after }: { before: unknown; after: unknown }) {
  const [open, setOpen] = useState(false);
  if (before == null && after == null) return null;
  return (
    <div className="mt-1">
      <button onClick={() => setOpen((v) => !v)} className="text-[11px] text-primary hover:underline">
        {open ? 'Hide details' : 'Show details'}
      </button>
      {open && (
        <div className="mt-1 grid grid-cols-1 sm:grid-cols-2 gap-2">
          {before != null && (
            <pre className="text-[10px] bg-gray-50 rounded p-2 overflow-x-auto">
              <span className="text-gray-400">before</span>{'\n'}
              {JSON.stringify(before, null, 2)}
            </pre>
          )}
          {after != null && (
            <pre className="text-[10px] bg-gray-50 rounded p-2 overflow-x-auto">
              <span className="text-gray-400">after</span>{'\n'}
              {JSON.stringify(after, null, 2)}
            </pre>
          )}
        </div>
      )}
    </div>
  );
}

export default function AuditPage() {
  const [targetType, setTargetType] = useState('');
  const { data: entries = [], isLoading, isError } = useAudit({ targetType: targetType || undefined, limit: 100 });

  return (
    <PageLayout title="Audit log" subtitle="Every action taken from this console, newest first">
      <div className="space-y-3">
        <div className="flex items-center gap-2">
          <select value={targetType} onChange={(e) => setTargetType(e.target.value)} className="text-xs py-1.5">
            {TARGET_TYPES.map((t) => (
              <option key={t} value={t}>
                {t || 'All types'}
              </option>
            ))}
          </select>
        </div>

        {isLoading && <p className="text-xs text-gray-400">Loading…</p>}
        {isError && <p className="text-xs text-red-600">Could not load the audit log.</p>}

        {!isLoading && entries.length === 0 && (
          <div className="card px-4 py-6 text-center">
            <p className="text-xs text-gray-400">No audit entries yet.</p>
          </div>
        )}

        {entries.length > 0 && (
          <div className="card divide-y divide-gray-100">
            {entries.map((e) => (
              <div key={e.id} className="px-4 py-2.5">
                <div className="flex items-center justify-between gap-3">
                  <p className="text-xs text-gray-900 font-medium">{e.action}</p>
                  <p className="text-[11px] text-gray-400">{formatDateTime(e.createdAt)}</p>
                </div>
                <p className="text-[11px] text-gray-400">
                  {e.targetType} · {e.targetId}
                </p>
                <DiffPreview before={e.before} after={e.after} />
              </div>
            ))}
          </div>
        )}
      </div>
    </PageLayout>
  );
}
