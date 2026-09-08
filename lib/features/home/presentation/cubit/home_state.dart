part of 'home_cubit.dart';

enum HomeStatus { loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final HomeData? data;
  final String? errorMessage;

  const HomeState({this.status = HomeStatus.loading, this.data, this.errorMessage});

  HomeState copyWith({HomeStatus? status, HomeData? data, String? errorMessage}) {
    return HomeState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, data, errorMessage];
}
