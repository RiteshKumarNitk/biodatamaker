import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Admin credential verification.
///
/// The admin password is stored as a SHA-256 hash instead of plaintext in
/// the APK. Rotate it by putting a new hash here (generate with:
/// `echo -n 'newpassword' | sha256sum`). For a real backend, move this check
/// server-side — any client-side check can be patched out of a release APK;
/// this raises the bar without being a hard security boundary.
abstract final class AdminAuth {
  /// sha256('Admin@123') — the original seeded password. Rotate before
  /// shipping a production build.
  static const String _passwordHash =
      'e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7';

  static String hash(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  static bool verify(String password) => hash(password) == _passwordHash;
}
