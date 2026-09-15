import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import 'package:biodata_maker/core/constants/asset_constants.dart';
import 'package:biodata_maker/core/i18n/strings.dart';
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
                    hintText: Strings.tr('Search biodatas...'),
                    border: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (query) {
                    // Search composes with the active filter (the bloc keeps
                    // both and applies filter first, then search).
                    context.read<BiodataListBloc>().add(SearchBiodatas(query));
                  },
                )
              : Text(Strings.tr('My Biodatas'), key: const ValueKey('title')),
        ),
        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchController.clear();
                  context
                      .read<BiodataListBloc>()
                      .add(const SearchBiodatas(''));
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
                        Icon(Icons.error_outline,
                            size: 64, color: theme.colorScheme.error),
                        const SizedBox(height: 16),
                        Text(state.error!, style: theme.textTheme.bodyLarge),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () => context
                              .read<BiodataListBloc>()
                              .add(const LoadBiodatas()),
                          icon: const Icon(Icons.refresh),
                          label: Text(Strings.tr('Retry')),
                        ),
                      ],
                    ),
                  );
                }
                if (state.biodatas.isEmpty) {
                  return _buildEmptyState(theme, state);
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<BiodataListBloc>()
                        .add(const LoadBiodatas());
                  },
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: state.biodatas.length,
                    itemBuilder: (context, index) {
                      final biodata = state.biodatas[index];
                      return _BiodataListItem(biodata: biodata)
                          .animate()
                          .fadeIn(delay: (index * 60).ms)
                          .slideY(begin: 0.05);
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

  /// Lottie empty state matching the dashboard's, adapted for search/filter
  /// results (a filtered-to-empty view shows a softer "no results" message).
  Widget _buildEmptyState(ThemeData theme, BiodataListState state) {
    final isFiltered =
        state.filter != 'all' || state.searchQuery.isNotEmpty;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: Lottie.asset(
                AssetConstants.emptyState,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.folder_open,
                  size: 80,
                  color: theme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.5),
                ),
              ),
            ).animate().fadeIn(duration: 600.ms).scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                  curve: Curves.easeOutBack,
                ),
            const SizedBox(height: 24),
            Text(
              isFiltered
                  ? Strings.tr('No results found')
                  : Strings.tr('No biodatas found'),
              style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Text(
              isFiltered
                  ? Strings.tr('Try a different search or filter')
                  : Strings.tr('Create your first biodata to get started'),
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (!isFiltered)
              FilledButton.icon(
                onPressed: () => context.push('/biodata/create'),
                icon: const Icon(Icons.add),
                label: Text(Strings.tr('Create Biodata')),
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
          ],
        ),
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
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(Strings.tr(label)),
                  selected: isSelected,
                  onSelected: (_) {
                    context.read<BiodataListBloc>().add(SetFilter(value));
                  },
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
    if (diff.inDays > 365) return Strings.tr('${diff.inDays ~/ 365}y ago');
    if (diff.inDays > 30) return Strings.tr('${diff.inDays ~/ 30}mo ago');
    if (diff.inDays > 7) return Strings.tr('${diff.inDays ~/ 7}w ago');
    if (diff.inDays > 0) return Strings.tr('${diff.inDays}d ago');
    if (diff.inHours > 0) return Strings.tr('${diff.inHours}h ago');
    if (diff.inMinutes > 0) return Strings.tr('${diff.inMinutes}m ago');
    return Strings.tr('just now');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = biodata.fullName.isNotEmpty
        ? biodata.fullName
            .split(' ')
            .map((s) => s.isNotEmpty ? s[0] : '')
            .take(2)
            .join()
            .toUpperCase()
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
          biodata.fullName.isNotEmpty
              ? biodata.fullName
              : Strings.tr('Untitled'),
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          biodata.occupation.isNotEmpty
              ? biodata.occupation
              : Strings.tr('No occupation'),
          style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant),
        ),
        // Keep trailing light: status chip + popup only. The old Row of
        // time-chip + menu overflowed on narrow screens.
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (biodata.isDraft)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  Strings.tr('Draft'),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                    fontSize: 10,
                  ),
                ),
              )
            else
              Text(
                _timeAgo(biodata.updatedAt),
                style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant),
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
                    context
                        .read<BiodataListBloc>()
                        .add(ToggleFavorite(biodata.id));
                    break;
                  case 'duplicate':
                    context
                        .read<BiodataListBloc>()
                        .add(DuplicateBiodata(biodata.id));
                    break;
                  case 'archive':
                    context
                        .read<BiodataListBloc>()
                        .add(ToggleArchive(biodata.id));
                    break;
                  case 'delete':
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(Strings.tr('Delete Biodata')),
                        content: Text(Strings.tr(
                            'Are you sure you want to delete this biodata?')),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(Strings.tr('Cancel')),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              context
                                  .read<BiodataListBloc>()
                                  .add(DeleteBiodata(biodata.id));
                            },
                            child: Text(
                              Strings.tr('Delete'),
                              style: TextStyle(
                                  color: Theme.of(ctx).colorScheme.error),
                            ),
                          ),
                        ],
                      ),
                    );
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                    value: 'edit',
                    child: Row(children: [
                      const Icon(Icons.edit, size: 20),
                      const SizedBox(width: 12),
                      Text(Strings.tr('Edit')),
                    ])),
                PopupMenuItem(
                    value: 'preview',
                    child: Row(children: [
                      const Icon(Icons.visibility, size: 20),
                      const SizedBox(width: 12),
                      Text(Strings.tr('Preview')),
                    ])),
                PopupMenuItem(
                  value: 'favorite',
                  child: Row(children: [
                    Icon(
                        biodata.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 20),
                    const SizedBox(width: 12),
                    Text(biodata.isFavorite
                        ? Strings.tr('Unfavorite')
                        : Strings.tr('Favorite')),
                  ]),
                ),
                PopupMenuItem(
                    value: 'duplicate',
                    child: Row(children: [
                      const Icon(Icons.copy, size: 20),
                      const SizedBox(width: 12),
                      Text(Strings.tr('Duplicate')),
                    ])),
                PopupMenuItem(
                  value: 'archive',
                  child: Row(children: [
                    Icon(
                        biodata.isArchived
                            ? Icons.unarchive
                            : Icons.archive,
                        size: 20),
                    const SizedBox(width: 12),
                    Text(biodata.isArchived
                        ? Strings.tr('Unarchive')
                        : Strings.tr('Archive')),
                  ]),
                ),
                PopupMenuItem(
                    value: 'delete',
                    child: Row(children: [
                      Icon(Icons.delete,
                          size: 20,
                          color: Theme.of(context).colorScheme.error),
                      const SizedBox(width: 12),
                      Text(Strings.tr('Delete'),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error)),
                    ])),
              ],
            ),
          ],
        ),
        onTap: () => context.push('/biodata/edit/${biodata.id}'),
      ),
    );
  }
}
