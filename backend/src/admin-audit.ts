import { Prisma } from '@prisma/client';

// One row per super-admin write/delete. Guardrail #4: no mutation goes
// unrecorded. Always call this with the *transaction* client so the audit row
// and the change it describes commit (or roll back) together.

export type AuditEntry = {
  actorId: string;
  action: string; // e.g. "salon.update" | "salon.delete" | "user.reset-password"
  targetType: string; // "Salon" | "User" | "Booking" | ...
  targetId: string;
  before?: unknown; // snapshot before the change; omit secrets (password hash)
  after?: unknown; // snapshot after
};

function toJson(value: unknown): Prisma.InputJsonValue | typeof Prisma.JsonNull | undefined {
  if (value === undefined) return undefined;
  if (value === null) return Prisma.JsonNull;
  return value as Prisma.InputJsonValue;
}

export function writeAudit(tx: Prisma.TransactionClient, entry: AuditEntry) {
  return tx.adminAuditLog.create({
    data: {
      actorId: entry.actorId,
      action: entry.action,
      targetType: entry.targetType,
      targetId: entry.targetId,
      before: toJson(entry.before),
      after: toJson(entry.after),
    },
  });
}
