import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import 'jalabiya_quality.dart';

/// What [AddProductPage] submits. The photo is either a stock-gallery
/// [imageUrl] or device [imageBytes] (uploaded first; takes precedence).
class NewSellerProduct extends Equatable {
  final String name;
  final String description;
  final double priceAed;
  final bool isMadeToMeasure;
  final bool isHandmade;
  final double handmadeExtraCostAed;
  final double lengthCm;
  final double chestCm;
  final double sleeveCm;
  final JalabiyaQuality quality;
  final String imageUrl;
  final Uint8List? imageBytes;

  const NewSellerProduct({
    required this.name,
    required this.description,
    required this.priceAed,
    required this.isMadeToMeasure,
    required this.isHandmade,
    required this.handmadeExtraCostAed,
    required this.lengthCm,
    required this.chestCm,
    required this.sleeveCm,
    required this.quality,
    required this.imageUrl,
    this.imageBytes,
  });

  @override
  List<Object?> get props => [
        name,
        description,
        priceAed,
        isMadeToMeasure,
        isHandmade,
        handmadeExtraCostAed,
        lengthCm,
        chestCm,
        sleeveCm,
        quality,
        imageUrl,
        imageBytes,
      ];
}
