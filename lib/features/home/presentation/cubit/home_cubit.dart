import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/usecases/get_home_data.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeData _getHomeData;

  HomeCubit({required GetHomeData getHomeData})
      : _getHomeData = getHomeData,
        super(const HomeState());

  Future<void> load() async {
    emit(state.copyWith(status: HomeStatus.loading));
    final result = await _getHomeData(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: HomeStatus.error, errorMessage: failure.message)),
      (data) => emit(state.copyWith(status: HomeStatus.loaded, data: data)),
    );
  }
}
