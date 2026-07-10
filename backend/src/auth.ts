import crypto from 'crypto';
import { NextFunction, Request, Response } from 'express';
import { UserRole } from '@prisma/client';

export type AuthUser = {
  id: string;
  role: UserRole;
  phone?: string;
};

declare global {
  namespace Express {
    interface Request {
      user?: AuthUser;
    }
  }
}

const tokenTtlSeconds = Number(process.env.AUTH_TOKEN_TTL_SECONDS || 60 * 60 * 24 * 7);

function isProduction() {
  return process.env.NODE_ENV === 'production';
}

function authRequired() {
  return isProduction() || process.env.AUTH_REQUIRED !== 'false';
}

function secret() {
  const value = process.env.JWT_SECRET || '';
  if ((authRequired() || isProduction()) && value.length < 32) {
    throw new Error('JWT_SECRET must be at least 32 characters when auth is required');
  }
  return value || 'local-demo-secret-not-for-production';
}

function base64Url(input: Buffer | string) {
  return Buffer.from(input)
    .toString('base64')
    .replace(/=/g, '')
    .replace(/\+/g, '-')
    .replace(/\//g, '_');
}

function decodeBase64Url(input: string) {
  const padded = input.padEnd(input.length + ((4 - (input.length % 4)) % 4), '=');
  return Buffer.from(padded.replace(/-/g, '+').replace(/_/g, '/'), 'base64').toString('utf8');
}

export function signToken(user: AuthUser) {
  const header = base64Url(JSON.stringify({ alg: 'HS256', typ: 'JWT' }));
  const payload = base64Url(
    JSON.stringify({
      sub: user.id,
      role: user.role,
      phone: user.phone,
      exp: Math.floor(Date.now() / 1000) + tokenTtlSeconds,
    }),
  );
  const data = `${header}.${payload}`;
  const signature = base64Url(crypto.createHmac('sha256', secret()).update(data).digest());
  return `${data}.${signature}`;
}

export function verifyToken(token: string): AuthUser | null {
  const [header, payload, signature] = token.split('.');
  if (!header || !payload || !signature) return null;

  const data = `${header}.${payload}`;
  const expected = base64Url(crypto.createHmac('sha256', secret()).update(data).digest());
  if (!crypto.timingSafeEqual(Buffer.from(signature), Buffer.from(expected))) {
    return null;
  }

  const parsed = JSON.parse(decodeBase64Url(payload));
  if (!parsed.sub || !parsed.role || parsed.exp < Math.floor(Date.now() / 1000)) {
    return null;
  }

  return {
    id: parsed.sub,
    role: parsed.role,
    phone: parsed.phone,
  };
}

export function authOptional(req: Request, res: Response, next: NextFunction) {
  const header = req.header('authorization') || '';
  const token = header.startsWith('Bearer ') ? header.slice('Bearer '.length) : null;
  if (!token) return next();

  try {
    req.user = verifyToken(token) ?? undefined;
    next();
  } catch {
    res.status(401).json({ error: 'Invalid auth token' });
  }
}

export function requireAuth(req: Request, res: Response, next: NextFunction) {
  if (!authRequired()) {
    req.user ??= { id: 'demo-auth-bypass', role: 'SUPER_ADMIN' };
    next();
    return;
  }

  if (!req.user) {
    res.status(401).json({ error: 'Authentication required' });
    return;
  }

  next();
}

export function requireRole(...roles: UserRole[]) {
  return (req: Request, res: Response, next: NextFunction) => {
    requireAuth(req, res, () => {
      if (!req.user || !roles.includes(req.user.role)) {
        res.status(403).json({ error: 'Forbidden' });
        return;
      }

      next();
    });
  };
}
