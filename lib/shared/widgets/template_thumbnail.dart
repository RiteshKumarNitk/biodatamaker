import 'package:flutter/material.dart';

import 'package:biodata_maker/core/services/pdf_service.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/templates/data/models/theme_config.dart';
import 'package:biodata_maker/shared/widgets/sample_biodata.dart';

/// A small rendered preview of a template, generated from the real PDF
/// engine (so thumbnails match the final document exactly) and cached in
/// memory for the session.
///
/// Falls back to a color-swatch placeholder while generating or if raster
/// rendering is unavailable on the current platform.
class TemplateThumbnail extends StatefulWidget {
  final ThemeConfig template;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const TemplateThumbnail({
    super.key,
    required this.template,
    this.width = 120,
    this.height = 170,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  State<TemplateThumbnail> createState() => _TemplateThumbnailState();
}

class _TemplateThumbnailState extends State<TemplateThumbnail> {
  static final Map<String, ImageProvider> _cache = {};

  late ImageProvider? _image;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _image = _cache[widget.template.id];
    if (_image == null) {
      _generate();
    }
  }

  Future<void> _generate() async {
    try {
      final png = await sl<PdfService>().renderPageImage(
        sampleBiodataForPreview,
        widget.template,
        dpi: 72, // thumbnail resolution; keeps generation fast
      );
      if (!mounted) return;
      final provider = MemoryImage(png);
      _cache[widget.template.id] = provider;
      setState(() => _image = provider);
    } catch (_) {
      if (!mounted) return;
      setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: _image != null
            ? Image(image: _image!, fit: BoxFit.cover)
            : _buildPlaceholder(context),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final primary = Color(widget.template.primaryColor);
    return Container(
      color: Color(widget.template.backgroundColor),
      alignment: Alignment.center,
      child: _failed
          ? Text(
              widget.template.name.isNotEmpty
                  ? widget.template.name[0].toUpperCase()
                  : '?',
              style: TextStyle(
                color: primary,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            )
          : const CircularProgressIndicator(strokeWidth: 2),
    );
  }
}
