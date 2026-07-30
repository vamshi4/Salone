'use client';

import { useState } from 'react';
import { QRCodeSVG } from 'qrcode.react';
import { Copy, Check, Share2 } from 'lucide-react';
import { API_URL } from '@/lib/api';

export function BookingLinkCard({ salonId, salonName }: { salonId: string; salonName: string }) {
  const [copied, setCopied] = useState(false);
  const [copyFailed, setCopyFailed] = useState(false);
  const link = `${API_URL}/book/${salonId}`;

  const copyLink = async () => {
    setCopyFailed(false);
    try {
      await navigator.clipboard.writeText(link);
    } catch {
      // Clipboard API can be denied (older browsers, insecure context,
      // permissions policy) — fall back to the legacy selection-based copy.
      const textarea = document.createElement('textarea');
      textarea.value = link;
      textarea.style.position = 'fixed';
      textarea.style.opacity = '0';
      document.body.appendChild(textarea);
      textarea.select();
      const ok = document.execCommand('copy');
      document.body.removeChild(textarea);
      if (!ok) {
        setCopyFailed(true);
        setTimeout(() => setCopyFailed(false), 2000);
        return;
      }
    }
    setCopied(true);
    setTimeout(() => setCopied(false), 1500);
  };

  const shareLink = async () => {
    if (navigator.share) {
      await navigator.share({ title: salonName, text: `Book with ${salonName}`, url: link });
    } else {
      await copyLink();
    }
  };

  return (
    <div className="card p-4 flex items-start gap-3">
      <div className="p-1.5 bg-white rounded-lg border border-gray-100 flex-shrink-0">
        <QRCodeSVG value={link} size={72} />
      </div>
      <div className="flex-1 min-w-0">
        <p className="text-xs font-medium text-gray-900">Customer booking link</p>
        <p className="text-xs text-gray-400 truncate mt-0.5">{link}</p>
        <p className="text-xs text-gray-400 mt-1">
          Customers can scan this QR code or use the link to book with you directly — no app needed.
        </p>
        <div className="flex items-center gap-3 mt-2">
          <button
            onClick={copyLink}
            className="inline-flex items-center gap-1.5 text-xs font-medium text-gray-600 hover:text-primary-dark"
          >
            {copied ? <Check size={14} className="text-green-600" /> : <Copy size={14} />}
            {copied ? 'Copied' : copyFailed ? "Couldn't copy — select manually" : 'Copy link'}
          </button>
          <button
            onClick={shareLink}
            className="inline-flex items-center gap-1.5 text-xs font-medium text-gray-600 hover:text-primary-dark"
          >
            <Share2 size={14} />
            Share
          </button>
        </div>
      </div>
    </div>
  );
}
