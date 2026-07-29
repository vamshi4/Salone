'use client';

import { useState } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { PageLayout } from '@/components/PageLayout';
import { useSalonDetail } from '@/lib/admin-queries';
import { formatINR } from '@/lib/admin-api';
import type { SalonStylistRow, SalonCustomerRow, SalonRecentBooking } from '@/lib/admin-api';
import {
  ConfirmModal,
  ResetPasswordModal,
  EditUserModal,
  RoleModal,
  EditSalonModal,
  EditStylistModal,
  EditCustomerNotesModal,
  EditBookingModal,
  useDeleteBooking,
  useDeleteCustomer,
  useDeleteSalon,
  useDeleteStylist,
  useDeleteUser,
  useRestoreSalon,
  useRestoreStylist,
  useRestoreUser,
} from '@/components/SalonDetailModals';
import { ArrowLeft, Pencil, KeyRound, Shield, Trash2, RotateCcw } from 'lucide-react';

type ModalState =
  | { type: 'editSalon' }
  | { type: 'editUser'; userId: string; initial: { name: string; phone: string; email?: string } }
  | { type: 'resetPassword'; userId: string; name: string }
  | { type: 'role'; userId: string; name: string; currentRole: string }
  | { type: 'confirm'; title: string; message: string; confirmLabel: string; danger?: boolean; onConfirm: () => void }
  | { type: 'editStylist'; row: SalonStylistRow }
  | { type: 'editCustomerNotes'; row: SalonCustomerRow }
  | { type: 'editBooking'; booking: SalonRecentBooking }
  | null;

function formatDate(iso: string | null) {
  if (!iso) return '—';
  return new Date(iso).toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric' });
}

function formatDateTime(iso: string) {
  return new Date(iso).toLocaleString('en-IN', { day: 'numeric', month: 'short', hour: 'numeric', minute: '2-digit' });
}

function IconButton({
  label,
  onClick,
  danger,
}: {
  label: string;
  onClick: () => void;
  danger?: boolean;
}) {
  const icons: Record<string, React.ReactNode> = {
    Edit: <Pencil size={12} />,
    'Reset password': <KeyRound size={12} />,
    'Change role': <Shield size={12} />,
    Delete: <Trash2 size={12} />,
    Restore: <RotateCcw size={12} />,
  };
  return (
    <button
      onClick={onClick}
      className={`inline-flex items-center gap-1 px-2 py-1 rounded text-[11px] font-medium transition-colors ${
        danger ? 'text-danger hover:bg-red-50' : 'text-gray-600 hover:bg-gray-100'
      }`}
    >
      {icons[label]}
      {label}
    </button>
  );
}

