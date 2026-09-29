import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/product_summary.dart';
import '../../domain/usecases/recently_viewed.dart';

/// The Home "Recently viewed" row: products the user opened, newest first,
/// persisted on the device. A lazy singleton so the list survives tab
/// switches; storage failures just leave the row as it was.
class RecentlyViewedCubit extends Cubit<List<ProductSummary>> {
  final GetRecentlyViewed _getRecentlyViewed;
  final RecordProductView _recordProductView;
  final ClearRecentlyViewed _clearRecentlyViewed;

  RecentlyViewedCubit({
    required GetRecentlyViewed getRecentlyViewed,
    required RecordProductView recordProductView,
    required ClearRecentlyViewed clearRecentlyViewed,
  })  : _getRecentlyViewed = getRecentlyViewed,
        _recordProductView = recordProductView,
        _clearRecentlyViewed = clearRecentlyViewed,
        super(const []);

  Future<void> load() async {
    final result = await _getRecentlyViewed(const NoParams());
    result.fold((_) {}, emit);
  }

  Future<void> record(ProductSummary product) async {
    final result = await _recordProductView(product);
    result.fold((_) {}, emit);
  }

  Future<void> clear() async {
    emit(const []);
    await _clearRecentlyViewed(const NoParams());
  }
}
