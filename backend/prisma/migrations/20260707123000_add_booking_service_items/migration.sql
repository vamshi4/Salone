CREATE TABLE "BookingServiceItem" (
    "id" TEXT NOT NULL,
    "bookingId" TEXT NOT NULL,
    "serviceId" TEXT NOT NULL,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "BookingServiceItem_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "BookingServiceItem_bookingId_serviceId_key" ON "BookingServiceItem"("bookingId", "serviceId");
CREATE INDEX "BookingServiceItem_serviceId_idx" ON "BookingServiceItem"("serviceId");

ALTER TABLE "BookingServiceItem"
ADD CONSTRAINT "BookingServiceItem_bookingId_fkey"
FOREIGN KEY ("bookingId") REFERENCES "Booking"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "BookingServiceItem"
ADD CONSTRAINT "BookingServiceItem_serviceId_fkey"
FOREIGN KEY ("serviceId") REFERENCES "Service"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

INSERT INTO "BookingServiceItem" ("id", "bookingId", "serviceId", "sortOrder")
SELECT gen_random_uuid()::text, "id", "serviceId", 0
FROM "Booking";
