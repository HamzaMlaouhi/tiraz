part of 'measurement_entry_cubit.dart';

class MeasurementEntryState extends Equatable {
  final int stepIndex;
  final String value;
  final bool submitting;

  const MeasurementEntryState({this.stepIndex = 0, required this.value, this.submitting = false});

  int get stepNumber => stepIndex + 1;
  int get totalSteps => MeasurementEntryCubit.stepKeys.length;
  double get progress => stepNumber / totalSteps;
  String get stepKey => MeasurementEntryCubit.stepKeys[stepIndex];

  MeasurementEntryState copyWith({int? stepIndex, String? value, bool? submitting}) {
    return MeasurementEntryState(
      stepIndex: stepIndex ?? this.stepIndex,
      value: value ?? this.value,
      submitting: submitting ?? this.submitting,
    );
  }

  @override
  List<Object?> get props => [stepIndex, value, submitting];
}
