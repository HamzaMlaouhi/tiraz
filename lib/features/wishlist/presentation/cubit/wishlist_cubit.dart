import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/wishlist_item.dart';

/// Registered as a lazy singleton so the Account row's saved-piece
/// count stays in sync with removals made on the Wishlist page itself.
class WishlistCubit extends Cubit<List<WishlistItem>> {
  WishlistCubit()
      : super(const [
          WishlistItem(
            id: 'yasmeen-jalabiya',
            name: LocalizedText(ar: 'جلابية ياسمين', en: 'Yasmeen jalabiya'),
            seller: LocalizedText(ar: 'بيت الحرير', en: 'Silk House'),
            priceAed: 1150,
            imageGradient: [Color(0xFFE8DDD2), Color(0xFFD4C3B4)],
          ),
          WishlistItem(
            id: 'fajr-kaftan',
            name: LocalizedText(ar: 'قفطان الفجر', en: 'Fajr kaftan'),
            seller: LocalizedText(ar: 'دار الشيماء', en: 'Dar Al Shaima'),
            priceAed: 420,
            imageGradient: [Color(0xFFDFE9E7), Color(0xFFC6D8D4)],
          ),
          WishlistItem(
            id: 'zahra-jalabiya',
            name: LocalizedText(ar: 'جلابية زهرة', en: 'Zahra jalabiya'),
            seller: LocalizedText(ar: 'أتيليه لمى', en: 'Atelier Lama'),
            priceAed: 650,
            imageGradient: [Color(0xFFE6D9C0), Color(0xFFD8C6A6)],
          ),
        ]);

  void remove(String id) => emit(state.where((item) => item.id != id).toList());
}
