import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TranslationHelper {
  TranslationHelper._();

  static getDeviceLanguage(BuildContext context) {
    var deviceLanguage = context.deviceLocale.countryCode!.toLowerCase();

    switch (deviceLanguage) {
      case 'TR':
        return 'tr';
      default:
        return 'en';
    }
  }
}
