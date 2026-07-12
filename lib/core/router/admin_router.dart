import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:biodata_maker/features/admin/presentation/screens/admin_login_screen.dart';
import 'package:biodata_maker/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:biodata_maker/features/admin/presentation/screens/template_editor_screen.dart';
import 'package:biodata_maker/features/admin/presentation/screens/template_preview_screen.dart';

List<GoRoute> buildAdminRoutes(GlobalKey<NavigatorState> navigatorKey) {
  return [
    GoRoute(
      path: '/admin/login',
      parentNavigatorKey: navigatorKey,
      builder: (context, state) => const AdminLoginScreen(),
    ),
    GoRoute(
      path: '/admin/dashboard',
      parentNavigatorKey: navigatorKey,
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/admin/template/new',
      parentNavigatorKey: navigatorKey,
      builder: (context, state) => const TemplateEditorScreen(),
    ),
    GoRoute(
      path: '/admin/template/edit/:id',
      parentNavigatorKey: navigatorKey,
      builder: (context, state) => TemplateEditorScreen(
        templateId: state.pathParameters['id'],
      ),
    ),
    GoRoute(
      path: '/admin/template/preview/:id',
      parentNavigatorKey: navigatorKey,
      builder: (context, state) => TemplatePreviewScreen(
        templateId: state.pathParameters['id']!,
      ),
    ),
  ];
}
