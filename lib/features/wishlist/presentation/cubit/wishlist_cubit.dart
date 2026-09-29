import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/usecases/add_to_wishlist.dart';
import '../../domain/usecases/get_wishlist.dart';
import '../../domain/usecases/remove_from_wishlist.dart';

/// Registered as a lazy singleton so the Account row's saved-piece
/// count, the Wishlist page, and the product page's heart all share one
/// list. Mutations are optimistic: the UI updates immediately and rolls
/// back if the server call fails.
class WishlistCubit extends Cubit<List<WishlistItem>> {
  final GetWishlist _getWishlist;
  final AddToWishlist _addToWishlist;
  final RemoveFromWishlist _removeFromWishlist;

  WishlistCubit({
    required GetWishlist getWishlist,
    required AddToWishlist addToWishlist,
    required RemoveFromWishlist removeFromWishlist,
  })  : _getWishlist = getWishlist,
        _addToWishlist = addToWishlist,
        _removeFromWishlist = removeFromWishlist,
        super(const []);

  /// On failure the last known list is kept rather than blanked.
  Future<void> load() async {
    final result = await _getWishlist(const NoParams());
    result.fold((_) {}, emit);
  }

  bool isSaved(String productId) => state.any((item) => item.productId == productId);

  Future<void> remove(String id) async {
    final previous = state;
    emit(state.where((item) => item.id != id).toList());
    final result = await _removeFromWishlist(id);
    result.fold((_) => emit(previous), (_) {});
  }

  /// Saves [productId] if it isn't saved yet, otherwise un-saves it.
  Future<void> toggle(String productId) async {
    final existing = state.where((item) => item.productId == productId).firstOrNull;
    if (existing != null) return remove(existing.id);

    final result = await _addToWishlist(productId);
    result.fold((_) {}, (item) {
      if (!isSaved(item.productId)) emit([item, ...state]);
    });
  }
}
