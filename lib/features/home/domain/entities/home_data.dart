import 'package:equatable/equatable.dart';

import 'occasion.dart';
import 'product_summary.dart';
import 'store.dart';

class HomeData extends Equatable {
  final int eidDaysAway;
  final List<Occasion> occasions;
  final List<ProductSummary> newDrops;
  final List<Store> stores;

  const HomeData({
    required this.eidDaysAway,
    required this.occasions,
    required this.newDrops,
    required this.stores,
  });

  @override
  List<Object?> get props => [eidDaysAway, occasions, newDrops, stores];
}
