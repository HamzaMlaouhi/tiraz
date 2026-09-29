import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/address.dart';
import '../../domain/usecases/delete_address.dart';
import '../../domain/usecases/get_addresses.dart';
import '../../domain/usecases/save_address.dart';
import '../../domain/usecases/set_default_address.dart';

part 'addresses_state.dart';

/// Registered as a lazy singleton: Checkout and Account both read and
/// write the same default-address selection.
///
/// Mutations return the failure message (null on success) so the calling
/// sheet/page can surface it. Create/update/delete re-fetch the list
/// afterwards, since the server decides which address is the default.
class AddressesCubit extends Cubit<AddressesState> {
  final GetAddresses _getAddresses;
  final SaveAddress _saveAddress;
  final DeleteAddress _deleteAddress;
  final SetDefaultAddress _setDefaultAddress;

  AddressesCubit({
    required GetAddresses getAddresses,
    required SaveAddress saveAddress,
    required DeleteAddress deleteAddress,
    required SetDefaultAddress setDefaultAddress,
  })  : _getAddresses = getAddresses,
        _saveAddress = saveAddress,
        _deleteAddress = deleteAddress,
        _setDefaultAddress = setDefaultAddress,
        super(const AddressesState());

  Future<void> load() async {
    if (state.status != AddressesStatus.loaded) emit(state.copyWith(status: AddressesStatus.loading));
    final result = await _getAddresses(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: AddressesStatus.error, errorMessage: failure.message)),
      (book) => emit(AddressesState(
        status: AddressesStatus.loaded,
        addresses: book.addresses,
        defaultId: book.defaultId,
      )),
    );
  }

  /// Optimistic: the highlight moves immediately and reverts on failure.
  Future<String?> selectDefault(String id) async {
    final previous = state;
    emit(state.copyWith(defaultId: id));
    final result = await _setDefaultAddress(id);
    return result.fold((failure) {
      emit(previous);
      return failure.message;
    }, (_) => null);
  }

  Future<String?> save({String? id, required LocalizedText label, required LocalizedText line}) =>
      _mutateThenReload(_saveAddress(SaveAddressParams(id: id, label: label, line: line)));

  Future<String?> delete(String id) => _mutateThenReload(_deleteAddress(id));

  Future<String?> _mutateThenReload(Future<Either<Failure, Unit>> call) async {
    final result = await call;
    if (result.isLeft()) return result.fold((failure) => failure.message, (_) => null);
    await load();
    return null;
  }
}
