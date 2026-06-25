import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:biodata_maker/presentation/providers/app_providers.dart';

class MyBiodatasScreen extends ConsumerStatefulWidget {
  const MyBiodatasScreen({super.key});

  @override
  ConsumerState<MyBiodatasScreen> createState() => _MyBiodatasScreenState();
}

class _MyBiodatasScreenState extends ConsumerState<MyBiodatasScreen> {
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final biodatas = ref.watch(filteredBiodataProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search biodatas...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
              )
            : const Text('My Biodatas'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  ref.read(searchQueryProvider.notifier).state = '';
                }
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create'),
        icon: const Icon(Icons.add),
        label: const Text('New Biodata'),
      ),
      body: biodatas.isEmpty
          ? _EmptyState(isSearching: _isSearching)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: biodatas.length,
              itemBuilder: (context, index) {
                final biodata = biodatas[index];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor:
                          theme.colorScheme.primary.withOpacity(0.1),
                      child: Text(
                        biodata.fullName.isNotEmpty
                            ? biodata.fullName[0].toUpperCase()
                            : 'B',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    title: Text(
                      biodata.fullName.isNotEmpty
                          ? biodata.fullName
                          : biodata.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        if (biodata.occupation.isNotEmpty)
                          Text(
                            biodata.occupation,
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.5),
                            ),
                          ),
                        const SizedBox(height: 2),
                        Text(
                          'Updated ${_formatDate(biodata.updatedAt)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface
                                .withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 20),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'preview',
                          child: Row(
                            children: [
                              Icon(Icons.preview_outlined, size: 20),
                              SizedBox(width: 8),
                              Text('Preview'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'favorite',
                          child: Row(
                            children: [
                              Icon(
                                biodata.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 20,
                                color: biodata.isFavorite ? Colors.red : null,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                biodata.isFavorite
                                    ? 'Unfavorite'
                                    : 'Favorite',
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'duplicate',
                          child: Row(
                            children: [
                              Icon(Icons.copy_outlined, size: 20),
                              SizedBox(width: 8),
                              Text('Duplicate'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'archive',
                          child: Row(
                            children: [
                              Icon(Icons.archive_outlined, size: 20),
                              SizedBox(width: 8),
                              Text('Archive'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline,
                                  size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) =>
                          _handleMenuAction(context, biodata.id, value),
                    ),
                    onTap: () => context.push('/preview/${biodata.id}'),
                  ),
                ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.02);
              },
            ),
    );
  }

  void _handleMenuAction(BuildContext context, String id, String action) {
    final hiveService = ref.read(hiveServiceProvider);
    switch (action) {
      case 'edit':
        context.push('/edit/$id');
        break;
      case 'preview':
        context.push('/preview/$id');
        break;
      case 'favorite':
        hiveService.toggleFavorite(id);
        ref.invalidate(statsProvider);
        ref.invalidate(filteredBiodataProvider);
        break;
      case 'duplicate':
        hiveService.duplicateBiodata(id);
        ref.invalidate(statsProvider);
        ref.invalidate(filteredBiodataProvider);
        break;
      case 'archive':
        hiveService.toggleArchive(id);
        ref.invalidate(statsProvider);
        ref.invalidate(filteredBiodataProvider);
        break;
      case 'delete':
        _showDeleteDialog(context, id);
        break;
    }
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Biodata'),
        content: const Text('Are you sure you want to delete this biodata?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(hiveServiceProvider).deleteBiodata(id);
              ref.invalidate(statsProvider);
              ref.invalidate(filteredBiodataProvider);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _EmptyState extends StatelessWidget {
  final bool isSearching;

  const _EmptyState({required this.isSearching});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.folder_open,
              size: 64,
              color: theme.colorScheme.onSurface.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Text(
              isSearching ? 'No results found' : 'No biodatas yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSearching
                  ? 'Try a different search term'
                  : 'Tap the button below to create your first biodata',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
