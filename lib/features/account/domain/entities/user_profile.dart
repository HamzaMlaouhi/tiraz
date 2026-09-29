import 'package:equatable/equatable.dart';

/// The signed-in buyer, as returned by `GET /users/me`. [emirate] is the
/// backend's `AuthEmirate` enum value (e.g. `ABU_DHABI`), not a UI
/// translation key; [name] is null until the user sets one.
class UserProfile extends Equatable {
  final String id;
  final String phone;
  final String emirate;
  final String? name;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.phone,
    required this.emirate,
    required this.createdAt,
    this.name,
  });

  @override
  List<Object?> get props => [id, phone, emirate, name, createdAt];
}
