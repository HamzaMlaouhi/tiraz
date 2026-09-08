import '../models/measurement_profile_model.dart';

abstract class FitLocalDataSource {
  Future<List<MeasurementProfileModel>> getProfiles();
}

class FitLocalDataSourceImpl implements FitLocalDataSource {
  @override
  Future<List<MeasurementProfileModel>> getProfiles() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MeasurementProfileModel.mock();
  }
}
