'use client';

import Link from 'next/link';
import { PageLayout } from '@/components/PageLayout';
import { useDeletedItems, useRestoreSalon, useRestoreUser } from '@/lib/admin-queries';

function formatDate(iso: string) {
  return new Date(iso).toLocaleString('en-IN', { day: 'numeric', month: 'short', year: 'numeric', hour: 'numeric', minute: '2-digit' });
}

export default function DeletedPage() {
  const { data, isLoading, isError } = useDeletedItems();
  const restoreSalon = useRestoreSalon();
  const restoreUser = useRestoreUser();

  return (
    <PageLayout title="Deleted items" subtitle="Recover soft-deleted salons and users">
      <div className="space-y-4">
        {isLoading && <p className="text-xs text-gray-400">Loading…</p>}
        {isError && <p className="text-xs text-red-600">Could not load deleted items.</p>}

        {data && (
          <>
            <div className="card p-4">
              <h2 className="text-sm font-semibold text-gray-900 mb-2">Salons ({data.salons.length})</h2>
              {data.salons.length === 0 ? (
                <p className="text-xs text-gray-400">Nothing here.</p>
              ) : (
                <div className="divide-y divide-gray-100">
                  {data.salons.map((s) => (
                    <div key={s.id} className="py-2.5 flex items-center justify-between gap-3 flex-wrap">
                      <div className="text-xs text-gray-600">
                        <Link href={`/salons/${s.id}`} className="text-gray-900 font-medium hover:text-primary">
                          {s.name}
                        </Link>
                        <p className="text-gray-400">
                          {s.owner.name || s.owner.phone} · Deleted {formatDate(s.deletedAt)}
                        </p>
                      </div>
                      <button
                        onClick={() => restoreSalon.mutate(s.id)}
                        disabled={restoreSalon.isPending}
                        className="btn-secondary disabled:opacity-60"
                      >
                        Restore
                      </button>
                    </div>
                  ))}
                </div>
              )}
            </div>

            <div className="card p-4">
              <h2 className="text-sm font-semibold text-gray-900 mb-2">Users ({data.users.length})</h2>
              {data.users.length === 0 ? (
                <p className="text-xs text-gray-400">Nothing here.</p>
              ) : (
                <div className="divide-y divide-gray-100">
                  {data.users.map((u) => (
                    <div key={u.id} className="py-2.5 flex items-center justify-between gap-3 flex-wrap">
                      <div className="text-xs text-gray-600">
                        <p className="text-gray-900 font-medium">{u.name || 'Unnamed'}</p>
                        <p className="text-gray-400">
                          {u.phone} · {u.role} · Deleted {formatDate(u.deletedAt)}
                        </p>
                      </div>
                      <button
                        onClick={() => restoreUser.mutate(u.id)}
                        disabled={restoreUser.isPending}
                        className="btn-secondary disabled:opacity-60"
                      >
                        Restore
                      </button>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </>
        )}
      </div>
    </PageLayout>
  );
}
