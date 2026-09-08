part of 'measurement_entry_cubit.dart';

class MeasurementEntryState extends Equatable {
  final int stepIndex;
  final String value;

  const MeasurementEntryState({this.stepIndex = 0, required this.value});

  int get stepNumber => stepIndex + 1;
  int get totalSteps => MeasurementEntryCubit.stepKeys.length;
  double get progress => stepNumber / totalSteps;
  String get stepKey => MeasurementEntryCubit.stepKeys[stepIndex];

  MeasurementEntryState copyWith({int? stepIndex, String? value}) {
    return MeasurementEntryState(stepIndex: stepIndex ?? this.stepIndex, value: value ?? this.value);
  }

  @override
  List<Object?> get props => [stepIndex, value];
}
