import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { getTokenFromRequest, verifyToken } from '@/lib/auth'
import { handleCors, corsResponse } from '@/lib/cors'

// GET /api/collections/[id] - Get collection details with photos
export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
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

    const collection = await prisma.collection.findUnique({
      where: { id: params.id },
      include: {
        photos: {
          orderBy: { createdAt: 'desc' },
        },
      },
    })

    if (!collection) {
      return corsResponse(NextResponse.json(
        { error: 'Collection not found' },
        { status: 404 }
      ))
    }

    // Only owner can view private collections
    if (!collection.isPublic && collection.userId !== payload.userId) {
      return corsResponse(NextResponse.json(
        { error: 'Not authorized' },
        { status: 403 }
      ))
    }

    return corsResponse(NextResponse.json({
      id: collection.id,
      name: collection.name,
      description: collection.description,
      coverImage: collection.coverImage,
      isPublic: collection.isPublic,
      photoCount: collection.photos.length,
      photos: collection.photos.map((p) => ({
        id: p.id,
        imageUrl: p.imageUrl,
        imageCaption: p.imageCaption,
        createdAt: p.createdAt,
      })),
      createdAt: collection.createdAt,
      updatedAt: collection.updatedAt,
    }))
  } catch (error) {
    console.error('Get collection error:', error)
    return corsResponse(NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    ))
  }
}

// PATCH /api/collections/[id] - Update collection (name, description, isPublic)
export async function PATCH(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
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

    const collection = await prisma.collection.findUnique({
      where: { id: params.id },
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
        { error: 'Not authorized' },
        { status: 403 }
      ))
    }

    const { name, description, isPublic, coverImage } = await request.json()

    const updated = await prisma.collection.update({
      where: { id: params.id },
      data: {
        ...(name !== undefined ? { name } : {}),
        ...(description !== undefined ? { description } : {}),
        ...(isPublic !== undefined ? { isPublic } : {}),
        ...(coverImage !== undefined ? { coverImage } : {}),
      },
    })

    return corsResponse(NextResponse.json(updated))
  } catch (error) {
    console.error('Update collection error:', error)
    return corsResponse(NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    ))
  }
}
