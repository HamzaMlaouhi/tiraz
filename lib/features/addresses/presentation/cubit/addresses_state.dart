part of 'addresses_cubit.dart';

class AddressesState extends Equatable {
  final List<Address> addresses;
  final String defaultId;

  const AddressesState({required this.addresses, required this.defaultId});

  Address get defaultAddress => addresses.firstWhere((a) => a.id == defaultId, orElse: () => addresses.first);

  AddressesState copyWith({List<Address>? addresses, String? defaultId}) {
    return AddressesState(addresses: addresses ?? this.addresses, defaultId: defaultId ?? this.defaultId);
  }

  @override
  List<Object?> get props => [addresses, defaultId];
}
