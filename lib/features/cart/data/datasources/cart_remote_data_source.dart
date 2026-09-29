import 'package:dio/dio.dart';

import '../../../../core/network/api_call.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/cart_snapshot.dart';
import '../models/cart_item_model.dart';

abstract class CartDataSource {
  Future<CartSnapshot> getCart();

  /// Catalog path: the server resolves name, seller, price and lead time
  /// from [productId]; [madeToMeasure] picks the MTM price over RTW.
  Future<CartItem> addProduct({required String productId, required bool madeToMeasure, LocalizedText? variant});

  /// Raw path (family sets): the server stores each item's
  /// seller/leadLabel/itemName/variant/priceAed as given. `id` and
  /// `imageGradient` on the inputs are ignored.
  Future<List<CartItem>> addCustomItems(List<CartItem> items);

  Future<void> removeItem(String id);
  Future<void> setGiftWrap(bool giftWrap);
  Future<void> clear();
}

/// `/cart` — mirrors tiraz-backend's CartController.
class CartRemoteDataSourceImpl implements CartDataSource {
  final Dio _dio;
  CartRemoteDataSourceImpl(this._dio);

  @override
  Future<CartSnapshot> getCart() {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>('/cart');
      final data = response.data!;
      return CartSnapshot(
        items: (data['items'] as List<dynamic>)
            .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
            .toList(),
        giftWrap: data['giftWrap'] as bool,
        // Older servers don't send it (the fee was the same flat 20 AED).
        shippingAed: data['shippingAed'] as int? ?? CartSnapshot.defaultShippingAed,
        delivery: _delivery(data['delivery'] as Map<String, dynamic>?),
      );
    });
  }

  @override
  Future<CartItem> addProduct({required String productId, required bool madeToMeasure, LocalizedText? variant}) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>('/cart/items', data: {
        'productId': productId,
        'mode': madeToMeasure ? 'mtm' : 'rtw',
        if (variant != null) 'variant': _json(variant),
      });
      return CartItemModel.fromJson(response.data!);
    });
  }

  @override
  Future<List<CartItem>> addCustomItems(List<CartItem> items) {
    return guardApiCall(() async {
      final response = await _dio.post<List<dynamic>>('/cart/items/batch', data: {
        'items': items
            .map((item) => {
                  'seller': _json(item.seller),
                  'leadLabel': _json(item.leadLabel),
                  'itemName': _json(item.itemName),
                  'variant': _json(item.variant),
                  'priceAed': item.priceAed,
                })
            .toList(),
      });
      return response.data!.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  @override
  Future<void> removeItem(String id) => guardApiCall(() => _dio.delete<void>('/cart/items/$id'));

  @override
  Future<void> setGiftWrap(bool giftWrap) =>
      guardApiCall(() => _dio.patch<void>('/cart/gift-wrap', data: {'giftWrap': giftWrap}));

  @override
  Future<void> clear() => guardApiCall(() => _dio.delete<void>('/cart'));

  static CartDelivery? _delivery(Map<String, dynamic>? json) => json == null
      ? null
      : CartDelivery(
          etaLabel: LocalizedText.fromJson(json['etaLabel'] as Map<String, dynamic>),
          beforeEid: json['beforeEid'] as bool,
        );

  static Map<String, String> _json(LocalizedText text) => {'ar': text.ar, 'en': text.en};
}
