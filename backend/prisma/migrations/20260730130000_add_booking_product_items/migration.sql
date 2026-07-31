-- Retail products sold alongside a booking at completion. price is a
-- retailPrice snapshot (paise), same reasoning as Booking.commissionSnapshot.
CREATE TABLE "BookingProductItem" (
    "id" TEXT NOT NULL,
    "bookingId" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 1,
    "price" INTEGER NOT NULL,

    CONSTRAINT "BookingProductItem_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "BookingProductItem_bookingId_productId_key" ON "BookingProductItem"("bookingId", "productId");
CREATE INDEX "BookingProductItem_productId_idx" ON "BookingProductItem"("productId");

ALTER TABLE "BookingProductItem" ADD CONSTRAINT "BookingProductItem_bookingId_fkey"
  FOREIGN KEY ("bookingId") REFERENCES "Booking"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "BookingProductItem" ADD CONSTRAINT "BookingProductItem_productId_fkey"
  FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
