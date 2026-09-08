import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Formats a whole-dirham amount the way the design canvas does:
/// `AED 1,300` in English, `1,300 د.إ` in Arabic — same grouped digits,
/// the currency mark just swaps sides.
String formatAed(int valueAed, Locale locale) {
  final grouped = NumberFormat('#,##0').format(valueAed);
  return locale.languageCode == 'ar' ? '$grouped د.إ' : 'AED $grouped';
}
