import { NextRequest, NextResponse } from 'next/server';
import prisma from '@/lib/prisma';
import { verifyToken } from '@/lib/auth';

export async function GET() {
  try {
    const filters = await prisma.faceFilter.findMany({
      orderBy: { createdAt: 'desc' },
    });

    return NextResponse.json(filters);
  } catch (error) {
    console.error('Error fetching filters:', error);
    return NextResponse.json({ error: 'Failed to fetch filters' }, { status: 500 });
  }
}

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

    if (decoded.role !== 'admin') {
      return NextResponse.json({ error: 'Admin access required' }, { status: 403 });
    }

    const body = await request.json();
    const { name, imageUrl, thumbnailUrl } = body;

    const filter = await prisma.faceFilter.create({
      data: {
        name,
        imageUrl,
        thumbnailUrl,
      },
    });

    return NextResponse.json(filter);
  } catch (error) {
    console.error('Error creating filter:', error);
    return NextResponse.json({ error: 'Failed to create filter' }, { status: 500 });
  }
}
