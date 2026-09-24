import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Deterministic placeholder color(s) for entities the backend doesn't
/// (and shouldn't) send color data for. Image gradients/tile backgrounds
/// are purely a client-side "still looks intentional while the network
/// photo loads" fallback, not real content — so they're derived from a
/// stable key (a product/store id, or an image URL when no id exists)
/// rather than round-tripped through the API.
abstract final class PlaceholderPalette {
  static const List<List<Color>> _gradients = [
    [Color(0xFFE6D9C0), Color(0xFFD8C6A6)],
    [Color(0xFFDFE9E7), Color(0xFFC6D8D4)],
    [Color(0xFFE8DDD2), Color(0xFFD4C3B4)],
    [Color(0xFFEFE3D3), Color(0xFFDCC9AA)],
    [Color(0xFFE3DCE8), Color(0xFFC9BFD6)],
    [Color(0xFFF1E6D6), Color(0xFFE0CBA0)],
    [Color(0xFFE3E8DE), Color(0xFFC7D2BC)],
    [Color(0xFFEAD9D2), Color(0xFFD6B9AC)],
    [Color(0xFFE8DCEA), Color(0xFFD1BBD9)],
    [Color(0xFFDDE6E6), Color(0xFFBFD0D0)],
  ];

  static const List<Color> _occasionBackgrounds = [
    AppColors.occasionSand,
    AppColors.occasionMint,
    AppColors.occasionTaupe,
    AppColors.occasionCream,
  ];

  static List<Color> gradientFor(String key) => _gradients[key.hashCode.abs() % _gradients.length];

  static Color occasionBackgroundFor(String key) =>
      _occasionBackgrounds[key.hashCode.abs() % _occasionBackgrounds.length];
}
