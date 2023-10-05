// Copyright 2021-2022, Markus Näther <naem@hs-furtwangen.de>

import 'package:flutter/material.dart';
import 'package:fancai_client/core/constants.dart';
import 'package:fancai_client/core/storage.dart';

class LocalizationProvider extends ChangeNotifier {
  final Storage storage = Storage.instance;

  Locale _locale = const Locale('de', 'DE');

  Locale get locale => _locale;

  LocalizationProvider() {
    _loadCurrentLanguage();
  }

  void setLanguage(Locale locale) {
    _locale = locale;
    // Save to shared prefs
    _saveLanguage(_locale);
    notifyListeners();
  }

  _loadCurrentLanguage() async {
    _locale = Locale(
        storage.getStringValue(Constants.LANGUAGE_CODE).toString() ?? 'de',
        storage.getStringValue(Constants.COUNTRY_CODE).toString() ?? 'DE');
    notifyListeners();
  }

  _saveLanguage(Locale locale) async {
    storage.setStringValue(Constants.LANGUAGE_CODE, locale.languageCode);
    storage.setStringValue(Constants.COUNTRY_CODE, locale.countryCode!);
  }
}
