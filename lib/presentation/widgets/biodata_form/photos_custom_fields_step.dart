import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:biodata_maker/data/models/biodata.dart';
import 'package:biodata_maker/data/models/custom_field.dart';
import 'package:biodata_maker/data/models/photo_info.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Step 6: Photos & Custom Fields
class PhotosCustomFieldsStep extends StatefulWidget {
  final Biodata biodata;
  final ValueChanged<Biodata> onChanged;

  const PhotosCustomFieldsStep({
    super.key,
    required this.biodata,
    required this.onChanged,
  });

  @override
  State<PhotosCustomFieldsStep> createState() =>
      _PhotosCustomFieldsStepState();
}

class _PhotosCustomFieldsStepState extends State<PhotosCustomFieldsStep> {
  final _picker = ImagePicker();

  Future<void> _addPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked == null) return;

    // Copy to app directory
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = '${_uuid.v4()}${p.extension(picked.path)}';
    final savedFile = await File(picked.path).copy('${appDir.path}/$fileName');

    final photo = PhotoInfo(
      id: _uuid.v4(),
      path: savedFile.path,
      order: widget.biodata.photos.length,
      isProfilePhoto: widget.biodata.photos.isEmpty,
    );

    widget.onChanged(
      widget.biodata.copyWith(
        photos: [...widget.biodata.photos, photo],
        profilePhotoPath:
            widget.biodata.photos.isEmpty ? savedFile.path : widget.biodata.profilePhotoPath,
      ),
    );
  }

  void _removePhoto(int index) {
    final photos = List<PhotoInfo>.from(widget.biodata.photos);
    photos.removeAt(index);
    // Reorder
    final reordered = photos
        .asMap()
        .entries
        .map((e) => e.value.copyWith(order: e.key))
        .toList();

    // Find new profile photo or fall back to first photo
    final newProfile = reordered.where((p) => p.isProfilePhoto).isNotEmpty
        ? reordered.firstWhere((p) => p.isProfilePhoto).path
        : reordered.isNotEmpty
            ? reordered.first.path
            : '';

    widget.onChanged(
      widget.biodata.copyWith(
        photos: reordered,
        profilePhotoPath: newProfile,
      ),
    );
  }

  void _setAsProfile(int index) {
    final photos = widget.biodata.photos
        .asMap()
        .entries
        .map((e) => e.value.copyWith(isProfilePhoto: e.key == index))
        .toList();

    widget.onChanged(
      widget.biodata.copyWith(
        photos: photos,
        profilePhotoPath: photos[index].path,
      ),
    );
  }

  void _addCustomField() {
    final fields = List<CustomField>.from(widget.biodata.customFields);
    fields.add(
      CustomField(
        id: _uuid.v4(),
        section: 'custom',
        label: '',
        value: '',
        order: fields.length,
      ),
    );
    widget.onChanged(widget.biodata.copyWith(customFields: fields));
  }

  void _updateCustomField(int index, {String? label, String? value}) {
    final fields = widget.biodata.customFields
        .asMap()
        .entries
        .map((e) {
      if (e.key != index) return e.value;
      return e.value.copyWith(
        label: label ?? e.value.label,
        value: value ?? e.value.value,
      );
    }).toList();
    widget.onChanged(widget.biodata.copyWith(customFields: fields));
  }

  void _removeCustomField(int index) {
    final fields = widget.biodata.customFields
        .asMap()
        .entries
        .where((e) => e.key != index)
        .map((e) => e.value)
        .toList();
    widget.onChanged(widget.biodata.copyWith(customFields: fields));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final photos = widget.biodata.photos;
    final customFields = widget.biodata.customFields;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionHeader(title: 'Photos', theme: theme),
        const SizedBox(height: 12),

        // Photo grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: photos.length + 1, // +1 for add button
          itemBuilder: (context, index) {
            if (index == photos.length) {
              return _AddPhotoButton(onTap: _addPhoto);
            }
            final photo = photos[index];
            return _PhotoTile(
              photo: photo,
              onRemove: () => _removePhoto(index),
              onSetProfile: () => _setAsProfile(index),
            );
          },
        ),

        if (photos.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Tap ☆ to set as profile photo',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],

        const SizedBox(height: 24),
        _SectionHeader(title: 'Custom Fields', theme: theme),
        const SizedBox(height: 12),

        if (customFields.isEmpty)
          _EmptyCustomFields(onAdd: _addCustomField)
        else
          ...customFields.asMap().entries.map((entry) {
            final i = entry.key;
            final field = entry.value;
            return _CustomFieldTile(
              field: field,
              onLabelChanged: (v) => _updateCustomField(i, label: v),
              onValueChanged: (v) => _updateCustomField(i, value: v),
              onRemove: () => _removeCustomField(i),
            );
          }),

        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _addCustomField,
          icon: const Icon(Icons.add),
          label: const Text('Add Custom Field'),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

// ─── Sub Widgets ────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final ThemeData theme;

  const _SectionHeader({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }
}

class _AddPhotoButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddPhotoButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.3),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo_outlined,
              size: 32,
              color: theme.colorScheme.primary.withOpacity(0.6),
            ),
            const SizedBox(height: 4),
            Text(
              'Add Photo',
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.primary.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final PhotoInfo photo;
  final VoidCallback onRemove;
  final VoidCallback onSetProfile;

  const _PhotoTile({
    required this.photo,
    required this.onRemove,
    required this.onSetProfile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.file(
              File(photo.path),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: theme.colorScheme.surfaceVariant,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ),
        // Profile badge
        if (photo.isProfilePhoto)
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.star,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        // Actions
        Positioned(
          top: 4,
          right: 4,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!photo.isProfilePhoto)
                GestureDetector(
                  onTap: onSetProfile,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star_outline,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(width: 2),
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyCustomFields extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyCustomFields({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.dashboard_customize_outlined,
            size: 40,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 8),
          Text(
            'No custom fields added yet',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Custom Field'),
          ),
        ],
      ),
    );
  }
}

class _CustomFieldTile extends StatelessWidget {
  final CustomField field;
  final ValueChanged<String> onLabelChanged;
  final ValueChanged<String> onValueChanged;
  final VoidCallback onRemove;

  const _CustomFieldTile({
    required this.field,
    required this.onLabelChanged,
    required this.onValueChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: field.label,
                    onChanged: onLabelChanged,
                    decoration: const InputDecoration(
                      labelText: 'Label',
                      hintText: 'e.g. Family Property',
                      isDense: true,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: Theme.of(context).colorScheme.error,
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: field.value,
              onChanged: onValueChanged,
              decoration: const InputDecoration(
                labelText: 'Value',
                hintText: 'Enter value',
                isDense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


