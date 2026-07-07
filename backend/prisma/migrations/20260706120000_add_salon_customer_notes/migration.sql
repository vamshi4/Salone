CREATE TABLE "SalonCustomer" (
    "id" TEXT NOT NULL,
    "salonId" TEXT NOT NULL,
    "customerId" TEXT NOT NULL,
    "notes" TEXT NOT NULL DEFAULT '',
    "tags" JSONB NOT NULL DEFAULT '[]',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SalonCustomer_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "SalonCustomer_salonId_customerId_key" ON "SalonCustomer"("salonId", "customerId");
CREATE INDEX "SalonCustomer_customerId_idx" ON "SalonCustomer"("customerId");

ALTER TABLE "SalonCustomer" ADD CONSTRAINT "SalonCustomer_salonId_fkey" FOREIGN KEY ("salonId") REFERENCES "Salon"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SalonCustomer" ADD CONSTRAINT "SalonCustomer_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
