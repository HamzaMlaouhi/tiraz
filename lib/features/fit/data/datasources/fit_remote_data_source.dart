import 'package:dio/dio.dart';

import '../../../../core/network/api_call.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../models/measurement_profile_model.dart';

abstract class FitDataSource {
  Future<List<MeasurementProfileModel>> getProfiles();
  Future<MeasurementProfileModel> createProfile(LocalizedText name);

  /// Upserts one measurement ([key], e.g. `bust`) and returns the profile
  /// with its refreshed completion count/status.
  Future<MeasurementProfileModel> submitMeasurement(String profileId, {required String key, required double valueCm});
}

/// `/fit/profiles` — mirrors tiraz-backend's FitController.
class FitRemoteDataSourceImpl implements FitDataSource {
  final Dio _dio;
  FitRemoteDataSourceImpl(this._dio);

  @override
  Future<List<MeasurementProfileModel>> getProfiles() {
    return guardApiCall(() async {
      final response = await _dio.get<List<dynamic>>('/fit/profiles');
      return response.data!.map((item) => MeasurementProfileModel.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  @override
  Future<MeasurementProfileModel> createProfile(LocalizedText name) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>('/fit/profiles', data: {
        'name': {'ar': name.ar, 'en': name.en},
      });
      return MeasurementProfileModel.fromJson(response.data!);
    });
  }

  @override
  Future<MeasurementProfileModel> submitMeasurement(String profileId, {required String key, required double valueCm}) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>('/fit/profiles/$profileId/measurements', data: {
        'key': key,
        'valueCm': valueCm,
      });
      return MeasurementProfileModel.fromJson(response.data!);
    });
  }
}
