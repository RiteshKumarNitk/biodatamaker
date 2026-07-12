import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:biodata_maker/features/templates/data/models/theme_config.dart';
import 'package:biodata_maker/features/templates/data/repositories/template_repository.dart';
import 'package:biodata_maker/core/services/service_locator.dart';

class TemplatePreviewScreen extends StatelessWidget {
  final String templateId;

  const TemplatePreviewScreen({super.key, required this.templateId});

  @override
  Widget build(BuildContext context) {
    final template = sl<TemplateRepository>().getById(templateId);
    if (template == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Preview')),
        body: const Center(child: Text('Template not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Preview: ${template.name}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _DummyBiodataPreview(template: template),
      ),
    );
  }
}

class _DummyBiodataPreview extends StatelessWidget {
  final ThemeConfig template;

  const _DummyBiodataPreview({required this.template});

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(template.primaryColor);
    final textColor = Color(template.textColor);
    final subtitleColor = Color(template.subtitleColor);
    final bgColor = Color(template.backgroundColor);

    return Card(
      color: bgColor,
      child: Padding(
        padding: EdgeInsets.all(template.margin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(primaryColor, textColor, subtitleColor),
            SizedBox(height: template.sectionSpacing),
            _buildSectionTitle('About Me', primaryColor),
            SizedBox(height: template.fieldSpacing),
            Text(
              'A sincere and family-oriented person looking for a life partner who values tradition and modern values alike.',
              style: GoogleFonts.poppins(
                  fontSize: template.bodyFontSize, color: textColor),
            ),
            SizedBox(height: template.sectionSpacing),
            _buildSectionTitle('Education & Career', primaryColor),
            SizedBox(height: template.fieldSpacing),
            _buildField('Qualification', 'M.Tech in Computer Science',
                subtitleColor, textColor),
            _buildField(
                'Occupation', 'Software Engineer', subtitleColor, textColor),
            _buildField('Annual Income', '₹12,00,000',
                subtitleColor, textColor),
            SizedBox(height: template.sectionSpacing),
            _buildSectionTitle('Family Details', primaryColor),
            SizedBox(height: template.fieldSpacing),
            _buildField('Father', 'Mr. Rajesh Sharma',
                subtitleColor, textColor),
            _buildField(
                'Mother', 'Mrs. Sunita Sharma', subtitleColor, textColor),
            _buildField('Brothers', '1 Elder', subtitleColor, textColor),
            _buildField('Sisters', '1 Younger', subtitleColor, textColor),
            SizedBox(height: template.sectionSpacing),
            _buildSectionTitle('Lifestyle & Interests', primaryColor),
            SizedBox(height: template.fieldSpacing),
            _buildField('Diet', 'Vegetarian', subtitleColor, textColor),
            _buildField('Languages', 'Hindi, English',
                subtitleColor, textColor),
            _buildField('Hobbies', 'Reading, Traveling, Music',
                subtitleColor, textColor),
            SizedBox(height: template.sectionSpacing),
            _buildSectionTitle('Contact Information', primaryColor),
            SizedBox(height: template.fieldSpacing),
            _buildField(
                'Mobile', '+91-9876543210', subtitleColor, textColor),
            _buildField('Email', 'arjun.sharma@email.com',
                subtitleColor, textColor),
            _buildField('City', 'Mumbai, Maharashtra',
                subtitleColor, textColor),
            SizedBox(height: template.sectionSpacing),
            _buildSectionTitle('Partner Preference', primaryColor),
            SizedBox(height: template.fieldSpacing),
            _buildField(
                'Preferred Age', '25-30', subtitleColor, textColor),
            _buildField('Preferred Education', 'Graduate',
                subtitleColor, textColor),
            _buildField(
                'Expectations',
                'Looking for a caring, educated partner from a respectable family.',
                subtitleColor,
                textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color primary, Color text, Color subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(
                template.photoShape == 'circle' ? 50 : 12),
          ),
          child: Center(
            child: Text(
              _getInitials('Arjun Sharma'),
              style: GoogleFonts.playfairDisplay(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Arjun Sharma',
                style: GoogleFonts.playfairDisplay(
                  fontSize: template.headingFontSize,
                  color: text,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '28 years | Male',
                style: GoogleFonts.poppins(
                    fontSize: template.bodyFontSize, color: subtitle),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Software Engineer',
                  style: GoogleFonts.poppins(
                      fontSize: template.bodyFontSize, color: subtitle),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, Color primary) {
    return Text(
      title,
      style: GoogleFonts.playfairDisplay(
        fontSize: template.headingFontSize - 4,
        color: primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildField(
      String label, String value, Color subtitle, Color text) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: template.fieldSpacing / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: template.bodyFontSize,
                color: subtitle,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: template.bodyFontSize,
                color: text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
