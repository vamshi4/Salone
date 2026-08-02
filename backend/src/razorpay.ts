import crypto from 'crypto';

// Inert until keys are configured — mirrors the Meta Pixel pattern on the
// web-admin side. Razorpay only onboards India-registered merchants, so
// this is only ever used for salons with countryCode 'IN'.
const KEY_ID = process.env.RAZORPAY_KEY_ID;
const KEY_SECRET = process.env.RAZORPAY_KEY_SECRET;

export function isRazorpayConfigured(): boolean {
  return !!(KEY_ID && KEY_SECRET);
}

export function razorpayPublicKeyId(): string | null {
  return KEY_ID ?? null;
}

// amountPaise: order amount in paise (same minor-unit convention as every
// other money field in this codebase — see Booking.price).
export async function createRazorpayOrder(
  amountPaise: number,
  receipt: string
): Promise<{ id: string; amount: number; currency: string }> {
  if (!KEY_ID || !KEY_SECRET) throw new Error('Razorpay is not configured');
  const auth = Buffer.from(`${KEY_ID}:${KEY_SECRET}`).toString('base64');
  const res = await fetch('https://api.razorpay.com/v1/orders', {
    method: 'POST',
    headers: {
      Authorization: `Basic ${auth}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      amount: amountPaise,
      currency: 'INR',
      receipt,
      payment_capture: 1,
    }),
  });
  if (!res.ok) {
    const body = await res.text().catch(() => '');
    throw new Error(`Razorpay order creation failed (${res.status}): ${body}`);
  }
  const data = (await res.json()) as { id: string; amount: number; currency: string };
  return { id: data.id, amount: data.amount, currency: data.currency };
}

// Verifies the HMAC-SHA256 signature Razorpay Checkout returns after a
// successful payment (`orderId|paymentId` signed with the key secret) —
// this is the only thing that actually proves the payment happened; never
// trust a client-reported "payment succeeded" without this check.
export function verifyRazorpaySignature(orderId: string, paymentId: string, signature: string): boolean {
  if (!KEY_SECRET) return false;
  const expected = crypto
    .createHmac('sha256', KEY_SECRET)
    .update(`${orderId}|${paymentId}`)
    .digest('hex');
  return crypto.timingSafeEqual(Buffer.from(expected), Buffer.from(signature));
}
