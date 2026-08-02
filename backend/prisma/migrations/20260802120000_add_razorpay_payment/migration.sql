-- Adds RAZORPAY as a verifiable online payment method (unlike CASH/CARD/UPI,
-- which are self-reported by staff) and a column to track the Razorpay
-- order before payment completes. paymentId (existing column) stores the
-- Razorpay payment_id once paid.
ALTER TYPE "PaymentMethod" ADD VALUE 'RAZORPAY';

ALTER TABLE "Booking" ADD COLUMN "razorpayOrderId" TEXT;
