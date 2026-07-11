// Create (or promote) the platform's first SUPER_ADMIN — the account that can
// sign into /admin. Credentials come from the operator, never hardcoded here.
//
// Usage (either form):
//   npx tsx prisma/create-super-admin.ts <phone> <password> [name]
//   SUPER_ADMIN_PHONE=... SUPER_ADMIN_PASSWORD=... [SUPER_ADMIN_NAME=...] npx tsx prisma/create-super-admin.ts
//
// Idempotent: if the phone already exists it is promoted to SUPER_ADMIN and its
// password is reset. Password uses the same scrypt hash as auth login, so the
// account can sign in immediately. Min 12 chars (matches the admin reset-password
// endpoint). The password is never printed or logged.

import { PrismaClient } from '@prisma/client';
import { hashPassword } from '../src/password';

const MIN_PASSWORD = 12;

async function main() {
  const [argPhone, argPassword, argName] = process.argv.slice(2);
  const phone = (argPhone || process.env.SUPER_ADMIN_PHONE || '').trim();
  const password = argPassword || process.env.SUPER_ADMIN_PASSWORD || '';
  const name = (argName || process.env.SUPER_ADMIN_NAME || 'Super Admin').trim();

  if (!phone || !password) {
    console.error(
      'Usage: npx tsx prisma/create-super-admin.ts <phone> <password> [name]\n' +
        '   or: set SUPER_ADMIN_PHONE / SUPER_ADMIN_PASSWORD [/ SUPER_ADMIN_NAME] and run with no args.',
    );
    process.exit(1);
  }
  if (password.length < MIN_PASSWORD) {
    console.error(`Password must be at least ${MIN_PASSWORD} characters.`);
    process.exit(1);
  }

  const prisma = new PrismaClient();
  try {
    const user = await prisma.user.upsert({
      where: { phone },
      update: { role: 'SUPER_ADMIN', name, password: hashPassword(password), deletedAt: null },
      create: { phone, name, role: 'SUPER_ADMIN', password: hashPassword(password) },
    });
    console.log(`SUPER_ADMIN ready: id=${user.id} phone=${user.phone} name=${user.name || '-'}`);
    console.log('Sign in at /admin with this phone and the password you supplied (role SUPER_ADMIN).');
  } finally {
    await prisma.$disconnect();
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
