import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:biodata_maker/core/services/ad_service.dart';

/// A self-contained banner ad widget that handles its own lifecycle.
/// Place this at the bottom of screens where ads are appropriate.
/// Never place inside PDF/preview/form widgets.
class AppBannerAd extends StatefulWidget {
  final AdSize adSize;

  const AppBannerAd({super.key, this.adSize = AdSize.banner});

  @override
  State<AppBannerAd> createState() => _AppBannerAdState();
}

class _AppBannerAdState extends State<AppBannerAd> {
  BannerAd? _ad;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _ad = AdService().createBannerAd(
      size: widget.adSize,
      onLoaded: () {
        if (mounted) setState(() => _isLoaded = true);
      },
      onFailedToLoad: () {
        if (mounted) setState(() => _isLoaded = false);
      },
    );
    _ad?.load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _ad == null) return const SizedBox.shrink();
    return SizedBox(
      width: _ad!.size.width.toDouble(),
      height: _ad!.size.height.toDouble(),
      child: AdWidget(ad: _ad!),
    );
  }
}
