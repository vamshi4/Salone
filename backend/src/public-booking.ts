// Public, unauthenticated client self-booking page and submit endpoint.
// GET /book/:salonId renders a plain HTML form (no build step, same
// zero-framework approach as privacy.ts/admin-page.ts) listing the salon's
// services/stylists; its inline script POSTs the request as JSON. The
// created booking lands as a normal PENDING booking, so it flows straight
// into the existing owner-side "Needs Action" confirm/reject flow with no
// changes needed there.
import type { Application, Request, Response } from 'express';
import { prisma } from './index';
import { commissionSplit } from './commission';

const disabledPassword = 'disabled';
const MAX_PENDING_PER_CUSTOMER = 3;
const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

// Finds the CUSTOMER user for a phone number, creating a stub account if
// none exists yet — shared by the booking submit handler below, which needs
// to attach state (name, email) to a User row before a real booking exists.
async function findOrCreateCustomer(phone: string, name?: string) {
  const normalizedPhone = String(phone).trim();
  let user = await prisma.user.findUnique({ where: { phone: normalizedPhone } });
  if (user) {
    if (name && name !== user.name) {
      user = await prisma.user.update({ where: { id: user.id }, data: { name: String(name).trim() } });
    }
    return user;
  }
  return prisma.user.create({
    data: {
      phone: normalizedPhone,
      name: name ? String(name).trim() : null,
      role: 'CUSTOMER',
      password: disabledPassword,
    },
  });
}

