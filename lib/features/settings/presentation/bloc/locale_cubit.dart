import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  static const String localePreferenceKey = 'user_locale_code';
  final SharedPreferences prefs;

  LocaleCubit({required this.prefs})
      : super(LocaleState(Locale(
          prefs.getString(localePreferenceKey) ?? 'en',
        )));

  Future<void> changeLocale(String languageCode) async {
    if (state.locale.languageCode == languageCode) return;

    await prefs.setString(localePreferenceKey, languageCode);
    emit(LocaleState(Locale(languageCode)));
  }

}
