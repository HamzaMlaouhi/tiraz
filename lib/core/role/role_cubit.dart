import 'package:flutter_bloc/flutter_bloc.dart';

/// Which side of the marketplace the current session is using. Chosen on
/// [RolePickerPage] right after splash, and switchable later from either
/// side's account tab — there's no persistence (matching every other bit
/// of app state here), so it resets to unset on a fresh launch.
enum UserRole { buyer, seller }

/// `null` means "not chosen yet" — the state [RolePickerPage] is shown for.
class RoleCubit extends Cubit<UserRole?> {
  RoleCubit() : super(null);

  void choose(UserRole role) => emit(role);

  void reset() => emit(null);
}

/// The shell branch a given role lands on.
String roleHomePath(UserRole? role) => role == UserRole.seller ? '/seller' : '/home';
