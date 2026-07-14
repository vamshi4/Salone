// Sends OTP codes via the Meta WhatsApp Business Cloud API. Requires an
// approved "authentication" template (Meta rejects freeform business-initiated
// messages outside a customer-service window) — see docs/HANDOFF.md for setup
// steps. Until WHATSAPP_ACCESS_TOKEN is configured, this logs the OTP instead
// of sending it, so the forgot-password flow is testable end-to-end in dev.

const GRAPH_VERSION = 'v20.0';

export class WhatsAppNotConfiguredError extends Error {
  constructor() {
    super('WhatsApp OTP delivery is not configured');
    this.name = 'WhatsAppNotConfiguredError';
  }
}

export async function sendWhatsAppOtp(toE164Digits: string, code: string): Promise<void> {
  const token = process.env.WHATSAPP_ACCESS_TOKEN;
  const phoneNumberId = process.env.WHATSAPP_PHONE_NUMBER_ID;
  const templateName = process.env.WHATSAPP_OTP_TEMPLATE_NAME || 'otp_login';
  const templateLang = process.env.WHATSAPP_OTP_TEMPLATE_LANG || 'en_US';

  if (!token || !phoneNumberId) {
    if (process.env.NODE_ENV === 'production') {
      throw new WhatsAppNotConfiguredError();
    }
    // eslint-disable-next-line no-console
    console.log(`[dev] WhatsApp OTP for +${toE164Digits}: ${code}`);
    return;
  }

  const res = await fetch(
    `https://graph.facebook.com/${GRAPH_VERSION}/${phoneNumberId}/messages`,
    {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        messaging_product: 'whatsapp',
        to: toE164Digits,
        type: 'template',
        template: {
          name: templateName,
          language: { code: templateLang },
          components: [
            { type: 'body', parameters: [{ type: 'text', text: code }] },
            {
              type: 'button',
              sub_type: 'url',
              index: '0',
              parameters: [{ type: 'text', text: code }],
            },
          ],
        },
      }),
    },
  );

  if (!res.ok) {
    const body = await res.text().catch(() => '');
    throw new Error(`WhatsApp send failed (${res.status}): ${body}`);
  }
}
