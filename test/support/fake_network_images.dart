import 'dart:async';
import 'dart:io';

/// `flutter_test`'s binding always 400s real HTTP requests, so any
/// `Image.network` (the app's placeholder store/product/event photos)
/// reports a load failure through `FlutterError` on every test run — noisy
/// and non-deterministic to filter after the fact. Installing this
/// [HttpOverrides] instead makes every request resolve instantly with a
/// tiny valid image, so tests can assert `tester.takeException()` is null
/// and mean it.
///
/// Usage: `HttpOverrides.global = FakeNetworkImageHttpOverrides();` in
/// `setUp`, `HttpOverrides.global = null;` in `tearDown`.
class FakeNetworkImageHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _FakeHttpClient();
}

// A minimal 1x1 transparent GIF — small enough to inline, and decodes
// cleanly under Skia like any other image the app would load.
const List<int> _kTransparentImageBytes = [
  0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00, 0x80, 0x00, //
  0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0x21, 0xF9, 0x04, 0x01, 0x00, //
  0x00, 0x00, 0x00, 0x2C, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00, //
  0x00, 0x02, 0x02, 0x44, 0x01, 0x00, 0x3B, //
];

/// Every member beyond [getUrl] is unused by `NetworkImage`, so they're
/// left to `noSuchMethod` — the standard "fake by interface" trick (also
/// how `package:mockito`'s `Mock` works) that lets a class skip providing
/// every member of a large `dart:io` interface.
class _FakeHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _FakeHttpClientRequest();

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeHttpClientRequest implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async => _FakeHttpClientResponse();

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  @override
  int get statusCode => HttpStatus.ok;

  @override
  int get contentLength => _kTransparentImageBytes.length;

  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_kTransparentImageBytes])
        .listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
