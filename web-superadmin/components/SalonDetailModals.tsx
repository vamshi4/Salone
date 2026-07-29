'use client';

import { useState } from 'react';
import { Modal, Field, inputClass } from './Modal';
import {
  useDeleteBooking,
  useDeleteCustomer,
  useDeleteSalon,
  useDeleteStylist,
  useDeleteUser,
  useResetUserPassword,
  useRestoreSalon,
  useRestoreStylist,
  useRestoreUser,
  useUpdateBooking,
  useUpdateCustomer,
  useUpdateSalon,
  useUpdateStylist,
  useUpdateUser,
  useUpdateUserRole,
} from '@/lib/admin-queries';
import type { SalonDetail, SalonRecentBooking, SalonStylistRow, SalonCustomerRow } from '@/lib/admin-api';

/** Generic destructive-action confirmation — used for every delete/restore in
 * this app instead of the browser's native confirm(), which is too easy to
 * click through without reading on an admin console that can delete real
 * accounts. */
export function ConfirmModal({
  title,
  message,
  confirmLabel,
  danger,
  loading,
  onConfirm,
  onClose,
}: {
  title: string;
  message: string;
  confirmLabel: string;
  danger?: boolean;
  loading?: boolean;
  onConfirm: () => void;
  onClose: () => void;
}) {
  return (
    <Modal title={title} onClose={onClose}>
      <div className="space-y-3">
        <p className="text-xs text-gray-600">{message}</p>
        <div className="flex justify-end gap-2 pt-2 border-t border-gray-200">
          <button onClick={onClose} className="btn-secondary">
            Cancel
          </button>
          <button onClick={onConfirm} disabled={loading} className={danger ? 'btn-danger disabled:opacity-60' : 'btn-primary disabled:opacity-60'}>
            {loading ? 'Working…' : confirmLabel}
          </button>
        </div>
      </div>
    </Modal>
  );
}

/** Reset any user's password by id — the one action explicitly asked for
 * ("help the users for resetting the password"). Works for the owner, any
 * stylist, or any customer, since POST /admin/users/:id/reset-password
 * doesn't care about the target's role. */
export function ResetPasswordModal({
  userId,
  name,
  onClose,
}: {
  userId: string;
  name: string;
  onClose: () => void;
}) {
  const resetPassword = useResetUserPassword();
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [done, setDone] = useState(false);

  const save = () => {
    if (password.length < 12) return setError('Password must be at least 12 characters');
    setError('');
    resetPassword.mutate(
      { userId, password },
      {
        onSuccess: () => setDone(true),
        onError: (e) => setError(e instanceof Error ? e.message : 'Could not reset the password.'),
      }
    );
  };

  return (
    <Modal title="Reset password" subtitle={name} onClose={onClose}>
      <div className="space-y-3">
        {done ? (
          <div className="px-3 py-2.5 bg-emerald-50 border border-emerald-200 rounded-md text-emerald-700 text-xs">
            Password reset. Share the new password with {name} through a secure channel.
          </div>
        ) : (
          <>
            <Field label="New password (min 12 characters)">
              <input
                type="text"
                className={inputClass}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="A temporary password to share with the user"
              />
            </Field>
            {error && <p className="text-xs text-red-600">{error}</p>}
          </>
        )}
        <div className="flex justify-end gap-2 pt-2 border-t border-gray-200">
          <button onClick={onClose} className="btn-secondary">
            {done ? 'Close' : 'Cancel'}
          </button>
          {!done && (
            <button onClick={save} disabled={resetPassword.isPending} className="btn-primary disabled:opacity-60">
              {resetPassword.isPending ? 'Resetting…' : 'Reset password'}
            </button>
          )}
        </div>
      </div>
    </Modal>
  );
}

/** Edit a user's identity fields (name/phone/email) — works for any user id,
 * same reasoning as ResetPasswordModal. */
