import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { getTokenFromRequest, verifyToken } from '@/lib/auth'
import { handleCors, corsResponse } from '@/lib/cors'

export async function POST(request: NextRequest) {
  const corsPreflight = handleCors(request)
  if (corsPreflight) return corsPreflight

  try {
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

    const { token } = await request.json()

    if (!token) {
      return corsResponse(NextResponse.json(
        { error: 'FCM token is required' },
        { status: 400 }
      ))
    }

    // Deactivate the token instead of deleting
    await prisma.deviceToken.updateMany({
      where: {
        userId: payload.userId,
        token: token,
      },
      data: { isActive: false },
    })

    return corsResponse(NextResponse.json({ success: true }))
  } catch (error) {
    console.error('Unregister token error:', error)
    return corsResponse(NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    ))
  }
}