function escapeHtml(value: string): string {
  return value
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

function notFoundPage(): string {
  return `<!doctype html>
<html lang="en"><head><meta charset="utf-8"><title>Salon not found</title>
<meta name="viewport" content="width=device-width, initial-scale=1"></head>
<body style="font-family:system-ui,-apple-system,'Segoe UI',Roboto,sans-serif;text-align:center;padding:60px 20px;color:#1A1A1A;">
<h1>Salon not found</h1><p>This booking link is no longer valid.</p>
</body></html>`;
}

function bookingPageHtml(salon: {
  id: string;
  name: string;
  address: string;
  stylists: { stylist: { id: string; user: { name: string | null } } }[];
  services: { id: string; name: string; category: string; duration: number; basePrice: number }[];
}): string {
  const stylistOptions = salon.stylists
    .map(
      (s) =>
        `<option value="${escapeHtml(s.stylist.id)}">${escapeHtml(s.stylist.user.name || 'Stylist')}</option>`,
    )
    .join('');

  const serviceRows = salon.services
    .map((svc) => {
      const rupees = (svc.basePrice / 100).toFixed(0);
      return `<label class="svc">
        <input type="checkbox" name="serviceIds" value="${escapeHtml(svc.id)}">
        <span>${escapeHtml(svc.name)} <em>${escapeHtml(svc.category)}</em></span>
        <span class="price">₹${rupees} · ${svc.duration} min</span>
      </label>`;
    })
    .join('');

  return `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Book at ${escapeHtml(salon.name)}</title>
<style>
  :root { --ink:#1A1A1A; --muted:#6B6B6B; --accent:#E91E76; --accent-soft:#FDEAF1; --border:#ECECEE; }
  * { box-sizing:border-box; }
  body { margin:0; background:#fff; color:var(--ink);
    font-family:system-ui,-apple-system,"Segoe UI",Roboto,sans-serif; line-height:1.5; }
  .wrap { max-width:480px; margin:0 auto; padding:28px 20px 60px; }
  h1 { font-size:22px; margin:0 0 2px; }
  .addr { color:var(--muted); font-size:13px; margin:0 0 24px; }
  label.field { display:block; font-size:13px; font-weight:600; color:var(--muted); margin:16px 0 6px; }
  input[type="text"], input[type="tel"], input[type="datetime-local"], select {
    width:100%; padding:12px 14px; border:1px solid var(--border); border-radius:12px;
    font-size:15px; color:var(--ink); background:#fff;
  }
  .services { border:1px solid var(--border); border-radius:12px; padding:6px; margin-top:6px; }
  .svc { display:flex; align-items:center; gap:10px; padding:10px 8px; font-size:14px; cursor:pointer; }
  .svc:not(:last-child) { border-bottom:1px solid var(--border); }
  .svc em { font-style:normal; color:var(--muted); font-size:12px; margin-left:4px; }
  .svc .price { margin-left:auto; color:var(--muted); font-size:13px; white-space:nowrap; }
  button { width:100%; margin-top:22px; padding:14px; border:none; border-radius:999px;
    background:var(--accent); color:#fff; font-size:16px; font-weight:700; cursor:pointer; }
  button:disabled { opacity:0.6; }
  .error { color:#C0392B; font-size:13px; margin-top:10px; display:none; }
  .success { text-align:center; padding:40px 0; display:none; }
  .success h2 { margin-bottom:8px; }
  .success p { color:var(--muted); }
</style>
</head>
<body>
<div class="wrap">
  <div id="formView">
    <h1>Book at ${escapeHtml(salon.name)}</h1>
    <p class="addr">${escapeHtml(salon.address)}</p>

    <label class="field">Your name</label>
    <input type="text" id="customerName" required>

    <label class="field">Your phone number</label>
    <input type="tel" id="customerPhone" required>

    <label class="field">Email (optional)</label>
    <input type="text" id="customerEmail" placeholder="you@example.com">

    <label class="field">Stylist</label>
    <select id="stylistId" required>${stylistOptions}</select>

    <label class="field">Services</label>
    <div class="services">${serviceRows}</div>

    <label class="field">Preferred date &amp; time</label>
    <input type="datetime-local" id="requestedAt" required>

    <button id="submitBtn" type="button">Request booking</button>
    <p class="error" id="errorMsg"></p>
  </div>
  <div class="success" id="successView">
    <h2>Request sent</h2>
    <p>${escapeHtml(salon.name)} will confirm your booking shortly.</p>
  </div>
</div>
<script>
  document.getElementById('submitBtn').addEventListener('click', async function () {
    var errorEl = document.getElementById('errorMsg');
    errorEl.style.display = 'none';

    var serviceIds = Array.prototype.slice
      .call(document.querySelectorAll('input[name="serviceIds"]:checked'))
      .map(function (el) { return el.value; });

    var body = {
      customerName: document.getElementById('customerName').value.trim(),
      customerPhone: document.getElementById('customerPhone').value.trim(),
      customerEmail: document.getElementById('customerEmail').value.trim(),
      stylistId: document.getElementById('stylistId').value,
      serviceIds: serviceIds,
      requestedAt: document.getElementById('requestedAt').value,
    };

    var btn = document.getElementById('submitBtn');
    btn.disabled = true;
    btn.textContent = 'Sending…';
    try {
      var res = await fetch(${JSON.stringify(`/api/v2/public/salons/${salon.id}/bookings`)}, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
      });
      var data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Something went wrong');
      document.getElementById('formView').style.display = 'none';
      document.getElementById('successView').style.display = 'block';
    } catch (e) {
      errorEl.textContent = e.message;
      errorEl.style.display = 'block';
      btn.disabled = false;
      btn.textContent = 'Request booking';
    }
  });
</script>
</body>
</html>`;
}

export function registerPublicBookingRoutes(app: Application): void {
  app.get('/book/:salonId', async (req: Request, res: Response) => {
    try {
      const salon = await prisma.salon.findFirst({
        where: { id: req.params.salonId, deletedAt: null },
        include: {
          services: true,
          stylists: {
            where: { status: 'ACTIVE', stylist: { deletedAt: null } },
            include: { stylist: { include: { user: true } } },
          },
        },
      });
      if (!salon) return res.status(404).type('html').send(notFoundPage());
      res.type('html').send(bookingPageHtml(salon));
    } catch (e: any) {
      res.status(500).type('html').send(notFoundPage());
    }
  });

  app.post('/api/v2/public/salons/:salonId/bookings', async (req: Request, res: Response) => {
    try {
      const { salonId } = req.params;
      const { customerName, customerPhone, customerEmail, stylistId, serviceIds, requestedAt } = req.body ?? {};

      if (customerEmail && !EMAIL_RE.test(String(customerEmail).trim())) {
        return res.status(400).json({ error: 'That email address doesn\'t look right' });
      }

      const requestedServiceIds = Array.isArray(serviceIds) ? serviceIds.filter(Boolean) : [];
      if (
        !customerName ||
        String(customerName).trim().length < 2 ||
        !customerPhone ||
        String(customerPhone).trim().length < 6 ||
        !stylistId ||
        requestedServiceIds.length === 0 ||
        !requestedAt
      ) {
        return res.status(400).json({
          error: 'Name, phone, stylist, at least one service, and a preferred date/time are required',
        });
      }

      const requestedDate = new Date(requestedAt);
      if (Number.isNaN(requestedDate.getTime()) || requestedDate.getTime() < Date.now() - 5 * 60 * 1000) {
        return res.status(400).json({ error: 'Please choose a valid future date and time' });
      }

      const salon = await prisma.salon.findFirst({ where: { id: salonId, deletedAt: null } });
      if (!salon) return res.status(404).json({ error: 'Salon not found' });

      const stylist = await prisma.stylist.findFirst({
        where: {
          id: stylistId,
          deletedAt: null,
          salonStylists: { some: { salonId, status: 'ACTIVE' } },
        },
      });
      if (!stylist) return res.status(404).json({ error: 'Stylist not found for this salon' });

      const services = await prisma.service.findMany({
        where: { id: { in: requestedServiceIds }, salonId },
      });
      if (services.length !== requestedServiceIds.length) {
        return res.status(404).json({ error: 'One or more services were not found for this salon' });
      }

      let customer = await findOrCreateCustomer(customerPhone, customerName);

      // Email is optional and best-effort: it's a plain unique field, so if
      // it's already taken by a different account, just skip silently
      // rather than blocking the booking over it.
      if (customerEmail) {
        const normalizedEmail = String(customerEmail).trim();
        if (normalizedEmail !== customer.email) {
          const emailTaken = await prisma.user.findUnique({ where: { email: normalizedEmail } });
          if (!emailTaken) {
            customer = await prisma.user.update({ where: { id: customer.id }, data: { email: normalizedEmail } });
          }
        }
      }

      // Cheap abuse guard: a public, unauthenticated endpoint has no
      // requireRole gate at all, so cap how many un-confirmed requests one
      // phone number can pile up at a given salon.
      const pendingCount = await prisma.booking.count({
        where: { salonId, customerId: customer.id, status: 'PENDING' },
      });
      if (pendingCount >= MAX_PENDING_PER_CUSTOMER) {
        return res.status(429).json({
          error: 'You already have pending booking requests here. Please wait for the salon to confirm them.',
        });
      }

      const totalDuration = services.reduce((total, item) => total + item.duration, 0);
      const price = services.reduce((total, item) => total + item.basePrice, 0);
      const slotEnd = new Date(requestedDate.getTime() + totalDuration * 60 * 1000);
      const primaryService = services[0];
      const { stylistPct, salonPct } = await commissionSplit(prisma, salonId, stylistId);

      const booking = await prisma.booking.create({
        data: {
          customerId: customer.id,
          providerType: 'SALON',
          salonId,
          stylistId,
          serviceId: primaryService.id,
          bookedVia: 'PUBLIC_PAGE',
          serviceType: 'IN_SALON',
          slotStart: requestedDate,
          slotEnd,
          originalDateTime: requestedDate,
          price,
          platformFee: 0,
          travelFee: 0,
          stylistPayout: Math.round(price * (stylistPct / 100)),
          salonPayout: Math.round(price * (salonPct / 100)),
          commissionSnapshot: { stylist: stylistPct, salon: salonPct, source: 'PUBLIC_PAGE' },
          status: 'PENDING',
          services: {
            create: services.map((item, index) => ({ serviceId: item.id, sortOrder: index })),
          },
        },
      });

      res.status(201).json({ id: booking.id });
    } catch (e: any) {
      res.status(500).json({ error: e.message });
    }
  });
}
