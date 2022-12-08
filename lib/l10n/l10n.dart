import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('es'),
    const Locale('en'),
    const Locale('pt'),
  ];
  static String getFlag(String code) {
    switch (code) {
      case 'pt':
        return '🇵🇹';
      case 'en':
        return '🇺🇸';
      case 'es':
      default:
        return '🇪🇸';
    }
  }
}
