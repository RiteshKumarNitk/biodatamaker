import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { getTokenFromRequest, verifyToken } from '@/lib/auth'
import { sendPoseOfTheDay } from '@/lib/notification-service'
import { handleCors, corsResponse } from '@/lib/cors'

export async function POST(request: NextRequest) {
  const corsPreflight = handleCors(request)
  if (corsPreflight) return corsPreflight

  try {
    // Verify admin auth
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

    if (payload.role !== 'admin') {
      return corsResponse(NextResponse.json(
        { error: 'Admin access required' },
        { status: 403 }
      ))
    }

    // Pick a random featured photo for the day
    const featuredPhoto = await prisma.photo.findFirst({
      where: { posingInstructions: { not: null } },
      orderBy: { createdAt: 'desc' },
      skip: Math.floor(Math.random() * 10),
    })

    const result = await sendPoseOfTheDay(featuredPhoto?.imageUrl)

    return corsResponse(NextResponse.json({
      success: true,
      sent: result.sent,
      photo: featuredPhoto?.imageUrl || null,
    }))
  } catch (error) {
    console.error('Send pose of day error:', error)
    return corsResponse(NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    ))
  }
}

// Support GET for Vercel Cron Jobs (which use GET requests)
export async function GET(request: NextRequest) {
  // Allow unauthenticated GET for Vercel Cron if CRON_SECRET matches
  const cronSecret = request.headers.get('x-cron-secret')
  if (cronSecret !== process.env.CRON_SECRET) {
    return corsResponse(NextResponse.json(
      { error: 'Unauthorized' },
      { status: 401 }
    ))
  }

  const result = await sendPoseOfTheDay()
  return corsResponse(NextResponse.json({
    success: true,
    sent: result.sent,
  }))
}
