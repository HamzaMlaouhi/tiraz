import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/widgets/fade_in_network_image.dart';

/// Renders a seller product's photo — an uploaded device photo
/// ([imageBytes], shown instantly via `Image.memory`) if there is one,
/// otherwise the chosen stock-gallery photo ([imageUrl], via the app's
/// usual [FadeInNetworkImage]).
class SellerProductImage extends StatelessWidget {
  final String imageUrl;
  final Uint8List? imageBytes;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget fallback;

  const SellerProductImage({
    super.key,
    required this.imageUrl,
    required this.fallback,
    this.imageBytes,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final bytes = imageBytes;
    if (bytes != null) {
      return Image.memory(bytes, width: width, height: height, fit: fit);
    }
    return FadeInNetworkImage(url: imageUrl, width: width, height: height, fit: fit, fallback: fallback);
  }
}
