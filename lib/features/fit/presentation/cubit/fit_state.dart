part of 'fit_cubit.dart';

enum FitStatus { loading, loaded, error }

class FitState extends Equatable {
  final FitStatus status;
  final List<MeasurementProfile> profiles;
  final String? errorMessage;

  const FitState({this.status = FitStatus.loading, this.profiles = const [], this.errorMessage});

  FitState copyWith({FitStatus? status, List<MeasurementProfile>? profiles, String? errorMessage}) {
    return FitState(
      status: status ?? this.status,
      profiles: profiles ?? this.profiles,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profiles, errorMessage];
}
