import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:biodata_maker/core/services/hive_service.dart';
import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/core/theme/app_theme.dart';
import 'package:biodata_maker/core/router/app_router.dart';
import 'package:biodata_maker/features/auth/data/models/user.dart';
import 'package:biodata_maker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:biodata_maker/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:biodata_maker/features/biodata/presentation/bloc/biodata_list_bloc.dart';
import 'package:biodata_maker/features/biodata/presentation/bloc/form_bloc.dart';
import 'package:biodata_maker/features/templates/presentation/bloc/template_bloc.dart';
import 'package:biodata_maker/features/templates/presentation/bloc/template_event.dart';
import 'package:biodata_maker/features/settings/presentation/bloc/settings_bloc.dart';

import 'package:biodata_maker/features/templates/data/models/theme_engine.dart';
import 'package:biodata_maker/features/settings/presentation/bloc/settings_event.dart';
import 'package:biodata_maker/features/settings/presentation/bloc/settings_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hiveService = HiveService();
  await hiveService.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  setupServiceLocator(hiveService);

  // Seed default templates on initial startup if empty
  await _seedTemplates(hiveService);
  await _seedAdmin(hiveService);

  runApp(const BiodataMakerApp());
}

Future<void> _seedTemplates(HiveService hiveService) async {
  if (hiveService.getAllTemplates().isEmpty) {
    for (final template in ThemeEngine.defaultTemplates) {
      await hiveService.saveTemplate(template);
    }
  }
}

Future<void> _seedAdmin(HiveService hiveService) async {
  final existing = hiveService.getAllUsers().where((u) => u.email == 'admin@biodata.com');
  if (existing.isEmpty) {
    final admin = User(
      id: const Uuid().v4(),
      name: 'Admin',
      email: 'admin@biodata.com',
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
    await hiveService.saveUser(admin);
  }
}

class BiodataMakerApp extends StatelessWidget {
  const BiodataMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<DashboardBloc>(create: (_) => DashboardBloc()),
        BlocProvider<BiodataListBloc>(create: (_) => BiodataListBloc()),
        BlocProvider<BiodataFormBloc>(create: (_) => BiodataFormBloc()),
        BlocProvider<TemplateBloc>(create: (_) => TemplateBloc()..add(const LoadTemplates())),
        BlocProvider<SettingsBloc>(create: (_) => SettingsBloc()..add(const LoadSettings())),
      ],
      child: const _AppContent(),
    );
  }
}

class _AppContent extends StatelessWidget {
  const _AppContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        ThemeMode themeMode = ThemeMode.system;
        if (state is SettingsLoaded) {
          switch (state.settings.themeMode) {
            case 'light':
              themeMode = ThemeMode.light;
              break;
            case 'dark':
              themeMode = ThemeMode.dark;
              break;
            default:
              themeMode = ThemeMode.system;
              break;
          }
        }
        return MaterialApp.router(
          title: 'Biodata Maker',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
