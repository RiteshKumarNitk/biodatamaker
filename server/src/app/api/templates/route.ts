import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { getTokenFromRequest, verifyToken } from '@/lib/auth'
import { handleCors, corsResponse } from '@/lib/cors'

function isAdminRequest(request: NextRequest): boolean {
  const token = getTokenFromRequest(request)
  if (!token) return false
  const decoded = verifyToken(token)
  return decoded?.role === 'admin'
}

export async function GET(request: NextRequest) {
  const corsPreflight = handleCors(request)
  if (corsPreflight) return corsPreflight

  try {
    const isAdmin = isAdminRequest(request)
    const templates = await prisma.template.findMany({
      where: isAdmin ? {} : { isPublished: true },
      orderBy: { displayOrder: 'asc' },
    })
    return corsResponse(NextResponse.json(templates))
  } catch (error) {
    console.error('Get templates error:', error)
    return corsResponse(
      NextResponse.json({ error: 'Internal server error' }, { status: 500 })
    )
  }
}

export async function POST(request: NextRequest) {
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
    if (decoded.role !== 'admin') {
      return corsResponse(NextResponse.json({ error: 'Admin access required' }, { status: 403 }))
    }

    const body = await request.json()
    if (!body.id || !body.name || !body.category) {
      return corsResponse(
        NextResponse.json({ error: 'id, name and category are required' }, { status: 400 })
      )
    }

    const template = await prisma.template.create({ data: body })
    return corsResponse(NextResponse.json(template, { status: 201 }))
  } catch (error) {
    console.error('Create template error:', error)
    return corsResponse(
      NextResponse.json({ error: 'Internal server error' }, { status: 500 })
    )
  }
}
