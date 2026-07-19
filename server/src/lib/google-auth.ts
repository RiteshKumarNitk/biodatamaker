import { OAuth2Client } from 'google-auth-library';

const GOOGLE_CLIENT_ID = process.env.GOOGLE_CLIENT_ID;

let client: OAuth2Client | null = null;

function getClient(): OAuth2Client {
  if (!client) {
    if (!GOOGLE_CLIENT_ID) {
      throw new Error('GOOGLE_CLIENT_ID environment variable is not set');
    }
    client = new OAuth2Client(GOOGLE_CLIENT_ID);
  }
  return client;
}

export interface GoogleUserPayload {
  sub: string;       // Google's unique user ID
  email: string;
  name: string;
  picture: string;
  email_verified: boolean;
}

/**
 * Verifies a Google ID token and returns the user payload.
 * Throws an error if the token is invalid.
 */
export async function verifyGoogleToken(idToken: string): Promise<GoogleUserPayload> {
  const client = getClient();

  try {
    const ticket = await client.verifyIdToken({
      idToken,
      audience: GOOGLE_CLIENT_ID,
    });

    const payload = ticket.getPayload();

    if (!payload) {
      throw new Error('Invalid Google token: no payload');
    }

    if (!payload.email_verified) {
      throw new Error('Google account email is not verified');
    }

    return {
      sub: payload.sub,
      email: payload.email || '',
      name: payload.name || 'User',
      picture: payload.picture || '',
      email_verified: payload.email_verified,
    };
  } catch (error) {
    console.error('Google token verification failed:', error);
    throw new Error('Invalid Google authentication token');
  }
}
