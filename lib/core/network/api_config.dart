import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// Where the tiraz-backend NestJS API lives.
///
/// No global prefix on the server (`/auth`, `/products`, ... are bare), so
/// this is the whole authority — every request path is appended directly.
/// Override at build/run time with `--dart-define=API_BASE_URL=http://...`
/// for a real device or a deployed backend; the defaults below only cover
/// the local-dev simulator/emulator cases.
class ApiConfig {
  const ApiConfig._();

  static const String _override = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    if (kIsWeb) return 'http://localhost:3000';
    // Android emulator's host-loopback alias; a physical device needs
    // --dart-define=API_BASE_URL=http://<your-machine-lan-ip>:3000.
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://localhost:3000';
  }
}
