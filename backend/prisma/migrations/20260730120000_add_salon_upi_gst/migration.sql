-- Salon's own UPI ID (VPA) for the payment QR shown at booking completion,
-- and a GST toggle/rate so that QR's amount can include GST when the owner
-- is GST-registered.
ALTER TABLE "Salon" ADD COLUMN "upiId" TEXT;
ALTER TABLE "Salon" ADD COLUMN "gstEnabled" BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE "Salon" ADD COLUMN "gstRate" INTEGER NOT NULL DEFAULT 18;
