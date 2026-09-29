import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/product_summary.dart';
import '../models/product_summary_model.dart';

abstract class RecentlyViewedDataSource {
  /// Most recent first.
  Future<List<ProductSummary>> getRecentlyViewed();

  /// Moves [product] to the front (deduped by id) and keeps the newest
  /// [RecentlyViewedLocalDataSourceImpl.maxItems]. Returns the new list.
  Future<List<ProductSummary>> record(ProductSummary product);

  Future<void> clear();
}

/// Stored on the device only (shared_preferences), as one JSON list.
class RecentlyViewedLocalDataSourceImpl implements RecentlyViewedDataSource {
  static const maxItems = 10;
  static const _key = 'recently_viewed_products';

  @override
  Future<List<ProductSummary>> getRecentlyViewed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return const [];
      return ProductSummaryModel.listFromJson(jsonDecode(raw) as List<dynamic>);
    } catch (_) {
      // Corrupt or outdated data isn't worth surfacing — start over.
      throw const CacheException('Could not read recently viewed products');
    }
  }

  @override
  Future<List<ProductSummary>> record(ProductSummary product) async {
    List<ProductSummary> current;
    try {
      current = await getRecentlyViewed();
    } on CacheException {
      current = const [];
    }
    final updated = [product, ...current.where((p) => p.id != product.id)].take(maxItems).toList();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonEncode(updated.map(ProductSummaryModel.toJson).toList()));
    } catch (_) {
      throw const CacheException('Could not save recently viewed products');
    }
    return updated;
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
