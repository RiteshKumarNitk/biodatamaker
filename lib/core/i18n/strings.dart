import 'package:flutter/foundation.dart';

import 'hi_strings.dart';

/// Lightweight, dependency-free localization used across the app.
///
/// UI copy stays authored in English and passes through [tr]; when the active
/// language is Hindi the matching entry from [kHiStrings] is returned and any
/// key without a translation falls back to the English text. User-entered
/// data (names, dropdown values, custom field labels) is never translated and
/// PDF output intentionally keeps its English labels.
class Strings {
  Strings._();

  static const String en = 'en';
  static const String hi = 'hi';
  static const List<String> supported = [en, hi];

  static final ValueNotifier<String> notifier = ValueNotifier<String>(en);
  static String _language = en;

  static String get language => _language;

  /// Switches the whole app (and fires [notifier] so the root rebuilds).
  static void set(String language) {
    if (!supported.contains(language)) language = en;
    if (_language == language) return;
    _language = language;
    notifier.value = language;
  }

  static bool get isHindi => _language == hi;

  static String tr(String text) {
    if (!isHindi) return text;
    return kHiStrings[text] ?? text;
  }
}
