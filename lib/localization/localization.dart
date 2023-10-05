// Copyright 2021-2022, Markus Näther <naem@hs-furtwangen.de>

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fancai_client/core/constants.dart';

class Localization {
  final Locale locale;
  Map<String, String>? _localizedValues;

  Localization(this.locale);

  static Localization? of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization);
  }

  Future<void> load() async {
    String jsonValues = await rootBundle
        .loadString('assets/language/${locale.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonValues);
    // TODO(naetherm): Allow more complex dictionary structures
    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String? translate(String key) {
    return _localizedValues![key];
  }

  static const LocalizationsDelegate<Localization> delete =
      _FancAILocalizationsDelegate();
}

class _FancAILocalizationsDelegate extends LocalizationsDelegate<Localization> {
  const _FancAILocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    List<String> _languageString = [];
    // TODO(naetherm): Add languages to constants!
    return _languageString.contains(locale.languageCode);
  }

  @override
  Future<Localization> load(Locale locale) async {
    Localization localization = Localization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<Localization> old) {
    return false;
  }
}
