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

app.use(cors());
app.use(express.json());

app.get('/health', (req: Request, res: Response) => {
  res.json({ status: 'ok', version: '2.0.0' });
});

// Mount v2 routes
app.use('/api/v2/stylists', stylistRoutes);
app.use('/api/v2/bookings', bookingRoutes);
app.use('/api/v2/salons', salonRoutes);
app.use('/v2/bookings', bookingRoutes);

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
