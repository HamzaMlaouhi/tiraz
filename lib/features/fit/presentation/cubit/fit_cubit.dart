import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/measurement_profile.dart';
import '../../domain/usecases/get_measurement_profiles.dart';

part 'fit_state.dart';

class FitCubit extends Cubit<FitState> {
  final GetMeasurementProfiles _getMeasurementProfiles;

  FitCubit({required GetMeasurementProfiles getMeasurementProfiles})
      : _getMeasurementProfiles = getMeasurementProfiles,
        super(const FitState());

  Future<void> load() async {
    emit(state.copyWith(status: FitStatus.loading));
    final result = await _getMeasurementProfiles(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: FitStatus.error, errorMessage: failure.message)),
      (profiles) => emit(state.copyWith(status: FitStatus.loaded, profiles: profiles)),
    );
  }
}
