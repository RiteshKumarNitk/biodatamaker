import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/settings/data/repositories/settings_repository.dart';
import 'package:biodata_maker/features/templates/data/models/theme_config.dart';
import 'package:biodata_maker/features/templates/presentation/bloc/template_bloc.dart';
import 'package:biodata_maker/features/templates/presentation/bloc/template_event.dart';
import 'package:biodata_maker/features/templates/presentation/bloc/template_state.dart';
import 'package:biodata_maker/shared/widgets/biodata_renderer.dart';
import 'package:biodata_maker/shared/widgets/sample_biodata.dart';

class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TemplateBloc()..add(const LoadTemplates()),
      child: const _TemplatesView(),
    );
  }
}

class _TemplatesView extends StatelessWidget {
  const _TemplatesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.tr('Template Store'))),
      body: BlocBuilder<TemplateBloc, TemplateState>(
        builder: (context, state) {
          if (state is TemplateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TemplateError) {
            return Center(child: Text(state.message));
          }
          if (state is TemplateLoaded) {
            return _TemplateContent(state: state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _TemplateContent extends StatefulWidget {
  final TemplateLoaded state;

  const _TemplateContent({required this.state});

  @override
  State<_TemplateContent> createState() => _TemplateContentState();
}

class _TemplateContentState extends State<_TemplateContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.state.categories.length,
      vsync: this,
    );
    final initialIndex = widget.state.categories
        .indexOf(widget.state.selectedCategory);
    if (initialIndex >= 0) {
      _tabController.index = initialIndex;
    }
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      final category = widget.state.categories[_tabController.index];
      context.read<TemplateBloc>().add(FilterByCategory(category));
    }
  }

  @override
  void didUpdateWidget(covariant _TemplateContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.categories.length != widget.state.categories.length) {
      _tabController.dispose();
      _tabController = TabController(
        length: widget.state.categories.length,
        vsync: this,
      );
      final initialIndex = widget.state.categories
          .indexOf(widget.state.selectedCategory);
      if (initialIndex >= 0) {
        _tabController.index = initialIndex;
      }
      _tabController.addListener(_onTabChanged);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: widget.state.categories
              .map((c) => Tab(text: c))
              .toList(),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, duration: 400.ms),
        Expanded(
          child: BlocBuilder<TemplateBloc, TemplateState>(
            builder: (context, state) {
              if (state is TemplateLoaded) {
                return TabBarView(
                  controller: _tabController,
                  children: widget.state.categories.map((category) {
                    return _TemplateGrid(
                      templates: state.templates,
                      selectedCategory: category,
                    );
                  }).toList(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

class _TemplateGrid extends StatelessWidget {
  final List<ThemeConfig> templates;
  final String selectedCategory;

  const _TemplateGrid({
    required this.templates,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    if (templates.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.dashboard_customize_outlined,
                size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text('No templates in this category',
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) =>
          _TemplateCard(template: templates[index]).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final ThemeConfig template;

  const _TemplateCard({required this.template});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(template.primaryColor);
    final secondaryColor = Color(template.secondaryColor);

    return GestureDetector(
      onTap: () => _showTemplatePreview(context),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  image: template.backgroundImage.isNotEmpty
                      ? DecorationImage(image: AssetImage(template.backgroundImage), fit: BoxFit.cover)
                      : null,
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            template.name.isNotEmpty
                                ? template.name[0].toUpperCase()
                                : '?',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (template.isPremium)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              template.category,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                template.name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTemplatePreview(BuildContext context) {
    final settingsRepo = sl<SettingsRepository>();
    final isPremium = settingsRepo.isPremium;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 420),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: IgnorePointer(
                    child: SingleChildScrollView(
                      child: BiodataRenderer(
                        biodata: sampleBiodataForPreview,
                        theme: template,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  template.name,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(template.secondaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    template.category,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Template Details',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildChip('Colors', '${template.primaryColor.toRadixString(16).substring(2)} / ${template.secondaryColor.toRadixString(16).substring(2)}'),
                  _buildChip('Font Style', '${template.headingFont} / ${template.bodyFont}'),
                  _buildChip('Photo Shape', template.photoShape),
                  _buildChip('Border Style', template.borderStyle),
                  _buildChip('Header Decoration', template.headerDecoration),
                  _buildChip('Footer Decoration', template.footerDecoration),
                  _buildChip('Divider Style', template.dividerStyle),
                  if (template.isPremium)
                    const Chip(
                      avatar: Icon(Icons.star, size: 16),
                      label: Text('Premium'),
                    )
                  else
                    Chip(
                      avatar: Icon(Icons.check_circle, size: 16,
                          color: Theme.of(context).colorScheme.tertiary),
                      label: const Text('Free'),
                    ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (template.isPremium && !isPremium) {
                      Navigator.of(ctx).pop();
                      context.push('/paywall');
                    } else {
                      Navigator.of(ctx).pop();
                      context.push('/biodata/create?templateId=${template.id}');
                    }
                  },
                  child: Text(
                    template.isPremium && !isPremium
                        ? 'Unlock with Premium'
                        : 'Use This Template',
                  ),
                ),
              ),
              if (template.isPremium && !isPremium)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.push('/paywall');
                      },
                      child: const Text('View Premium Plans'),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, String value) {
    return Chip(
      label: Text('$label: $value'),
      labelStyle: GoogleFonts.poppins(fontSize: 11),
    );
  }
}
