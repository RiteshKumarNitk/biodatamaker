import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { getTokenFromRequest, verifyToken } from '@/lib/auth'
import { handleCors, corsResponse } from '@/lib/cors'
import { v2 as cloudinary } from 'cloudinary'

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
  secure: true,
})

function requireAdmin(request: NextRequest): { ok: true } | { ok: false; response: NextResponse } {
  const token = getTokenFromRequest(request)
  if (!token) {
    return { ok: false, response: NextResponse.json({ error: 'Unauthorized' }, { status: 401 }) }
  }
  const decoded = verifyToken(token)
  if (!decoded) {
    return { ok: false, response: NextResponse.json({ error: 'Invalid token' }, { status: 401 }) }
  }
  if (decoded.role !== 'admin') {
    return { ok: false, response: NextResponse.json({ error: 'Admin access required' }, { status: 403 }) }
  }
  return { ok: true }
}

export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  const corsPreflight = handleCors(request)
  if (corsPreflight) return corsPreflight

  try {
    const template = await prisma.template.findUnique({ where: { id: params.id } })
    if (!template) {
      return corsResponse(NextResponse.json({ error: 'Template not found' }, { status: 404 }))
    }
    return corsResponse(NextResponse.json(template))
  } catch (error) {
    console.error('Get template error:', error)
    return corsResponse(NextResponse.json({ error: 'Internal server error' }, { status: 500 }))
  }
}

export async function PUT(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  const corsPreflight = handleCors(request)
  if (corsPreflight) return corsPreflight

  const admin = requireAdmin(request)
  if (!admin.ok) return corsResponse(admin.response)

  try {
    const body = await request.json()
    delete body.id
    delete body.createdAt
    delete body.updatedAt
    const template = await prisma.template.update({ where: { id: params.id }, data: body })
    return corsResponse(NextResponse.json(template))
  } catch (error) {
    console.error('Update template error:', error)
    return corsResponse(NextResponse.json({ error: 'Internal server error' }, { status: 500 }))
  }
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  const corsPreflight = handleCors(request)
  if (corsPreflight) return corsPreflight

  const admin = requireAdmin(request)
  if (!admin.ok) return corsResponse(admin.response)

  try {
    const existing = await prisma.template.findUnique({ where: { id: params.id } })
    if (existing?.backgroundPublicId) {
      await cloudinary.uploader.destroy(existing.backgroundPublicId).catch(() => null)
    }
    await prisma.template.delete({ where: { id: params.id } })
    return corsResponse(NextResponse.json({ success: true }))
  } catch (error) {
    console.error('Delete template error:', error)
    return corsResponse(NextResponse.json({ error: 'Internal server error' }, { status: 500 }))
  }
}
