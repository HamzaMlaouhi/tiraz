import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.phone,
    required super.emirate,
    required super.createdAt,
    super.name,
  });

  /// Mirrors the object `UsersController.me` returns on the backend.
  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        id: json['id'] as String,
        phone: json['phone'] as String,
        emirate: json['emirate'] as String,
        name: json['name'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
