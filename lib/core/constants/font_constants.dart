class BiodataFont {
  final String id;
  final String name;
  final String category;
  final String assetPath;

  const BiodataFont({
    required this.id,
    required this.name,
    required this.category,
    required this.assetPath,
  });
}

class FontConstants {
  FontConstants._();

  static const List<BiodataFont> availableFonts = [
    BiodataFont(
      id: 'playfair_display',
      name: 'Playfair Display',
      category: 'Serif',
      assetPath: 'assets/fonts/PlayfairDisplay.ttf',
    ),
    BiodataFont(
      id: 'poppins',
      name: 'Poppins',
      category: 'Sans Serif',
      assetPath: 'assets/fonts/Poppins.ttf',
    ),
    BiodataFont(
      id: 'lora',
      name: 'Lora',
      category: 'Serif',
      assetPath: 'assets/fonts/Lora.ttf',
    ),
    BiodataFont(
      id: 'montserrat',
      name: 'Montserrat',
      category: 'Sans Serif',
      assetPath: 'assets/fonts/Montserrat.ttf',
    ),
    BiodataFont(
      id: 'nunito',
      name: 'Nunito',
      category: 'Sans Serif',
      assetPath: 'assets/fonts/Nunito.ttf',
    ),
    BiodataFont(
      id: 'raleway',
      name: 'Raleway',
      category: 'Sans Serif',
      assetPath: 'assets/fonts/Raleway.ttf',
    ),
    BiodataFont(
      id: 'eb_garamond',
      name: 'EB Garamond',
      category: 'Serif',
      assetPath: 'assets/fonts/EBGaramond.ttf',
    ),
    BiodataFont(
      id: 'josefin_sans',
      name: 'Josefin Sans',
      category: 'Sans Serif',
      assetPath: 'assets/fonts/JosefinSans.ttf',
    ),
    BiodataFont(
      id: 'great_vibes',
      name: 'Great Vibes',
      category: 'Script',
      assetPath: 'assets/fonts/GreatVibes.ttf',
    ),
    BiodataFont(
      id: 'dancing_script',
      name: 'Dancing Script',
      category: 'Handwritten',
      assetPath: 'assets/fonts/DancingScript.ttf',
    ),
  ];

  static BiodataFont getById(String id) {
    return availableFonts.firstWhere(
      (f) => f.id == id,
      orElse: () => availableFonts.first,
    );
  }

  static const String defaultFontId = 'playfair_display';
}
