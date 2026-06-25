import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:biodata_maker/core/constants/app_constants.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = ['All', ...AppConstants.templateCategories];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Templates'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: _categories.map((c) => Tab(text: c)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          return _TemplateGrid(category: category);
        }).toList(),
      ),
    );
  }
}

class _TemplateGrid extends StatelessWidget {
  final String category;

  const _TemplateGrid({required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Placeholder templates
    final templates = List.generate(12, (index) {
      return _PlaceholderTemplate(
        name: '$category Template ${index + 1}',
        index: index,
      );
    });

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return _TemplateCard(
          template: template,
          theme: theme,
        ).animate().fadeIn(delay: (index * 50).ms).scale(begin: const Offset(0.95, 0.95));
      },
    );
  }
}

class _PlaceholderTemplate {
  final String name;
  final int index;

  const _PlaceholderTemplate({required this.name, required this.index});

  Color get previewColor {
    final colors = [
      Colors.red.shade100,
      Colors.green.shade100,
      Colors.blue.shade100,
      Colors.amber.shade100,
      Colors.purple.shade100,
      Colors.teal.shade100,
      Colors.pink.shade100,
      Colors.indigo.shade100,
      Colors.orange.shade100,
      Colors.cyan.shade100,
      Colors.deepOrange.shade100,
      Colors.lime.shade100,
    ];
    return colors[index % colors.length];
  }

  Color get accentColor {
    final colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.amber.shade700,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.orange,
      Colors.cyan,
      Colors.deepOrange,
      Colors.lime.shade700,
    ];
    return colors[index % colors.length];
  }
}

class _TemplateCard extends StatelessWidget {
  final _PlaceholderTemplate template;
  final ThemeData theme;

  const _TemplateCard({required this.template, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Preview area
          Expanded(
            flex: 3,
            child: Container(
              color: template.previewColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 40,
                      color: template.accentColor.withOpacity(0.6),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: template.accentColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'PREVIEW',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: template.accentColor,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Info area
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    template.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Free',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