export function EditUserModal({
  salonId,
  userId,
  initial,
  onClose,
}: {
  salonId: string;
  userId: string;
  initial: { name: string; phone: string; email?: string };
  onClose: () => void;
}) {
  const updateUser = useUpdateUser(salonId);
  const [name, setName] = useState(initial.name);
  const [phone, setPhone] = useState(initial.phone);
  const [email, setEmail] = useState(initial.email ?? '');
  const [error, setError] = useState('');

  const save = () => {
    if (phone.trim().length < 6) return setError('Enter a valid phone number');
    setError('');
    updateUser.mutate(
      { userId, payload: { name: name.trim() || null, phone: phone.trim(), email: email.trim() || null } },
      {
        onSuccess: () => onClose(),
        onError: (e) => setError(e instanceof Error ? e.message : 'Could not save changes.'),
      }
    );
  };

  return (
    <Modal title="Edit user" onClose={onClose}>
      <div className="space-y-3">
        <Field label="Name">
          <input className={inputClass} value={name} onChange={(e) => setName(e.target.value)} />
        </Field>
        <Field label="Phone">
          <input className={inputClass} value={phone} onChange={(e) => setPhone(e.target.value)} />
        </Field>
        <Field label="Email">
          <input className={inputClass} value={email} onChange={(e) => setEmail(e.target.value)} placeholder="optional" />
        </Field>
        {error && <p className="text-xs text-red-600">{error}</p>}
        <div className="flex justify-end gap-2 pt-2 border-t border-gray-200">
          <button onClick={onClose} className="btn-secondary">
            Cancel
          </button>
          <button onClick={save} disabled={updateUser.isPending} className="btn-primary disabled:opacity-60">
            {updateUser.isPending ? 'Saving…' : 'Save changes'}
          </button>
        </div>
      </div>
    </Modal>
  );
}

export function RoleModal({
  salonId,
  userId,
  name,
  currentRole,
  onClose,
}: {
  salonId: string;
  userId: string;
  name: string;
  currentRole: string;
  onClose: () => void;
}) {
  const updateRole = useUpdateUserRole(salonId);
  const [role, setRole] = useState(currentRole);
  const [error, setError] = useState('');
  const roles = ['CUSTOMER', 'STYLIST', 'SALON_OWNER', 'SUPER_ADMIN'];

  const save = () => {
    updateRole.mutate(
      { userId, role },
      {
        onSuccess: () => onClose(),
        onError: (e) => setError(e instanceof Error ? e.message : 'Could not change the role.'),
      }
    );
  };

  return (
    <Modal title="Change role" subtitle={name} onClose={onClose}>
      <div className="space-y-3">
        <Field label="Role">
          <select className={inputClass} value={role} onChange={(e) => setRole(e.target.value)}>
            {roles.map((r) => (
              <option key={r} value={r}>
                {r}
              </option>
            ))}
          </select>
        </Field>
        <p className="text-xs text-amber-600">
          Changing a role takes effect immediately and changes what this account can access.
        </p>
        {error && <p className="text-xs text-red-600">{error}</p>}
        <div className="flex justify-end gap-2 pt-2 border-t border-gray-200">
          <button onClick={onClose} className="btn-secondary">
            Cancel
          </button>
          <button onClick={save} disabled={updateRole.isPending} className="btn-primary disabled:opacity-60">
            {updateRole.isPending ? 'Saving…' : 'Change role'}
          </button>
        </div>
      </div>
    </Modal>
  );
}

