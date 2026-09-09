import 'package:equatable/equatable.dart';

/// A piece the current seller has listed. Unlike the buyer-side catalog
/// (curated, bilingual editorial copy), the name here is whatever the
/// seller typed into [AddProductPage] — a plain string, not [LocalizedText].
class SellerProduct extends Equatable {
  final String id;
  final String name;
  final double priceAed;
  final bool isMadeToMeasure;
  final String imageUrl;

  const SellerProduct({
    required this.id,
    required this.name,
    required this.priceAed,
    required this.isMadeToMeasure,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, priceAed, isMadeToMeasure, imageUrl];
}
