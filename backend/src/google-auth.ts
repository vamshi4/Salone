import { OAuth2Client } from 'google-auth-library';

// GOOGLE_CLIENT_ID is the Web OAuth client ID from Google Cloud Console,
// passed to the Flutter app as `serverClientId` (see
// mobile/salon_admin_app_v3/lib/core/google_auth.dart) so the ID token it
// gets back is issued with this ID as the audience. Not a secret — safe to
// keep in plain env vars, unlike WHATSAPP_ACCESS_TOKEN.
const client = new OAuth2Client();

export class GoogleAuthNotConfiguredError extends Error {
  constructor() {
    super('Google sign-in is not configured');
    this.name = 'GoogleAuthNotConfiguredError';
  }
}

export interface GoogleIdentity {
  googleId: string;
  email: string;
  name: string | null;
}

export async function verifyGoogleIdToken(idToken: string): Promise<GoogleIdentity> {
  const audience = process.env.GOOGLE_CLIENT_ID;
  if (!audience) throw new GoogleAuthNotConfiguredError();

  const ticket = await client.verifyIdToken({ idToken, audience });
  const payload = ticket.getPayload();
  if (!payload?.sub || !payload.email) {
    throw new Error('Google token missing sub/email');
  }

  return {
    googleId: payload.sub,
    email: payload.email.toLowerCase(),
    name: payload.name ?? null,
  };
}
