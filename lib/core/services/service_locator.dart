import 'package:get_it/get_it.dart';
import 'package:biodata_maker/core/services/hive_service.dart';
import 'package:biodata_maker/core/services/pdf_service.dart';
import 'package:biodata_maker/core/services/ad_service.dart';
import 'package:biodata_maker/core/services/export_service.dart';
import 'package:biodata_maker/features/auth/data/repositories/auth_repository.dart';
import 'package:biodata_maker/features/biodata/data/repositories/biodata_repository.dart';
import 'package:biodata_maker/features/settings/data/repositories/settings_repository.dart';
import 'package:biodata_maker/features/templates/data/repositories/template_repository.dart';

final GetIt sl = GetIt.instance;

void setupServiceLocator(HiveService hiveService) {
  sl.registerSingleton<HiveService>(hiveService);
  sl.registerLazySingleton<AdService>(() => AdService());
  sl.registerLazySingleton<PdfService>(() => PdfService());
  sl.registerLazySingleton<ExportService>(() => ExportService());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository());
  sl.registerLazySingleton<BiodataRepository>(() => BiodataRepository());
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepository());
  sl.registerLazySingleton<TemplateRepository>(() => TemplateRepository());
}
