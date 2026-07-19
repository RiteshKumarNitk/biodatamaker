import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { getTokenFromRequest, verifyToken } from '@/lib/auth'

export async function POST(request: NextRequest) {
  try {
    const token = getTokenFromRequest(request)
    if (!token) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const decoded = verifyToken(token)
    if (!decoded) {
      return NextResponse.json({ error: 'Invalid token' }, { status: 401 })
    }

    const { imageUrl } = await request.json()

    if (!imageUrl) {
      return NextResponse.json(
        { error: 'Image URL is required' },
        { status: 400 }
      )
    }

    const existingLike = await prisma.like.findFirst({
      where: { userId: decoded.userId, imageUrl }
    })

    if (existingLike) {
      await prisma.like.delete({
        where: { id: existingLike.id }
      })
      return NextResponse.json({ liked: false })
    } else {
      await prisma.like.create({
        data: { userId: decoded.userId, imageUrl }
      })
      return NextResponse.json({ liked: true })
    }
  } catch (error) {
    console.error('Toggle like error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const imageUrl = searchParams.get('imageUrl')

    if (!imageUrl) {
      return NextResponse.json(
        { error: 'Image URL is required' },
        { status: 400 }
      )
    }

    const token = getTokenFromRequest(request)
    let isLiked = false
    if (token) {
      const decoded = verifyToken(token)
      if (decoded) {
        const existingLike = await prisma.like.findFirst({
          where: { userId: decoded.userId, imageUrl }
        })
        isLiked = !!existingLike
      }
    }

    const count = await prisma.like.count({
      where: { imageUrl }
    })

    return NextResponse.json({ isLiked, count })
  } catch (error) {
    console.error('Get like status error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
