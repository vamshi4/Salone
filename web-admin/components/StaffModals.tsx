'use client';

import { useState } from 'react';
import { Modal, Field, inputClass } from './Modal';
import { formatINR, type AvailabilityRule, type Staff } from '@/lib/salon-api';
import { X } from 'lucide-react';
import {
  useAddAvailabilityRule,
  useAddStaff,
  useAvailabilityRules,
  useDeleteAvailabilityRule,
  usePaySalary,
  usePayouts,
  useSaveService,
  useSelectedSalonId,
  useSettleCommissionPayout,
  useStylistEarnings,
  useUpdateStaff,
  useUpdateStylistProfile,
} from '@/lib/salon-queries';
import { AuthError } from '@/lib/auth';

const DAY_LABELS = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
// Mon..Sun display order, matching the mobile app's staff_manage_sheet.dart.
const DAY_ORDER = [1, 2, 3, 4, 5, 6, 0];

export function AddStaffModal({ onClose }: { onClose: () => void }) {
  const salonId = useSelectedSalonId();
  const addStaff = useAddStaff(salonId ?? '');
  const saveService = useSaveService(salonId ?? '');
  const [name, setName] = useState('');
  const [phone, setPhone] = useState('');
  const [serviceName, setServiceName] = useState('');
  const [price, setPrice] = useState('');
  // Extra services beyond the required starter one, added up front — mirrors
  // the mobile app's add_staff_sheet.dart, which chains one POST per extra
  // service to /stylists/:id/services since staff-setup only takes one.
  const [extraServices, setExtraServices] = useState<{ name: string; price: number }[]>([]);
  const [extraName, setExtraName] = useState('');
  const [extraPrice, setExtraPrice] = useState('');
  const [openTime, setOpenTime] = useState('09:00');
  const [closeTime, setCloseTime] = useState('18:00');
  const [workDays, setWorkDays] = useState<Set<number>>(new Set([1, 2, 3, 4, 5, 6]));
  const [error, setError] = useState('');
  const [saving, setSaving] = useState(false);

  const toggleDay = (day: number) => {
    setWorkDays((prev) => {
      const next = new Set(prev);
      if (next.has(day)) next.delete(day);
      else next.add(day);
      return next;
    });
  };

  const addExtraService = () => {
    const n = extraName.trim();
    const p = parseFloat(extraPrice);
    if (n.length < 2 || !p || p <= 0) return setError('Enter a name and price for that service');
    setError('');
    setExtraServices((prev) => [...prev, { name: n, price: p }]);
    setExtraName('');
    setExtraPrice('');
  };

  const removeExtraService = (index: number) => {
    setExtraServices((prev) => prev.filter((_, i) => i !== index));
  };

  const save = async () => {
    if (!salonId) return setError('No salon selected');
    if (!name.trim() || name.trim().length < 2) return setError('Enter a name');
    if (!phone.trim() || phone.trim().length < 6) return setError('Enter a valid phone number');
    if (!serviceName.trim() || serviceName.trim().length < 2) return setError('Enter a starter service they offer');
    const p = parseFloat(price);
    if (!p || p <= 0) return setError('Enter a valid price for that service');
    if (workDays.size === 0) return setError('Select at least one working day');

    setError('');
    setSaving(true);
    try {
      const { stylistId } = await addStaff.mutateAsync({
        name: name.trim(),
        phone: phone.trim(),
        serviceName: serviceName.trim(),
        price: p,
        startTime: openTime,
        endTime: closeTime,
        days: [...workDays].sort(),
      });
      for (const svc of extraServices) {
        await saveService.mutateAsync({
          name: svc.name,
          category: 'Salon',
          duration: 60,
          price: svc.price,
          stylistId,
        });
      }
      onClose();
    } catch (e) {
      setError(e instanceof AuthError ? e.message : 'Could not add this staff member.');
    } finally {
      setSaving(false);
    }
  };

  return (
    <Modal title="Add staff" subtitle="New team member" onClose={onClose}>
      <div className="space-y-3">
        <Field label="Name">
          <input className={inputClass} value={name} onChange={(e) => setName(e.target.value)} placeholder="Full name" />
        </Field>
        <Field label="Phone">
          <input className={inputClass} value={phone} onChange={(e) => setPhone(e.target.value)} placeholder="98765 43210" />
        </Field>
        <div className="grid grid-cols-2 gap-2">
          <Field label="A service they offer">
            <input
              className={inputClass}
              value={serviceName}
              onChange={(e) => setServiceName(e.target.value)}
              placeholder="Haircut"
            />
          </Field>
          <Field label="Price (₹)">
            <input
              type="number"
              className={inputClass}
              value={price}
              onChange={(e) => setPrice(e.target.value)}
              placeholder="300"
            />
          </Field>
        </div>
        {extraServices.length > 0 && (
          <div className="space-y-1">
            {extraServices.map((svc, i) => (
              <div key={i} className="flex items-center justify-between px-2.5 py-1.5 rounded-md border border-gray-200 text-xs">
                <span className="font-medium text-gray-900">{svc.name}</span>
                <div className="flex items-center gap-2">
                  <span className="text-gray-500 tabular-nums">{formatINR(svc.price)}</span>
                  <button onClick={() => removeExtraService(i)} className="p-0.5 hover:bg-gray-100 rounded">
                    <X size={12} className="text-gray-400" />
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
        <div className="flex items-end gap-2">
          <Field label="Add another service">
            <input
              className={inputClass}
              value={extraName}
              onChange={(e) => setExtraName(e.target.value)}
              placeholder="Beard trim"
            />
          </Field>
          <input
            type="number"
            className={`${inputClass} w-20`}
            value={extraPrice}
            onChange={(e) => setExtraPrice(e.target.value)}
            placeholder="₹"
          />
          <button type="button" onClick={addExtraService} className="btn-secondary">
            Add
          </button>
        </div>
        <p className="text-xs text-gray-400">
          You can also add more services for them later from the Services tab.
        </p>
        <div className="grid grid-cols-2 gap-2">
          <Field label="Opens">
            <input type="time" className={inputClass} value={openTime} onChange={(e) => setOpenTime(e.target.value)} />
          </Field>
          <Field label="Closes">
            <input type="time" className={inputClass} value={closeTime} onChange={(e) => setCloseTime(e.target.value)} />
          </Field>
        </div>
        <Field label="Working days">
          <div className="flex flex-wrap gap-1.5">
            {DAY_ORDER.map((day) => (
              <button
                key={day}
                type="button"
                onClick={() => toggleDay(day)}
                className={`px-2.5 py-1 rounded-md text-xs font-medium transition-colors ${
                  workDays.has(day) ? 'bg-primary-light text-primary-dark' : 'bg-gray-100 text-gray-500'
                }`}
              >
                {DAY_LABELS[day]}
              </button>
            ))}
          </div>
        </Field>
        {error && <p className="text-xs text-red-600">{error}</p>}
        <div className="flex justify-end pt-2 border-t border-gray-200">
          <button onClick={save} disabled={saving} className="btn-primary disabled:opacity-60">
            {saving ? 'Adding…' : 'Add staff'}
          </button>
        </div>
      </div>
    </Modal>
  );
}

/** Per-day working-hours editor for one stylist — mirrors the mobile app's
 * staff_manage_sheet.dart: each day auto-saves on toggle/time change (delete
 * + recreate the rule, since the backend rejects overlapping windows), no
 * separate "save hours" button. */
function WorkingHoursSection({ stylistId }: { stylistId: string }) {
  const { data: rules = [], isLoading } = useAvailabilityRules(stylistId);
  const addRule = useAddAvailabilityRule(stylistId);
  const deleteRule = useDeleteAvailabilityRule(stylistId);
  const [savingDay, setSavingDay] = useState<number | null>(null);

  const ruleForDay = (day: number): AvailabilityRule | undefined => rules.find((r) => r.dayOfWeek === day);

  const toggleDay = async (day: number, enabled: boolean) => {
    setSavingDay(day);
    try {
      const existing = ruleForDay(day);
      if (existing) await deleteRule.mutateAsync(existing.id);
      if (enabled) {
        await addRule.mutateAsync({
          dayOfWeek: day,
          startTime: existing?.startTime ?? '09:00',
          endTime: existing?.endTime ?? '18:00',
        });
      }
    } finally {
      setSavingDay(null);
    }
  };

  const changeTime = async (day: number, field: 'startTime' | 'endTime', value: string) => {
    const existing = ruleForDay(day);
    if (!existing) return;
    setSavingDay(day);
    try {
      await deleteRule.mutateAsync(existing.id);
      await addRule.mutateAsync({
        dayOfWeek: day,
        startTime: field === 'startTime' ? value : existing.startTime,
        endTime: field === 'endTime' ? value : existing.endTime,
      });
    } finally {
      setSavingDay(null);
    }
  };

  if (isLoading) return <p className="text-xs text-gray-400">Loading hours…</p>;

  return (
    <div className="space-y-1.5">
      {DAY_ORDER.map((day) => {
        const rule = ruleForDay(day);
        const enabled = !!rule;
        const busy = savingDay === day;
        return (
          <div key={day} className="flex items-center gap-2 px-2.5 py-1.5 rounded-md bg-gray-50">
            <span className="w-8 text-xs font-medium text-gray-700">{DAY_LABELS[day]}</span>
            <input
              type="checkbox"
              checked={enabled}
              disabled={busy}
              onChange={(e) => toggleDay(day, e.target.checked)}
              className="rounded"
            />
            {enabled ? (
              <div className="flex items-center gap-1 ml-auto">
                <input
                  type="time"
                  value={rule!.startTime}
                  disabled={busy}
                  onChange={(e) => changeTime(day, 'startTime', e.target.value)}
                  className="px-1.5 py-1 rounded border border-gray-300 text-xs"
                />
                <span className="text-gray-400">–</span>
                <input
                  type="time"
                  value={rule!.endTime}
                  disabled={busy}
                  onChange={(e) => changeTime(day, 'endTime', e.target.value)}
                  className="px-1.5 py-1 rounded border border-gray-300 text-xs"
                />
              </div>
            ) : (
              <span className="ml-auto text-xs text-gray-400">Day off</span>
            )}
          </div>
        );
      })}
    </div>
  );
}

/** Edit an existing staff member: name/phone, active toggle, pay type
 * (commission/salary/both) with the matching rate/amount field, and working
 * hours — full parity with the mobile app's staff_manage_sheet.dart.
 * canSetOwnPrice/canCancelBooking stay backend-enforced but UI-hidden until
 * there's a stylist-facing app for them to matter (mobile's own precedent). */
export function ManageStaffModal({ member, onClose }: { member: Staff; onClose: () => void }) {
  const salonId = useSelectedSalonId();
  const updateStaff = useUpdateStaff(salonId ?? '');
  const updateProfile = useUpdateStylistProfile(salonId ?? '');
  const [name, setName] = useState(member.name);
  const [phone, setPhone] = useState(member.phone);
  const [active, setActive] = useState(member.status === 'ACTIVE');
  const [payType, setPayType] = useState(member.payType);
  const [commissionRate, setCommissionRate] = useState(String(member.commissionRate));
  const [salaryAmount, setSalaryAmount] = useState(member.salaryAmount ? String(member.salaryAmount) : '');
  const [error, setError] = useState('');

  const showCommission = payType === 'COMMISSION' || payType === 'BOTH';
  const showSalary = payType === 'SALARY' || payType === 'BOTH';

  const save = () => {
    if (!salonId) return setError('No salon selected');
    if (!name.trim() || name.trim().length < 2 || !phone.trim() || phone.trim().length < 6) {
      return setError('Enter a valid name and phone number');
    }
    const rate = parseInt(commissionRate, 10) || 0;
    if (rate < 0 || rate > 100) return setError('Commission must be between 0 and 100');
    const salary = parseFloat(salaryAmount) || 0;

    setError('');
    updateProfile.mutate(
      { stylistId: member.stylistId, payload: { name: name.trim(), phone: phone.trim() } },
      {
        onError: (e) => setError(e instanceof AuthError ? e.message : 'Could not update staff details.'),
      }
    );
    updateStaff.mutate(
      {
        stylistId: member.stylistId,
        payload: { status: active ? 'ACTIVE' : 'TERMINATED', payType, commissionRate: rate, salaryAmount: salary },
      },
      {
        onSuccess: () => onClose(),
        onError: (e) => setError(e instanceof AuthError ? e.message : 'Could not save changes.'),
      }
    );
  };

  const saving = updateStaff.isPending || updateProfile.isPending;

  return (
    <Modal title="Manage staff" subtitle={member.name} onClose={onClose} wide>
      <div className="space-y-3">
        <div className="grid grid-cols-2 gap-2">
          <Field label="Name">
            <input className={inputClass} value={name} onChange={(e) => setName(e.target.value)} />
          </Field>
          <Field label="Phone">
            <input className={inputClass} value={phone} onChange={(e) => setPhone(e.target.value)} />
          </Field>
        </div>
        <label className="flex items-center justify-between px-3 py-2 rounded-md bg-gray-50 cursor-pointer">
          <div>
            <p className="text-xs font-medium text-gray-900">Active</p>
            <p className="text-xs text-gray-400">Inactive staff can't take bookings</p>
          </div>
          <input type="checkbox" checked={active} onChange={(e) => setActive(e.target.checked)} className="w-4 h-4" />
        </label>

        <Field label="Pay type">
          <div className="flex gap-1 bg-gray-100 p-0.5 rounded-md w-fit">
            {(['COMMISSION', 'SALARY', 'BOTH'] as const).map((pt) => (
              <button
                key={pt}
                type="button"
                onClick={() => setPayType(pt)}
                className={`px-3 py-1.5 rounded text-xs font-medium transition-colors ${
                  payType === pt ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-500'
                }`}
              >
                {pt === 'COMMISSION' ? 'Commission' : pt === 'SALARY' ? 'Salary' : 'Both'}
              </button>
            ))}
          </div>
        </Field>
        <div className="grid grid-cols-2 gap-2">
          {showCommission && (
            <Field label="Commission rate (%)">
              <input
                type="number"
                className={inputClass}
                value={commissionRate}
                onChange={(e) => setCommissionRate(e.target.value)}
              />
            </Field>
          )}
          {showSalary && (
            <Field label="Monthly salary (₹)">
              <input
                type="number"
                className={inputClass}
                value={salaryAmount}
                onChange={(e) => setSalaryAmount(e.target.value)}
                placeholder="15000"
              />
            </Field>
          )}
        </div>

        <div className="pt-2 border-t border-gray-200">
          <p className="text-xs font-semibold text-gray-900 mb-2">Working hours</p>
          <WorkingHoursSection stylistId={member.stylistId} />
        </div>

        {error && <p className="text-xs text-red-600">{error}</p>}
        <div className="flex justify-end pt-2 border-t border-gray-200">
          <button onClick={save} disabled={saving} className="btn-primary disabled:opacity-60">
            {saving ? 'Saving…' : 'Save changes'}
          </button>
        </div>
      </div>
    </Modal>
  );
}

/** Commission/salary payout view for one staff member — mirrors the mobile
 * payout sheet: period earnings, an unpaid-commission "mark as paid" action,
 * a salary "pay salary" action, and settlement history. Backed by the same
 * per-stylist earnings + payouts endpoints the mobile app uses. */
export function PayoutModal({ member, onClose }: { member: Staff; onClose: () => void }) {
  const salonId = useSelectedSalonId();
  const [period, setPeriod] = useState<'day' | 'week' | 'month'>('month');
  const { data, isLoading } = useStylistEarnings(salonId ?? '', member.stylistId, period);
  const { data: payouts = [] } = usePayouts(salonId ?? '', member.stylistId);
  const settleCommission = useSettleCommissionPayout(salonId ?? '', member.stylistId);
  const paySalary = usePaySalary(salonId ?? '', member.stylistId);

  const showCommission = data && (data.payType === 'COMMISSION' || data.payType === 'BOTH');
  const showSalary = data && (data.payType === 'SALARY' || data.payType === 'BOTH');

  return (
    <Modal title="Payouts" subtitle={member.name} onClose={onClose} wide>
      <div className="space-y-3">
        <div className="flex gap-1 bg-gray-100 p-0.5 rounded-md w-fit">
          {(['day', 'week', 'month'] as const).map((p) => (
            <button
              key={p}
              onClick={() => setPeriod(p)}
              className={`px-3 py-1.5 rounded text-xs font-medium transition-colors ${
                period === p ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-500'
              }`}
            >
              {p === 'day' ? 'Today' : p === 'week' ? 'Week' : 'Month'}
            </button>
          ))}
        </div>

        {isLoading || !data ? (
          <p className="text-xs text-gray-400">Loading…</p>
        ) : (
          <>
            <div className="grid grid-cols-3 gap-2">
              <div className="bg-gray-50 rounded-md px-3 py-2">
                <p className="text-xs text-gray-500">Services</p>
                <p className="text-base font-semibold text-gray-900 tabular-nums">{data.count}</p>
              </div>
              <div className="bg-gray-50 rounded-md px-3 py-2">
                <p className="text-xs text-gray-500">Gross</p>
                <p className="text-base font-semibold text-gray-900 tabular-nums">{formatINR(data.grossRevenue)}</p>
              </div>
              <div className="bg-primary-light rounded-md px-3 py-2">
                <p className="text-xs text-primary-dark/70">Their payout</p>
                <p className="text-base font-semibold text-primary-dark tabular-nums">{formatINR(data.totalPayout)}</p>
              </div>
            </div>

            {showCommission && (
              <div className="rounded-md bg-amber-50 px-3 py-2.5 space-y-2">
                <p className="text-xs font-medium text-amber-800">Unpaid commission ({data.unpaidCount})</p>
                <p className="text-lg font-bold text-amber-900 tabular-nums">{formatINR(data.unpaidTotal)}</p>
                <button
                  onClick={() => settleCommission.mutate()}
                  disabled={data.unpaidCount === 0 || settleCommission.isPending}
                  className="btn-primary disabled:opacity-60 text-xs py-1.5"
                >
                  {settleCommission.isPending ? 'Marking as paid…' : 'Mark as paid'}
                </button>
              </div>
            )}

            {showSalary && (
              <div className={`rounded-md px-3 py-2.5 space-y-2 ${data.salaryPaidThisMonth ? 'bg-green-50' : 'bg-amber-50'}`}>
                <p className={`text-xs font-medium ${data.salaryPaidThisMonth ? 'text-green-800' : 'text-amber-800'}`}>
                  Salary this month
                </p>
                <p className="text-lg font-bold text-gray-900 tabular-nums">{formatINR(data.salaryAmount)}</p>
                {data.salaryPaidThisMonth ? (
                  <span className="inline-block px-2 py-0.5 rounded text-xs font-medium bg-white text-green-700">Paid</span>
                ) : (
                  <button
                    onClick={() => paySalary.mutate()}
                    disabled={data.salaryAmount === 0 || paySalary.isPending}
                    className="btn-primary disabled:opacity-60 text-xs py-1.5"
                  >
                    {paySalary.isPending ? 'Paying salary…' : 'Pay salary'}
                  </button>
                )}
              </div>
            )}
          </>
        )}

        <div className="pt-2 border-t border-gray-200">
          <p className="text-xs font-semibold text-gray-900 mb-1.5">Payout history ({payouts.length})</p>
          {payouts.length === 0 ? (
            <p className="text-xs text-gray-400">No payouts yet.</p>
          ) : (
            <div className="space-y-1.5 max-h-40 overflow-y-auto">
              {payouts.map((p) => (
                <div key={p.id} className="flex items-center justify-between px-2.5 py-1.5 rounded-md bg-gray-50">
                  <div>
                    <p className="text-xs font-medium text-gray-900">
                      {new Date(p.paidAt).toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric' })}
                    </p>
                    <p className="text-xs text-gray-400">{p.isSalaryPayout ? 'Salary' : `${p.bookingCount} bookings`}</p>
                  </div>
                  <span className="text-xs font-semibold text-gray-900 tabular-nums">{formatINR(p.totalPayout)}</span>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </Modal>
  );
}
