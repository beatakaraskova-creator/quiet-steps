/// Home-screen widget copy. Unknown language falls back to English.
library;

const glanceStatusGoal = {
  'en': 'Goal reached',
  'sk': 'Cieľ splnený',
  'cs': 'Cíl splněn',
  'pl': 'Cel osiągnięty',
  'de': 'Ziel erreicht',
  'es': 'Meta alcanzada',
  'fr': 'Objectif atteint',
  'it': 'Obiettivo raggiunto',
};

const glanceStepsToGo = <String, Map<String, String>>{
  'en': {'one': '{n} step to go', 'other': '{n} steps to go'},
  'sk': {
    'one': 'Ešte {n} krok',
    'few': 'Ešte {n} kroky',
    'other': 'Ešte {n} krokov',
  },
  'cs': {
    'one': 'Ještě {n} krok',
    'few': 'Ještě {n} kroky',
    'other': 'Ještě {n} kroků',
  },
  'pl': {
    'one': 'Jeszcze {n} krok',
    'few': 'Jeszcze {n} kroki',
    'other': 'Jeszcze {n} kroków',
  },
  'de': {'one': 'Noch {n} Schritt', 'other': 'Noch {n} Schritte'},
  'es': {'one': 'Falta {n} paso', 'other': 'Faltan {n} pasos'},
  'fr': {'one': 'Plus que {n} pas', 'other': 'Plus que {n} pas'},
  'it': {'one': 'Manca {n} passo', 'other': 'Mancano {n} passi'},
};

const glanceUi = {
  'en': {
    'smallLabel': 'Quiet Steps',
    'smallDescription': "Today's steps and a progress bar",
    'mediumLabel': 'Quiet Steps',
    'mediumDescription': "Today's steps, streak and status",
  },
  'sk': {
    'smallLabel': 'Quiet Steps',
    'smallDescription': 'Dnešné kroky a ukazovateľ cieľa',
    'mediumLabel': 'Quiet Steps',
    'mediumDescription': 'Dnešné kroky, séria a stav',
  },
  'cs': {
    'smallLabel': 'Quiet Steps',
    'smallDescription': 'Dnešní kroky a ukazatel cíle',
    'mediumLabel': 'Quiet Steps',
    'mediumDescription': 'Dnešní kroky, série a stav',
  },
  'pl': {
    'smallLabel': 'Quiet Steps',
    'smallDescription': 'Dzisiejsze kroki i pasek postępu',
    'mediumLabel': 'Quiet Steps',
    'mediumDescription': 'Dzisiejsze kroki, seria i status',
  },
  'de': {
    'smallLabel': 'Quiet Steps',
    'smallDescription': 'Heutige Schritte und Fortschritt',
    'mediumLabel': 'Quiet Steps',
    'mediumDescription': 'Heutige Schritte, Serie und Status',
  },
  'es': {
    'smallLabel': 'Quiet Steps',
    'smallDescription': 'Pasos de hoy y barra de progreso',
    'mediumLabel': 'Quiet Steps',
    'mediumDescription': 'Pasos de hoy, racha y estado',
  },
  'fr': {
    'smallLabel': 'Quiet Steps',
    'smallDescription': 'Pas du jour et barre de progression',
    'mediumLabel': 'Quiet Steps',
    'mediumDescription': 'Pas du jour, série et statut',
  },
  'it': {
    'smallLabel': 'Quiet Steps',
    'smallDescription': 'Passi di oggi e barra di avanzamento',
    'mediumLabel': 'Quiet Steps',
    'mediumDescription': 'Passi di oggi, serie e stato',
  },
};

String glanceUiLine(String language, String key) {
  return glanceUi[_lang(language)]?[key] ?? glanceUi['en']![key]!;
}

String glanceGoalReached(String language) {
  return glanceStatusGoal[_lang(language)] ?? glanceStatusGoal['en']!;
}

String glanceStepsToGoLine(String language, int remaining) {
  final lang = _lang(language);
  final forms = glanceStepsToGo[lang] ?? glanceStepsToGo['en']!;
  final key = _plural(lang, remaining);
  final template = forms[key] ?? forms['other'] ?? glanceStepsToGo['en']!['other']!;
  return template.replaceAll('{n}', _fmt(remaining));
}

String glanceLang(String language) => _lang(language);

String _lang(String language) {
  return glanceUi.containsKey(language) ? language : 'en';
}

String _plural(String lang, int n) {
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
      if (mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20)) {
        return 'few';
      }
      return 'other';
    default:
      return abs == 1 ? 'one' : 'other';
  }
}

String _fmt(int n) {
  return n.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );
}

String glanceFormatNumber(int n) => _fmt(n);
