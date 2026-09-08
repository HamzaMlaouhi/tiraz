import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/address.dart';

part 'addresses_state.dart';

/// Registered as a lazy singleton: Checkout and Account both read and
/// write the same default-address selection.
class AddressesCubit extends Cubit<AddressesState> {
  AddressesCubit()
      : super(
          const AddressesState(
            addresses: [
              Address(
                id: 'home',
                label: LocalizedText(ar: 'المنزل', en: 'Home'),
                line: LocalizedText(ar: 'شارع الوصل، جميرا 1، دبي', en: 'Al Wasl Road, Jumeirah 1, Dubai'),
              ),
              Address(
                id: 'work',
                label: LocalizedText(ar: 'العمل', en: 'Work'),
                line: LocalizedText(ar: 'أبراج الإمارات، مكتب 12، دبي', en: 'Emirates Towers, Suite 12, Dubai'),
              ),
            ],
            defaultId: 'home',
          ),
        );

  void selectDefault(String id) => emit(state.copyWith(defaultId: id));
}
