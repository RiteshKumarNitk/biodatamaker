import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { getTokenFromRequest, verifyToken } from '@/lib/auth'

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const category = searchParams.get('category')

    const where = category ? { category } : {}

    const quotes = await prisma.quote.findMany({
      where,
      orderBy: { createdAt: 'desc' }
    })

    return NextResponse.json(quotes.map(q => ({
      id: q.id,
      content: q.content,
      author: q.author,
      category: q.category
    })))
  } catch (error) {
    console.error('Get quotes error:', error)
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

    const { content, author, category } = await request.json()

    if (!content) {
      return NextResponse.json(
        { error: 'Quote content is required' },
        { status: 400 }
      )
    }

    const quote = await prisma.quote.create({
      data: {
        content,
        author: author || 'Unknown',
        category: category || 'General'
      }
    })

    return NextResponse.json(quote, { status: 201 })
  } catch (error) {
    console.error('Create quote error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