export function EditSalonModal({
  salon,
  onClose,
}: {
  salon: SalonDetail['salon'];
  onClose: () => void;
}) {
  const updateSalon = useUpdateSalon(salon.id);
  const [name, setName] = useState(salon.name);
  const [address, setAddress] = useState(salon.address);
  const [saasPlan, setSaasPlan] = useState(salon.saasPlan);
  const [commissionRate, setCommissionRate] = useState(String(salon.commissionRate));
  const [error, setError] = useState('');

  const save = () => {
    const rate = parseInt(commissionRate, 10);
    if (Number.isNaN(rate) || rate < 0 || rate > 100) return setError('Commission must be between 0 and 100');
    setError('');
    updateSalon.mutate(
      { name: name.trim(), address: address.trim(), saasPlan, commissionRate: rate },
      {
        onSuccess: () => onClose(),
        onError: (e) => setError(e instanceof Error ? e.message : 'Could not save changes.'),
      }
    );
  };

  return (
    <Modal title="Edit salon" onClose={onClose}>
      <div className="space-y-3">
        <Field label="Name">
          <input className={inputClass} value={name} onChange={(e) => setName(e.target.value)} />
        </Field>
        <Field label="Address">
          <input className={inputClass} value={address} onChange={(e) => setAddress(e.target.value)} />
        </Field>
        <div className="grid grid-cols-2 gap-2">
          <Field label="Plan">
            <select className={inputClass} value={saasPlan} onChange={(e) => setSaasPlan(e.target.value)}>
              <option value="FREE">FREE</option>
              <option value="PREMIUM">PREMIUM</option>
            </select>
          </Field>
          <Field label="Default commission (%)">
            <input
              type="number"
              className={inputClass}
              value={commissionRate}
              onChange={(e) => setCommissionRate(e.target.value)}
            />
          </Field>
        </div>
        {error && <p className="text-xs text-red-600">{error}</p>}
        <div className="flex justify-end gap-2 pt-2 border-t border-gray-200">
          <button onClick={onClose} className="btn-secondary">
            Cancel
          </button>
          <button onClick={save} disabled={updateSalon.isPending} className="btn-primary disabled:opacity-60">
            {updateSalon.isPending ? 'Saving…' : 'Save changes'}
          </button>
        </div>
      </div>
    </Modal>
  );
}

export function EditStylistModal({
  salonId,
  row,
  onClose,
}: {
  salonId: string;
  row: SalonStylistRow;
  onClose: () => void;
}) {
  const updateStylist = useUpdateStylist(salonId);
  const [basePrice, setBasePrice] = useState(row.stylist.basePrice != null ? String(row.stylist.basePrice) : '');
  const [homeService, setHomeService] = useState(row.stylist.homeServiceEnabled);
  const [independent, setIndependent] = useState(row.stylist.independentBookingEnabled);
  const [error, setError] = useState('');

  const save = () => {
    const price = basePrice.trim() ? parseFloat(basePrice) : null;
    if (basePrice.trim() && (Number.isNaN(price) || (price as number) < 0)) {
      return setError('Base price must be a non-negative number');
    }
    setError('');
    updateStylist.mutate(
      {
        stylistId: row.stylist.id,
        payload: { basePrice: price, homeServiceEnabled: homeService, independentBookingEnabled: independent },
      },
      {
        onSuccess: () => onClose(),
        onError: (e) => setError(e instanceof Error ? e.message : 'Could not save changes.'),
      }
    );
  };

  return (
    <Modal title="Edit stylist" subtitle={row.stylist.user.name || row.stylist.user.phone} onClose={onClose}>
      <div className="space-y-3">
        <Field label="Base price (₹)">
          <input
            type="number"
            className={inputClass}
            value={basePrice}
            onChange={(e) => setBasePrice(e.target.value)}
            placeholder="optional"
          />
        </Field>
        <label className="flex items-center justify-between px-3 py-2 rounded-md bg-gray-50 cursor-pointer">
          <span className="text-xs font-medium text-gray-900">Home service enabled</span>
          <input type="checkbox" checked={homeService} onChange={(e) => setHomeService(e.target.checked)} className="w-4 h-4" />
        </label>
        <label className="flex items-center justify-between px-3 py-2 rounded-md bg-gray-50 cursor-pointer">
          <span className="text-xs font-medium text-gray-900">Independent booking enabled</span>
          <input type="checkbox" checked={independent} onChange={(e) => setIndependent(e.target.checked)} className="w-4 h-4" />
        </label>
        {error && <p className="text-xs text-red-600">{error}</p>}
        <div className="flex justify-end gap-2 pt-2 border-t border-gray-200">
          <button onClick={onClose} className="btn-secondary">
            Cancel
          </button>
          <button onClick={save} disabled={updateStylist.isPending} className="btn-primary disabled:opacity-60">
            {updateStylist.isPending ? 'Saving…' : 'Save changes'}
          </button>
        </div>
      </div>
    </Modal>
  );
}

