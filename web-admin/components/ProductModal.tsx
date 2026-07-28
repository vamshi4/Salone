'use client';

import { useState } from 'react';
import { Modal, Field, inputClass } from './Modal';
import { useDataStore, type Product } from '@/lib/data';

export function ProductModal({ product, onClose }: { product?: Product; onClose: () => void }) {
  const { products, saveProduct, deleteProduct } = useDataStore();
  const categories = [...new Set(products.map((p) => p.category))].sort();

  const [name, setName] = useState(product?.name ?? '');
  const [category, setCategory] = useState(product?.category ?? categories[0] ?? 'Hair care');
  const [newCategory, setNewCategory] = useState('');
  const [price, setPrice] = useState(String(product?.retailPrice ?? ''));
  const [stock, setStock] = useState(String(product?.stockQty ?? '0'));
  const [threshold, setThreshold] = useState(String(product?.lowStockThreshold ?? '5'));
  const [error, setError] = useState('');

  const save = () => {
    if (!name.trim()) return setError('Enter a product name');
    const p = parseInt(price, 10);
    if (!p || p <= 0) return setError('Enter a valid price');
    saveProduct({
      id: product?.id,
      name: name.trim(),
      category: newCategory.trim() || category,
      retailPrice: p,
      stockQty: parseInt(stock, 10) || 0,
      lowStockThreshold: parseInt(threshold, 10) || 0,
    });
    onClose();
  };

  return (
    <Modal title={product ? 'Edit product' : 'Add product'} onClose={onClose}>
      <div className="space-y-3">
        <Field label="Name">
          <input className={inputClass} value={name} onChange={(e) => setName(e.target.value)} placeholder="Argan oil shampoo" />
        </Field>
        <div className="grid grid-cols-2 gap-2">
          <Field label="Category">
            <select className={inputClass} value={category} onChange={(e) => setCategory(e.target.value)}>
              {categories.map((c) => (
                <option key={c}>{c}</option>
              ))}
            </select>
          </Field>
          <Field label="Or new category">
            <input className={inputClass} value={newCategory} onChange={(e) => setNewCategory(e.target.value)} placeholder="Tools" />
          </Field>
        </div>
        <div className="grid grid-cols-3 gap-2">
          <Field label="Price (₹)">
            <input type="number" className={inputClass} value={price} onChange={(e) => setPrice(e.target.value)} />
          </Field>
          <Field label="Stock qty">
            <input type="number" className={inputClass} value={stock} onChange={(e) => setStock(e.target.value)} />
          </Field>
          <Field label="Low-stock alert at">
            <input type="number" className={inputClass} value={threshold} onChange={(e) => setThreshold(e.target.value)} />
          </Field>
        </div>
        {error && <p className="text-xs text-red-600">{error}</p>}
        <div className="flex justify-between pt-2 border-t border-gray-200">
          {product ? (
            <button
              onClick={() => {
                deleteProduct(product.id);
                onClose();
              }}
              className="text-xs text-red-600 hover:underline"
            >
              Delete product
            </button>
          ) : (
            <span />
          )}
          <button onClick={save} className="btn-primary">Save product</button>
        </div>
      </div>
    </Modal>
  );
}
