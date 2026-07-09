import express, { Request, Response } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { PrismaClient } from '@prisma/client';
import stylistRoutes from './routes/stylist.routes';
import bookingRoutes from './routes/booking.routes';
import salonRoutes from './routes/salon.routes';
import authRoutes from './routes/auth.routes';
import { authOptional } from './auth';
import { privacyHtml } from './privacy';
import { deleteAccountHtml } from './delete-account';

dotenv.config();
export const prisma = new PrismaClient();
const app = express();
const PORT = process.env.PORT || 3000;
const allowedOrigins = (process.env.CORS_ORIGIN || '')
  .split(',')
  .map((origin) => origin.trim())
  .filter(Boolean);

app.set('trust proxy', 1);
app.use(
  cors({
    origin(origin, callback) {
      if (!origin || allowedOrigins.length === 0 || allowedOrigins.includes(origin)) {
        callback(null, true);
        return;
      }

      callback(new Error('Not allowed by CORS'));
    },
  }),
);
app.use(express.json({ limit: process.env.JSON_LIMIT || '1mb' }));
app.use(authOptional);

app.get('/health', (req: Request, res: Response) => {
  res.json({ status: 'ok', version: '2.0.0' });
});

// Public privacy policy (used for the Play Store listing / Data Safety form).
app.get('/privacy', (_req: Request, res: Response) => {
  res.type('html').send(privacyHtml);
});

// Public account-deletion instructions (required by Play Data safety).
app.get('/delete-account', (_req: Request, res: Response) => {
  res.type('html').send(deleteAccountHtml);
});

// Public app-config: minimum supported version per app (drives force-update).
// Bump via env (e.g. SALON_ADMIN_MIN_VERSION=2.1.0) without shipping code.
app.get('/api/v2/app-config', (_req: Request, res: Response) => {
  res.json({
    salonAdminMinVersion: process.env.SALON_ADMIN_MIN_VERSION || '2.0.0',
    customerMinVersion: process.env.CUSTOMER_MIN_VERSION || '2.0.0',
    stylistMinVersion: process.env.STYLIST_MIN_VERSION || '2.0.0',
    salonAdminStoreUrl:
      process.env.SALON_ADMIN_STORE_URL ||
      'https://play.google.com/store/apps/details?id=com.chairful.admin',
  });
});

// Mount v2 routes
app.use('/api/v2/auth', authRoutes);
app.use('/api/v2/stylists', stylistRoutes);
app.use('/api/v2/bookings', bookingRoutes);
app.use('/api/v2/salons', salonRoutes);
app.use('/v2/bookings', bookingRoutes);

app.use((err: Error, _req: Request, res: Response, _next: Function) => {
  console.error(err);
  res.status(500).json({ error: 'Internal server error' });
});

const server = app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

async function shutdown(signal: string) {
  console.log(`${signal} received, shutting down`);
  server.close(async () => {
    await prisma.$disconnect();
    process.exit(0);
  });
}

process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));
