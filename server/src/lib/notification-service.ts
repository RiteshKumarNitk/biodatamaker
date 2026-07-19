import prisma from '@/lib/prisma';
import { getMessagingInstance } from '@/lib/firebase-admin';

export interface PushNotificationPayload {
  title: string;
  body: string;
  data?: Record<string, string>;
  imageUrl?: string;
}

/**
 * Send a push notification to a specific user's all active devices.
 */
export async function sendToUser(
  userId: string,
  notification: PushNotificationPayload
): Promise<{ success: number; failed: number }> {
  const tokens = await prisma.deviceToken.findMany({
    where: { userId, isActive: true },
    select: { token: true, id: true },
  });

  if (tokens.length === 0) {
    return { success: 0, failed: 0 };
  }

  const messaging = getMessagingInstance();

  // Prepare multicast message
  const message = {
    notification: {
      title: notification.title,
      body: notification.body,
      ...(notification.imageUrl ? { imageUrl: notification.imageUrl } : {}),
    },
    data: notification.data ?? {},
    tokens: tokens.map((t) => t.token),
  };

  try {
    const response = await messaging.sendEachForMulticast(message);

    // Handle invalid tokens - deactivate them
    const failedTokens: string[] = [];
    response.responses.forEach((resp, index) => {
      if (
        !resp.success &&
        resp.error &&
        (resp.error.code === 'messaging/invalid-registration-token' ||
          resp.error.code === 'messaging/registration-token-not-registered')
      ) {
        failedTokens.push(tokens[index].token);
      }
    });

    if (failedTokens.length > 0) {
      await prisma.deviceToken.updateMany({
        where: { token: { in: failedTokens } },
        data: { isActive: false },
      });
    }

    return {
      success: response.successCount,
      failed: response.failureCount,
    };
  } catch (error) {
    console.error('FCM send error:', error);
    return { success: 0, failed: tokens.length };
  }
}

/**
 * Send a push notification to multiple users (e.g., all users who liked a photo).
 */
export async function sendToUsers(
  userIds: string[],
  notification: PushNotificationPayload
): Promise<{ success: number; failed: number }> {
  const tokens = await prisma.deviceToken.findMany({
    where: { userId: { in: userIds }, isActive: true },
    select: { token: true },
  });

  if (tokens.length === 0) return { success: 0, failed: 0 };

  const messaging = getMessagingInstance();

  const message = {
    notification: {
      title: notification.title,
      body: notification.body,
      ...(notification.imageUrl ? { imageUrl: notification.imageUrl } : {}),
    },
    data: notification.data ?? {},
    tokens: tokens.map((t) => t.token),
  };

  try {
    const response = await messaging.sendEachForMulticast(message);
    return {
      success: response.successCount,
      failed: response.failureCount,
    };
  } catch (error) {
    console.error('FCM multicast error:', error);
    return { success: 0, failed: tokens.length };
  }
}

/**
 * Send 'Pose of the Day' notification to all active users.
 * Ideally called by a cron job (e.g., GitHub Actions or Vercel Cron).
 */
export async function sendPoseOfTheDay(photoUrl?: string): Promise<{
  sent: number;
}> {
  const activeTokens = await prisma.deviceToken.findMany({
    where: { isActive: true },
    distinct: ['userId'],
  });

  if (activeTokens.length === 0) return { sent: 0 };

  const result = await sendToUsers(
    activeTokens.map((t) => t.userId),
    {
      title: '📸 Pose of the Day',
      body: 'Check out today\'s featured posing idea and try it with Magic Camera!',
      data: {
        type: 'pose_of_the_day',
        screen: 'explore',
      },
      imageUrl: photoUrl,
    }
  );

  return { sent: result.success };
}
