import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// App-wide language switch. Arabic (RTL) is the default, matching the
/// design canvas's "Arabic-first, full RTL" brief; English (LTR) sits
/// alongside it.
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('ar'));

  void setArabic() => emit(const Locale('ar'));
  void setEnglish() => emit(const Locale('en'));
  void toggle() => emit(state.languageCode == 'ar' ? const Locale('en') : const Locale('ar'));
}
