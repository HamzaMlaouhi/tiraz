import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/submit_measurement.dart';
import 'fit_cubit.dart';

part 'measurement_entry_state.dart';

/// The guided single-measurement wizard, one step per body point. Each
/// "next" saves that step's value to the profile on the server before
/// advancing; the step copy lives in the page via l10n, keyed by
/// [stepKeys] (which double as the backend's measurement keys).
class MeasurementEntryCubit extends Cubit<MeasurementEntryState> {
  static const stepKeys = ['shoulder', 'bust', 'waist'];

  final String profileId;
  final SubmitMeasurement _submitMeasurement;
  final FitCubit _fitCubit;

  MeasurementEntryCubit({
    required this.profileId,
    required SubmitMeasurement submitMeasurement,
    required FitCubit fitCubit,
  })  : _submitMeasurement = submitMeasurement,
        _fitCubit = fitCubit,
        super(const MeasurementEntryState(value: '92'));

  void valueChanged(String value) => emit(state.copyWith(value: value));

  /// Saves the current step. Returns whether the wizard is finished, or
  /// the failure message (the step does not advance on failure).
  Future<({bool finished, String? error})> next() async {
    final valueCm = double.tryParse(state.value.replaceAll(',', '.'));
    if (valueCm == null || valueCm <= 0) return (finished: false, error: null);

    emit(state.copyWith(submitting: true));
    final result = await _submitMeasurement(
      SubmitMeasurementParams(profileId: profileId, key: state.stepKey, valueCm: valueCm),
    );
    return result.fold<({bool finished, String? error})>(
      (failure) {
        emit(state.copyWith(submitting: false));
        return (finished: false, error: failure.message);
      },
      (profile) {
        _fitCubit.profileUpdated(profile);
        if (state.stepIndex >= stepKeys.length - 1) {
          emit(state.copyWith(submitting: false));
          return (finished: true, error: null);
        }
        emit(state.copyWith(stepIndex: state.stepIndex + 1, value: '92', submitting: false));
        return (finished: false, error: null);
      },
    );
  }

  void previous() {
    if (state.stepIndex == 0) return;
    emit(state.copyWith(stepIndex: state.stepIndex - 1));
  }
}
