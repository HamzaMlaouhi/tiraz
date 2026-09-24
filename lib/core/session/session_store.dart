import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_session.dart';

/// Persists the current login across app restarts and hands the JWT to
/// [ApiClient]'s request interceptor. Everything else that needs "am I
/// logged in" / "who is the current user" reads [current] after [hydrate]
/// has run once at startup, rather than re-hitting secure storage.
class SessionStore {
  static const _kToken = 'auth_token';
  static const _kUserId = 'auth_user_id';
  static const _kPhone = 'auth_phone';
  static const _kEmirate = 'auth_emirate';
  static const _kName = 'auth_name';

  final FlutterSecureStorage _storage;
  AuthSession? _cached;

  SessionStore({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage();

  AuthSession? get current => _cached;

  bool get isLoggedIn => _cached != null;

  /// Loads a previously-saved session (if any) from secure storage into
  /// memory. Call once at app startup, before the router decides where to
  /// land.
  Future<AuthSession?> hydrate() async {
    final values = await Future.wait([
      _storage.read(key: _kToken),
      _storage.read(key: _kUserId),
      _storage.read(key: _kPhone),
      _storage.read(key: _kEmirate),
      _storage.read(key: _kName),
    ]);
    final token = values[0];
    final userId = values[1];
    final phone = values[2];
    final emirate = values[3];
    if (token == null || userId == null || phone == null || emirate == null) {
      _cached = null;
      return null;
    }
    _cached = AuthSession(token: token, userId: userId, phone: phone, emirate: emirate, name: values[4]);
    return _cached;
  }

  Future<void> save(AuthSession session) async {
    _cached = session;
    await Future.wait([
      _storage.write(key: _kToken, value: session.token),
      _storage.write(key: _kUserId, value: session.userId),
      _storage.write(key: _kPhone, value: session.phone),
      _storage.write(key: _kEmirate, value: session.emirate),
      if (session.name != null) _storage.write(key: _kName, value: session.name) else _storage.delete(key: _kName),
    ]);
  }

  Future<String?> readToken() async {
    if (_cached != null) return _cached!.token;
    return _storage.read(key: _kToken);
  }

  Future<void> clear() async {
    _cached = null;
    await Future.wait([
      _storage.delete(key: _kToken),
      _storage.delete(key: _kUserId),
      _storage.delete(key: _kPhone),
      _storage.delete(key: _kEmirate),
      _storage.delete(key: _kName),
    ]);
  }
}
