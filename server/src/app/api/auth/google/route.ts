import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { generateToken } from '@/lib/auth'
import { verifyGoogleToken } from '@/lib/google-auth'
import { handleCors, corsResponse } from '@/lib/cors'

export async function POST(request: NextRequest) {
  const corsPreflight = handleCors(request)
  if (corsPreflight) return corsPreflight

  try {
    const { idToken } = await request.json()

    if (!idToken) {
      return corsResponse(NextResponse.json(
        { error: 'Google ID token is required' },
        { status: 400 }
      ))
    }

    // Verify the Google ID token server-side
    const googleUser = await verifyGoogleToken(idToken)

    // Check if user already exists with this Google ID
    let user = await prisma.user.findUnique({
      where: { googleId: googleUser.sub }
    })

    // If not found by Google ID, check by email
    if (!user) {
      user = await prisma.user.findUnique({
        where: { email: googleUser.email }
      })

      // If user exists with this email but no Google ID, link the account
      if (user) {
        user = await prisma.user.update({
          where: { id: user.id },
          data: {
            googleId: googleUser.sub,
            avatar: user.avatar || googleUser.picture,
          }
        })
      }
    }

    // Create new user if doesn't exist
    if (!user) {
      const referralCode = googleUser.name.toLowerCase().replace(/\s/g, '') +
        Math.random().toString(36).substring(2, 6)

      user = await prisma.user.create({
        data: {
          email: googleUser.email,
          googleId: googleUser.sub,
          username: googleUser.name,
          fullName: googleUser.name,
          avatar: googleUser.picture,
          referralCode,
          role: 'user',
        }
      })
    }

    // Generate JWT token
    const token = generateToken({
      userId: user.id,
      email: user.email,
      role: user.role
    })

    const userResponse = {
      id: user.id,
      email: user.email,
      username: user.username,
      fullName: user.fullName,
      avatar: user.avatar,
      bio: user.bio,
      role: user.role,
      referralCode: user.referralCode,
      points: user.points,
    }

    return corsResponse(NextResponse.json({
      token,
      user: userResponse,
      isNewUser: !user.passwordHash && user.googleId !== null,
    }, { status: 200 }))
  } catch (error) {
    console.error('Google sign-in error:', error)
    const message = error instanceof Error ? error.message : 'Internal server error'
    return corsResponse(NextResponse.json(
      { error: message },
      { status: 401 }
    ))
  }
}
