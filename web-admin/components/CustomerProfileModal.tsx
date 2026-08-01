'use client';

import { useEffect, useState } from 'react';
import { useTranslations, useLocale } from 'next-intl';
import { Modal, Field, inputClass } from './Modal';
import { StatusBadge } from './StatusBadge';
import { formatINR, type Booking, type Customer } from '@/lib/salon-api';
import {
  useBookings,
  useCurrentSalon,
  useCustomerProfile,
  useSaveCustomerProfile,
  useSelectedSalonId,
} from '@/lib/salon-queries';
import { X } from 'lucide-react';

function formatDay(iso: string, locale: string): { key: 'today' | 'yesterday' } | { text: string } {
  const d = new Date(iso);
  const today = new Date();
  const diff = Math.round((today.setHours(0, 0, 0, 0) - new Date(d).setHours(0, 0, 0, 0)) / 86400000);
  if (diff === 0) return { key: 'today' };
  if (diff === 1) return { key: 'yesterday' };
  return { text: d.toLocaleDateString(locale, { weekday: 'short', day: 'numeric', month: 'short' }) };
}

function formatTime(iso: string, locale: string) {
  return new Date(iso).toLocaleTimeString(locale, { hour: 'numeric', minute: '2-digit', hour12: true }).toLowerCase();
}

export function CustomerProfileModal({
  customer,
  onClose,
}: {
  customer: Customer;
  onClose: () => void;
}) {
  const t = useTranslations('customerProfile');
  const locale = useLocale();
  const salonId = useSelectedSalonId();
  const salon = useCurrentSalon();
  const { data: bookings = [] } = useBookings(salonId);
  const { data: profile } = useCustomerProfile(salonId, customer.id);
  const saveProfile = useSaveCustomerProfile(salonId ?? '');

  const [notes, setNotes] = useState('');
  const [tags, setTags] = useState<string[]>([]);
  const [tagInput, setTagInput] = useState('');
  const [saved, setSaved] = useState(false);

  useEffect(() => {
    if (profile) {
      setNotes(profile.notes);
      setTags(profile.tags);
    }
  }, [profile]);

  const history = bookings
    .filter((b: Booking) => b.customerId === customer.id)
    .sort((a: Booking, b: Booking) => b.time.localeCompare(a.time));
  const done = history.filter((b: Booking) => b.status === 'COMPLETED');
  const totalSpend = done.reduce((s: number, b: Booking) => s + b.price, 0);
  const last = done[0];

  const dayLabel = (raw: ReturnType<typeof formatDay>) => ('key' in raw ? t(raw.key) : raw.text);

  const addTag = () => {
    const tag = tagInput.trim().toLowerCase();
    if (tag && !tags.includes(tag)) setTags([...tags, tag]);
    setTagInput('');
  };

  const save = () => {
    if (!salonId) return;
    saveProfile.mutate(
      { customerId: customer.id, notes, tags },
      {
        onSuccess: () => {
          setSaved(true);
          setTimeout(() => setSaved(false), 1500);
        },
      }
    );
  };

  return (
    <Modal title={customer.name} subtitle={customer.phone} onClose={onClose}>
      <div className="space-y-4">
        {/* Stats */}
        <div className="grid grid-cols-3 gap-2">
          <div className="bg-gray-50 rounded-md px-3 py-2">
            <p className="text-xs text-gray-500">{t('visits')}</p>
            <p className="text-base font-semibold text-gray-900 tabular-nums">{done.length}</p>
          </div>
          <div className="bg-gray-50 rounded-md px-3 py-2">
            <p className="text-xs text-gray-500">{t('totalSpend')}</p>
            <p className="text-base font-semibold text-gray-900 tabular-nums">{formatINR(totalSpend)}</p>
          </div>
          <div className="bg-gray-50 rounded-md px-3 py-2">
            <p className="text-xs text-gray-500">{t('lastVisit')}</p>
            <p className="text-base font-semibold text-gray-900">
              {last ? dayLabel(formatDay(last.time, locale)) : '—'}
            </p>
          </div>
        </div>

        {/* Notes + tags */}
        <Field label={t('notes')}>
          <textarea
            className={`${inputClass} min-h-[56px] resize-y`}
            value={notes}
            onChange={(e) => setNotes(e.target.value)}
            placeholder={t('notesPlaceholder')}
          />
        </Field>
        <Field label={t('tags')}>
          <div className="flex flex-wrap items-center gap-1.5">
            {tags.map((tag) => (
              <span
                key={tag}
                className="inline-flex items-center gap-1 px-2 py-0.5 rounded text-xs bg-primary-light text-primary-dark"
              >
                {tag}
                <button onClick={() => setTags(tags.filter((x) => x !== tag))}>
                  <X size={11} />
                </button>
              </span>
            ))}
            <input
              className="px-2 py-1 rounded-md text-xs border border-gray-300 focus:outline-none focus:ring-1 focus:ring-primary/40 w-28"
              value={tagInput}
              onChange={(e) => setTagInput(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && addTag()}
              placeholder={t('addTagPlaceholder')}
            />
          </div>
        </Field>
        <button onClick={save} disabled={saveProfile.isPending} className="btn-secondary disabled:opacity-60">
          {saveProfile.isPending ? t('saving') : saved ? t('saved') : t('saveNotes')}
        </button>

        {/* History */}
        <div>
          <p className="text-xs font-semibold text-gray-900 mb-1.5">{t('history')}</p>
          <div className="border border-gray-200 rounded-md divide-y divide-gray-100">
            {history.length === 0 && (
              <p className="px-3 py-3 text-xs text-gray-400">{t('noBookingsYet')}</p>
            )}
            {history.map((b: Booking) => (
              <div key={b.id} className="flex items-center justify-between px-3 py-2">
                <div>
                  <p className="text-xs text-gray-900">
                    {b.serviceNames.join(' + ') || t('serviceFallback')}
                    <span className="text-gray-400"> · {b.stylistName}</span>
                  </p>
                  <p className="text-xs text-gray-400">
                    {dayLabel(formatDay(b.time, locale))} · {formatTime(b.time, locale)}
                  </p>
                </div>
                <div className="flex items-center gap-2.5">
                  <span className="text-xs text-gray-900 tabular-nums">{formatINR(b.price)}</span>
                  <StatusBadge status={b.status} />
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </Modal>
  );
}
