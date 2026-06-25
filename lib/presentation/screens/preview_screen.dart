import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:biodata_maker/presentation/providers/app_providers.dart';
import 'package:biodata_maker/core/theme/theme_engine.dart';
import 'package:biodata_maker/core/services/pdf_service.dart';
import 'package:biodata_maker/data/models/theme_config.dart';
import 'package:biodata_maker/data/models/biodata.dart';

class PreviewScreen extends ConsumerStatefulWidget {
  final String biodataId;

  const PreviewScreen({super.key, required this.biodataId});

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  ThemeConfig _selectedTheme = ThemeEngine.templates.first;
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final hiveService = ref.read(hiveServiceProvider);
    final biodata = hiveService.getBiodata(widget.biodataId);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        actions: [
          if (biodata != null) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.push('/edit/${widget.biodataId}');
              },
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: _isExporting
                  ? null
                  : () => _sharePdf(biodata),
              tooltip: 'Share PDF',
            ),
          ],
        ],
      ),
      floatingActionButton: biodata != null
          ? FloatingActionButton.extended(
              onPressed: _isExporting
                  ? null
                  : () => _previewPdf(biodata),
              icon: _isExporting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.picture_as_pdf),
              label: Text(_isExporting ? 'Exporting...' : 'Export PDF'),
            )
          : null,
      body: biodata == null
          ? _NotFoundState(theme: theme)
          : Column(
              children: [
                // Theme Selector
                _ThemeSelector(
                  selectedTheme: _selectedTheme,
                  onThemeSelected: (t) => setState(() => _selectedTheme = t),
                ),

                // Preview Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _BiodataPreviewCard(
                      biodata: biodata,
                      themeConfig: _selectedTheme,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _previewPdf(Biodata biodata) async {
    setState(() => _isExporting = true);
    try {
      await PdfService.previewPdf(
        biodata: biodata,
        theme: _selectedTheme,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _sharePdf(Biodata biodata) async {
    setState(() => _isExporting = true);
    try {
      await PdfService.sharePdf(
        biodata: biodata,
        theme: _selectedTheme,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }
}

// ─── Theme Selector ─────────────────────────────────────────────────

class _ThemeSelector extends StatelessWidget {
  final ThemeConfig selectedTheme;
  final ValueChanged<ThemeConfig> onThemeSelected;

  const _ThemeSelector({
    required this.selectedTheme,
    required this.onThemeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.palette_outlined,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Theme',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  selectedTheme.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 56,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: ThemeEngine.templates.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final template = ThemeEngine.templates[index];
                final isSelected = template.id == selectedTheme.id;
                return GestureDetector(
                  onTap: () => onThemeSelected(template),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 80,
                    decoration: BoxDecoration(
                      color: Color(template.backgroundColor),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Color(template.primaryColor)
                            : Colors.transparent,
                        width: 2.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Color(template.primaryColor)
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Color(template.primaryColor),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              template.name[0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          template.name,
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: Color(template.textColor),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Biodata Preview Card ──────────────────────────────────────────

class _BiodataPreviewCard extends StatelessWidget {
  final Biodata biodata;
  final ThemeConfig themeConfig;

  const _BiodataPreviewCard({
    required this.biodata,
    required this.themeConfig,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = themeConfig.backgroundColor == 0xFF1E1E1E;
    final primaryColor = Color(themeConfig.primaryColor);
    final secondaryColor = Color(themeConfig.secondaryColor);
    final bgColor = Color(themeConfig.backgroundColor);
    final textColor = Color(themeConfig.textColor);
    final subtitleColor = Color(themeConfig.subtitleColor);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 700),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(themeConfig.margin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header with Photo ────────────────────────────
            _buildHeader(
              primaryColor: primaryColor,
              secondaryColor: secondaryColor,
              bgColor: bgColor,
              textColor: textColor,
            ),

            SizedBox(height: themeConfig.sectionSpacing),

            // ─── Personal Details ─────────────────────────────
            _buildSection(
              'Personal Details',
              primaryColor: primaryColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
              items: {
                'Full Name': biodata.fullName,
                'Age': biodata.age > 0 ? '${biodata.age} years' : '',
                'Religion': biodata.religion,
                'Caste': biodata.caste,
                'Mother Tongue': biodata.motherTongue,
                'Height': biodata.height,
                'Complexion': biodata.complexion,
                'Marital Status': biodata.maritalStatus,
                'Blood Group': biodata.bloodGroup,
              },
            ),

            SizedBox(height: themeConfig.sectionSpacing),

            // ─── About Me ─────────────────────────────────────
            if (biodata.aboutMe.isNotEmpty) ...[
              _buildSection(
                'About Me',
                primaryColor: primaryColor,
                textColor: textColor,
                subtitleColor: subtitleColor,
                items: {'': biodata.aboutMe},
                isAboutMe: true,
              ),
              SizedBox(height: themeConfig.sectionSpacing),
            ],

            // ─── Education & Career ───────────────────────────
            _buildSection(
              'Education & Career',
              primaryColor: primaryColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
              items: {
                'Qualification': biodata.qualification,
                'College': biodata.college,
                'Occupation': biodata.occupation,
                'Designation': biodata.designation,
                'Company': biodata.company,
                'Annual Income': biodata.annualIncome,
              },
            ),

            SizedBox(height: themeConfig.sectionSpacing),

            // ─── Family Details ───────────────────────────────
            _buildSection(
              'Family Details',
              primaryColor: primaryColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
              items: {
                "Father's Name": biodata.fatherName,
                "Father's Occupation": biodata.fatherOccupation,
                "Mother's Name": biodata.motherName,
                'Brothers': biodata.brothers,
                'Sisters': biodata.sisters,
                'Family Type': biodata.familyType,
                'Native Place': biodata.nativePlace,
              },
            ),

            SizedBox(height: themeConfig.sectionSpacing),

            // ─── Lifestyle ────────────────────────────────────
            _buildSection(
              'Lifestyle',
              primaryColor: primaryColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
              items: {
                'Diet': biodata.diet,
                'Smoking': biodata.smoking,
                'Drinking': biodata.drinking,
                'Languages': biodata.languages,
                'Hobbies': biodata.hobbies,
              },
            ),

            SizedBox(height: themeConfig.sectionSpacing),

            // ─── Partner Preferences ──────────────────────────
            _buildSection(
              'Partner Preferences',
              primaryColor: primaryColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
              items: {
                'Preferred Age': biodata.preferredAge,
                'Preferred Height': biodata.preferredHeight,
                'Preferred Education': biodata.preferredEducation,
                'Preferred Occupation': biodata.preferredOccupation,
                'Preferred Religion': biodata.preferredReligion,
                'Preferred Location': biodata.preferredLocation,
              },
              extra: biodata.expectations.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        biodata.expectations,
                        style: TextStyle(
                          fontSize: themeConfig.bodyFontSize,
                          color: textColor,
                          height: 1.5,
                        ),
                      ),
                    )
                  : null,
            ),

            SizedBox(height: themeConfig.sectionSpacing),

            // ─── Contact ──────────────────────────────────────
            _buildSection(
              'Contact Information',
              primaryColor: primaryColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
              items: {
                'Mobile': biodata.mobile,
                'WhatsApp': biodata.whatsapp,
                'Email': biodata.email,
                'City': biodata.city,
                'State': biodata.state,
                'Country': biodata.country,
              },
            ),

            // ─── Footer ───────────────────────────────────────
            SizedBox(height: themeConfig.sectionSpacing * 2),
            Divider(color: primaryColor.withOpacity(0.3)),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Created with Biodata Maker',
                style: TextStyle(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: subtitleColor.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({
    required Color primaryColor,
    required Color secondaryColor,
    required Color bgColor,
    required Color textColor,
  }) {
    return Column(
      children: [            // Photo
        if (themeConfig.photoShape == 'circle')
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withOpacity(0.1),
              border: Border.all(color: primaryColor.withOpacity(0.3), width: 2),
            ),
            child: biodata.profilePhotoPath.isNotEmpty
                ? ClipOval(
                    child: Image.file(
                      File(biodata.profilePhotoPath),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildPlaceholder(primaryColor),
                    ),
                  )
                : _buildPlaceholder(primaryColor),
          )
        else
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: primaryColor.withOpacity(0.1),
              border: Border.all(color: primaryColor.withOpacity(0.3), width: 2),
            ),
            child: biodata.profilePhotoPath.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(biodata.profilePhotoPath),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildPlaceholder(primaryColor),
                    ),
                  )
                : _buildPlaceholder(primaryColor),
          ),

        const SizedBox(height: 12),

        // Name
        Text(
          biodata.fullName.isNotEmpty ? biodata.fullName : biodata.name,
          style: TextStyle(
            fontSize: themeConfig.headingFontSize,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),

        // Occupation
        if (biodata.occupation.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            biodata.occupation,
            style: TextStyle(
              fontSize: themeConfig.bodyFontSize,
              color: secondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],

        // Divider
        const SizedBox(height: 12),
        Divider(color: primaryColor.withOpacity(0.3)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildPlaceholder(Color primaryColor) {
    return Center(
      child: Icon(
        Icons.person,
        size: 40,
        color: primaryColor.withOpacity(0.5),
      ),
    );
  }

  Widget _buildSection(
    String title, {
    required Color primaryColor,
    required Color textColor,
    required Color subtitleColor,
    required Map<String, String> items,
    bool isAboutMe = false,
    Widget? extra,
  }) {
    final validItems = items.entries.where((e) => e.value.isNotEmpty).toList();
    if (validItems.isEmpty && extra == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: themeConfig.bodyFontSize + 2,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 6),
        Divider(color: primaryColor.withOpacity(0.2)),
        const SizedBox(height: 6),
        if (isAboutMe)
          Text(
            validItems.first.value,
            style: TextStyle(
              fontSize: themeConfig.bodyFontSize,
              color: textColor,
              height: 1.5,
            ),
          )
        else
          ...validItems.map(
            (entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      '${entry.key}:',
                      style: TextStyle(
                        fontSize: themeConfig.bodyFontSize - 1,
                        color: subtitleColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: themeConfig.bodyFontSize,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (extra != null) extra,
      ],
    );
  }
}

// ─── Not Found State ────────────────────────────────────────────────

class _NotFoundState extends StatelessWidget {
  final ThemeData theme;

  const _NotFoundState({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: theme.colorScheme.error.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Biodata not found',
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
