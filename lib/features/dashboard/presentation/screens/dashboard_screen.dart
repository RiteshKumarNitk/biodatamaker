import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import 'package:biodata_maker/core/constants/asset_constants.dart';
import 'package:biodata_maker/core/i18n/strings.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/auth/data/repositories/auth_repository.dart';
import 'package:biodata_maker/features/auth/data/models/user.dart';
import 'package:biodata_maker/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:biodata_maker/features/biodata/data/models/biodata.dart';
import 'package:biodata_maker/shared/widgets/app_banner_ad.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int? _pressedActionIndex;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
    context.read<DashboardBloc>().add(const LoadDashboard());
  }

  Future<void> _loadUser() async {
    final user = await sl<AuthRepository>().getCurrentUser();
    if (mounted) setState(() => _user = user);
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return Strings.tr('${diff.inDays}d ago');
    if (diff.inHours > 0) return Strings.tr('${diff.inHours}h ago');
    if (diff.inMinutes > 0) return Strings.tr('${diff.inMinutes}m ago');
    return Strings.tr('just now');
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(const LoadDashboard());
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  _buildAppBar(context, user, colorScheme),
                  if (state.isLoading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.error != null)
                    SliverFillRemaining(
                      child: _buildErrorView(context, state.error!),
                    )
                  else if (state.totalCount == 0)
                    SliverFillRemaining(
                      child: _buildEmptyState(context, colorScheme),
                    )
                  else
                    ..._buildDashboardContent(context, state, theme, colorScheme),
                ],
              ),
            );
          },
        ),
    );
  }

  Widget _buildAppBar(BuildContext context, User? user, ColorScheme colorScheme) {
    final name = user?.name.isNotEmpty == true ? user!.name : 'Guest';
    final initials = name.isNotEmpty
        ? name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join()
        : '?';

    return SliverAppBar(
      floating: true,
      snap: true,
      toolbarHeight: 80,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${Strings.tr('Hello')}, $name',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            Strings.tr('Welcome to Biodata Maker'),
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.05, end: 0),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.primary.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: Colors.transparent,
            child: Text(
              initials.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 100.ms).scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1, 1),
            ),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error.withValues(alpha: 0.7)),
            const SizedBox(height: 16),
            Text(
              Strings.tr('Something went wrong'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.read<DashboardBloc>().add(const LoadDashboard()),
              icon: const Icon(Icons.refresh),
              label: Text(Strings.tr('Try Again')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: LottieBuilder.asset(
                AssetConstants.emptyState,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image_not_supported_outlined,
                    size: 80,
                    color: colorScheme.error.withValues(alpha: 0.5),
                  );
                },
              ),
            ).animate().fadeIn(duration: 600.ms).scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                  curve: Curves.easeOutBack,
                ),
            const SizedBox(height: 24),
            Text(
              Strings.tr('Create your first biodata'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(
                  begin: 0.2,
                  end: 0,
                ),
            const SizedBox(height: 8),
            Text(
              Strings.tr('Design a beautiful marriage biodata\nin minutes'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(
                  begin: 0.2,
                  end: 0,
                ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.push('/biodata/create'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(200, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.add),
              label: Text(Strings.tr('Get Started')),
            ).animate().fadeIn(duration: 400.ms, delay: 400.ms).slideY(
                  begin: 0.2,
                  end: 0,
                ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDashboardContent(
    BuildContext context,
    DashboardState state,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        sliver: SliverToBoxAdapter(
          child: _buildStatsRow(context, state, colorScheme),
        ),
      ),
      if (state.draftBiodatas.isNotEmpty) ...[
        const SliverPadding(padding: EdgeInsets.only(top: 28)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverToBoxAdapter(
            child: _buildSectionHeader(
              context,
              icon: Icons.edit_note,
              title: Strings.tr('Continue Draft'),
              subtitle:
                  '${state.draftBiodatas.length} ${Strings.tr('pending')}',
              colorScheme: colorScheme,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 12),
          sliver: SliverToBoxAdapter(
            child: _buildDraftList(context, state.draftBiodatas, colorScheme),
          ),
        ),
      ],
      if (state.recentBiodatas.isNotEmpty) ...[
        const SliverPadding(padding: EdgeInsets.only(top: 28)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverToBoxAdapter(
            child: _buildSectionHeader(
              context,
              icon: Icons.history,
              title: Strings.tr('Recent Biodatas'),
              subtitle: Strings.tr('Last updated'),
              colorScheme: colorScheme,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildRecentItem(
                  context, state.recentBiodatas[index], colorScheme, index);
              },
              childCount: state.recentBiodatas.length,
            ),
          ),
        ),
      ],
      const SliverPadding(padding: EdgeInsets.only(top: 28)),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverToBoxAdapter(
          child: _buildSectionHeader(
            context,
            icon: Icons.bolt,
            title: Strings.tr('Quick Actions'),
            subtitle: Strings.tr('Jump to'),
            colorScheme: colorScheme,
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        sliver: SliverToBoxAdapter(
          child: _buildQuickActions(context, colorScheme),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Center(child: AppBannerAd()),
        ),
      ),
    ];
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required ColorScheme colorScheme,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context, DashboardState state, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(child: _buildStatCard(
          icon: Icons.description,
          label: Strings.tr('Total'),
          count: state.totalCount,
          gradientColors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.8)],
          delay: 0,
        )),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard(
          icon: Icons.favorite,
          label: Strings.tr('Favorites'),
          count: state.favoriteCount,
          gradientColors: [colorScheme.error, colorScheme.error.withValues(alpha: 0.8)],
          delay: 100,
        )),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard(
          icon: Icons.archive,
          label: Strings.tr('Archived'),
          count: state.archivedCount,
          gradientColors: [colorScheme.onSurfaceVariant, colorScheme.onSurfaceVariant.withValues(alpha: 0.8)],
          delay: 200,
        )),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required int count,
    required List<Color> gradientColors,
    required int delay,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: delay)).fadeIn(duration: 400.ms).slideY(
          begin: 0.3,
          end: 0,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildDraftList(BuildContext context, List<Biodata> drafts, ColorScheme colorScheme) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: drafts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final draft = drafts[index];
          return GestureDetector(
            onTap: () => context.push('/biodata/edit/${draft.id}'),
            child: Container(
              width: 180,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.outlineVariant),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          draft.name.isNotEmpty ? draft.name : Strings.tr('Untitled'),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          Strings.tr('Draft'),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onTertiaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 12, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        _timeAgo(draft.updatedAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate(delay: Duration(milliseconds: index * 80)).fadeIn(
                  duration: 300.ms,
                ).slideX(begin: 0.1, end: 0),
          );
        },
      ),
    );
  }

  Widget _buildRecentItem(
    BuildContext context,
    Biodata biodata,
    ColorScheme colorScheme,
    int index,
  ) {
    final initials = biodata.fullName.isNotEmpty
        ? biodata.fullName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join()
        : biodata.name.isNotEmpty ? biodata.name[0] : '?';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        elevation: 0,
        child: InkWell(
          onTap: () => context.push('/biodata/edit/${biodata.id}'),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.15),
                        colorScheme.primary.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      initials.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        biodata.fullName.isNotEmpty
                            ? biodata.fullName
                            : (biodata.name.isNotEmpty
                                ? biodata.name
                                : Strings.tr('Untitled')),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (biodata.occupation.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          biodata.occupation,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _timeAgo(biodata.updatedAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right, size: 20, color: colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ).animate(delay: Duration(milliseconds: index * 100)).fadeIn(
            duration: 300.ms,
          ).slideX(begin: 0.1, end: 0),
    );
  }

  Widget _buildQuickActions(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context: context,
            icon: Icons.add_circle_outline,
            title: Strings.tr('Create New\nBiodata'),
            gradientColors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.8)],
            onTap: () => context.push('/biodata/create'),
            delay: 0,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            context: context,
            icon: Icons.grid_view_rounded,
            title: Strings.tr('Browse\nTemplates'),
            gradientColors: [colorScheme.tertiary, colorScheme.tertiary.withValues(alpha: 0.8)],
            onTap: () => context.push('/templates'),
            delay: 100,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required List<Color> gradientColors,
    required VoidCallback onTap,
    required int delay,
  }) {
    final isPressed = _pressedActionIndex == delay;
    return AnimatedScale(
      scale: isPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onHighlightChanged: (highlighted) {
            setState(() => _pressedActionIndex = highlighted ? delay : null);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: gradientColors.first.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Colors.white, size: 32),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ).animate(delay: Duration(milliseconds: delay)).fadeIn(
                duration: 400.ms,
              ).slideY(begin: 0.2, end: 0),
        ),
      ),
    );
  }
}
