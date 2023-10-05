// Copyright 2021-2022, Markus Näther <naem@hs-furtwangen.de>

class LanguageModel {
  String imageUrl;
  String languageName;
  String languageCode;
  String countryCode;

  LanguageModel(
      {required this.imageUrl,
      required this.languageName,
      required this.languageCode,
      required this.countryCode});
}
