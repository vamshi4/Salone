/** Adds GST on top of a service total when the salon is GST-registered. */
export function totalWithGst(amount: number, salon?: { gstEnabled?: boolean; gstRate?: number }) {
  if (!salon?.gstEnabled) return amount;
  return Math.round(amount * (1 + (salon.gstRate ?? 18) / 100) * 100) / 100;
}

/** Builds a `upi://pay` deep link that any UPI app can scan and pre-fill. */
export function buildUpiLink({
  vpa,
  payeeName,
  amount,
  note,
}: {
  vpa: string;
  payeeName: string;
  amount: number;
  note?: string;
}) {
  const parts = [
    `pa=${encodeURIComponent(vpa)}`,
    `pn=${encodeURIComponent(payeeName)}`,
    `am=${amount.toFixed(2)}`,
    'cu=INR',
  ];
  if (note) parts.push(`tn=${encodeURIComponent(note)}`);
  return `upi://pay?${parts.join('&')}`;
}
