import { NextRequest, NextResponse } from 'next/server';
import prisma from '@/lib/prisma';
import { verifyToken } from '@/lib/auth';

export async function POST(request: NextRequest) {
  try {
    const token = request.headers.get('authorization')?.replace('Bearer ', '');
    if (!token) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const decoded = verifyToken(token);
    if (!decoded) {
      return NextResponse.json({ error: 'Invalid token' }, { status: 401 });
    }

    const body = await request.json();
    const { quoteId } = body;

    const existingLike = await prisma.quoteLike.findUnique({
      where: {
        userId_quoteId: {
          userId: decoded.userId,
          quoteId,
        },
      },
    });

    if (existingLike) {
      await prisma.quoteLike.delete({
        where: { id: existingLike.id },
      });
      return NextResponse.json({ liked: false });
    }

    await prisma.quoteLike.create({
      data: {
        userId: decoded.userId,
        quoteId,
      },
    });

    return NextResponse.json({ liked: true });
  } catch (error) {
    console.error('Error toggling quote like:', error);
    return NextResponse.json({ error: 'Failed to toggle like' }, { status: 500 });
  }
}

export async function GET(request: NextRequest) {
  try {
    const token = request.headers.get('authorization')?.replace('Bearer ', '');
    if (!token) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const decoded = verifyToken(token);
    if (!decoded) {
      return NextResponse.json({ error: 'Invalid token' }, { status: 401 });
    }

    const { searchParams } = new URL(request.url);
    const quoteId = searchParams.get('quoteId');

    if (!quoteId) {
      return NextResponse.json({ error: 'Quote ID required' }, { status: 400 });
    }

    const like = await prisma.quoteLike.findUnique({
      where: {
        userId_quoteId: {
          userId: decoded.userId,
          quoteId,
        },
      },
    });

    const count = await prisma.quoteLike.count({
      where: { quoteId },
    });

    return NextResponse.json({ liked: !!like, count });
  } catch (error) {
    console.error('Error checking quote like:', error);
    return NextResponse.json({ error: 'Failed to check like status' }, { status: 500 });
  }
}
