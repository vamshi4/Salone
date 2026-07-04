import express, { Request, Response } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { PrismaClient } from '@prisma/client';
import stylistRoutes from './routes/stylist.routes';
import bookingRoutes from './routes/booking.routes';
import salonRoutes from './routes/salon.routes';

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

app.get('/health', (req: Request, res: Response) => {
  res.json({ status: 'ok', version: '2.0.0' });
});

// Mount v2 routes
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
