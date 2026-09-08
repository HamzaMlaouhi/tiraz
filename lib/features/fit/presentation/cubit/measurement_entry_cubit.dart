import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'measurement_entry_state.dart';

/// The guided single-measurement wizard, one step per body point. Purely
/// local UI state — like Auth's OTP flow, it has no repository of its
/// own; the step copy lives in the page via l10n, keyed by [stepKeys].
class MeasurementEntryCubit extends Cubit<MeasurementEntryState> {
  static const stepKeys = ['shoulder', 'bust', 'waist'];

  MeasurementEntryCubit() : super(const MeasurementEntryState(value: '92'));

  void valueChanged(String value) => emit(state.copyWith(value: value));

  bool next() {
    if (state.stepIndex >= stepKeys.length - 1) return true;
    emit(state.copyWith(stepIndex: state.stepIndex + 1, value: '92'));
    return false;
  }

  void previous() {
    if (state.stepIndex == 0) return;
    emit(state.copyWith(stepIndex: state.stepIndex - 1));
  }
}
