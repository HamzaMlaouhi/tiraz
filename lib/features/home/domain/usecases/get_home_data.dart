import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/home_data.dart';
import '../repositories/home_repository.dart';

class GetHomeData implements UseCase<HomeData, NoParams> {
  final HomeRepository repository;
  const GetHomeData(this.repository);

  @override
  Future<Either<Failure, HomeData>> call(NoParams params) => repository.getHomeData();
}
