// Public, unauthenticated review page + submit endpoint — same
// zero-framework approach as public-booking.ts. The bookingId itself
// (an unguessable cuid) is the access token: whoever holds the link the
// salon shares after a completed visit can rate it, no login needed.
import type { Application, Request, Response } from 'express';
import { prisma } from './index';

function escapeHtml(value: string): string {
  return value
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

function messagePage(title: string, body: string): string {
  return `<!doctype html>
<html lang="en"><head><meta charset="utf-8"><title>${escapeHtml(title)}</title>
<meta name="viewport" content="width=device-width, initial-scale=1"></head>
<body style="font-family:system-ui,-apple-system,'Segoe UI',Roboto,sans-serif;text-align:center;padding:60px 20px;color:#1A1A1A;">
<h1>${escapeHtml(title)}</h1><p>${escapeHtml(body)}</p>
</body></html>`;
}

function reviewPageHtml(booking: {
  id: string;
  salonName: string;
  stylistName: string;
  serviceNames: string[];
}): string {
  return `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Rate your visit to ${escapeHtml(booking.salonName)}</title>
<style>
  :root { --ink:#1A1A1A; --muted:#6B6B6B; --accent:#E91E76; --border:#ECECEE; }
  * { box-sizing:border-box; }
  body { margin:0; background:#fff; color:var(--ink);
    font-family:system-ui,-apple-system,"Segoe UI",Roboto,sans-serif; line-height:1.5; }
  .wrap { max-width:480px; margin:0 auto; padding:28px 20px 60px; }
  h1 { font-size:22px; margin:0 0 2px; }
  .sub { color:var(--muted); font-size:13px; margin:0 0 24px; }
  label.field { display:block; font-size:13px; font-weight:600; color:var(--muted); margin:20px 0 8px; }
  .stars { display:flex; gap:6px; }
  .stars button { font-size:28px; background:none; border:none; cursor:pointer; padding:0; color:var(--border); line-height:1; }
  .stars button.on { color:#F5A623; }
  textarea { width:100%; padding:12px 14px; border:1px solid var(--border); border-radius:12px;
    font-size:15px; color:var(--ink); background:#fff; font-family:inherit; resize:vertical; min-height:70px; }
  button#submitBtn { width:100%; margin-top:26px; padding:14px; border:none; border-radius:999px;
    background:var(--accent); color:#fff; font-size:16px; font-weight:700; cursor:pointer; }
  button#submitBtn:disabled { opacity:0.6; }
  .error { color:#C0392B; font-size:13px; margin-top:10px; display:none; }
  .success { text-align:center; padding:40px 0; display:none; }
  .success h2 { margin-bottom:8px; }
  .success p { color:var(--muted); }
</style>
</head>
<body>
<div class="wrap">
  <div id="formView">
    <h1>How was your visit?</h1>
    <p class="sub">${escapeHtml(booking.serviceNames.join(', '))} with ${escapeHtml(booking.stylistName)} at ${escapeHtml(booking.salonName)}</p>

    <label class="field">Rate ${escapeHtml(booking.stylistName)}</label>
    <div class="stars" data-target="stylistRating">
      <button type="button" data-value="1">★</button>
      <button type="button" data-value="2">★</button>
      <button type="button" data-value="3">★</button>
      <button type="button" data-value="4">★</button>
      <button type="button" data-value="5">★</button>
    </div>

    <label class="field">Comment about ${escapeHtml(booking.stylistName)} (optional)</label>
    <textarea id="stylistComment"></textarea>

    <label class="field">Rate ${escapeHtml(booking.salonName)}</label>
    <div class="stars" data-target="salonRating">
      <button type="button" data-value="1">★</button>
      <button type="button" data-value="2">★</button>
      <button type="button" data-value="3">★</button>
      <button type="button" data-value="4">★</button>
      <button type="button" data-value="5">★</button>
    </div>

    <label class="field">Comment about the salon (optional)</label>
    <textarea id="salonComment"></textarea>

    <button id="submitBtn" type="button">Submit review</button>
    <p class="error" id="errorMsg"></p>
  </div>
  <div class="success" id="successView">
    <h2>Thank you!</h2>
    <p>Your review helps ${escapeHtml(booking.salonName)} improve.</p>
  </div>
</div>
<script>
  var ratings = { stylistRating: 0, salonRating: 0 };
  document.querySelectorAll('.stars').forEach(function (group) {
    var target = group.getAttribute('data-target');
    var buttons = Array.prototype.slice.call(group.querySelectorAll('button'));
    buttons.forEach(function (btn) {
      btn.addEventListener('click', function () {
        var value = parseInt(btn.getAttribute('data-value'), 10);
        ratings[target] = value;
        buttons.forEach(function (b) {
          b.classList.toggle('on', parseInt(b.getAttribute('data-value'), 10) <= value);
        });
      });
    });
  });

  document.getElementById('submitBtn').addEventListener('click', async function () {
    var errorEl = document.getElementById('errorMsg');
    errorEl.style.display = 'none';
    if (!ratings.stylistRating && !ratings.salonRating) {
      errorEl.textContent = 'Please choose at least one rating';
      errorEl.style.display = 'block';
      return;
    }
    var body = {
      stylistRating: ratings.stylistRating || undefined,
      salonRating: ratings.salonRating || undefined,
      stylistComment: document.getElementById('stylistComment').value.trim() || undefined,
      salonComment: document.getElementById('salonComment').value.trim() || undefined,
    };
    var btn = document.getElementById('submitBtn');
    btn.disabled = true;
    btn.textContent = 'Submitting…';
    try {
      var res = await fetch(${JSON.stringify(`/api/v2/public/bookings/${booking.id}/review`)}, {
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
      btn.textContent = 'Submit review';
    }
  });
</script>
</body>
</html>`;
}

// Recomputes the running rating/totalReviews aggregate for one stylist from
// every review left across their bookings — simple full recompute rather
// than an incremental update, cheap at this scale and avoids drift.
async function recomputeStylistRating(stylistId: string): Promise<void> {
  const reviews = await prisma.review.findMany({
    where: { booking: { stylistId }, stylistRating: { not: null } },
    select: { stylistRating: true },
  });
  const total = reviews.length;
  const avg = total > 0 ? reviews.reduce((sum, r) => sum + (r.stylistRating ?? 0), 0) / total : 0;
  await prisma.stylist.update({ where: { id: stylistId }, data: { rating: avg, totalReviews: total } });
}

async function recomputeSalonRating(salonId: string): Promise<void> {
  const reviews = await prisma.review.findMany({
    where: { booking: { salonId }, salonRating: { not: null } },
    select: { salonRating: true },
  });
  const total = reviews.length;
  const avg = total > 0 ? reviews.reduce((sum, r) => sum + (r.salonRating ?? 0), 0) / total : 0;
  await prisma.salon.update({ where: { id: salonId }, data: { rating: avg, totalReviews: total } });
}

export function registerPublicReviewRoutes(app: Application): void {
  app.get('/review/:bookingId', async (req: Request, res: Response) => {
    try {
      const booking = await prisma.booking.findUnique({
        where: { id: req.params.bookingId },
        include: {
          salon: true,
          stylist: { include: { user: true } },
          services: { include: { service: true }, orderBy: { sortOrder: 'asc' } },
          service: true,
          review: true,
        },
      });
      if (!booking || !booking.salon) {
        return res.status(404).type('html').send(messagePage('Link not found', 'This review link is no longer valid.'));
      }
      if (booking.status !== 'COMPLETED') {
        return res
          .status(400)
          .type('html')
          .send(messagePage('Not ready yet', 'This visit hasn’t been completed yet, so it can’t be reviewed.'));
      }
      if (booking.review) {
        return res
          .type('html')
          .send(messagePage('Already reviewed', 'You’ve already shared feedback for this visit — thank you!'));
      }

      const serviceNames = booking.services.length
        ? booking.services.map((s) => s.service.name)
        : [booking.service.name];

      res.type('html').send(
        reviewPageHtml({
          id: booking.id,
          salonName: booking.salon.name,
          stylistName: booking.stylist?.user.name || 'your stylist',
          serviceNames,
        })
      );
    } catch (e: any) {
      res.status(500).type('html').send(messagePage('Something went wrong', 'Please try again later.'));
    }
  });

  app.post('/api/v2/public/bookings/:bookingId/review', async (req: Request, res: Response) => {
    try {
      const { stylistRating, salonRating, stylistComment, salonComment } = req.body ?? {};

      const ratingsToCheck = [stylistRating, salonRating].filter((v) => v != null);
      if (ratingsToCheck.length === 0) {
        return res.status(400).json({ error: 'At least one rating is required' });
      }
      for (const r of ratingsToCheck) {
        if (!Number.isInteger(r) || r < 1 || r > 5) {
          return res.status(400).json({ error: 'Ratings must be whole numbers from 1 to 5' });
        }
      }

      const booking = await prisma.booking.findUnique({
        where: { id: req.params.bookingId },
        include: { review: true },
      });
      if (!booking || !booking.salonId) return res.status(404).json({ error: 'Booking not found' });
      if (booking.status !== 'COMPLETED') {
        return res.status(400).json({ error: 'This visit hasn’t been completed yet' });
      }
      if (booking.review) return res.status(409).json({ error: 'This visit has already been reviewed' });

      const flaggedToSalon = [stylistRating, salonRating].some((r) => typeof r === 'number' && r <= 2);

      await prisma.review.create({
        data: {
          bookingId: booking.id,
          customerId: booking.customerId,
          stylistRating: stylistRating ?? null,
          salonRating: salonRating ?? null,
          stylistComment: stylistComment ?? null,
          salonComment: salonComment ?? null,
          reviewTargetType: 'BOTH',
          flaggedToSalon,
          flagReason: flaggedToSalon ? 'Low rating' : null,
        },
      });

      if (booking.stylistId && stylistRating != null) await recomputeStylistRating(booking.stylistId);
      if (salonRating != null) await recomputeSalonRating(booking.salonId);

      res.status(201).json({ ok: true });
    } catch (e: any) {
      res.status(500).json({ error: e.message });
    }
  });
}
