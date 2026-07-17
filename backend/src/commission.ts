// Shared by booking.routes.ts and public-booking.ts (siblings — can't import
// from each other) to compute the stylist/salon revenue split at booking
// creation time. Reads SalonStylist.commissionRate, which existed in the
// schema with a default of 70 but had zero read/write call sites anywhere —
// every booking-creation site independently hardcoded a 70/30 split instead.
// This makes that split actually configurable per stylist-salon relationship,
// while staying behavior-neutral for every relationship that hasn't been
// customized away from the schema default.
import type { PrismaClient } from '@prisma/client';

export async function commissionSplit(
  prisma: PrismaClient,
  salonId: string | null | undefined,
  stylistId: string,
): Promise<{ stylistPct: number; salonPct: number }> {
  // An independent stylist (no salon) keeps the pre-existing hardcoded 70%,
  // with no salon cut (the other 30% isn't attributed anywhere in that case)
  // — matches current behavior exactly, not something to change here.
  if (!salonId) return { stylistPct: 70, salonPct: 0 };

  const relation = await prisma.salonStylist.findUnique({
    where: { salonId_stylistId: { salonId, stylistId } },
  });
  // SALARY-only staff aren't paid per booking — their pay comes from the
  // fixed monthly salary settlement instead, so the salon keeps 100% of
  // the booking revenue here. BOTH keeps the normal commission split on
  // top of the salary.
  if (relation?.payType === 'SALARY') return { stylistPct: 0, salonPct: 100 };
  const stylistPct = relation?.commissionRate ?? 70;
  return { stylistPct, salonPct: 100 - stylistPct };
}
