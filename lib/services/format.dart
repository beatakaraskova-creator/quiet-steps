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