export default function SalonDetailPage() {
  const params = useParams();
  const router = useRouter();
  const salonId = params.id as string;
  const { data, isLoading, isError } = useSalonDetail(salonId);
  const [modal, setModal] = useState<ModalState>(null);

  const deleteSalon = useDeleteSalon(salonId);
  const restoreSalon = useRestoreSalon();
  const deleteUser = useDeleteUser(salonId);
  const deleteStylist = useDeleteStylist(salonId);
  const restoreStylist = useRestoreStylist(salonId);
  const deleteCustomer = useDeleteCustomer(salonId);
  const deleteBooking = useDeleteBooking(salonId);

  if (isLoading) {
    return (
      <PageLayout title="Salon">
        <p className="text-xs text-gray-400">Loading…</p>
      </PageLayout>
    );
  }
  if (isError || !data) {
    return (
      <PageLayout title="Salon">
        <p className="text-xs text-red-600">Could not load this salon.</p>
      </PageLayout>
    );
  }

  const { salon, bookings } = data;
  const owner = salon.owner;

  return (
    <PageLayout
      title={salon.name}
      subtitle={salon.address}
      action={
        <button onClick={() => router.push('/salons')} className="btn-secondary">
          <ArrowLeft size={13} />
          Back to salons
        </button>
      }
    >
      <div className="space-y-4">
        {/* Salon info */}
        <div className="card p-4">
          <div className="flex items-start justify-between gap-3">
            <div className="flex items-center gap-3 flex-wrap">
              <span
                className={`inline-block px-2 py-0.5 rounded text-[11px] font-medium ${
                  salon.saasPlan === 'PREMIUM' ? 'bg-primary-light text-primary' : 'bg-gray-100 text-gray-500'
                }`}
              >
                {salon.saasPlan}
              </span>
              <span className="text-xs text-gray-500">Commission: {salon.commissionRate}%</span>
              <span className="text-xs text-gray-500">
                {salon._count.bookings} bookings · {salon._count.customers} customers · {salon._count.stylists} stylists
              </span>
              {salon.deletedAt && (
                <span className="inline-block px-2 py-0.5 rounded text-[11px] font-medium bg-red-50 text-danger">
                  Deleted {formatDate(salon.deletedAt)}
                </span>
              )}
            </div>
            <div className="flex items-center gap-1 flex-shrink-0">
              <IconButton label="Edit" onClick={() => setModal({ type: 'editSalon' })} />
              {salon.deletedAt ? (
                <IconButton
                  label="Restore"
                  onClick={() =>
                    setModal({
                      type: 'confirm',
                      title: 'Restore salon',
                      message: `Restore "${salon.name}"? It will become visible to its owner and appear in listings again.`,
                      confirmLabel: 'Restore',
                      onConfirm: () => restoreSalon.mutate(salonId, { onSuccess: () => setModal(null) }),
                    })
                  }
                />
              ) : (
                <IconButton
                  label="Delete"
                  danger
                  onClick={() =>
                    setModal({
                      type: 'confirm',
                      title: 'Delete salon',
                      message: `Soft-delete "${salon.name}"? It will disappear from the owner's account and all listings. This can be undone from the Deleted page.`,
                      confirmLabel: 'Delete',
                      danger: true,
                      onConfirm: () => deleteSalon.mutate(undefined, { onSuccess: () => setModal(null) }),
                    })
                  }
                />
              )}
            </div>
          </div>
        </div>

        {/* Owner */}
        <div className="card p-4">
          <h2 className="text-sm font-semibold text-gray-900 mb-2">Owner</h2>
          <div className="flex items-start justify-between gap-3 flex-wrap">
            <div className="text-xs text-gray-600 space-y-0.5">
              <p className="text-gray-900 font-medium">{owner.name || 'Unnamed owner'}</p>
              <p>{owner.phone}{owner.email ? ` · ${owner.email}` : ''}</p>
              <p className="text-gray-400">Role: {owner.role} · Joined {formatDate(owner.createdAt)}</p>
            </div>
            <div className="flex items-center gap-1 flex-wrap">
              <IconButton
                label="Edit"
                onClick={() =>
                  setModal({
                    type: 'editUser',
                    userId: owner.id,
                    initial: { name: owner.name ?? '', phone: owner.phone, email: owner.email ?? '' },
                  })
                }
              />
              <IconButton
                label="Reset password"
                onClick={() => setModal({ type: 'resetPassword', userId: owner.id, name: owner.name || owner.phone })}
              />
              <IconButton
                label="Change role"
                onClick={() => setModal({ type: 'role', userId: owner.id, name: owner.name || owner.phone, currentRole: owner.role })}
              />
              <IconButton
                label="Delete"
                danger
                onClick={() =>
                  setModal({
                    type: 'confirm',
                    title: 'Delete owner account',
                    message: `Soft-delete ${owner.name || owner.phone}'s account? They will no longer be able to sign in. This can be undone from the Deleted page.`,
                    confirmLabel: 'Delete',
                    danger: true,
                    onConfirm: () => deleteUser.mutate(owner.id, { onSuccess: () => setModal(null) }),
                  })
                }
              />
            </div>
          </div>
        </div>

        {/* Stylists */}
        <div className="card p-4">
          <h2 className="text-sm font-semibold text-gray-900 mb-2">Stylists ({salon.stylists.length})</h2>
          {salon.stylists.length === 0 ? (
            <p className="text-xs text-gray-400">No stylists yet.</p>
          ) : (
            <div className="divide-y divide-gray-100">
              {salon.stylists.map((row) => (
                <div key={row.stylist.id} className="py-2.5 flex items-start justify-between gap-3 flex-wrap">
                  <div className="text-xs text-gray-600 space-y-0.5">
                    <p className="text-gray-900 font-medium">
                      {row.stylist.user.name || 'Unnamed'} <span className="text-gray-400 font-normal">· {row.stylist.user.phone}</span>
                    </p>
                    <p className="text-gray-400">
                      {row.status}
                      {row.stylist.basePrice != null ? ` · Base price ${formatINR(row.stylist.basePrice)}` : ''}
                      {row.stylist.homeServiceEnabled ? ' · Home service' : ''}
                      {row.stylist.independentBookingEnabled ? ' · Independent booking' : ''}
                      {row.stylist.deletedAt ? ' · Deleted' : ''}
                    </p>
                  </div>
                  <div className="flex items-center gap-1 flex-wrap">
                    <IconButton label="Edit" onClick={() => setModal({ type: 'editStylist', row })} />
                    <IconButton
                      label="Reset password"
                      onClick={() =>
                        setModal({ type: 'resetPassword', userId: row.stylist.user.id, name: row.stylist.user.name || row.stylist.user.phone })
                      }
                    />
                    {row.stylist.deletedAt ? (
                      <IconButton
                        label="Restore"
                        onClick={() => restoreStylist.mutate(row.stylist.id)}
                      />
                    ) : (
                      <IconButton
                        label="Delete"
                        danger
                        onClick={() =>
                          setModal({
                            type: 'confirm',
                            title: 'Remove stylist',
                            message: `Soft-delete ${row.stylist.user.name || row.stylist.user.phone}? They'll drop out of bookings/discovery; their account and history stay intact and this can be undone.`,
                            confirmLabel: 'Delete',
                            danger: true,
                            onConfirm: () => deleteStylist.mutate(row.stylist.id, { onSuccess: () => setModal(null) }),
                          })
                        }
                      />
                    )}
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Customers */}
        <div className="card p-4">
          <h2 className="text-sm font-semibold text-gray-900 mb-2">Customers ({salon.customers.length})</h2>
          {salon.customers.length === 0 ? (
            <p className="text-xs text-gray-400">No customers yet.</p>
          ) : (
            <div className="divide-y divide-gray-100">
              {salon.customers.map((row) => (
                <div key={row.id} className="py-2.5 flex items-start justify-between gap-3 flex-wrap">
                  <div className="text-xs text-gray-600 space-y-0.5">
                    <p className="text-gray-900 font-medium">
                      {row.customer.name || 'Unnamed'} <span className="text-gray-400 font-normal">· {row.customer.phone}</span>
                    </p>
                    {(row.notes || row.tags.length > 0) && (
                      <p className="text-gray-400">
                        {row.notes}
                        {row.tags.length > 0 ? ` · ${row.tags.join(', ')}` : ''}
                      </p>
                    )}
                  </div>
                  <div className="flex items-center gap-1 flex-wrap">
                    <IconButton
                      label="Edit"
                      onClick={() =>
                        setModal({
                          type: 'editUser',
                          userId: row.customer.id,
                          initial: { name: row.customer.name ?? '', phone: row.customer.phone },
                        })
                      }
                    />
                    <IconButton label="Reset password" onClick={() => setModal({ type: 'resetPassword', userId: row.customer.id, name: row.customer.name || row.customer.phone })} />
                    <button
                      onClick={() => setModal({ type: 'editCustomerNotes', row })}
                      className="inline-flex items-center gap-1 px-2 py-1 rounded text-[11px] font-medium text-gray-600 hover:bg-gray-100"
                    >
                      Notes/tags
                    </button>
                    <IconButton
                      label="Delete"
                      danger
                      onClick={() =>
                        setModal({
                          type: 'confirm',
                          title: 'Remove customer link',
                          message: `Remove ${row.customer.name || row.customer.phone} from this salon's customer list? Their account and bookings are untouched — only the salon-specific notes/tags link is removed.`,
                          confirmLabel: 'Remove',
                          danger: true,
                          onConfirm: () => deleteCustomer.mutate(row.id, { onSuccess: () => setModal(null) }),
                        })
                      }
                    />
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Recent bookings */}
        <div className="card p-4">
          <h2 className="text-sm font-semibold text-gray-900 mb-2">Recent bookings (last {bookings.length})</h2>
          {bookings.length === 0 ? (
            <p className="text-xs text-gray-400">No bookings yet.</p>
          ) : (
            <div className="divide-y divide-gray-100">
              {bookings.map((b) => (
                <div key={b.id} className="py-2 flex items-center justify-between gap-3 flex-wrap">
                  <div className="text-xs text-gray-600">
                    <p className="text-gray-900">
                      {b.customer.name || b.customer.phone}
                      <span className="text-gray-400"> · {b.service?.name ?? 'Service'} · {formatDateTime(b.slotStart)}</span>
                    </p>
                    <p className="text-gray-400">
                      {b.status} · {formatINR(b.price)}
                    </p>
                  </div>
                  <div className="flex items-center gap-1">
                    <IconButton label="Edit" onClick={() => setModal({ type: 'editBooking', booking: b })} />
                    <IconButton
                      label="Delete"
                      danger
                      onClick={() =>
                        setModal({
                          type: 'confirm',
                          title: 'Delete booking',
                          message: 'This permanently deletes the booking record. This cannot be undone from this UI (the audit log keeps a before-snapshot).',
                          confirmLabel: 'Delete permanently',
                          danger: true,
                          onConfirm: () => deleteBooking.mutate(b.id, { onSuccess: () => setModal(null) }),
                        })
                      }
                    />
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      {modal?.type === 'editSalon' && <EditSalonModal salon={salon} onClose={() => setModal(null)} />}
      {modal?.type === 'editUser' && (
        <EditUserModal salonId={salonId} userId={modal.userId} initial={modal.initial} onClose={() => setModal(null)} />
      )}
      {modal?.type === 'resetPassword' && (
        <ResetPasswordModal userId={modal.userId} name={modal.name} onClose={() => setModal(null)} />
      )}
      {modal?.type === 'role' && (
        <RoleModal salonId={salonId} userId={modal.userId} name={modal.name} currentRole={modal.currentRole} onClose={() => setModal(null)} />
      )}
      {modal?.type === 'editStylist' && <EditStylistModal salonId={salonId} row={modal.row} onClose={() => setModal(null)} />}
      {modal?.type === 'editCustomerNotes' && (
        <EditCustomerNotesModal salonId={salonId} row={modal.row} onClose={() => setModal(null)} />
      )}
      {modal?.type === 'editBooking' && <EditBookingModal salonId={salonId} booking={modal.booking} onClose={() => setModal(null)} />}
      {modal?.type === 'confirm' && (
        <ConfirmModal
          title={modal.title}
          message={modal.message}
          confirmLabel={modal.confirmLabel}
          danger={modal.danger}
          onConfirm={modal.onConfirm}
          onClose={() => setModal(null)}
        />
      )}
    </PageLayout>
  );
}
