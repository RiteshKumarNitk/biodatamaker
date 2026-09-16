import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/settings/data/repositories/settings_repository.dart';
import 'package:biodata_maker/core/services/ad_service.dart';
import 'package:biodata_maker/features/templates/data/models/theme_config.dart';
import 'package:biodata_maker/features/templates/presentation/bloc/template_bloc.dart';
import 'package:biodata_maker/features/templates/presentation/bloc/template_event.dart';
import 'package:biodata_maker/features/templates/presentation/bloc/template_state.dart';
import 'package:biodata_maker/features/templates/presentation/screens/template_pdf_preview_screen.dart';
import 'package:biodata_maker/shared/widgets/template_thumbnail.dart';

class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<TemplateBloc>()..add(const LoadTemplates()),
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
  List<String> _unlockedTemplates = [];

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
    _loadPremiumState();
  }

  Future<void> _loadPremiumState() async {
    final unlocked = await sl<SettingsRepository>().getUnlockedTemplates();
    if (mounted) setState(() => _unlockedTemplates = unlocked);
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
              .map((c) => Tab(text: Strings.tr(c) == c ? c : Strings.tr(c)))
              .toList(),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, duration: 400.ms),
        Expanded(
          child: BlocBuilder<TemplateBloc, TemplateState>(
            builder: (context, state) {
              if (state is TemplateLoaded) {
                // FIX: each tab must render only the templates of ITS OWN
                // category. The old code passed `state.templates` (the
                // currently-filtered list) to every tab, so all tabs showed
                // identical content.
                return TabBarView(
                  controller: _tabController,
                  children: widget.state.categories.map((category) {
                    final List<ThemeConfig> tabTemplates;
                    if (category == 'All') {
                      tabTemplates = state.templates;
                    } else if (state.selectedCategory == category) {
                      // Bloc already filtered for the active tab.
                      tabTemplates = state.templates;
                    } else {
                      tabTemplates = state.templates
                          .where((t) => t.category == category)
                          .toList();
                    }
                    return _TemplateGrid(
                      templates: tabTemplates,
                      unlockedTemplates: _unlockedTemplates,
                      onUnlocked: _loadPremiumState,
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
  final List<String> unlockedTemplates;
  final VoidCallback onUnlocked;

  const _TemplateGrid({
    required this.templates,
    required this.unlockedTemplates,
    required this.onUnlocked,
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
            Text(Strings.tr('No templates in this category'),
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) => _TemplateCard(
        template: templates[index],
        isUnlocked: unlockedTemplates.contains(templates[index].id),
        onUnlocked: onUnlocked,
      ).animate().fadeIn(delay: (index * 60).ms).slideY(begin: 0.08),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final ThemeConfig template;
  final bool isUnlocked;
  final VoidCallback onUnlocked;

  const _TemplateCard({
    required this.template,
    required this.isUnlocked,
    required this.onUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    final locked = template.isPremium && !isUnlocked;

    return GestureDetector(
      onTap: () => _onTap(context),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  TemplateThumbnail(
                    template: template,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  if (locked)
                    Positioned.fill(
                      child: Container(
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withValues(alpha: 0.55),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock_rounded,
                                size: 32,
                                color: Theme.of(context).colorScheme.primary),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                Strings.tr('Watch Ad'),
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Color(template.secondaryColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        template.category,
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
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

  void _onTap(BuildContext context) {
    final locked = template.isPremium && !isUnlocked;
    if (locked) {
      // Offer to unlock via rewarded video
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(Strings.tr('Unlock Template')),
          content: Text(Strings.tr(
              'This is a premium template. Watch a short video ad to unlock it permanently!')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(Strings.tr('Cancel')),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (c) => const Center(child: CircularProgressIndicator()),
                );
                
                final earned = await sl<AdService>().showRewardedAd();
                
                // Pop loading indicator
                if (context.mounted) Navigator.pop(context);
                
                if (earned) {
                  await sl<SettingsRepository>().unlockTemplate(template.id);
                  onUnlocked();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(Strings.tr('Template unlocked successfully!')),
                    ));
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(Strings.tr('Ad was not completed or failed to load.')),
                    ));
                  }
                }
              },
              child: Text(Strings.tr('Watch Ad')),
            ),
          ],
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TemplatePdfPreviewScreen(template: template),
      ),
    );
  }
}
