import { Router } from 'express';
import { UserRole } from '@prisma/client';
import { signToken } from '../auth';
import { prisma } from '../index';

const router = Router();

// Development helper. Keep disabled in production.
router.post('/demo-token', async (req, res) => {
  try {
    if (process.env.DEMO_AUTH_ENABLED === 'false') {
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
      user: { id: user.id, phone: user.phone, role: user.role, name: user.name },
    });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

export default router;
