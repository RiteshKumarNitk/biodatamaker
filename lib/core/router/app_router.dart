import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:biodata_maker/features/auth/presentation/screens/splash_screen.dart';
import 'package:biodata_maker/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:biodata_maker/features/auth/presentation/screens/login_screen.dart';
import 'package:biodata_maker/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:biodata_maker/features/biodata/presentation/screens/my_biodatas_screen.dart';
import 'package:biodata_maker/features/biodata/presentation/screens/create_biodata_screen.dart';
import 'package:biodata_maker/features/biodata/presentation/screens/edit_biodata_screen.dart';
import 'package:biodata_maker/features/templates/presentation/screens/templates_screen.dart';
import 'package:biodata_maker/features/preview/presentation/screens/preview_screen.dart';
import 'package:biodata_maker/features/preview/presentation/screens/paywall_screen.dart';
import 'package:biodata_maker/features/profile/presentation/screens/profile_screen.dart';
import 'package:biodata_maker/features/settings/presentation/screens/settings_screen.dart';
import 'package:biodata_maker/features/settings/presentation/screens/privacy_policy_screen.dart';
import 'package:biodata_maker/features/admin/presentation/screens/admin_login_screen.dart';
import 'package:biodata_maker/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:biodata_maker/features/admin/presentation/screens/template_editor_screen.dart';
import 'package:biodata_maker/features/admin/presentation/screens/template_preview_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
          GoRoute(
            path: '/my-biodatas',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MyBiodatasScreen(),
            ),
          ),
          GoRoute(
            path: '/templates',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TemplatesScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/biodata/create',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateBiodataScreen(),
      ),
      GoRoute(
        path: '/biodata/edit/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => EditBiodataScreen(
          biodataId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/preview/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => PreviewScreen(
          biodataId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/paywall',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PaywallScreen(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/privacy-policy',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: '/admin/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: '/admin/dashboard',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/template/new',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TemplateEditorScreen(),
      ),
      GoRoute(
        path: '/admin/template/edit/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => TemplateEditorScreen(
          templateId: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        path: '/admin/template/preview/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => TemplatePreviewScreen(
          templateId: state.pathParameters['id']!,
        ),
      ),
    ],
  );
}

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/my-biodatas')) return 1;
    if (location.startsWith('/templates')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          switch (i) {
            case 0: context.go('/dashboard');
            case 1: context.go('/my-biodatas');
            case 2: context.go('/templates');
            case 3: context.go('/profile');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon: Icon(Icons.description),
            label: 'My Biodatas',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Templates',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: index == 0 || index == 1
          ? FloatingActionButton(
              onPressed: () => context.go('/biodata/create'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
