import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { getTokenFromRequest, verifyToken } from '@/lib/auth'
import { handleCors, corsResponse } from '@/lib/cors'

export async function PATCH(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  const corsPreflight = handleCors(request)
  if (corsPreflight) return corsPreflight

  try {
    const token = getTokenFromRequest(request)
    if (!token) {
      return corsResponse(NextResponse.json({ error: 'Unauthorized' }, { status: 401 }))
    }
    const decoded = verifyToken(token)
    if (!decoded || decoded.role !== 'admin') {
      return corsResponse(NextResponse.json({ error: 'Admin access required' }, { status: 403 }))
    }

    const { isPublished } = await request.json()
    const template = await prisma.template.update({
      where: { id: params.id },
      data: { isPublished: !!isPublished },
    })
    return corsResponse(NextResponse.json(template))
  } catch (error) {
    console.error('Publish template error:', error)
    return corsResponse(NextResponse.json({ error: 'Internal server error' }, { status: 500 }))
  }
}
