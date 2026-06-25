import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:biodata_maker/presentation/providers/app_providers.dart';
import 'package:biodata_maker/presentation/widgets/common/dashboard_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Biodata Maker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            _WelcomeHeader(),
            const SizedBox(height: 24),

            // Quick Stats
            _StatsRow(stats: stats),
            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Quick Actions',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            DashboardCard(
              icon: Icons.add_circle_outline,
              title: 'Create Biodata',
              subtitle: 'Start a new biodata from scratch',
              onTap: () => context.push('/create'),
              color: theme.colorScheme.primary,
            ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.05),

            const SizedBox(height: 8),
            DashboardCard(
              icon: Icons.dashboard_outlined,
              title: 'Premium Templates',
              subtitle: 'Explore beautiful template designs',
              onTap: () => context.go('/templates'),
              color: Colors.amber.shade700,
            ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.05),

            const SizedBox(height: 24),

            // Recent Biodatas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Biodatas',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/my-biodatas'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Recent list or empty state
            const _RecentBiodatasList(),
          ],
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome! 🎊',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create beautiful marriage biodatas\nin minutes',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}

class _StatsRow extends StatelessWidget {
  final Map<String, int> stats;

  const _StatsRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        _StatChip(
          label: 'Total',
          value: '${stats['total'] ?? 0}',
          color: theme.colorScheme.primary,
        ).animate().fadeIn(delay: 150.ms),
        const SizedBox(width: 8),
        _StatChip(
          label: 'Favorites',
          value: '${stats['favorites'] ?? 0}',
          color: Colors.amber,
        ).animate().fadeIn(delay: 250.ms),
        const SizedBox(width: 8),
        _StatChip(
          label: 'Archived',
          value: '${stats['archived'] ?? 0}',
          color: Colors.grey,
        ).animate().fadeIn(delay: 350.ms),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentBiodatasList extends ConsumerWidget {
  const _RecentBiodatasList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biodatas = ref.watch(filteredBiodataProvider);
    final theme = Theme.of(context);

    if (biodatas.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.note_add_outlined,
              size: 48,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No biodatas yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first biodata to get started',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 400.ms);
    }

    return Column(
      children: biodatas.take(3).map((biodata) {
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              child: Text(
                biodata.fullName.isNotEmpty
                    ? biodata.fullName[0].toUpperCase()
                    : 'B',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              biodata.fullName.isNotEmpty ? biodata.fullName : biodata.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              biodata.occupation.isNotEmpty ? biodata.occupation : 'No occupation set',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                fontSize: 13,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            onTap: () => context.push('/preview/${biodata.id}'),
          ),
        );
      }).toList(),
    ).animate().fadeIn(delay: 400.ms);
  }
}
