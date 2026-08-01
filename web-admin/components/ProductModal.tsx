'use client';

import { useState } from 'react';
import { useTranslations } from 'next-intl';
import { Modal, Field, inputClass } from './Modal';
import type { Product } from '@/lib/salon-api';
import { useCurrentSalon, useDeleteProduct, useSaveProduct, useSelectedSalonId } from '@/lib/salon-queries';
import { AuthError } from '@/lib/auth';

export function ProductModal({ product, onClose }: { product?: Product; onClose: () => void }) {
  const t = useTranslations('productModal');
  const salonId = useSelectedSalonId();
  const salon = useCurrentSalon();
  const saveProduct = useSaveProduct(salonId ?? '');
  const deleteProduct = useDeleteProduct(salonId ?? '');

  const products = salon?.products ?? [];
  const categories = [...new Set(products.map((p) => p.category))].sort();

  const [name, setName] = useState(product?.name ?? '');
  const [category, setCategory] = useState(product?.category ?? categories[0] ?? 'Hair care');
  const [newCategory, setNewCategory] = useState('');
  const [price, setPrice] = useState(product?.retailPrice ? String(product.retailPrice) : '');
  const [stock, setStock] = useState(String(product?.stockQty ?? '0'));
  const [threshold, setThreshold] = useState(String(product?.lowStockThreshold ?? '5'));
  const [error, setError] = useState('');

  const save = () => {
    if (!salonId) return setError(t('errNoSalon'));
    if (!name.trim()) return setError(t('errName'));
    const p = parseFloat(price);
    if (!p || p <= 0) return setError(t('errPrice'));

    saveProduct.mutate(
      {
        id: product?.id,
        name: name.trim(),
        category: newCategory.trim() || category,
        retailPrice: p,
        stockQty: parseInt(stock, 10) || 0,
        lowStockThreshold: parseInt(threshold, 10) || 0,
      },
      {
        onSuccess: () => onClose(),
        onError: (e) => setError(e instanceof AuthError ? e.message : t('errSave')),
      }
    );
  };

  const remove = () => {
    if (!product) return;
    deleteProduct.mutate(product.id, {
      onSuccess: () => onClose(),
      onError: (e) => setError(e instanceof AuthError ? e.message : t('errDelete')),
    });
  };

  return (
    <Modal title={product ? t('editTitle') : t('addTitle')} onClose={onClose}>
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
        <div className="grid grid-cols-3 gap-2">
          <Field label={t('price')}>
            <input type="number" className={inputClass} value={price} onChange={(e) => setPrice(e.target.value)} />
          </Field>
          <Field label={t('stockQty')}>
            <input type="number" className={inputClass} value={stock} onChange={(e) => setStock(e.target.value)} />
          </Field>
          <Field label={t('lowStockAlertAt')}>
            <input type="number" className={inputClass} value={threshold} onChange={(e) => setThreshold(e.target.value)} />
          </Field>
        </div>
        {error && <p className="text-xs text-red-600">{error}</p>}
        <div className="flex justify-between pt-2 border-t border-gray-200">
          {product ? (
            <button onClick={remove} disabled={deleteProduct.isPending} className="text-xs text-red-600 hover:underline disabled:opacity-60">
              {deleteProduct.isPending ? t('deleting') : t('deleteProduct')}
            </button>
          ) : (
            <span />
          )}
          <button onClick={save} disabled={saveProduct.isPending} className="btn-primary disabled:opacity-60">
            {saveProduct.isPending ? t('saving') : t('saveProduct')}
          </button>
        </div>
      </div>
    </Modal>
  );
}
