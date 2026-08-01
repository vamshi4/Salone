'use client';

import { useState } from 'react';
import { useTranslations } from 'next-intl';
import { Modal, Field, inputClass } from './Modal';
import type { Service } from '@/lib/salon-api';
import { useCurrentSalon, useDeleteService, useSaveService, useSelectedSalonId } from '@/lib/salon-queries';
import { AuthError } from '@/lib/auth';

export function ServiceModal({ service, onClose }: { service?: Service; onClose: () => void }) {
  const t = useTranslations('serviceModal');
  const salonId = useSelectedSalonId();
  const salon = useCurrentSalon();
  const saveService = useSaveService(salonId ?? '');
  const deleteService = useDeleteService(salonId ?? '');

  const services = salon?.services ?? [];
  const staff = salon?.staff ?? [];
  const categories = [...new Set(services.map((s) => s.category))].sort();

  const [name, setName] = useState(service?.name ?? '');
  const [category, setCategory] = useState(service?.category ?? categories[0] ?? 'Hair');
  const [newCategory, setNewCategory] = useState('');
  const [duration, setDuration] = useState(String(service?.duration ?? 30));
  const [price, setPrice] = useState(service?.price ? String(service.price) : '');
  const [stylistId, setStylistId] = useState(service?.stylistId ?? '');
  const [error, setError] = useState('');

  const save = () => {
    if (!salonId) return setError(t('errNoSalon'));
    if (!name.trim()) return setError(t('errName'));
    const p = parseFloat(price);
    if (!p || p <= 0) return setError(t('errPrice'));

    saveService.mutate(
      {
        id: service?.id,
        name: name.trim(),
        category: newCategory.trim() || category,
        duration: parseInt(duration, 10) || 30,
        price: p,
        stylistId: stylistId || null,
      },
      {
        onSuccess: () => onClose(),
        onError: (e) => setError(e instanceof AuthError ? e.message : t('errSave')),
      }
    );
  };

  const remove = () => {
    if (!service) return;
    deleteService.mutate(service.id, {
      onSuccess: () => onClose(),
      onError: (e) => setError(e instanceof AuthError ? e.message : t('errDelete')),
    });
  };

  return (
    <Modal title={service ? t('editTitle') : t('addTitle')} onClose={onClose}>
      <div className="space-y-3">
        <Field label={t('name')}>
          <input className={inputClass} value={name} onChange={(e) => setName(e.target.value)} placeholder={t('namePlaceholder')} />
        </Field>
        <div className="grid grid-cols-2 gap-2">
          <Field label={t('category')}>
            <select className={inputClass} value={category} onChange={(e) => setCategory(e.target.value)}>
              {categories.map((c) => (
                <option key={c}>{c}</option>
              ))}
            </select>
          </Field>
          <Field label={t('orNewCategory')}>
            <input className={inputClass} value={newCategory} onChange={(e) => setNewCategory(e.target.value)} placeholder={t('newCategoryPlaceholder')} />
          </Field>
        </div>
        <div className="grid grid-cols-2 gap-2">
          <Field label={t('duration')}>
            <input type="number" className={inputClass} value={duration} onChange={(e) => setDuration(e.target.value)} />
          </Field>
          <Field label={t('price')}>
            <input type="number" className={inputClass} value={price} onChange={(e) => setPrice(e.target.value)} placeholder="300" />
          </Field>
        </div>
        <Field label={t('assignedStaff')}>
          <select className={inputClass} value={stylistId} onChange={(e) => setStylistId(e.target.value)}>
            <option value="">{t('anyStaff')}</option>
            {staff.filter((s) => s.status === 'ACTIVE').map((s) => (
              <option key={s.stylistId} value={s.stylistId}>{s.name}</option>
            ))}
          </select>
        </Field>
        {error && <p className="text-xs text-red-600">{error}</p>}
        <div className="flex justify-between pt-2 border-t border-gray-200">
          {service ? (
            <button onClick={remove} disabled={deleteService.isPending} className="text-xs text-red-600 hover:underline disabled:opacity-60">
              {deleteService.isPending ? t('deleting') : t('deleteService')}
            </button>
          ) : (
            <span />
          )}
          <button onClick={save} disabled={saveService.isPending} className="btn-primary disabled:opacity-60">
            {saveService.isPending ? t('saving') : t('saveService')}
          </button>
        </div>
      </div>
    </Modal>
  );
}
