import 'package:dio/dio.dart';

import '../../../../core/network/api_call.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../models/address_model.dart';

abstract class AddressesDataSource {
  Future<List<AddressModel>> getAddresses();

  /// The server makes a user's first address their default.
  Future<AddressModel> create({required LocalizedText label, required LocalizedText line});
  Future<AddressModel> update(String id, {LocalizedText? label, LocalizedText? line});

  /// The server refuses (409) to delete a user's only address.
  Future<void> remove(String id);
  Future<void> setDefault(String id);
}

/// `/addresses` CRUD plus `PATCH /addresses/:id/default` — mirrors
/// tiraz-backend's AddressesController.
class AddressesRemoteDataSourceImpl implements AddressesDataSource {
  final Dio _dio;
  AddressesRemoteDataSourceImpl(this._dio);

  @override
  Future<List<AddressModel>> getAddresses() {
    return guardApiCall(() async {
      final response = await _dio.get<List<dynamic>>('/addresses');
      return response.data!.map((item) => AddressModel.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  @override
  Future<AddressModel> create({required LocalizedText label, required LocalizedText line}) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>('/addresses', data: {
        'label': _json(label),
        'line': _json(line),
      });
      return AddressModel.fromJson(response.data!);
    });
  }

  @override
  Future<AddressModel> update(String id, {LocalizedText? label, LocalizedText? line}) {
    return guardApiCall(() async {
      final response = await _dio.patch<Map<String, dynamic>>('/addresses/$id', data: {
        if (label != null) 'label': _json(label),
        if (line != null) 'line': _json(line),
      });
      return AddressModel.fromJson(response.data!);
    });
  }

  @override
  Future<void> remove(String id) => guardApiCall(() => _dio.delete<void>('/addresses/$id'));

  @override
  Future<void> setDefault(String id) => guardApiCall(() => _dio.patch<void>('/addresses/$id/default'));

  static Map<String, String> _json(LocalizedText text) => {'ar': text.ar, 'en': text.en};
}
