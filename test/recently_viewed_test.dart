import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiraz/core/theme/placeholder_palette.dart';
import 'package:tiraz/core/value_objects/localized_text.dart';
import 'package:tiraz/features/home/data/datasources/recently_viewed_local_data_source.dart';
import 'package:tiraz/features/home/domain/entities/product_summary.dart';

ProductSummary _product(String id) => ProductSummary(
      id: id,
      name: LocalizedText(ar: 'منتج $id', en: 'Product $id'),
      seller: const LocalizedText(ar: 'بائع', en: 'Seller'),
      price: const LocalizedText(ar: '100 د.إ', en: 'AED 100'),
      isMadeToMeasure: true,
      imageGradient: PlaceholderPalette.gradientFor(id),
      imageUrl: 'https://example.com/$id.jpg',
    );

void main() {
  late RecentlyViewedLocalDataSourceImpl dataSource;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    dataSource = RecentlyViewedLocalDataSourceImpl();
  });

  test('starts empty', () async {
    expect(await dataSource.getRecentlyViewed(), isEmpty);
  });

  test('newest first, re-viewing moves a product to the front without duplicating it', () async {
    await dataSource.record(_product('a'));
    await dataSource.record(_product('b'));
    await dataSource.record(_product('a'));

    final ids = (await dataSource.getRecentlyViewed()).map((p) => p.id);
    expect(ids, ['a', 'b']);
  });

  test('keeps only the newest maxItems', () async {
    for (var i = 0; i < RecentlyViewedLocalDataSourceImpl.maxItems + 3; i++) {
      await dataSource.record(_product('$i'));
    }

    final ids = (await dataSource.getRecentlyViewed()).map((p) => p.id).toList();
    expect(ids.length, RecentlyViewedLocalDataSourceImpl.maxItems);
    expect(ids.first, '12');
    expect(ids.last, '3');
  });

  test('round-trips every field through storage', () async {
    final original = _product('x');
    await dataSource.record(original);

    final restored = (await RecentlyViewedLocalDataSourceImpl().getRecentlyViewed()).single;
    // Compare fields, not objects: the restored one is a ProductSummaryModel,
    // and Equatable also compares runtime types.
    expect(restored.props, original.props);
  });

  test('clear empties the list', () async {
    await dataSource.record(_product('a'));
    await dataSource.clear();
    expect(await dataSource.getRecentlyViewed(), isEmpty);
  });
}
