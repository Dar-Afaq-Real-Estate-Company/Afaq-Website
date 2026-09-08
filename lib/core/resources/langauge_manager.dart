
import 'package:flutter/material.dart';

enum LanguageType { ENGLISH, ARABIC }

const String arabic = "ar";
const String english = "en";

const String assetsLangPath = "assets/lang";


const Locale arabicLocale = Locale("ar", '');
const Locale englishLocale = Locale("en", '');

extension LanguageTypeExtension on LanguageType {
  String getLanguageValue() {
    switch (this) {
      case LanguageType.ENGLISH:
        return english;
      case LanguageType.ARABIC:
        return arabic;
    }
  }
}
