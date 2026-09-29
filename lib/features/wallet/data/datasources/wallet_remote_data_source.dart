import 'package:dio/dio.dart';

import '../../../../core/network/api_call.dart';
import '../models/wallet_model.dart';

abstract class WalletDataSource {
  Future<WalletModel> getWallet();
}

/// `GET /wallet` — mirrors tiraz-backend's WalletController.
class WalletRemoteDataSourceImpl implements WalletDataSource {
  final Dio _dio;
  WalletRemoteDataSourceImpl(this._dio);

  @override
  Future<WalletModel> getWallet() {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>('/wallet');
      return WalletModel.fromJson(response.data!);
    });
  }
}
