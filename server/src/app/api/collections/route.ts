import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { getTokenFromRequest, verifyToken } from '@/lib/auth'
import { handleCors, corsResponse } from '@/lib/cors'

// GET /api/collections - List user's collections
export async function GET(request: NextRequest) {
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

    const collections = await prisma.collection.findMany({
      where: { userId: payload.userId },
      include: {
        _count: { select: { photos: true } },
        photos: {
          take: 1,
          orderBy: { createdAt: 'desc' },
          select: { imageUrl: true },
        },
      },
      orderBy: { updatedAt: 'desc' },
    })

    // Format response
    const result = collections.map((c) => ({
      id: c.id,
      name: c.name,
      description: c.description,
      coverImage: c.photos[0]?.imageUrl || c.coverImage,
      photoCount: c._count.photos,
      isPublic: c.isPublic,
      createdAt: c.createdAt,
      updatedAt: c.updatedAt,
    }))

    return corsResponse(NextResponse.json(result))
  } catch (error) {
    console.error('List collections error:', error)
    return corsResponse(NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    ))
  }
}

// POST /api/collections - Create a new collection
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

    const { name, description, isPublic } = await request.json()

    if (!name || name.trim().length === 0) {
      return corsResponse(NextResponse.json(
        { error: 'Collection name is required' },
        { status: 400 }
      ))
    }

    // Check if collection with same name already exists for this user
    const existing = await prisma.collection.findUnique({
      where: {
        userId_name: {
          userId: payload.userId,
          name: name.trim(),
        },
      },
    })

    if (existing) {
      return corsResponse(NextResponse.json(
        { error: 'You already have a collection with this name' },
        { status: 409 }
      ))
    }

    const collection = await prisma.collection.create({
      data: {
        name: name.trim(),
        description: description || null,
        userId: payload.userId,
        isPublic: isPublic || false,
      },
    })

    return corsResponse(NextResponse.json(collection, { status: 201 }))
  } catch (error) {
    console.error('Create collection error:', error)
    return corsResponse(NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    ))
  }
}

// DELETE /api/collections - Delete a collection
export async function DELETE(request: NextRequest) {
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

    const { searchParams } = new URL(request.url)
    const id = searchParams.get('id')

    if (!id) {
      return corsResponse(NextResponse.json(
        { error: 'Collection ID is required' },
        { status: 400 }
      ))
    }

    // Verify ownership
    const collection = await prisma.collection.findUnique({
      where: { id },
      select: { userId: true },
    })

    if (!collection) {
      return corsResponse(NextResponse.json(
        { error: 'Collection not found' },
        { status: 404 }
      ))
    }

    if (collection.userId !== payload.userId) {
      return corsResponse(NextResponse.json(
        { error: 'Not authorized to delete this collection' },
        { status: 403 }
      ))
    }

    await prisma.collection.delete({ where: { id } })

    return corsResponse(NextResponse.json({ success: true }))
  } catch (error) {
    console.error('Delete collection error:', error)
    return corsResponse(NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    ))
  }
}
