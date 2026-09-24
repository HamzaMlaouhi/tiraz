import 'package:equatable/equatable.dart';

/// A verified login: the bearer token plus the minimal user fields the app
/// needs before it has fetched anything else. [emirate] is the backend's
/// `AuthEmirate` enum value (e.g. `DUBAI`), not a UI translation key.
class AuthSession extends Equatable {
  final String token;
  final String userId;
  final String phone;
  final String emirate;
  final String? name;

  const AuthSession({
    required this.token,
    required this.userId,
    required this.phone,
    required this.emirate,
    this.name,
  });

  @override
  List<Object?> get props => [token, userId, phone, emirate, name];
}
