import { Router } from 'express';
import crypto from 'crypto';
import { UserRole } from '@prisma/client';
import { requireRole, signToken } from '../auth';
import { prisma } from '../index';

const router = Router();
const passwordPrefix = 'scrypt';

function hashPassword(password: string) {
  const salt = crypto.randomBytes(16).toString('hex');
  const hash = crypto.scryptSync(password, salt, 64).toString('hex');
  return `${passwordPrefix}$${salt}$${hash}`;
}

function verifyPassword(password: string, stored?: string | null) {
  if (!stored) return false;
  const [prefix, salt, hash] = stored.split('$');
  if (prefix !== passwordPrefix || !salt || !hash) return false;
  const candidate = crypto.scryptSync(password, salt, 64);
  return crypto.timingSafeEqual(Buffer.from(hash, 'hex'), candidate);
}

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

router.post('/salon-signup', async (req, res) => {
  try {
    const { ownerName, phone, password, salonName, address, lat = 0, lng = 0 } = req.body;
    if (!ownerName || !phone || !password || !salonName || !address) {
      return res.status(400).json({
        error: 'ownerName, phone, password, salonName and address are required',
      });
    }
    if (String(password).length < 6) {
      return res.status(400).json({ error: 'Password must be at least 6 characters' });
    }

    const existing = await prisma.user.findUnique({
      where: { phone },
    });
    if (existing) {
      return res.status(409).json({ error: 'Phone already registered' });
    }

    const result = await prisma.$transaction(async (tx) => {
      const user = await tx.user.create({
        data: {
          phone: String(phone).trim(),
          name: String(ownerName).trim(),
          role: 'SALON_OWNER',
          password: hashPassword(String(password)),
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
      },
    });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

router.get('/me', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user!.id },
      include: { salonOwned: true },
    });
    if (!user) return res.status(404).json({ error: 'Account not found' });

    res.json({
      user: publicUser(user),
      salon: user.salonOwned,
    });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

router.patch('/me', requireRole('SALON_OWNER', 'SUPER_ADMIN'), async (req, res) => {
  try {
    const { ownerName, phone, email, salonName, address, lat, lng } = req.body;
    const user = await prisma.user.findUnique({
      where: { id: req.user!.id },
      include: { salonOwned: true },
    });
    if (!user || !user.salonOwned) {
      return res.status(404).json({ error: 'Salon owner account not found' });
    }

    const nextPhone = phone == null ? user.phone : String(phone).trim();
    if (nextPhone.length < 6) {
      return res.status(400).json({ error: 'Phone must be at least 6 digits' });
    }

    const nextEmail =
      email == null || String(email).trim() === '' ? null : String(email).trim();
    const nextOwnerName =
      ownerName == null ? user.name : String(ownerName).trim();
    const nextSalonName =
      salonName == null ? user.salonOwned.name : String(salonName).trim();
    const nextAddress =
      address == null ? user.salonOwned.address : String(address).trim();

    if (!nextOwnerName || !nextSalonName || !nextAddress) {
      return res.status(400).json({ error: 'Owner, salon name and address are required' });
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
      const updatedSalon = await tx.salon.update({
        where: { id: user.salonOwned!.id },
        data: {
          name: nextSalonName,
          address: nextAddress,
          ...(lat != null && Number.isFinite(Number(lat)) ? { lat: Number(lat) } : {}),
          ...(lng != null && Number.isFinite(Number(lng)) ? { lng: Number(lng) } : {}),
        },
      });
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
