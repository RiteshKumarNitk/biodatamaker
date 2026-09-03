import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/features/biodata/presentation/bloc/biodata_list_bloc.dart';

class MyBiodatasScreen extends StatefulWidget {
  const MyBiodatasScreen({super.key});

  @override
  State<MyBiodatasScreen> createState() => _MyBiodatasScreenState();
}

class _MyBiodatasScreenState extends State<MyBiodatasScreen> {
  bool _showSearch = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BiodataListBloc>().add(const LoadBiodatas());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: _showSearch
              ? TextField(
                  key: const ValueKey('search'),
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search biodatas...',
                    border: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (query) {
                    context.read<BiodataListBloc>().add(SearchBiodatas(query));
                  },
                )
              : const Text('My Biodatas', key: ValueKey('title')),
        ),
        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchController.clear();
                  context.read<BiodataListBloc>().add(const SearchBiodatas(''));
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _FilterChips().animate().fadeIn(duration: 400.ms),
          Expanded(
            child: BlocBuilder<BiodataListBloc, BiodataListState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.error != null) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
                        const SizedBox(height: 16),
                        Text(state.error!, style: theme.textTheme.bodyLarge),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () => context.read<BiodataListBloc>().add(const LoadBiodatas()),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                if (state.biodatas.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.folder_open, size: 80, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                        const SizedBox(height: 16),
                        Text('No biodatas found', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                        const SizedBox(height: 8),
                        Text('Create your first biodata to get started', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: () => context.push('/biodata/create'),
                          icon: const Icon(Icons.add),
                          label: const Text('Create Biodata'),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, duration: 400.ms);
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<BiodataListBloc>().add(const LoadBiodatas());
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: state.biodatas.length,
                    itemBuilder: (context, index) {
                      final biodata = state.biodatas[index];
                      return _BiodataListItem(biodata: biodata).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/biodata/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final filters = const [
    {'label': 'All', 'value': 'all'},
    {'label': 'Drafts', 'value': 'drafts'},
    {'label': 'Completed', 'value': 'completed'},
    {'label': 'Favorites', 'value': 'favorites'},
    {'label': 'Archived', 'value': 'archived'},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BiodataListBloc, BiodataListState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: filters.map((f) {
              final value = f['value'] as String;
              final label = f['label'] as String;
              final isSelected = state.filter == value;
              final chipTheme = Theme.of(context).colorScheme;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected
                        ? chipTheme.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                  ),
                  child: FilterChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (_) {
                      context.read<BiodataListBloc>().add(SetFilter(value));
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _BiodataListItem extends StatelessWidget {
  final Biodata biodata;

  const _BiodataListItem({required this.biodata});

  String _timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y ago';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo ago';
    if (diff.inDays > 7) return '${diff.inDays ~/ 7}w ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = biodata.fullName.isNotEmpty
        ? biodata.fullName.split(' ').map((s) => s.isNotEmpty ? s[0] : '').take(2).join().toUpperCase()
        : '?';
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            initials,
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Text(
          biodata.fullName.isNotEmpty ? biodata.fullName : 'Untitled',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          biodata.occupation.isNotEmpty ? biodata.occupation : 'No occupation',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (biodata.isDraft)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Draft',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                    fontSize: 10,
                  ),
                ),
              )
            else
              Text(
                _timeAgo(biodata.updatedAt),
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    context.push('/biodata/edit/${biodata.id}');
                    break;
                  case 'preview':
                    context.push('/preview/${biodata.id}');
                    break;
                  case 'favorite':
                    context.read<BiodataListBloc>().add(ToggleFavorite(biodata.id));
                    break;
                  case 'duplicate':
                    context.read<BiodataListBloc>().add(DuplicateBiodata(biodata.id));
                    break;
                  case 'archive':
                    context.read<BiodataListBloc>().add(ToggleArchive(biodata.id));
                    break;
                  case 'delete':
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Biodata'),
                        content: Text('Are you sure you want to delete ${biodata.fullName.isNotEmpty ? biodata.fullName : 'this biodata'}?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              context.read<BiodataListBloc>().add(DeleteBiodata(biodata.id));
                            },
                            child: Text('Delete', style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
                          ),
                        ],
                      ),
                    );
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit), title: Text('Edit'))),
                const PopupMenuItem(value: 'preview', child: ListTile(leading: Icon(Icons.visibility), title: Text('Preview'))),
                PopupMenuItem(
                  value: 'favorite',
                  child: ListTile(
                    leading: Icon(biodata.isFavorite ? Icons.favorite : Icons.favorite_border),
                    title: Text(biodata.isFavorite ? 'Unfavorite' : 'Favorite'),
                  ),
                ),
                const PopupMenuItem(value: 'duplicate', child: ListTile(leading: Icon(Icons.copy), title: Text('Duplicate'))),
                PopupMenuItem(
                  value: 'archive',
                  child: ListTile(
                    leading: Icon(biodata.isArchived ? Icons.unarchive : Icons.archive),
                    title: Text(biodata.isArchived ? 'Unarchive' : 'Archive'),
                  ),
                ),
                PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete, color: Theme.of(context).colorScheme.error), title: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)))),
              ],
            ),
          ],
        ),
        onTap: () => context.push('/biodata/edit/${biodata.id}'),
      ),
    );
  }
}
