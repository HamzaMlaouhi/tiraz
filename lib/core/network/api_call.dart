import 'package:dio/dio.dart';

import '../error/exceptions.dart';

/// Runs [request] and converts any Dio/network failure into the
/// [ServerException] every repository already knows how to map to a
/// [Failure] — so remote data sources stay a plain call to `dio`, with no
/// per-call try/catch boilerplate.
Future<T> guardApiCall<T>(Future<T> Function() request) async {
  try {
    return await request();
  } on DioException catch (e) {
    throw ServerException(_messageFrom(e));
  }
}

String _messageFrom(DioException e) {
  final data = e.response?.data;
  if (data is Map && data['message'] != null) {
    final message = data['message'];
    if (message is List) return message.join(', ');
    return message.toString();
  }
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'Connection timed out';
    case DioExceptionType.connectionError:
      return 'Could not reach the server';
    default:
      return e.message ?? 'Server error';
  }
}
