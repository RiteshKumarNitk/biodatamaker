import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { getTokenFromRequest, verifyToken } from '@/lib/auth'

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const categoryId = searchParams.get('categoryId')
    const categoryName = searchParams.get('categoryName')
    const subCategoryId = searchParams.get('subCategoryId')

    const where: any = {}
    
    if (categoryId) {
      where.categoryId = categoryId
    } else if (categoryName) {
      // Filter by category name (case-insensitive)
      where.category = {
        name: {
          equals: categoryName.toLowerCase(),
          mode: 'insensitive'
        }
      }
    }
    
    if (subCategoryId) {
      where.subCategoryId = subCategoryId
    }

    const photos = await prisma.photo.findMany({
      where,
      select: {
        id: true,
        imageUrl: true,
        title: true,
        description: true,
        posingInstructions: true,
        category: {
          select: { id: true, name: true }
        },
        subCategory: {
          select: { id: true, name: true }
        },
        createdAt: true
      },
      orderBy: { createdAt: 'desc' }
    })

    const formattedPhotos = photos.map(p => ({
      id: p.id,
      imageUrl: p.imageUrl,
      title: p.title,
      subtitle: p.description,
      posingInstructions: p.posingInstructions,
      category: p.category,
      subCategory: p.subCategory,
      createdAt: p.createdAt
    }))

    return NextResponse.json(formattedPhotos)
  } catch (error) {
    console.error('Get photos error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

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

    if (decoded.role !== 'admin') {
      return NextResponse.json({ error: 'Admin access required' }, { status: 403 })
    }

    const { imageUrl, categoryId, subCategoryId, title, description, posingInstructions } = await request.json()

    if (!imageUrl) {
      return NextResponse.json(
        { error: 'Image URL is required' },
        { status: 400 }
      )
    }

    const photo = await prisma.photo.create({
      data: {
        imageUrl,
        title,
        description,
        posingInstructions,
        categoryId: categoryId || null,
        subCategoryId: subCategoryId || null,
        userId: decoded.userId
      }
    })

    return NextResponse.json(photo, { status: 201 })
  } catch (error) {
    console.error('Create photo error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
