import 'package:dio/dio.dart';

import '../session/session_store.dart';
import 'api_config.dart';

/// Shared Dio instance every remote data source talks through. Attaches
/// the bearer token from [SessionStore] to every request — the backend's
/// `JwtAuthGuard` is global, so nearly every route needs it.
class ApiClient {
  final Dio dio;

  ApiClient(SessionStore sessionStore)
      : dio = Dio(BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        )) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await sessionStore.readToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ));
  }
}
