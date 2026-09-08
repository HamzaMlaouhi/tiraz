import 'package:flutter_bloc/flutter_bloc.dart';

/// Payment method keys, mirroring how [AuthCubit]'s emirate list works —
/// the cubit holds keys, the page maps each to its localized label (and,
/// for two of them, a note) via `AppLocalizations`.
class CheckoutCubit extends Cubit<int> {
  static const paymentKeys = ['applePay', 'bankCard', 'tabby', 'cod'];

  CheckoutCubit() : super(0);

  void selectPayment(int index) => emit(index);
}
