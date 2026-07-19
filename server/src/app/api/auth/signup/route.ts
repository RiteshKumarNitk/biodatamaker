import { NextRequest, NextResponse } from 'next/server'
import bcrypt from 'bcryptjs'
import prisma from '@/lib/prisma'
import { generateToken } from '@/lib/auth'
import { handleCors, corsResponse } from '@/lib/cors'

export async function POST(request: NextRequest) {
  const corsPreflight = handleCors(request)
  if (corsPreflight) return corsPreflight

  try {
    const { email, password, name, referringCode } = await request.json()

    if (!email || !password) {
      return corsResponse(NextResponse.json(
        { error: 'Email and password are required' },
        { status: 400 }
      ))
    }

    const existingUser = await prisma.user.findUnique({
      where: { email }
    })

    if (existingUser) {
      return corsResponse(NextResponse.json(
        { error: 'User already exists' },
        { status: 409 }
      ))
    }

    const hashedPassword = await bcrypt.hash(password, 12)
    const referralCode = (name || 'user').toLowerCase().replace(/\s/g, '') + Math.random().toString(36).substring(2, 6)

    const user = await prisma.user.create({
      data: {
        email,
        passwordHash: hashedPassword,
        username: name || 'User',
        referralCode,
        referredBy: referringCode || null
      }
    })

    // If referred, we could add points or rewards here
    if (referringCode) {
      await prisma.user.updateMany({
        where: { referralCode: referringCode },
        data: {
          points: { increment: 10 }
        }
      })
    }

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
      points: user.points
    }

    return corsResponse(NextResponse.json({
      token,
      user: userResponse
    }, { status: 201 }))
  } catch (error) {
    console.error('Signup error:', error)
    return corsResponse(NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    ))
  }
}
