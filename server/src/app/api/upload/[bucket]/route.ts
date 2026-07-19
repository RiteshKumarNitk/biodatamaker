import { NextRequest, NextResponse } from 'next/server';
import { verifyToken } from '@/lib/auth';
import { v2 as cloudinary } from 'cloudinary';

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
  secure: true,
});

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

    const formData = await request.formData();
    const file = formData.get('file') as File | null;
    const bucket = formData.get('bucket') as string | null;

    if (!file) {
      return NextResponse.json({ error: 'File is required' }, { status: 400 });
    }

    const cloudName = process.env.CLOUDINARY_CLOUD_NAME;
    const apiKey = process.env.CLOUDINARY_API_KEY;
    const apiSecret = process.env.CLOUDINARY_API_SECRET;

    if (!cloudName || !apiKey || !apiSecret) {
      return NextResponse.json({ 
        error: 'Cloudinary not configured',
        details: 'Missing Cloudinary environment variables'
      }, { status: 500 });
    }

    const bytes = await file.arrayBuffer();
    const buffer = Buffer.from(bytes);
    const base64Data = buffer.toString('base64');
    const mimeType = file.type || 'image/jpeg';

    // Generate clean public ID without slashes
    const timestamp = Date.now();
    const randomSuffix = Math.random().toString(36).substring(2, 8);
    const publicId = `photo_${timestamp}_${randomSuffix}`;

    console.log('Cloudinary upload attempt:', {
      cloudName,
      hasApiKey: !!apiKey,
      hasApiSecret: !!apiSecret,
      fileName: file.name,
      publicId,
      mimeType
    });

    // Use signed upload with explicit public_id and display_name
    const uploadResult = await cloudinary.uploader.upload(
      `data:${mimeType};base64,${base64Data}`,
      {
        public_id: publicId,
        folder: bucket === 'photos' ? 'SnapIdeas/Images' : `SnapIdeas/${bucket || 'Images'}`,
        resource_type: 'auto',
        // Explicitly set display name to avoid slashes issue
        display_name: `photo_${timestamp}`,
        // Don't use filename as display name
        use_filename: false,
        unique_filename: false,
        overwrite: false,
        // Sign the upload
        timestamp: timestamp,
        api_key: apiKey,
        api_secret: apiSecret,
      }
    );

    console.log('Upload success:', uploadResult.secure_url);

    return NextResponse.json({
      url: uploadResult.secure_url,
      publicId: uploadResult.public_id,
      filename: file.name,
    });
  } catch (error: any) {
    console.error('Cloudinary upload error:', error);
    
    return NextResponse.json({ 
      error: 'Cloudinary upload failed',
      details: error.message || 'Unknown error'
    }, { status: 500 });
  }
}

export async function DELETE(request: NextRequest) {
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

    const { searchParams } = new URL(request.url);
    const publicId = searchParams.get('publicId');

    if (!publicId) {
      return NextResponse.json({ error: 'Public ID is required' }, { status: 400 });
    }

    const result = await cloudinary.uploader.destroy(publicId);

    if (result.result === 'ok') {
      return NextResponse.json({ message: 'File deleted successfully' });
    }

    return NextResponse.json({ error: 'Failed to delete file' }, { status: 500 });
  } catch (error) {
    console.error('Error deleting from Cloudinary:', error);
    return NextResponse.json({ error: 'Failed to delete file' }, { status: 500 });
  }
}
