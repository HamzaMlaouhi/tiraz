import '../../domain/entities/home_data.dart';
import '../models/occasion_model.dart';
import '../models/product_summary_model.dart';
import '../models/store_model.dart';

abstract class HomeLocalDataSource {
  Future<HomeData> getHomeData();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  Future<HomeData> getHomeData() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return HomeData(
      eidDaysAway: 23,
      occasions: OccasionModel.mock(),
      newDrops: ProductSummaryModel.mock(),
      stores: StoreModel.mock(),
    );
  }
}
