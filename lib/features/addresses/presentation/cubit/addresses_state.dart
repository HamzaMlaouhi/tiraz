part of 'addresses_cubit.dart';

enum AddressesStatus { initial, loading, loaded, error }

class AddressesState extends Equatable {
  final AddressesStatus status;
  final List<Address> addresses;

  /// Null only while [addresses] is empty.
  final String? defaultId;
  final String? errorMessage;

  const AddressesState({
    this.status = AddressesStatus.initial,
    this.addresses = const [],
    this.defaultId,
    this.errorMessage,
  });

  Address? get defaultAddress {
    if (addresses.isEmpty) return null;
    return addresses.firstWhere((a) => a.id == defaultId, orElse: () => addresses.first);
  }

  AddressesState copyWith({
    AddressesStatus? status,
    List<Address>? addresses,
    String? defaultId,
    String? errorMessage,
  }) {
    return AddressesState(
      status: status ?? this.status,
      addresses: addresses ?? this.addresses,
      defaultId: defaultId ?? this.defaultId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, addresses, defaultId, errorMessage];
}
