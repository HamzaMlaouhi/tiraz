import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import 'jalabiya_quality.dart';

/// A piece the current seller has listed. Unlike the buyer-side catalog
/// (curated, bilingual editorial copy), the name/description here is
/// whatever the seller typed into [AddProductPage] — plain strings, not
/// [LocalizedText].
class SellerProduct extends Equatable {
  final String id;
  final String name;
  final String description;
  final double priceAed;
  final bool isMadeToMeasure;

  /// Handmade pieces carry an extra cost on top of [priceAed] — see
  /// [totalPriceAed].
  final bool isHandmade;
  final double handmadeExtraCostAed;

  final double lengthCm;
  final double chestCm;
  final double sleeveCm;
  final JalabiyaQuality quality;

  /// The listing's photo. Device photos are uploaded to the backend on
  /// save, so a listing from the API always has a real [imageUrl];
  /// [imageBytes] is only ever set on a not-yet-saved local draft.
  final String imageUrl;
  final Uint8List? imageBytes;

  const SellerProduct({
    required this.id,
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

  double get totalPriceAed => priceAed + (isHandmade ? handmadeExtraCostAed : 0);

  @override
  List<Object?> get props => [
        id,
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
