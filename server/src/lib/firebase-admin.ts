import { initializeApp, getApps, cert, App } from 'firebase-admin/app';
import { getMessaging, Messaging } from 'firebase-admin/messaging';

let app: App | null = null;
let messagingInstance: Messaging | null = null;

/**
 * Initialize Firebase Admin SDK if not already initialized.
 * Requires FIREBASE_SERVICE_ACCOUNT_KEY env var (JSON string).
 */
function getFirebaseApp(): App {
  if (!app) {
    const serviceAccountJson = process.env.FIREBASE_SERVICE_ACCOUNT_KEY;
    if (!serviceAccountJson) {
      throw new Error(
        'FIREBASE_SERVICE_ACCOUNT_KEY environment variable is not set. ' +
        'Paste your Firebase service account JSON as a single-line string.'
      );
    }

    const serviceAccount = JSON.parse(serviceAccountJson);

    app = !getApps().length
      ? initializeApp({ credential: cert(serviceAccount) })
      : getApps()[0];
  }
  return app;
}

export function getMessagingInstance(): Messaging {
  if (!messagingInstance) {
    getFirebaseApp();
    messagingInstance = getMessaging();
  }
  return messagingInstance;
}
