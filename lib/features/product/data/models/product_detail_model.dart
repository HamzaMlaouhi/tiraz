import '../../../../core/theme/placeholder_palette.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/eid_deadline.dart';
import '../../domain/entities/fit_zone.dart';
import '../../domain/entities/product_detail.dart';

class ProductDetailModel extends ProductDetail {
  const ProductDetailModel({
    required super.id,
    required super.name,
    required super.seller,
    required super.priceRtw,
    required super.priceMtm,
    required super.priceRtwAed,
    required super.priceMtmAed,
    required super.ratingValue,
    required super.reviewCount,
    required super.fitAccuracyLabel,
    required super.sizes,
    required super.fabricShort,
    required super.fabricBody,
    required super.fitZones,
    required super.reviewQuote,
    required super.reviewBy,
    required super.imageGradient,
    required super.mtmLeadDays,
    super.eidDeadlineRtw,
    super.eidDeadlineMtm,
  });

  /// Mirrors `ProductsService.toDetailDto` on the backend.
  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    final eid = json['eidDeadline'] as Map<String, dynamic>?;
    return ProductDetailModel(
      id: id,
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>),
      seller: LocalizedText.fromJson(json['seller'] as Map<String, dynamic>),
      priceRtw: LocalizedText.fromJson(json['priceRtw'] as Map<String, dynamic>),
      priceMtm: LocalizedText.fromJson(json['priceMtm'] as Map<String, dynamic>),
      priceRtwAed: (json['priceRtwAed'] as num).toInt(),
      priceMtmAed: (json['priceMtmAed'] as num).toInt(),
      ratingValue: json['ratingValue'] as String,
      reviewCount: json['reviewCount'] as String,
      fitAccuracyLabel: LocalizedText.fromJson(json['fitAccuracyLabel'] as Map<String, dynamic>),
      sizes: List<String>.from(json['sizes'] as List<dynamic>),
      fabricShort: LocalizedText.fromJson(json['fabricShort'] as Map<String, dynamic>),
      fabricBody: LocalizedText.fromJson(json['fabricBody'] as Map<String, dynamic>),
      fitZones: (json['fitZones'] as List<dynamic>)
          .map((zone) => _fitZoneFromJson(zone as Map<String, dynamic>))
          .toList(),
      reviewQuote: LocalizedText.fromJson(json['reviewQuote'] as Map<String, dynamic>),
      reviewBy: LocalizedText.fromJson(json['reviewBy'] as Map<String, dynamic>),
      imageGradient: PlaceholderPalette.gradientFor(id),
      mtmLeadDays: json['mtmLeadDays'] as int,
      eidDeadlineRtw: eid == null ? null : _eidDeadlineFromJson(eid['rtw'] as Map<String, dynamic>),
      eidDeadlineMtm: eid == null ? null : _eidDeadlineFromJson(eid['mtm'] as Map<String, dynamic>),
    );
  }

  /// Mirrors `EidDeadline` in the backend's eid.util.ts.
  static EidDeadline _eidDeadlineFromJson(Map<String, dynamic> json) => EidDeadline(
        orderBy: DateTime.parse(json['orderBy'] as String),
        daysLeft: json['daysLeft'] as int,
        status: EidDeadlineStatus.values.byName(json['status'] as String),
        label: LocalizedText.fromJson(json['label'] as Map<String, dynamic>),
      );

  static FitZone _fitZoneFromJson(Map<String, dynamic> json) => FitZone(
        name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>),
        fitFraction: (json['fitFraction'] as num).toDouble(),
        label: LocalizedText.fromJson(json['label'] as Map<String, dynamic>),
      );
}
