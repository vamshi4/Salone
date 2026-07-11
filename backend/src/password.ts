import crypto from 'crypto';

// Single source of truth for password hashing. Both the auth flow and the
// super-admin password-reset endpoint must produce the exact same
// `scrypt$salt$hash` format, so keep this in one place.
const passwordPrefix = 'scrypt';

export function hashPassword(password: string) {
  const salt = crypto.randomBytes(16).toString('hex');
  const hash = crypto.scryptSync(password, salt, 64).toString('hex');
  return `${passwordPrefix}$${salt}$${hash}`;
}

export function verifyPassword(password: string, stored?: string | null) {
  if (!stored) return false;
  const [prefix, salt, hash] = stored.split('$');
  if (prefix !== passwordPrefix || !salt || !hash) return false;
  const candidate = crypto.scryptSync(password, salt, 64);
  return crypto.timingSafeEqual(Buffer.from(hash, 'hex'), candidate);
}
