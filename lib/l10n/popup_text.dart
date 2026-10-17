/// Milestone pop-up and its Settings toggle.
/// Unknown language falls back to English.
library;

const popupText = {
  'en': {
    'close': 'Close',
    'steps': '{n} steps',
    'goal': 'Daily goal',
    'today': 'Today',
    'tune': 'Milestone tune',
    'tuneHint':
        'A short, gentle tune when a milestone message appears. Never in quiet hours or when the phone is on silent.',
    'fontCredit': 'Messages are set in Noto Serif (SIL Open Font License 1.1).',
  },
  'sk': {
    'close': 'Zavrieť',
    'steps': '{n} krokov',
    'goal': 'Denný cieľ',
    'today': 'Dnes',
    'tune': 'Melódia pri míľnikoch',
    'tuneHint':
        'Krátka jemná melódia, keď sa zobrazí správa pri míľniku. Nikdy počas tichých hodín ani keď je telefón stlmený.',
    'fontCredit': 'Správy sú písané písmom Noto Serif (SIL Open Font License 1.1).',
  },
  'cs': {
    'close': 'Zavřít',
    'steps': '{n} kroků',
    'goal': 'Denní cíl',
    'today': 'Dnes',
    'tune': 'Melodie u milníků',
    'tuneHint':
        'Krátká jemná melodie, když se objeví zpráva u milníku. Nikdy v tichých hodinách ani když je telefon ztlumený.',
    'fontCredit': 'Zprávy jsou psány písmem Noto Serif (SIL Open Font License 1.1).',
  },
  'pl': {
    'close': 'Zamknij',
    'steps': '{n} kroków',
    'goal': 'Cel dzienny',
    'today': 'Dziś',
    'tune': 'Melodia przy kamieniach milowych',
    'tuneHint':
        'Krótka, łagodna melodia, gdy pojawia się wiadomość. Nigdy w ciche godziny ani gdy telefon jest wyciszony.',
    'fontCredit': 'Wiadomości są pisane krojem Noto Serif (SIL Open Font License 1.1).',
  },
  'de': {
    'close': 'Schließen',
    'steps': '{n} Schritte',
    'goal': 'Tagesziel',
    'today': 'Heute',
    'tune': 'Meilenstein-Melodie',
    'tuneHint':
        'Eine kurze, sanfte Melodie, wenn eine Meilenstein-Nachricht erscheint. Nie in Ruhezeiten oder wenn das Telefon lautlos ist.',
    'fontCredit': 'Nachrichten in der Schrift Noto Serif (SIL Open Font License 1.1).',
  },
  'es': {
    'close': 'Cerrar',
    'steps': '{n} pasos',
    'goal': 'Meta diaria',
    'today': 'Hoy',
    'tune': 'Melodía de hitos',
    'tuneHint':
        'Una melodía breve y suave cuando aparece un mensaje de hito. Nunca en horas tranquilas ni con el teléfono en silencio.',
    'fontCredit': 'Los mensajes usan la fuente Noto Serif (SIL Open Font License 1.1).',
  },
  'fr': {
    'close': 'Fermer',
    'steps': '{n} pas',
    'goal': 'Objectif du jour',
    'today': 'Aujourd’hui',
    'tune': 'Mélodie des paliers',
    'tuneHint':
        'Une courte mélodie douce quand un message de palier apparaît. Jamais pendant les heures calmes ni quand le téléphone est en silencieux.',
    'fontCredit': 'Les messages utilisent la police Noto Serif (SIL Open Font License 1.1).',
  },
  'it': {
    'close': 'Chiudi',
    'steps': '{n} passi',
    'goal': 'Obiettivo del giorno',
    'today': 'Oggi',
    'tune': 'Melodia delle tappe',
    'tuneHint':
        'Una breve melodia gentile quando appare un messaggio di tappa. Mai nelle ore silenziose né con il telefono in silenzioso.',
    'fontCredit': 'I messaggi usano il carattere Noto Serif (SIL Open Font License 1.1).',
  },
};

String popupLine(String language, String key) {
  final lang = popupText.containsKey(language) ? language : 'en';
  return popupText[lang]?[key] ?? popupText['en']![key]!;
}

/// Pop-up label for a fired milestone id: "5,000 steps" or "Daily goal".
/// [formatted] is the step count already grouped for the language.
String popupMilestoneLabel(String language, String milestoneKey, String Function(int) formatted) {
  if (milestoneKey == 'goal') return popupLine(language, 'goal');
  final n = int.tryParse(milestoneKey.replaceFirst('round_', ''));
  if (n == null) return popupLine(language, 'today');
  return popupLine(language, 'steps').replaceAll('{n}', formatted(n));
}
