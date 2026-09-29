import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;

/// Where the tiraz-backend NestJS API lives.
///
/// No global prefix on the server (`/auth`, `/products`, ... are bare), so
/// this is the whole authority — every request path is appended directly.
///
/// Which backend is used, in priority order:
/// 1. `--dart-define=API_BASE_URL=http://...` — any explicit URL.
/// 2. `--dart-define=API_ENV=deployed` (or any release build) — the test
///    deployment on Render, [deployedBaseUrl].
/// 3. Otherwise the local dev server on port 3000 (`API_ENV=local` forces
///    this even in a release build).
class ApiConfig {
  const ApiConfig._();

  /// The Render test deployment (see tiraz-backend's render.yaml).
  static const String deployedBaseUrl = 'https://tiraz-backend.onrender.com';

  static const String _override = String.fromEnvironment('API_BASE_URL');
  static const String _env = String.fromEnvironment('API_ENV');

  static bool get usesDeployed =>
      _override.isEmpty && (_env == 'deployed' || (kReleaseMode && _env != 'local'));

  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    if (usesDeployed) return deployedBaseUrl;
    if (kIsWeb) return 'http://localhost:3000';
    // Android emulator's host-loopback alias; a physical device needs
    // --dart-define=API_BASE_URL=http://<your-machine-lan-ip>:3000.
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://localhost:3000';
  }

  /// Render's free tier sleeps when idle and takes ~30–50 s to wake, so the
  /// deployed backend gets a timeout long enough to survive a cold start.
  static Duration get timeout => usesDeployed ? const Duration(seconds: 60) : const Duration(seconds: 15);
}
