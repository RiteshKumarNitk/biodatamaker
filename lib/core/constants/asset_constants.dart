class AssetConstants {
  AssetConstants._();

  static const String mandala = 'assets/svg/mandala.svg';
  static const String paisley = 'assets/svg/paisley.svg';
  static const String lotus = 'assets/svg/lotus.svg';
  static const String peacock = 'assets/svg/peacock.svg';
  static const String weddingBorder = 'assets/svg/wedding_border.svg';
  static const String templeBorder = 'assets/svg/temple_border.svg';
  static const String royalBorder = 'assets/svg/royal_border.svg';
  static const String goldenCorner = 'assets/svg/golden_corner.svg';
  static const String minimalDivider = 'assets/svg/minimal_divider.svg';
  static const String floral = 'assets/svg/floral.svg';
  static const String geometricStar = 'assets/svg/geometric_star.svg';
  static const String emptyState = 'assets/lottie/empty_state.json';
  static const String success = 'assets/lottie/success.json';
  static const String loading = 'assets/lottie/loading.json';
  static const String onboarding1 = 'assets/lottie/onboarding1.json';
  static const String onboarding2 = 'assets/lottie/onboarding2.json';
  static const String onboarding3 = 'assets/lottie/onboarding3.json';

  // Images
  static const String onboardingImage1 = 'assets/images/onboarding1.png';
  static const String onboardingImage2 = 'assets/images/onboarding2.png';
  static const String onboardingImage3 = 'assets/images/onboarding3.png';

  static String decorationAsset(String key) {
    switch (key) {
      case 'mandala': return mandala;
      case 'floral': return floral;
      case 'lotus': return lotus;
      case 'temple': return templeBorder;
      case 'geometric': return geometricStar;
      case 'ornate':
      case 'royal': return paisley;
      case 'minimal':
      case 'simple':
      default: return minimalDivider;
    }
  }
}
