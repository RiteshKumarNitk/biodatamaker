import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { getTokenFromRequest, verifyToken } from '@/lib/auth'
import bcrypt from 'bcryptjs'
import { handleCors, corsResponse } from '@/lib/cors'

export async function PUT(request: NextRequest) {
  const corsPreflight = handleCors(request)
  if (corsPreflight) return corsPreflight

  try {
    const token = getTokenFromRequest(request)
    if (!token) {
      return corsResponse(NextResponse.json({ error: 'Unauthorized' }, { status: 401 }))
    }

    const decoded = verifyToken(token)
    if (!decoded) {
      return corsResponse(NextResponse.json({ error: 'Invalid token' }, { status: 401 }))
    }

    const body = await request.json()
    const { username, fullName, avatar, bio, phoneNumber, gender, currentPassword, newPassword } = body

    if (currentPassword && newPassword) {
      const user = await prisma.user.findUnique({
        where: { id: decoded.userId }
      })

      if (!user) {
        return corsResponse(NextResponse.json({ error: 'User not found' }, { status: 404 }))
      }

      if (!user.passwordHash) {
        return corsResponse(NextResponse.json({ error: 'User has no password set' }, { status: 400 }))
      }

      const isValidPassword = await bcrypt.compare(currentPassword, user.passwordHash)
      if (!isValidPassword) {
        return corsResponse(NextResponse.json({ error: 'Current password is incorrect' }, { status: 400 }))
      }

      const hashedPassword = await bcrypt.hash(newPassword, 12)

      await prisma.user.update({
        where: { id: decoded.userId },
        data: { passwordHash: hashedPassword }
      })
    }

    const updateData: any = {}
    if (username !== undefined) updateData.username = username
    if (fullName !== undefined) updateData.fullName = fullName
    if (avatar !== undefined) updateData.avatar = avatar
    if (bio !== undefined) updateData.bio = bio
    if (phoneNumber !== undefined) updateData.phoneNumber = phoneNumber
    if (gender !== undefined) updateData.gender = gender

    const user = await prisma.user.update({
      where: { id: decoded.userId },
      data: updateData,
      select: {
        id: true,
        email: true,
        username: true,
        fullName: true,
        avatar: true,
        bio: true,
        phoneNumber: true,
        gender: true,
        role: true,
        createdAt: true,
      },
    })

    return corsResponse(NextResponse.json(user))
  } catch (error) {
    console.error('Error updating profile:', error)
    return corsResponse(NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    ))
  }
}
