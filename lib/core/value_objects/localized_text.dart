import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// Domain-level bilingual string — mirrors the design canvas's `A(ar, en)`
/// helper. Product/seller/content copy lives in the data layer (not the
/// .arb files, which hold UI chrome only) because it's *data*, not UI
/// translation, even though it happens to be bilingual too.
class LocalizedText extends Equatable {
  final String ar;
  final String en;

  const LocalizedText({required this.ar, required this.en});

  String resolve(Locale locale) => locale.languageCode == 'ar' ? ar : en;

  String of(BuildContext context) => resolve(Localizations.localeOf(context));

  @override
  List<Object?> get props => [ar, en];
}
