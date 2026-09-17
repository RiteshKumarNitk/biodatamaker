import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:biodata_maker/core/constants/font_constants.dart';
import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';

class FontSelectionStep extends StatelessWidget {
  final Biodata biodata;
  final void Function(Biodata) onUpdate;

  const FontSelectionStep({
    super.key,
    required this.biodata,
    required this.onUpdate,
  });

  String get _currentFontId =>
      biodata.selectedFontId.isEmpty
          ? FontConstants.defaultFontId
          : biodata.selectedFontId;

  String get _currentBodyFontId =>
      biodata.customSecondaryFont.isEmpty
          ? _currentFontId
          : biodata.customSecondaryFont;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sampleName = biodata.fullName.isNotEmpty
        ? biodata.fullName
        : 'Ritesh Sharma';

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            indicatorColor: theme.colorScheme.primary,
            tabs: const [
              Tab(text: 'Heading Font'),
              Tab(text: 'Body Font'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildFontList(theme, sampleName, true),
                _buildFontList(theme, sampleName, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFontList(ThemeData theme, String sampleName, bool isHeading) {
    final currentId = isHeading ? _currentFontId : _currentBodyFontId;
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _FontPreview(
          headingFont: FontConstants.getById(_currentFontId),
          bodyFont: FontConstants.getById(_currentBodyFontId),
          sampleText: sampleName,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHeading ? Strings.tr('Select Heading Font') : Strings.tr('Select Body Font'),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ...FontConstants.availableFonts.map((font) {
                  final isSelected = font.id == currentId;
                  return _FontOption(
                    font: font,
                    sampleText: isHeading ? sampleName : 'Date of Birth : 01/01/1995',
                    isSelected: isSelected,
                    onTap: () {
                      if (isHeading) {
                        onUpdate(biodata.copyWith(selectedFontId: font.id));
                      } else {
                        onUpdate(biodata.copyWith(customSecondaryFont: font.id));
                      }
                    },
                  );
                }),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _FontPreview extends StatelessWidget {
  final BiodataFont headingFont;
  final BiodataFont bodyFont;
  final String sampleText;

  const _FontPreview({
    required this.headingFont,
    required this.bodyFont,
    required this.sampleText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.visibility_outlined,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    Strings.tr('Font Preview'),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        headingFont.name,
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (headingFont.name != bodyFont.name)
                        Text(
                          '+ ${bodyFont.name}',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                            fontSize: 9,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sampleText,
                    style: _fontStyle(headingFont, 28, FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date of Birth : 01/01/1995',
                    style: _fontStyle(bodyFont, 14, FontWeight.normal),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Height : 5\'9"',
                    style: _fontStyle(bodyFont, 14, FontWeight.normal),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Occupation : Software Engineer',
                    style: _fontStyle(bodyFont, 14, FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _fontStyle(BiodataFont font, double size, FontWeight weight) {
    return GoogleFonts.getFont(
      font.name,
      fontSize: size,
      fontWeight: weight,
    );
  }
}

class _FontOption extends StatelessWidget {
  final BiodataFont font;
  final String sampleText;
  final bool isSelected;
  final VoidCallback onTap;

  const _FontOption({
    required this.font,
    required this.sampleText,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          font.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            font.category,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sampleText,
                      style: GoogleFonts.getFont(
                        font.name,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
