import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/value_objects/localized_text.dart';
import 'eid_deadline.dart';
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

  /// Order-by dates for Eid delivery per mode; null when the server has no
  /// upcoming Eid (or predates this field).
  final EidDeadline? eidDeadlineRtw;
  final EidDeadline? eidDeadlineMtm;

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
    this.eidDeadlineRtw,
    this.eidDeadlineMtm,
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
        eidDeadlineRtw,
        eidDeadlineMtm,
      ];
}
