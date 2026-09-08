import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/value_objects/localized_text.dart';
import 'fit_zone.dart';

class ProductDetail extends Equatable {
  final String id;
  final LocalizedText name;
  final LocalizedText seller;
  final LocalizedText priceRtw;
  final LocalizedText priceMtm;
  final int priceRtwAed;
  final int priceMtmAed;
  final String ratingValue;
  final String reviewCount;
  final LocalizedText fitAccuracyLabel;
  final List<String> sizes;
  final LocalizedText fabricShort;
  final LocalizedText fabricBody;
  final List<FitZone> fitZones;
  final LocalizedText reviewQuote;
  final LocalizedText reviewBy;
  final List<Color> imageGradient;
  final int mtmLeadDays;

  const ProductDetail({
    required this.id,
    required this.name,
    required this.seller,
    required this.priceRtw,
    required this.priceMtm,
    required this.priceRtwAed,
    required this.priceMtmAed,
    required this.ratingValue,
    required this.reviewCount,
    required this.fitAccuracyLabel,
    required this.sizes,
    required this.fabricShort,
    required this.fabricBody,
    required this.fitZones,
    required this.reviewQuote,
    required this.reviewBy,
    required this.imageGradient,
    required this.mtmLeadDays,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        seller,
        priceRtw,
        priceMtm,
        priceRtwAed,
        priceMtmAed,
        ratingValue,
        reviewCount,
        fitAccuracyLabel,
        sizes,
        fabricShort,
        fabricBody,
        fitZones,
        reviewQuote,
        reviewBy,
        imageGradient,
        mtmLeadDays,
      ];
}
