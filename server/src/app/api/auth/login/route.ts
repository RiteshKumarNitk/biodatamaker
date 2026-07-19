import { NextRequest, NextResponse } from 'next/server'
import bcrypt from 'bcryptjs'
import prisma from '@/lib/prisma'
import { generateToken } from '@/lib/auth'
import { handleCors, corsResponse } from '@/lib/cors'

export async function POST(request: NextRequest) {
  const corsPreflight = handleCors(request)
  if (corsPreflight) return corsPreflight

  try {
    const { email, password } = await request.json()

    if (!email || !password) {
      return corsResponse(NextResponse.json(
        { error: 'Email and password are required' },
        { status: 400 }
      ))
    }

    const user = await prisma.user.findUnique({
      where: { email }
    })

    if (!user || !user.passwordHash) {
      return corsResponse(NextResponse.json(
        { error: 'Invalid credentials' },
        { status: 401 }
      ))
    }

    const isValidPassword = await bcrypt.compare(password, user.passwordHash)
    if (!isValidPassword) {
      return corsResponse(NextResponse.json(
        { error: 'Invalid credentials' },
        { status: 401 }
      ))
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
    }))
  } catch (error) {
    console.error('Login error:', error)
    return corsResponse(NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    ))
  }
}
