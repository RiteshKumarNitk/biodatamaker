import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crop_image/crop_image.dart';

import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/biodata/data/models/photo_info.dart';

class PhotoStep extends StatefulWidget {
  final Biodata biodata;
  final void Function(Biodata) onUpdate;

  const PhotoStep({super.key, required this.biodata, required this.onUpdate});

  @override
  State<PhotoStep> createState() => _PhotoStepState();
}

class _PhotoStepState extends State<PhotoStep> {
  String _selectedShape = 'circle';

  Future<void> _pickAndCropImage(BuildContext context, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (pickedFile == null || !context.mounted) return;

      final croppedFile = await Navigator.of(context).push<File>(
        MaterialPageRoute(
          builder: (_) => _ImageCropScreen(imagePath: pickedFile.path),
        ),
      );

      if (croppedFile == null || !context.mounted) return;

      final photo = PhotoInfo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        path: croppedFile.path,
        isProfilePhoto: true,
      );
      widget.onUpdate(widget.biodata.copyWith(
        photos: [photo],
        profilePhotoPath: croppedFile.path,
      ));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${Strings.tr('Failed to pick image')}: $e')),
        );
      }
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(Strings.tr('Camera')),
              onTap: () {
                Navigator.pop(ctx);
                _pickAndCropImage(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(Strings.tr('Gallery')),
              onTap: () {
                Navigator.pop(ctx);
                _pickAndCropImage(context, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _removePhoto() {
    widget.onUpdate(widget.biodata.copyWith(
      photos: [],
      profilePhotoPath: '',
    ));
  }

  Widget _buildProfilePhoto(BuildContext context, ThemeData theme) {
    if (widget.biodata.photos.isEmpty) {
      return GestureDetector(
        onTap: () => _showPicker(context),
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            shape: _selectedShape == 'circle' ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: _selectedShape == 'rectangle' ? BorderRadius.circular(16) : null,
            border: Border.all(color: theme.colorScheme.outlineVariant, width: 1.5),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_a_photo, size: 32, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(height: 4),
                Text(Strings.tr('Tap to add'), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ),
      );
    }
    final profilePhoto = widget.biodata.photos.firstWhere(
      (p) => p.isProfilePhoto,
      orElse: () => widget.biodata.photos.first,
    );
    final photoExists = File(profilePhoto.path).existsSync();
    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: _selectedShape == 'circle' ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: _selectedShape == 'rectangle' ? BorderRadius.circular(16) : null,
            border: Border.all(color: theme.colorScheme.primary, width: 2),
          ),
          clipBehavior: Clip.antiAlias,
          child: photoExists
              ? Image.file(
                  File(profilePhoto.path),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _photoFallback(theme),
                )
              : _photoFallback(theme),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _showPicker(context),
            child: CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              radius: 14,
              child: Icon(Icons.edit, size: 14, color: theme.colorScheme.onPrimary),
            ),
          ),
        ),
        if (widget.biodata.photos.isNotEmpty)
          Positioned(
            bottom: 4,
            right: 4,
            child: GestureDetector(
              onTap: _removePhoto,
              child: CircleAvatar(
                backgroundColor: theme.colorScheme.error,
                radius: 14,
                child: Icon(Icons.delete, size: 14, color: theme.colorScheme.onError),
              ),
            ),
          ),
      ],
    );
  }

  Widget _photoFallback(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(Icons.person, size: 48, color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.photo_camera_outlined, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(Strings.tr('Profile Photo'), style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            Center(child: _buildProfilePhoto(context, theme)),
            const SizedBox(height: 12),
            Text(Strings.tr('Photo Shape'), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildShapeOption(context, 'circle', 'Circle', Icons.circle_outlined),
                const SizedBox(width: 16),
                _buildShapeOption(context, 'rectangle', 'Rounded', Icons.rounded_corner),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShapeOption(BuildContext context, String shape, String label, IconData icon) {
    final theme = Theme.of(context);
    final isSelected = _selectedShape == shape;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedShape = shape);
      },
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.1) : theme.colorScheme.surfaceContainerHighest,
              shape: shape == 'circle' ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: shape == 'rectangle' ? BorderRadius.circular(8) : null,
              border: Border.all(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Icon(icon, color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant, size: 24),
          ),
          const SizedBox(height: 4),
          Text(label, style: theme.textTheme.labelSmall?.copyWith(color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _ImageCropScreen extends StatefulWidget {
  final String imagePath;

  const _ImageCropScreen({required this.imagePath});

  @override
  State<_ImageCropScreen> createState() => _ImageCropScreenState();
}

class _ImageCropScreenState extends State<_ImageCropScreen> {
  final _controller = CropController(aspectRatio: 1.0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.tr('Crop Image')),
        actions: [
          TextButton(
            onPressed: () async {
              final bitmap = await _controller.croppedBitmap();
              final data = await bitmap.toByteData(format: ui.ImageByteFormat.png);
              final bytes = data!.buffer.asUint8List();

              final tempDir = await Directory.systemTemp.createTemp();
              final file = File('${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png');
              await file.writeAsBytes(bytes);

              if (context.mounted) {
                Navigator.of(context).pop(file);
              }
            },
            child: Text(Strings.tr('Done'), style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: CropImage(
        image: Image.file(File(widget.imagePath)),
        controller: _controller,
      ),
    );
  }
}
