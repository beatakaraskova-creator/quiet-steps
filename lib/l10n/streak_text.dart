/// Calm streak and weekly-view copy.
/// Unknown language falls back to English.
library;

import 'package:intl/intl.dart';

const _goodDays = <String, Map<String, String>>{
  'en': {'one': '{n} good day', 'other': '{n} good days'},
  'sk': {
    'one': '{n} dobrý deň',
    'few': '{n} dobré dni',
    'other': '{n} dobrých dní',
  },
  'cs': {
    'one': '{n} dobrý den',
    'few': '{n} dobré dny',
    'other': '{n} dobrých dní',
  },
  'pl': {
    'one': '{n} dobry dzień',
    'few': '{n} dobre dni',
    'other': '{n} dobrych dni',
  },
  'de': {'one': '{n} guter Tag', 'other': '{n} gute Tage'},
  'es': {'one': '{n} día bueno', 'other': '{n} días buenos'},
  'fr': {'one': '{n} beau jour', 'other': '{n} beaux jours'},
  'it': {'one': '{n} bel giorno', 'other': '{n} bei giorni'},
};

const _steps = <String, Map<String, String>>{
  'en': {'one': '{n} step', 'other': '{n} steps'},
  'sk': {
    'one': '{n} krok',
    'few': '{n} kroky',
    'other': '{n} krokov',
  },
  'cs': {
    'one': '{n} krok',
    'few': '{n} kroky',
    'other': '{n} kroků',
  },
  'pl': {
    'one': '{n} krok',
    'few': '{n} kroki',
    'other': '{n} kroków',
  },
  'de': {'one': '{n} Schritt', 'other': '{n} Schritte'},
  'es': {'one': '{n} paso', 'other': '{n} pasos'},
  'fr': {'one': '{n} pas', 'other': '{n} pas'},
  'it': {'one': '{n} passo', 'other': '{n} passi'},
};

const _restDay = {
  'en': 'Rest day',
  'sk': 'Deň odpočinku',
  'cs': 'Den odpočinku',
  'pl': 'Dzień odpoczynku',
  'de': 'Ruhetag',
  'es': 'Día de descanso',
  'fr': 'Jour de repos',
  'it': 'Giorno di riposo',
};

const _freshStart = {
  'en': 'A fresh start today.',
  'sk': 'Dnes je nový začiatok.',
  'cs': 'Dnes je nový začátek.',
  'pl': 'Dziś nowy początek.',
  'de': 'Heute ein neuer Anfang.',
  'es': 'Un nuevo comienzo hoy.',
  'fr': 'Un nouveau départ aujourd\'hui.',
  'it': 'Un nuovo inizio oggi.',
};

const _thisWeek = {
  'en': 'This week',
  'sk': 'Tento týždeň',
  'cs': 'Tento týden',
  'pl': 'Ten tydzień',
  'de': 'Diese Woche',
  'es': 'Esta semana',
  'fr': 'Cette semaine',
  'it': 'Questa settimana',
};

class StreakText {
  static String goodDays(String language, int n) {
    return _form(_goodDays, language, n);
  }

  static String steps(String language, int n) {
    return _form(_steps, language, n);
  }

  static String restDay(String language) =>
      _restDay[_lang(language)] ?? _restDay['en']!;

  static String freshStart(String language) =>
      _freshStart[_lang(language)] ?? _freshStart['en']!;

  static String thisWeek(String language) =>
      _thisWeek[_lang(language)] ?? _thisWeek['en']!;

  static String _lang(String language) {
    return _goodDays.containsKey(language) ? language : 'en';
  }

  static String _form(
    Map<String, Map<String, String>> table,
    String language,
    int n,
  ) {
    final lang = _lang(language);
    final forms = table[lang] ?? table['en']!;
    final key = _plural(lang, n);
    final template = forms[key] ?? forms['other'] ?? table['en']!['other']!;
    return template.replaceAll('{n}', _fmt(n, lang));
  }

  static String _plural(String lang, int n) {
    final abs = n.abs();
    switch (lang) {
      case 'sk':
      case 'cs':
        if (abs == 1) return 'one';
        if (abs >= 2 && abs <= 4) return 'few';
        return 'other';
      case 'pl':
        if (abs == 1) return 'one';
        final mod10 = abs % 10;
        final mod100 = abs % 100;
        if (mod10 >= 2 &&
            mod10 <= 4 &&
            (mod100 < 10 || mod100 >= 20)) {
          return 'few';
        }
        return 'other';
      default:
        return abs == 1 ? 'one' : 'other';
    }
  }

  static String _fmt(int n, String language) {
    try {
      return NumberFormat.decimalPattern(language).format(n);
    } catch (_) {
      return NumberFormat.decimalPattern('en').format(n);
    }
  }
}
