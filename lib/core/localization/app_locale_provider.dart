import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/local_storage_service.dart';
import 'app_language.dart';

const _localeStorageKey = 'app_locale_code';

final appLocaleProvider = NotifierProvider<AppLocaleNotifier, Locale>(
  AppLocaleNotifier.new,
);

class AppLocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    unawaited(_restoreSavedLocale());
    return const Locale('fr');
  }

  Future<void> _restoreSavedLocale() async {
    final localStorage = ref.read(localStorageProvider);
    final savedCode = await localStorage.getString(_localeStorageKey);
    if (savedCode == null || savedCode.isEmpty) {
      return;
    }

    final language = AppLanguage.fromCode(savedCode);
    state = Locale(language.code);
  }

  Future<void> setLanguage(AppLanguage language) async {
    final nextLocale = Locale(language.code);
    if (state.languageCode == nextLocale.languageCode) {
      return;
    }

    state = nextLocale;
    final localStorage = ref.read(localStorageProvider);
    await localStorage.setString(_localeStorageKey, language.code);
  }
}
