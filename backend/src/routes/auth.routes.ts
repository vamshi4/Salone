import crypto from 'crypto';
import { Router } from 'express';
import { UserRole } from '@prisma/client';
import { requireRole, signToken } from '../auth';
import { hashPassword, verifyPassword } from '../password';
import { prisma } from '../index';
import { dialCodeFor } from '../country-dial-codes';
import { sendWhatsAppOtp } from '../whatsapp';
import { verifyGoogleIdToken } from '../google-auth';

const router = Router();

function publicUser(user: {
  id: string;
  phone: string;
  email: string | null;
  role: UserRole;
  name: string | null;
  createdAt?: Date;
}) {
  return {
    id: user.id,
    phone: user.phone,
    email: user.email,
    role: user.role,
    name: user.name,
    createdAt: user.createdAt,
  };
}

router.post('/login', async (req, res) => {
  try {
    const { phone, password = '', role = 'CUSTOMER' } = req.body;
    if (!phone || !Object.values(UserRole).includes(role)) {
      return res.status(400).json({ error: 'phone and valid role are required' });
    }

    const user = await prisma.user.findUnique({
      where: { phone },
    });

    if (
      !user ||
      user.deletedAt ||
      user.role !== role ||
      !verifyPassword(String(password), user.password)
    ) {
      return res.status(401).json({ error: 'Invalid login' });
    }

    res.json({
      token: signToken({ id: user.id, role: user.role, phone: user.phone }),
      user: publicUser(user),
    });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// POST /google-login — { idToken, role }. Logs in an EXISTING account only
// (matched by googleId, or by email on first use — which also auto-links the
// Google account for next time). Does not create new accounts; a first-time
// owner still goes through /salon-signup (with googleIdToken instead of a
// password) since that also needs salon name/address.
router.post('/google-login', async (req, res) => {
  try {
    const { idToken, role = 'SALON_OWNER' } = req.body;
    if (!idToken || !Object.values(UserRole).includes(role)) {
      return res.status(400).json({ error: 'idToken and valid role are required' });
    }

    let identity;
    try {
      identity = await verifyGoogleIdToken(String(idToken));
    } catch (e: any) {
      return res.status(401).json({ error: 'Google sign-in failed: ' + e.message });
    }

    let user = await prisma.user.findFirst({
      where: { googleId: identity.googleId, role, deletedAt: null },
    });

    if (!user) {
      const byEmail = await prisma.user.findFirst({
        where: { email: identity.email, role, deletedAt: null, googleId: null },
      });
      if (byEmail) {
        user = await prisma.user.update({
          where: { id: byEmail.id },
          data: { googleId: identity.googleId },
        });
      }
    }

    if (!user) {
      return res.status(404).json({
        error: 'No account found for this Google account. Sign up first.',
      });
    }

    res.json({
      token: signToken({ id: user.id, role: user.role, phone: user.phone }),
      user: publicUser(user),
    });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

router.post('/salon-signup', async (req, res) => {
  try {
    const { ownerName, phone, password, googleIdToken, salonName, address, lat = 0, lng = 0, countryCode, currency } = req.body;
    if (!ownerName || !phone || !salonName || !address || (!password && !googleIdToken)) {
      return res.status(400).json({
        error: 'ownerName, phone, salonName, address and either password or googleIdToken are required',
      });
    }
    if (password && String(password).length < 6) {
      return res.status(400).json({ error: 'Password must be at least 6 characters' });
    }

    // "Continue with Google" signup: no password at all, googleId is the
    // credential instead. Verified before touching the DB so a bad token
    // fails fast without creating a half-formed account.
    let google: { googleId: string; email: string } | null = null;
    if (googleIdToken) {
      try {
        const identity = await verifyGoogleIdToken(String(googleIdToken));
        google = { googleId: identity.googleId, email: identity.email };
      } catch (e: any) {
        return res.status(401).json({ error: 'Google sign-in failed: ' + e.message });
      }
    }

    const existing = await prisma.user.findUnique({
      where: { phone },
    });
    if (existing) {
      return res.status(409).json({ error: 'Phone already registered' });
    }
    if (google) {
      const existingGoogle = await prisma.user.findUnique({ where: { googleId: google.googleId } });
      if (existingGoogle) {
        return res.status(409).json({ error: 'This Google account is already linked to another user' });
      }
    }

    const result = await prisma.$transaction(async (tx) => {
      const user = await tx.user.create({
        data: {
          phone: String(phone).trim(),
          name: String(ownerName).trim(),
          role: 'SALON_OWNER',
          ...(password ? { password: hashPassword(String(password)) } : {}),
          ...(google ? { googleId: google.googleId, email: google.email } : {}),
        },
      });

      const salon = await tx.salon.create({
        data: {
          ownerId: user.id,
          name: String(salonName).trim(),
          address: String(address).trim(),
          // ponytail: signup keeps location optional for now; replace with picked lat/lng when mapping matters.
          lat: Number(lat) || 0,
          lng: Number(lng) || 0,
          ...(countryCode ? { countryCode: String(countryCode).trim().toUpperCase() } : {}),
          ...(currency ? { currency: String(currency).trim().toUpperCase() } : {}),
        },
      });

      return { user, salon };
    });

    res.status(201).json({
      token: signToken({
        id: result.user.id,
        role: result.user.role,
        phone: result.user.phone,
      }),
      user: {
        id: result.user.id,
        phone: result.user.phone,
        email: result.user.email,
        role: result.user.role,
        name: result.user.name,
        createdAt: result.user.createdAt,
      },
      salon: {
        id: result.salon.id,
        name: result.salon.name,
        address: result.salon.address,
        countryCode: result.salon.countryCode,
        currency: result.salon.currency,
      },
    });
  } catch (e: any) {
    if (e.code === 'P2002') {
      return res.status(409).json({ error: 'That email is already registered to another account' });
    }
    res.status(500).json({ error: e.message });
  }
});

router.get('/me', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user!.id },
      // cuids are creation-ordered, so this approximates "oldest branch
      // first" without needing a createdAt column on Salon.
      include: { salonOwned: { orderBy: { id: 'asc' } } },
    });
    if (!user) return res.status(404).json({ error: 'Account not found' });

    res.json({
      user: publicUser(user),
      // Legacy singular field, kept exactly as before multi-branch.
      // DO NOT REMOVE: mobile/salon_admin_app_v3 (live on Play Store) reads
      // this as one object and has no branch-switching UI to need `salons`.
      salon: user.salonOwned[0] ?? null,
      // New field: the full branch list, for clients built for multi-branch.
      salons: user.salonOwned,
    });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// Fields that only make sense scoped to a specific branch. Present in the
// body here only via the v3-compatibility shim below — v4_1+ should call
// PATCH /api/v2/salons/:salonId instead, which this shim redirects to
// internally for single-salon owners.
const LEGACY_SALON_FIELDS = ['salonName', 'address', 'lat', 'lng', 'countryCode', 'currency', 'dailyRevenueGoal'];

router.patch('/me', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { ownerName, phone, email } = req.body;
    const user = await prisma.user.findUnique({
      where: { id: req.user!.id },
      include: { salonOwned: { orderBy: { id: 'asc' } } },
    });
    if (!user) return res.status(404).json({ error: 'Account not found' });

    const nextPhone = phone == null ? user.phone : String(phone).trim();
    if (nextPhone.length < 6) {
      return res.status(400).json({ error: 'Phone must be at least 6 digits' });
    }

    const nextEmail =
      email == null || String(email).trim() === '' ? null : String(email).trim();
    const nextOwnerName =
      ownerName == null ? user.name : String(ownerName).trim();

    if (!nextOwnerName) {
      return res.status(400).json({ error: 'Owner name is required' });
    }

    // v3 compatibility shim: v3's AccountScreen sends salon fields in this
    // same request and has no branch-creation UI, so any v3 caller always
    // has exactly one salon — safe to apply legacy fields to it here. A
    // caller with more than one salon must use the new endpoint instead,
    // since "which branch" is ambiguous from this route alone.
    const legacyBody = req.body as Record<string, unknown>;
    const hasLegacySalonFields = LEGACY_SALON_FIELDS.some((f) => legacyBody[f] != null);
    if (hasLegacySalonFields && user.salonOwned.length > 1) {
      return res.status(400).json({
        error: 'This account has multiple salons — update a specific one via PATCH /api/v2/salons/:salonId',
      });
    }
    const { salonName, address, lat, lng, countryCode, currency, dailyRevenueGoal } = legacyBody as any;
    const targetSalon = user.salonOwned[0];
    if (hasLegacySalonFields && !targetSalon) {
      return res.status(404).json({ error: 'No salon found for this account' });
    }

    const nextSalonName =
      salonName == null ? targetSalon?.name : String(salonName).trim();
    const nextAddress =
      address == null ? targetSalon?.address : String(address).trim();
    if (targetSalon && (!nextSalonName || !nextAddress)) {
      return res.status(400).json({ error: 'Salon name and address are required' });
    }

    const result = await prisma.$transaction(async (tx) => {
      const updatedUser = await tx.user.update({
        where: { id: user.id },
        data: {
          name: nextOwnerName,
          phone: nextPhone,
          email: nextEmail,
        },
      });
      const updatedSalon = targetSalon
        ? await tx.salon.update({
            where: { id: targetSalon.id },
            data: {
              name: nextSalonName,
              address: nextAddress,
              ...(lat != null && Number.isFinite(Number(lat)) ? { lat: Number(lat) } : {}),
              ...(lng != null && Number.isFinite(Number(lng)) ? { lng: Number(lng) } : {}),
              ...(countryCode ? { countryCode: String(countryCode).trim().toUpperCase() } : {}),
              ...(currency ? { currency: String(currency).trim().toUpperCase() } : {}),
              ...(dailyRevenueGoal != null && Number.isFinite(Number(dailyRevenueGoal))
                ? { dailyRevenueGoal: Math.max(0, Math.round(Number(dailyRevenueGoal))) }
                : {}),
            },
          })
        : null;
      return { user: updatedUser, salon: updatedSalon };
    });

    res.json({
      user: publicUser(result.user),
      salon: result.salon,
    });
  } catch (e: any) {
    if (e.code === 'P2002') {
      return res.status(409).json({ error: 'Phone or email is already registered' });
    }
    res.status(500).json({ error: e.message });
  }
});

router.post('/change-password', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { currentPassword = '', newPassword } = req.body;
    if (!newPassword || String(newPassword).length < 6) {
      return res.status(400).json({ error: 'New password must be at least 6 characters' });
    }

    const user = await prisma.user.findUnique({ where: { id: req.user!.id } });
    if (!user) return res.status(404).json({ error: 'Account not found' });
    if (!verifyPassword(String(currentPassword), user.password)) {
      return res.status(401).json({ error: 'Current password is incorrect' });
    }

    await prisma.user.update({
      where: { id: user.id },
      data: { password: hashPassword(String(newPassword)) },
    });

    res.json({ ok: true });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// POST /link-google — { idToken }. For an already-logged-in user (still has
// their password) to attach a Google account, so future logins don't need
// the password — or the paid WhatsApp OTP reset — at all.
router.post('/link-google', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { idToken } = req.body;
    if (!idToken) return res.status(400).json({ error: 'idToken is required' });

    let identity;
    try {
      identity = await verifyGoogleIdToken(String(idToken));
    } catch (e: any) {
      return res.status(401).json({ error: 'Google sign-in failed: ' + e.message });
    }

    const conflict = await prisma.user.findUnique({ where: { googleId: identity.googleId } });
    if (conflict && conflict.id !== req.user!.id) {
      return res.status(409).json({ error: 'This Google account is already linked to another user' });
    }

    const user = await prisma.user.findUnique({ where: { id: req.user!.id } });
    if (!user) return res.status(404).json({ error: 'Account not found' });

    const updated = await prisma.user.update({
      where: { id: user.id },
      data: {
        googleId: identity.googleId,
        // Only fill email if this account doesn't already have a different
        // one set — never silently overwrite an email the owner chose.
        ...(user.email ? {} : { email: identity.email }),
      },
    });

    res.json({ ok: true, user: publicUser(updated) });
  } catch (e: any) {
    if (e.code === 'P2002') {
      return res.status(409).json({ error: 'That email is already registered to another account' });
    }
    res.status(500).json({ error: e.message });
  }
});

const OTP_TTL_MS = 10 * 60 * 1000;
const OTP_RESEND_COOLDOWN_MS = 60 * 1000;
const OTP_MAX_ATTEMPTS = 5;

// POST /forgot-password — { phone, role }. Always responds 200 with the same
// generic message whether or not the account exists, so this can't be used to
// enumerate registered phone numbers. Only actually sends a code (via
// WhatsApp) when the account is real.
router.post('/forgot-password', async (req, res) => {
  try {
    const { phone, role = 'SALON_OWNER' } = req.body;
    if (!phone || !Object.values(UserRole).includes(role)) {
      return res.status(400).json({ error: 'phone and valid role are required' });
    }

    const generic = { ok: true, message: 'If that account exists, a code was sent via WhatsApp.' };

    const user = await prisma.user.findFirst({
      where: { phone: String(phone).trim(), role, deletedAt: null },
      // "Oldest branch's country" once an owner can have several — a
      // deliberate simplification, not a real fix, for owners whose
      // branches span countries. Revisit only if that becomes a real issue.
      include: { salonOwned: { select: { countryCode: true }, orderBy: { id: 'asc' }, take: 1 } },
    });
    if (!user) return res.json(generic);

    if (user.resetOtpSentAt && Date.now() - user.resetOtpSentAt.getTime() < OTP_RESEND_COOLDOWN_MS) {
      return res.status(429).json({ error: 'Please wait a minute before requesting another code' });
    }

    const otp = String(crypto.randomInt(100000, 1000000));
    await prisma.user.update({
      where: { id: user.id },
      data: {
        resetOtpHash: hashPassword(otp),
        resetOtpExpiresAt: new Date(Date.now() + OTP_TTL_MS),
        resetOtpAttempts: 0,
        resetOtpSentAt: new Date(),
      },
    });

    const dialCode = dialCodeFor(user.salonOwned[0]?.countryCode);
    await sendWhatsAppOtp(`${dialCode}${user.phone}`, otp);

    res.json(generic);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// POST /reset-password-otp — { phone, role, otp, newPassword }. Verifies the
// code from /forgot-password and sets a new password in one step (no
// separate "verify OTP" round trip).
router.post('/reset-password-otp', async (req, res) => {
  try {
    const { phone, role = 'SALON_OWNER', otp, newPassword } = req.body;
    if (!phone || !otp || !newPassword || String(newPassword).length < 6) {
      return res.status(400).json({
        error: 'phone, otp and a newPassword of at least 6 characters are required',
      });
    }

    const invalid = { error: 'Invalid or expired code' };

    const user = await prisma.user.findFirst({
      where: { phone: String(phone).trim(), role, deletedAt: null },
    });
    if (!user || !user.resetOtpHash || !user.resetOtpExpiresAt) {
      return res.status(400).json(invalid);
    }
    if (user.resetOtpExpiresAt.getTime() < Date.now()) {
      return res.status(400).json(invalid);
    }
    if (user.resetOtpAttempts >= OTP_MAX_ATTEMPTS) {
      return res.status(400).json({ error: 'Too many attempts — request a new code' });
    }

    if (!verifyPassword(String(otp), user.resetOtpHash)) {
      await prisma.user.update({
        where: { id: user.id },
        data: { resetOtpAttempts: { increment: 1 } },
      });
      return res.status(400).json(invalid);
    }

    await prisma.user.update({
      where: { id: user.id },
      data: {
        password: hashPassword(String(newPassword)),
        resetOtpHash: null,
        resetOtpExpiresAt: null,
        resetOtpAttempts: 0,
        resetOtpSentAt: null,
      },
    });

    res.json({ ok: true });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// Development helper. Keep disabled in production.
router.post('/demo-token', async (req, res) => {
  try {
    if (process.env.NODE_ENV === 'production' || process.env.DEMO_AUTH_ENABLED !== 'true') {
      return res.status(404).json({ error: 'Not found' });
    }

    const { phone, role = 'CUSTOMER', name } = req.body;
    if (!phone || !Object.values(UserRole).includes(role)) {
      return res.status(400).json({ error: 'phone and valid role are required' });
    }

    const user = await prisma.user.upsert({
      where: { phone },
      update: { role, name },
      create: { phone, role, name },
    });

    res.json({
      token: signToken({ id: user.id, role: user.role, phone: user.phone }),
      user: publicUser(user),
    });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

export default router;
