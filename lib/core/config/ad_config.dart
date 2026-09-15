import 'package:flutter/foundation.dart';

abstract final class AdConfig {
  const AdConfig._();

  // ── Google sample App IDs ──
  static const String sampleAndroidAppId =
      'ca-app-pub-3940256099942544~3347511713';
  static const String sampleIosAppId =
      'ca-app-pub-3940256099942544~1458002511';

  // ── Google official test ad unit IDs ──
  static const String _testBannerAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testBannerIos =
      'ca-app-pub-3940256099942544/2934735716';
  static const String _testInterstitialAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testInterstitialIos =
      'ca-app-pub-3940256099942544/4411468910';
  static const String _testRewardedAndroid =
      'ca-app-pub-3940256099942544/5224354917';
  static const String _testRewardedIos =
      'ca-app-pub-3940256099942544/1712485313';

  // ── Real ad unit IDs, injected at build time (empty by default) ──
  static const String _bannerAndroid =
      String.fromEnvironment('BANNER_AD_UNIT_ID_ANDROID');
  static const String _bannerIos =
      String.fromEnvironment('BANNER_AD_UNIT_ID_IOS');
  static const String _interstitialAndroid =
      String.fromEnvironment('INTERSTITIAL_AD_UNIT_ID_ANDROID');
  static const String _interstitialIos =
      String.fromEnvironment('INTERSTITIAL_AD_UNIT_ID_IOS');
  static const String _rewardedAndroid =
      String.fromEnvironment('REWARDED_AD_UNIT_ID_ANDROID');
  static const String _rewardedIos =
      String.fromEnvironment('REWARDED_AD_UNIT_ID_IOS');

  static bool get _isAndroid =>
      defaultTargetPlatform == TargetPlatform.android;

  static String _resolve({
    required String real,
    required String testId,
  }) {
    if (kReleaseMode && real.isNotEmpty) return real;
    return testId;
  }

  static String get bannerAdUnitId => _resolve(
        real: _isAndroid ? _bannerAndroid : _bannerIos,
        testId: _isAndroid ? _testBannerAndroid : _testBannerIos,
      );

  static String get interstitialAdUnitId => _resolve(
        real: _isAndroid ? _interstitialAndroid : _interstitialIos,
        testId: _isAndroid ? _testInterstitialAndroid : _testInterstitialIos,
      );

  static String get rewardedAdUnitId => _resolve(
        real: _isAndroid ? _rewardedAndroid : _rewardedIos,
        testId: _isAndroid ? _testRewardedAndroid : _testRewardedIos,
      );

  static bool get usingProductionIds {
    if (!kReleaseMode) return false;
    final ids = _isAndroid
        ? [_bannerAndroid, _interstitialAndroid, _rewardedAndroid]
        : [_bannerIos, _interstitialIos, _rewardedIos];
    return ids.any((id) => id.isNotEmpty);
  }
}
