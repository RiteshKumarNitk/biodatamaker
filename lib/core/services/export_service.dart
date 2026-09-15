import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Where a finished export lands on the device.
enum ExportLocation {
  /// Saved into the user-visible gallery (Android Pictures/Download,
  /// iOS Photos) — best for images.
  gallery,

  /// Saved into the user-visible Downloads folder — best for PDFs.
  downloads,

  /// Saved to the app's own documents directory; not user-visible from
  /// other apps. Used when the platform gives us no better option
  /// (desktop, or a gallery/media-store failure).
  appDocuments,
}

class ExportResult {
  final ExportLocation location;
  final String path;

  const ExportResult(this.location, this.path);

  /// Human-friendly place name for snackbars, already localized at the call
  /// site via [nameKey].
  String get nameKey => switch (location) {
        ExportLocation.gallery => 'Saved to your gallery',
        ExportLocation.downloads => 'Saved to your Downloads folder',
        ExportLocation.appDocuments => 'Saved to app folder',
      };
}

/// Centralizes "put this file where the user can actually find it" logic.
///
/// Images go to the gallery via `gal` (Android MediaStore / iOS Photos).
/// PDFs go to the Android Downloads folder via MediaStore (no permission
/// needed on API 30+); on iOS the PDF is handed to the share sheet instead,
/// because iOS has no user-visible Downloads folder apps can write into
/// without a document picker.
class ExportService {
  static final ExportService _instance = ExportService._internal();
  factory ExportService() => _instance;
  ExportService._internal();

  static Future<void> _ensureMediaStoreInitialized() async {
    // Safe to call repeatedly; the plugin caches internally.
    await MediaStore.ensureInitialized();
  }

  /// Saves image [bytes] (PNG/JPEG) to the device gallery. Falls back to the
  /// app documents folder (path returned) when the gallery is unavailable.
  Future<ExportResult> saveImageToGallery(
    Uint8List bytes,
    String fileName,
  ) async {
    if (kIsWeb) return _saveToAppDocuments(bytes, fileName);
    try {
      await Gal.putImageBytes(bytes, name: fileName);
      return ExportResult(ExportLocation.gallery, fileName);
    } on GalException catch (e) {
      debugPrint('Gallery save failed (${e.type}): falling back to documents');
      return _saveToAppDocuments(bytes, fileName);
    } catch (e) {
      debugPrint('Gallery save failed: $e — falling back to documents');
      return _saveToAppDocuments(bytes, fileName);
    }
  }

  /// Saves a PDF file to the user-visible Downloads folder on Android.
  /// On other platforms (iOS/desktop) it saves to the app documents folder
  /// and returns that path — iOS users export through the share sheet.
  Future<ExportResult> savePdfToDownloads(String sourcePath, String fileName) async {
    if (!Platform.isAndroid) {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      if (sourcePath != file.path) {
        await file.writeAsBytes(await File(sourcePath).readAsBytes());
      }
      return ExportResult(ExportLocation.appDocuments, file.path);
    }
    try {
      await _ensureMediaStoreInitialized();
      final mediaStore = MediaStore();
      final saveInfo = await mediaStore.saveFile(
        tempFilePath: sourcePath,
        dirType: DirType.download,
        dirName: DirName.download,
      );
      if (saveInfo == null || !saveInfo.isSuccessful) {
        throw Exception('MediaStore save did not succeed');
      }
      // The copy now lives in Downloads; remove the app-private original.
      try {
        await File(sourcePath).delete();
      } catch (_) {}
      return ExportResult(
          ExportLocation.downloads, 'Download/VivahBio/${saveInfo.name}');
    } catch (e) {
      debugPrint('Downloads save failed: $e — keeping file in app documents');
      // Leave the original file where it is (already written by the caller).
      return ExportResult(ExportLocation.appDocuments, sourcePath);
    }
  }

  /// Writes [bytes] straight into the Downloads folder on Android (used when
  /// the PDF exists only in memory). Non-Android falls back to app documents.
  Future<ExportResult> savePdfBytesToDownloads(
    Uint8List bytes,
    String fileName,
  ) async {
    final temp = await _writeTemp(bytes, fileName);
    return savePdfToDownloads(temp, fileName);
  }

  /// Convenience: PNG bytes → gallery, with share sheet fallback for iOS
  /// users who denied photo-library access.
  Future<ExportResult> saveOrShareImage(
    Uint8List bytes,
    String fileName, {
    required String shareText,
  }) async {
    final result = await saveImageToGallery(bytes, fileName);
    if (result.location == ExportLocation.appDocuments && !kIsWeb) {
      await SharePlus.instance.share(
        ShareParams(files: [XFile(result.path)], text: shareText),
      );
    }
    return result;
  }

  Future<ExportResult> _saveToAppDocuments(Uint8List bytes, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return ExportResult(ExportLocation.appDocuments, file.path);
  }

  Future<String> _writeTemp(Uint8List bytes, String fileName) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }
}
