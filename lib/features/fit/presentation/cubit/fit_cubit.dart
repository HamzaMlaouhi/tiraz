import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/measurement_profile.dart';
import '../../domain/usecases/create_measurement_profile.dart';
import '../../domain/usecases/get_measurement_profiles.dart';

part 'fit_state.dart';

class FitCubit extends Cubit<FitState> {
  final GetMeasurementProfiles _getMeasurementProfiles;
  final CreateMeasurementProfile _createMeasurementProfile;

  FitCubit({
    required GetMeasurementProfiles getMeasurementProfiles,
    required CreateMeasurementProfile createMeasurementProfile,
  })  : _getMeasurementProfiles = getMeasurementProfiles,
        _createMeasurementProfile = createMeasurementProfile,
        super(const FitState());

  Future<void> load() async {
    if (state.status != FitStatus.loaded) emit(state.copyWith(status: FitStatus.loading));
    final result = await _getMeasurementProfiles(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: FitStatus.error, errorMessage: failure.message)),
      (profiles) => emit(state.copyWith(status: FitStatus.loaded, profiles: profiles)),
    );
  }

  /// Returns the failure message, or null on success.
  Future<String?> createProfile(LocalizedText name) async {
    final result = await _createMeasurementProfile(name);
    return result.fold((failure) => failure.message, (profile) {
      emit(state.copyWith(status: FitStatus.loaded, profiles: [...state.profiles, profile]));
      return null;
    });
  }

  /// Swaps in a profile the server just returned (e.g. after a
  /// measurement was saved), so the list's progress stays current.
  void profileUpdated(MeasurementProfile profile) {
    emit(state.copyWith(profiles: [
      for (final p in state.profiles) p.id == profile.id ? profile : p,
    ]));
  }
}
