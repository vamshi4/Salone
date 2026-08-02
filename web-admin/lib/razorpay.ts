import { createRazorpayOrder, type RazorpayPaymentFields } from './salon-api';

// Feature flag, not a secret — the actual Key ID/Secret live server-side
// and never reach the browser except via the per-order response. Set at
// deploy time once a Razorpay account is actually connected (see
// backend/src/razorpay.ts), same inert-until-configured pattern as the
// Meta Pixel's NEXT_PUBLIC_META_PIXEL_ID.
export const RAZORPAY_ENABLED = process.env.NEXT_PUBLIC_RAZORPAY_ENABLED === 'true';

declare global {
  interface Window {
    Razorpay?: new (options: Record<string, unknown>) => { open: () => void };
  }
}

let scriptPromise: Promise<void> | null = null;

function loadCheckoutScript(): Promise<void> {
  if (typeof window === 'undefined') return Promise.reject(new Error('Razorpay requires a browser'));
  if (window.Razorpay) return Promise.resolve();
  if (scriptPromise) return scriptPromise;
  scriptPromise = new Promise((resolve, reject) => {
    const script = document.createElement('script');
    script.src = 'https://checkout.razorpay.com/v1/checkout.js';
    script.async = true;
    script.onload = () => resolve();
    script.onerror = () => reject(new Error('Could not load Razorpay Checkout'));
    document.body.appendChild(script);
  });
  return scriptPromise;
}

/** Creates an order for `amountPaise`, opens Razorpay Checkout, and resolves
 * with the signed payment fields once the customer completes payment — the
 * backend still independently verifies the signature before treating the
 * booking as paid, this is just what gets sent to it. Rejects if the
 * customer closes the widget without paying. */
export async function collectRazorpayPayment(options: {
  amountPaise: number;
  salonName: string;
  customerName?: string;
  customerPhone?: string;
  description?: string;
}): Promise<RazorpayPaymentFields> {
  const order = await createRazorpayOrder(options.amountPaise);
  await loadCheckoutScript();

  return new Promise((resolve, reject) => {
    if (!window.Razorpay) return reject(new Error('Razorpay Checkout failed to load'));
    const rzp = new window.Razorpay({
      key: order.keyId,
      order_id: order.orderId,
      amount: order.amount,
      currency: order.currency,
      name: options.salonName,
      description: options.description,
      prefill: {
        name: options.customerName,
        contact: options.customerPhone,
      },
      handler: (response: { razorpay_order_id: string; razorpay_payment_id: string; razorpay_signature: string }) => {
        resolve({
          razorpayOrderId: response.razorpay_order_id,
          razorpayPaymentId: response.razorpay_payment_id,
          razorpaySignature: response.razorpay_signature,
        });
      },
      modal: {
        ondismiss: () => reject(new Error('Payment was not completed')),
      },
    });
    rzp.open();
  });
}
