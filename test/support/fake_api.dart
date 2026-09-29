import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// An in-memory tiraz-backend for widget tests, plugged in as the app's Dio
/// adapter. Read-only data comes from JSON captured from a freshly seeded
/// server (test/fixtures/api); seller listings and event reservations are
/// stateful, so a flow that adds a product or reserves a booth sees the
/// change on its next request, as it would against the real API.
///
/// Unhandled routes answer 404, which the app treats like any other server
/// error — so a missing route shows up as a failed expectation, not a hang.
class FakeApi implements HttpClientAdapter {
  final _home = _fixture('home.json') as Map<String, dynamic>;
  final _products = (_fixture('products.json') as List).cast<Map<String, dynamic>>();
  final _productsBySeller = _fixture('products_by_seller.json') as Map<String, dynamic>;
  final _sellerMe = _fixture('seller_me.json') as Map<String, dynamic>;
  final _events = (_fixture('events.json') as List).cast<Map<String, dynamic>>();

  final _sellerProducts = <Map<String, dynamic>>[];
  var _nextId = 1;

  static Object _fixture(String name) => jsonDecode(File('test/fixtures/api/$name').readAsStringSync()) as Object;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    final (status, body) = _route(options.method, options.uri.path, options.uri.queryParameters, options.data);
    return ResponseBody.fromString(
      body == null ? '' : jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  (int, Object?) _route(String method, String path, Map<String, String> query, Object? data) {
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    final route = '$method /${segments.join('/')}';

    switch (route) {
      case 'GET /home':
        return (200, _home);
      case 'GET /products':
        return (200, _searchProducts(query['search'], query['sellerId']));
      case 'GET /cart':
        return (200, {'items': [], 'giftWrap': false, 'subtotalAed': 0, 'shippingAed': 0, 'totalAed': 0, 'delivery': null});
      case 'GET /wishlist':
        return (200, []);
      case 'GET /sellers/me':
      case 'POST /sellers/me':
        return (200, _sellerMe);
      case 'GET /sellers/products':
        return (200, _sellerProducts.reversed.toList());
      case 'POST /sellers/products':
        return (201, _createSellerProduct(data as Map<String, dynamic>));
      case 'GET /events':
        return (200, _events);
    }

    if (segments.length == 3 && segments[0] == 'sellers' && segments[1] == 'products') {
      final product = _sellerProducts.where((p) => p['id'] == segments[2]).firstOrNull;
      if (method == 'GET' && product != null) return (200, product);
      if (method == 'DELETE' && product != null) {
        _sellerProducts.remove(product);
        return (204, null);
      }
    }

    if (segments.isNotEmpty && segments[0] == 'events' && segments.length >= 2) {
      final event = _events.where((e) => e['id'] == segments[1]).firstOrNull;
      if (event == null) return (404, {'message': 'Event not found'});
      if (segments.length == 2 && method == 'GET') return (200, event);
      if (segments.length == 3 && segments[2] == 'reservations') {
        final reserve = method == 'POST';
        if (event['reservedByMe'] != reserve) {
          event['reservedByMe'] = reserve;
          event['reservedSlots'] = (event['reservedSlots'] as int) + (reserve ? 1 : -1);
          event['slotsLeft'] = (event['totalSlots'] as int) - (event['reservedSlots'] as int);
        }
        return reserve ? (201, {'reserved': true}) : (204, null);
      }
    }

    return (404, {'message': 'FakeApi has no route for $route'});
  }

  /// Mirrors ProductsService.findMany: name match (ar/en) and/or one seller.
  List<Map<String, dynamic>> _searchProducts(String? search, String? sellerId) {
    if (sellerId != null) return (_productsBySeller[sellerId] as List? ?? []).cast<Map<String, dynamic>>();
    if (search == null || search.isEmpty) return _products;
    final q = search.toLowerCase();
    return _products.where((p) {
      final name = p['name'] as Map<String, dynamic>;
      return (name['ar'] as String).toLowerCase().contains(q) || (name['en'] as String).toLowerCase().contains(q);
    }).toList();
  }

  /// Mirrors ProductsService.toSellerDto for a freshly created listing.
  Map<String, dynamic> _createSellerProduct(Map<String, dynamic> body) {
    final isHandmade = body['isHandmade'] as bool;
    final extra = isHandmade ? body['handmadeExtraCostAed'] as num : 0;
    final product = {
      ...body,
      'id': 'fake-product-${_nextId++}',
      'handmadeExtraCostAed': extra,
      'totalPriceAed': (body['priceAed'] as num) + extra,
    };
    _sellerProducts.add(product);
    return product;
  }

  @override
  void close({bool force = false}) {}
}
