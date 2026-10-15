import 'package:intl/intl.dart';

/// Thousands grouping for the chosen language (10,000 / 10 000 / 10.000).
String formatCount(int n, String language) {
  final lang = language.isEmpty ? 'en' : language;
  try {
    return NumberFormat.decimalPattern(lang).format(n);
  } catch (_) {
    return NumberFormat.decimalPattern('en').format(n);
  }
}

/// Decimal numbers for the chosen language (4.99 in en, 4,99 in sk/cs/pl/de/es/fr/it).
String formatDecimal(num n, String language, {int digits = 2}) {
  final lang = language.isEmpty ? 'en' : language;
  try {
    return NumberFormat.decimalPatternDigits(
      locale: lang,
      decimalDigits: digits,
    ).format(n);
  } catch (_) {
    return NumberFormat.decimalPatternDigits(
      locale: 'en',
      decimalDigits: digits,
    ).format(n);
  }
}
