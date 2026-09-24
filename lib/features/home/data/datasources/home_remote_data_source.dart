import 'package:dio/dio.dart';

import '../../../../core/network/api_call.dart';
import '../../domain/entities/home_data.dart';
import '../models/occasion_model.dart';
import '../models/product_summary_model.dart';
import '../models/store_model.dart';

abstract class HomeDataSource {
  Future<HomeData> getHomeData();
}

/// `GET /home` — mirrors `HomeService.getHomeData` on the backend.
class HomeRemoteDataSourceImpl implements HomeDataSource {
  final Dio _dio;
  HomeRemoteDataSourceImpl(this._dio);

  @override
  Future<HomeData> getHomeData() {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>('/home');
      final data = response.data!;
      return HomeData(
        eidDaysAway: data['eidDaysAway'] as int,
        occasions: (data['occasions'] as List<dynamic>)
            .map((item) => OccasionModel.fromJson(item as Map<String, dynamic>))
            .toList(),
        newDrops: ProductSummaryModel.listFromJson(data['newDrops'] as List<dynamic>),
        stores: StoreModel.listFromJson(data['stores'] as List<dynamic>),
      );
    });
  }
}