export function EditCustomerNotesModal({
  salonId,
  row,
  onClose,
}: {
  salonId: string;
  row: SalonCustomerRow;
  onClose: () => void;
}) {
  const updateCustomer = useUpdateCustomer(salonId);
  const [notes, setNotes] = useState(row.notes);
  const [tags, setTags] = useState<string[]>(row.tags);
  const [tagInput, setTagInput] = useState('');
  const [error, setError] = useState('');

  const addTag = () => {
    const t = tagInput.trim().toLowerCase();
    if (t && !tags.includes(t)) setTags([...tags, t]);
    setTagInput('');
  };

  const save = () => {
    updateCustomer.mutate(
      { salonCustomerId: row.id, payload: { notes, tags } },
      {
        onSuccess: () => onClose(),
        onError: (e) => setError(e instanceof Error ? e.message : 'Could not save changes.'),
      }
    );
  };

  return (
    <Modal title="Edit customer notes" subtitle={row.customer.name || row.customer.phone} onClose={onClose}>
      <div className="space-y-3">
        <Field label="Notes">
          <textarea
            className={`${inputClass} min-h-[56px] resize-y`}
            value={notes}
            onChange={(e) => setNotes(e.target.value)}
          />
        </Field>
        <Field label="Tags">
          <div className="flex flex-wrap items-center gap-1.5">
            {tags.map((t) => (
              <span key={t} className="inline-flex items-center gap-1 px-2 py-0.5 rounded text-xs bg-primary-light text-primary">
                {t}
                <button onClick={() => setTags(tags.filter((x) => x !== t))}>×</button>
              </span>
            ))}
            <input
              className="px-2 py-1 rounded-md text-xs border border-gray-300 w-28"
              value={tagInput}
              onChange={(e) => setTagInput(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && addTag()}
              placeholder="Add tag"
            />
          </div>
        </Field>
        {error && <p className="text-xs text-red-600">{error}</p>}
        <div className="flex justify-end gap-2 pt-2 border-t border-gray-200">
          <button onClick={onClose} className="btn-secondary">
            Cancel
          </button>
          <button onClick={save} disabled={updateCustomer.isPending} className="btn-primary disabled:opacity-60">
            {updateCustomer.isPending ? 'Saving…' : 'Save changes'}
          </button>
        </div>
      </div>
    </Modal>
  );
}

const BOOKING_STATUSES = ['PENDING', 'PENDING_RESCHEDULE', 'CONFIRMED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'NO_SHOW'];

export function EditBookingModal({
  salonId,
  booking,
  onClose,
}: {
  salonId: string;
  booking: SalonRecentBooking;
  onClose: () => void;
}) {
  const updateBooking = useUpdateBooking(salonId);
  const [status, setStatus] = useState(booking.status);
  const [price, setPrice] = useState(String(booking.price));
  const [error, setError] = useState('');

  const save = () => {
    const p = parseFloat(price);
    if (Number.isNaN(p) || p < 0) return setError('Price must be a non-negative number');
    setError('');
    updateBooking.mutate(
      { bookingId: booking.id, payload: { status, price: p } },
      {
        onSuccess: () => onClose(),
        onError: (e) => setError(e instanceof Error ? e.message : 'Could not save changes.'),
      }
    );
  };

  return (
    <Modal title="Edit booking" subtitle={booking.customer.name || booking.customer.phone} onClose={onClose}>
      <div className="space-y-3">
        <Field label="Status">
          <select className={inputClass} value={status} onChange={(e) => setStatus(e.target.value)}>
            {BOOKING_STATUSES.map((s) => (
              <option key={s} value={s}>
                {s}
              </option>
            ))}
          </select>
        </Field>
        <Field label="Price (₹)">
          <input type="number" className={inputClass} value={price} onChange={(e) => setPrice(e.target.value)} />
        </Field>
        {error && <p className="text-xs text-red-600">{error}</p>}
        <div className="flex justify-end gap-2 pt-2 border-t border-gray-200">
          <button onClick={onClose} className="btn-secondary">
            Cancel
          </button>
          <button onClick={save} disabled={updateBooking.isPending} className="btn-primary disabled:opacity-60">
            {updateBooking.isPending ? 'Saving…' : 'Save changes'}
          </button>
        </div>
      </div>
    </Modal>
  );
}

// Re-exported so the detail page doesn't need to import every hook itself
// just to wire delete/restore buttons that only need `.mutate()`.
export {
  useDeleteBooking,
  useDeleteCustomer,
  useDeleteSalon,
  useDeleteStylist,
  useDeleteUser,
  useRestoreSalon,
  useRestoreStylist,
  useRestoreUser,
};
