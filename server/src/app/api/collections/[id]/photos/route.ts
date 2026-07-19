import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { getTokenFromRequest, verifyToken } from '@/lib/auth'
import { handleCors, corsResponse } from '@/lib/cors'

// POST /api/collections/[id]/photos - Add photo to collection
export async function POST(
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

    // Verify ownership
    const collection = await prisma.collection.findUnique({
      where: { id: params.id },
      select: { userId: true, coverImage: true },
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

    const { imageUrl, photoId, imageCaption } = await request.json()

    if (!imageUrl) {
      return corsResponse(NextResponse.json(
        { error: 'imageUrl is required' },
        { status: 400 }
      ))
    }

    // Check if photo already exists in collection
    const existing = await prisma.collectionPhoto.findUnique({
      where: {
        collectionId_imageUrl: {
          collectionId: params.id,
          imageUrl,
        },
      },
    })

    if (existing) {
      return corsResponse(NextResponse.json(
        { error: 'Photo already in collection' },
        { status: 409 }
      ))
    }

    const photo = await prisma.collectionPhoto.create({
      data: {
        collectionId: params.id,
        imageUrl,
        photoId: photoId || null,
        imageCaption: imageCaption || null,
      },
    })

    // Update the coverImage if this is the first photo
    await prisma.collection.update({
      where: { id: params.id },
      data: { coverImage: collection.coverImage || imageUrl },
    })

    return corsResponse(NextResponse.json(photo, { status: 201 }))
  } catch (error) {
    console.error('Add photo to collection error:', error)
    return corsResponse(NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    ))
  }
}

// DELETE /api/collections/[id]/photos - Remove photo from collection
export async function DELETE(
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

    const { searchParams } = new URL(request.url)
    const imageUrl = searchParams.get('imageUrl')

    if (!imageUrl) {
      return corsResponse(NextResponse.json(
        { error: 'imageUrl query parameter is required' },
        { status: 400 }
      ))
    }

    // Verify ownership
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

    await prisma.collectionPhoto.deleteMany({
      where: {
        collectionId: params.id,
        imageUrl: decodeURIComponent(imageUrl),
      },
    })

    return corsResponse(NextResponse.json({ success: true }))
  } catch (error) {
    console.error('Remove photo from collection error:', error)
    return corsResponse(NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    ))
  }
}
