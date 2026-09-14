import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';

import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/biodata/data/models/photo_info.dart';

class PhotoStep extends StatelessWidget {
  final Biodata biodata;
  final void Function(Biodata) onUpdate;

  const PhotoStep({super.key, required this.biodata, required this.onUpdate});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (pickedFile == null) return;

      final photo = PhotoInfo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        path: pickedFile.path,
        isProfilePhoto: biodata.photos.isEmpty,
      );
      final photos = [...biodata.photos, photo];
      onUpdate(biodata.copyWith(
        photos: photos,
        profilePhotoPath: biodata.profilePhotoPath.isEmpty ? pickedFile.path : biodata.profilePhotoPath,
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
                _pickImage(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(Strings.tr('Gallery')),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(context, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _setAsProfile(int index) {
    final photos = biodata.photos.asMap().entries.map((entry) {
      return entry.value.copyWith(isProfilePhoto: entry.key == index);
    }).toList();
    final profilePhoto = biodata.photos[index];
    onUpdate(biodata.copyWith(
      photos: photos,
      profilePhotoPath: profilePhoto.path,
    ));
  }

  void _removePhoto(int index) {
    final photos = [...biodata.photos];
    final removed = photos.removeAt(index);
    final newProfilePath = removed.isProfilePhoto
        ? (photos.isNotEmpty ? photos.firstWhere((p) => p.isProfilePhoto, orElse: () => photos.first).path : '')
        : biodata.profilePhotoPath;
    onUpdate(biodata.copyWith(
      photos: photos,
      profilePhotoPath: newProfilePath,
    ));
  }

  Widget _buildProfilePhoto(BuildContext context, ThemeData theme) {
    if (biodata.photos.isEmpty) {
      return GestureDetector(
        onTap: () => _showPicker(context),
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outlineVariant, width: 1.5, style: BorderStyle.solid),
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
    final profilePhoto = biodata.photos.firstWhere((p) => p.isProfilePhoto, orElse: () => biodata.photos.first);
    final photoExists = File(profilePhoto.path).existsSync();
    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
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
          child: CircleAvatar(
            backgroundColor: theme.colorScheme.primary,
            radius: 14,
            child: Icon(Icons.star, size: 14, color: theme.colorScheme.onPrimary),
          ),
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _showPicker(context),
            child: CircleAvatar(
              backgroundColor: theme.colorScheme.secondaryContainer,
              radius: 14,
              child: Icon(Icons.edit, size: 14, color: theme.colorScheme.onSecondaryContainer),
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Add Photos',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          'Upload a profile photo to personalize your biodata',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Strings.tr('Profile Photo'), style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Center(child: _buildProfilePhoto(context, theme)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Strings.tr('Additional Photos'), style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                ...biodata.photos.asMap().entries.map((entry) {
                  final index = entry.key;
                  final photo = entry.value;
                  if (photo.isProfilePhoto) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(File(photo.path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'profile') _setAsProfile(index);
                              if (value == 'delete') _removePhoto(index);
                            },
                            itemBuilder: (_) => [
                              PopupMenuItem(value: 'profile', child: Text(Strings.tr('Set as profile'))),
                                  PopupMenuItem(value: 'delete', child: Text(Strings.tr('Remove'), style: TextStyle(color: theme.colorScheme.error))),
                            ],
                          ),
                        ),
                      ],
                    )).animate().fadeIn(duration: 400.ms, delay: (index * 100).ms);
                }),
                GestureDetector(
                  onTap: () => _showPicker(context),
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.colorScheme.outlineVariant),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 8),
                          Text(Strings.tr('Add Photo'), style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
