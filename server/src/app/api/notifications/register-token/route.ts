import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { getTokenFromRequest, verifyToken } from '@/lib/auth'
import { handleCors, corsResponse } from '@/lib/cors'

export async function POST(request: NextRequest) {
  const corsPreflight = handleCors(request)
  if (corsPreflight) return corsPreflight

  try {
    // Verify auth
    const authToken = getTokenFromRequest(request)
    if (!authToken) {
      return corsResponse(NextResponse.json(
        { error: 'Authentication required' },
        { status: 401 }
      ))
    }

    const payload = verifyToken(authToken)
    if (!payload) {
      return corsResponse(NextResponse.json(
        { error: 'Invalid or expired token' },
        { status: 401 }
      ))
    }

    const { token, platform } = await request.json()

    if (!token) {
      return corsResponse(NextResponse.json(
        { error: 'FCM token is required' },
        { status: 400 }
      ))
    }

    // Upsert device token
    const existing = await prisma.deviceToken.findFirst({
      where: {
        userId: payload.userId,
        token: token,
      },
    })

    if (existing) {
      // Reactivate if was deactivated
      await prisma.deviceToken.update({
        where: { id: existing.id },
        data: { isActive: true, platform: platform || existing.platform },
      })
    } else {
      await prisma.deviceToken.create({
        data: {
          userId: payload.userId,
          token,
          platform: platform || 'unknown',
        },
      })
    }

    return corsResponse(NextResponse.json({ success: true }))
  } catch (error) {
    console.error('Register token error:', error)
    return corsResponse(NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    ))
  }
}
