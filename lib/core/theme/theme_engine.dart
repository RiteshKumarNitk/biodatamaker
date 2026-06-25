import 'package:biodata_maker/data/models/theme_config.dart';

/// A collection of predefined template themes for biodata preview.
class ThemeEngine {
  ThemeEngine._();

  /// All available templates
  static final List<ThemeConfig> templates = [
    // ─── Hindu / Traditional ──────────────────────────────────
    _classicRed,
    _royalGold,
    _mandalaGreen,
    _templeCream,
    _lotusPink,

    // ─── Muslim ───────────────────────────────────────────────
    _nikahGreen,
    _emeraldGold,
    _whiteMinimal,

    // ─── Sikh ─────────────────────────────────────────────────
    _punjabiBlue,
    _goldenPunjab,

    // ─── Christian ────────────────────────────────────────────
    _whiteFloral,
    _elegantBlue,

    // ─── Modern / Universal ───────────────────────────────────
    _modernMinimal,
    _corporate,
    _pastelLuxury,
    _darkElegance,
  ];

  /// Get template by ID
  static ThemeConfig? getById(String id) {
    try {
      return templates.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get templates by category
  static List<ThemeConfig> getByCategory(String category) {
    if (category == 'All') return templates;
    return templates.where((t) => t.category == category).toList();
  }

  // ─── Template Definitions ───────────────────────────────────

  static final _classicRed = ThemeConfig(
    id: 'classic_red',
    name: 'Classic Red',
    category: 'Traditional',
    primaryColor: 0xFFC62828,
    secondaryColor: 0xFFFFB300,
    backgroundColor: 0xFFFFFFFF,
    textColor: 0xFF212121,
    subtitleColor: 0xFF757575,
    headingFont: 'Playfair Display',
    bodyFont: 'Poppins',
    headingFontSize: 24,
    bodyFontSize: 14,
    photoShape: 'circle',
    borderStyle: 'ornate',
    headerDecoration: 'mandala',
    footerDecoration: 'floral',
    dividerStyle: 'decorative',
  );

  static final _royalGold = ThemeConfig(
    id: 'royal_gold',
    name: 'Royal Gold',
    category: 'Traditional',
    primaryColor: 0xFFD4A017,
    secondaryColor: 0xFF8E0000,
    backgroundColor: 0xFFFFFBF0,
    textColor: 0xFF3E2723,
    subtitleColor: 0xFF795548,
    headingFont: 'Playfair Display',
    bodyFont: 'Poppins',
    headingFontSize: 26,
    bodyFontSize: 14,
    photoShape: 'circle',
    borderStyle: 'royal',
    headerDecoration: 'ornate',
    footerDecoration: 'ornate',
    dividerStyle: 'decorative',
  );

  static final _mandalaGreen = ThemeConfig(
    id: 'mandala_green',
    name: 'Mandala Green',
    category: 'Traditional',
    primaryColor: 0xFF2E7D32,
    secondaryColor: 0xFFFFB300,
    backgroundColor: 0xFFF1F8E9,
    textColor: 0xFF1B5E20,
    subtitleColor: 0xFF4CAF50,
    headingFont: 'Playfair Display',
    bodyFont: 'Poppins',
    headingFontSize: 24,
    bodyFontSize: 14,
    photoShape: 'circle',
    borderStyle: 'ornate',
    headerDecoration: 'mandala',
    footerDecoration: 'mandala',
    dividerStyle: 'lotus',
  );

  static final _templeCream = ThemeConfig(
    id: 'temple_cream',
    name: 'Temple Cream',
    category: 'Traditional',
    primaryColor: 0xFFBF360C,
    secondaryColor: 0xFFD4A017,
    backgroundColor: 0xFFFFF8E1,
    textColor: 0xFF3E2723,
    subtitleColor: 0xFF8D6E63,
    headingFont: 'Playfair Display',
    bodyFont: 'Poppins',
    headingFontSize: 24,
    bodyFontSize: 14,
    photoShape: 'circle',
    borderStyle: 'temple',
    headerDecoration: 'temple',
    footerDecoration: 'temple',
    dividerStyle: 'decorative',
  );

  static final _lotusPink = ThemeConfig(
    id: 'lotus_pink',
    name: 'Lotus Pink',
    category: 'Traditional',
    primaryColor: 0xFFAD1457,
    secondaryColor: 0xFFFFB300,
    backgroundColor: 0xFFFCE4EC,
    textColor: 0xFF880E4F,
    subtitleColor: 0xFFE91E63,
    headingFont: 'Playfair Display',
    bodyFont: 'Poppins',
    headingFontSize: 24,
    bodyFontSize: 14,
    photoShape: 'circle',
    borderStyle: 'ornate',
    headerDecoration: 'lotus',
    footerDecoration: 'floral',
    dividerStyle: 'lotus',
  );

  static final _nikahGreen = ThemeConfig(
    id: 'nikah_green',
    name: 'Premium Nikah',
    category: 'Muslim',
    primaryColor: 0xFF1B5E20,
    secondaryColor: 0xFFD4A017,
    backgroundColor: 0xFFFFFFFF,
    textColor: 0xFF212121,
    subtitleColor: 0xFF757575,
    headingFont: 'Playfair Display',
    bodyFont: 'Poppins',
    headingFontSize: 24,
    bodyFontSize: 14,
    photoShape: 'circle',
    borderStyle: 'geometric',
    headerDecoration: 'geometric',
    footerDecoration: 'geometric',
    dividerStyle: 'geometric',
  );

  static final _emeraldGold = ThemeConfig(
    id: 'emerald_gold',
    name: 'Emerald & Gold',
    category: 'Muslim',
    primaryColor: 0xFF00695C,
    secondaryColor: 0xFFD4A017,
    backgroundColor: 0xFFE0F2F1,
    textColor: 0xFF004D40,
    subtitleColor: 0xFF009688,
    headingFont: 'Playfair Display',
    bodyFont: 'Poppins',
    headingFontSize: 24,
    bodyFontSize: 14,
    photoShape: 'circle',
    borderStyle: 'geometric',
    headerDecoration: 'geometric',
    footerDecoration: 'geometric',
    dividerStyle: 'geometric',
  );

  static final _whiteMinimal = ThemeConfig(
    id: 'white_minimal',
    name: 'White & Gold',
    category: 'Muslim',
    primaryColor: 0xFFD4A017,
    secondaryColor: 0xFF1B5E20,
    backgroundColor: 0xFFFFFFFF,
    textColor: 0xFF212121,
    subtitleColor: 0xFF9E9E9E,
    headingFont: 'Playfair Display',
    bodyFont: 'Poppins',
    headingFontSize: 22,
    bodyFontSize: 14,
    photoShape: 'circle',
    borderStyle: 'minimal',
    headerDecoration: 'minimal',
    footerDecoration: 'minimal',
    dividerStyle: 'simple',
  );

  static final _punjabiBlue = ThemeConfig(
    id: 'punjabi_blue',
    name: 'Royal Blue',
    category: 'Sikh',
    primaryColor: 0xFF1565C0,
    secondaryColor: 0xFFD4A017,
    backgroundColor: 0xFFE3F2FD,
    textColor: 0xFF0D47A1,
    subtitleColor: 0xFF42A5F5,
    headingFont: 'Playfair Display',
    bodyFont: 'Poppins',
    headingFontSize: 24,
    bodyFontSize: 14,
    photoShape: 'circle',
    borderStyle: 'ornate',
    headerDecoration: 'ornate',
    footerDecoration: 'ornate',
    dividerStyle: 'decorative',
  );

  static final _goldenPunjab = ThemeConfig(
    id: 'golden_punjab',
    name: 'Golden Punjab',
    category: 'Sikh',
    primaryColor: 0xFFD4A017,
    secondaryColor: 0xFF1565C0,
    backgroundColor: 0xFFFFF8E1,
    textColor: 0xFF3E2723,
    subtitleColor: 0xFF8D6E63,
    headingFont: 'Playfair Display',
    bodyFont: 'Poppins',
    headingFontSize: 24,
    bodyFontSize: 14,
    photoShape: 'circle',
    borderStyle: 'royal',
    headerDecoration: 'ornate',
    footerDecoration: 'ornate',
    dividerStyle: 'decorative',
  );

  static final _whiteFloral = ThemeConfig(
    id: 'white_floral',
    name: 'White Floral',
    category: 'Christian',
    primaryColor: 0xFF1565C0,
    secondaryColor: 0xFFD4A017,
    backgroundColor: 0xFFFFFFFF,
    textColor: 0xFF212121,
    subtitleColor: 0xFF9E9E9E,
    headingFont: 'Playfair Display',
    bodyFont: 'Poppins',
    headingFontSize: 24,
    bodyFontSize: 14,
    photoShape: 'circle',
    borderStyle: 'floral',
    headerDecoration: 'floral',
    footerDecoration: 'floral',
    dividerStyle: 'floral',
  );

  static final _elegantBlue = ThemeConfig(
    id: 'elegant_blue',
    name: 'Elegant Blue',
    category: 'Christian',
    primaryColor: 0xFF283593,
    secondaryColor: 0xFFD4A017,
    backgroundColor: 0xFFE8EAF6,
    textColor: 0xFF1A237E,
    subtitleColor: 0xFF5C6BC0,
    headingFont: 'Playfair Display',
    bodyFont: 'Poppins',
    headingFontSize: 24,
    bodyFontSize: 14,
    photoShape: 'circle',
    borderStyle: 'elegant',
    headerDecoration: 'minimal',
    footerDecoration: 'minimal',
    dividerStyle: 'simple',
  );

  static final _modernMinimal = ThemeConfig(
    id: 'modern_minimal',
    name: 'Modern Minimal',
    category: 'Modern',
    primaryColor: 0xFF212121,
    secondaryColor: 0xFFFFB300,
    backgroundColor: 0xFFFFFFFF,
    textColor: 0xFF212121,
    subtitleColor: 0xFF9E9E9E,
    headingFont: 'Poppins',
    bodyFont: 'Poppins',
    headingFontSize: 22,
    bodyFontSize: 14,
    photoShape: 'circle',
    borderStyle: 'minimal',
    headerDecoration: 'minimal',
    footerDecoration: 'minimal',
    dividerStyle: 'simple',
  );

  static final _corporate = ThemeConfig(
    id: 'corporate',
    name: 'Corporate',
    category: 'Professional',
    primaryColor: 0xFF37474F,
    secondaryColor: 0xFF26A69A,
    backgroundColor: 0xFFECEFF1,
    textColor: 0xFF263238,
    subtitleColor: 0xFF78909C,
    headingFont: 'Poppins',
    bodyFont: 'Poppins',
    headingFontSize: 22,
    bodyFontSize: 14,
    photoShape: 'square',
    borderStyle: 'minimal',
    headerDecoration: 'minimal',
    footerDecoration: 'minimal',
    dividerStyle: 'simple',
  );

  static final _pastelLuxury = ThemeConfig(
    id: 'pastel_luxury',
    name: 'Pastel Luxury',
    category: 'Luxury',
    primaryColor: 0xFF8D6E63,
    secondaryColor: 0xFFD4A017,
    backgroundColor: 0xFFEFEBE9,
    textColor: 0xFF3E2723,
    subtitleColor: 0xFFA1887F,
    headingFont: 'Playfair Display',
    bodyFont: 'Poppins',
    headingFontSize: 26,
    bodyFontSize: 14,
    photoShape: 'circle',
    borderStyle: 'ornate',
    headerDecoration: 'ornate',
    footerDecoration: 'ornate',
    dividerStyle: 'decorative',
  );

  static final _darkElegance = ThemeConfig(
    id: 'dark_elegance',
    name: 'Dark Elegance',
    category: 'Modern',
    primaryColor: 0xFFD4A017,
    secondaryColor: 0xFFC62828,
    backgroundColor: 0xFF1E1E1E,
    textColor: 0xFFFAFAFA,
    subtitleColor: 0xFFBDBDBD,
    headingFont: 'Playfair Display',
    bodyFont: 'Poppins',
    headingFontSize: 24,
    bodyFontSize: 14,
    photoShape: 'circle',
    borderStyle: 'ornate',
    headerDecoration: 'ornate',
    footerDecoration: 'ornate',
    dividerStyle: 'decorative',
  );
}
