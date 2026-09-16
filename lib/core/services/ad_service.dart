import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:biodata_maker/core/config/ad_config.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool _isInitialized = false;
  InterstitialAd? _interstitialAd;
  int _interstitialLoadAttempts = 0;
  
  RewardedAd? _rewardedAd;
  int _rewardedLoadAttempts = 0;
  static const int _maxLoadAttempts = 3;

  Future<void> initialize() async {
    if (_isInitialized) return;
    await MobileAds.instance.initialize();
    _isInitialized = true;
    _loadInterstitialAd();
    _loadRewardedAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _interstitialLoadAttempts++;
          if (_interstitialLoadAttempts < _maxLoadAttempts) {
            Future.delayed(const Duration(seconds: 30), _loadInterstitialAd);
          }
        },
      ),
    );
  }

  void showInterstitialAd({VoidCallback? onAdDismissed}) {
    if (_interstitialAd == null) {
      onAdDismissed?.call();
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd();
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd();
        onAdDismissed?.call();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void _loadRewardedAd() {
    // In production, use AdConfig.rewardedAdUnitId
    const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917'; // Test ID
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedLoadAttempts = 0;
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _rewardedLoadAttempts++;
          if (_rewardedLoadAttempts < _maxLoadAttempts) {
            Future.delayed(const Duration(seconds: 30), _loadRewardedAd);
          }
        },
      ),
    );
  }

  /// Shows the rewarded ad if loaded. Returns a Future that resolves to true
  /// if the user earned the reward (watched the video), false otherwise.
  Future<bool> showRewardedAd() async {
    if (_rewardedAd == null) {
      debugPrint('Warning: attempt to show rewarded ad before it was loaded.');
      return false; 
    }

    final completer = Completer<bool>();
    bool rewardEarned = false;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        _loadRewardedAd(); // Preload next ad
        if (!completer.isCompleted) {
          completer.complete(rewardEarned);
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        _loadRewardedAd(); // Retry
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      },
    );

    _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      rewardEarned = true;
    });

    return completer.future;
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}
