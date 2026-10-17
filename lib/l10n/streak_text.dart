/// Calm streak and weekly-view copy.
/// Unknown language falls back to English.
library;

import 'package:intl/intl.dart';

import 'day_pick.dart';

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

/// NEW. Kind rest-day lines: restDayLines[lang][style]['rest_day'] -> 7 lines,
/// index 0 = Monday ... 6 = Sunday. The short _restDay label above stays as it is.
const restDayLines = <String, Map<String, Map<String, List<String>>>>{
  'en': {
    'calm': {
      'rest_day': [
        'A rest day to begin the week. What a kind way to start.', // 0 Mon
        "A rest day. Resting is part of walking too, and today it's exactly right.", // 1 Tue
        'A quiet day to rest. Your good days are still right here with you.', // 2 Wed
        'Rest days matter. Let yourself enjoy the stillness.', // 3 Thu
        "Today is for resting, and that's a kind choice. Tomorrow will be there when you're ready.", // 4 Fri
        "A gentle pause. Rest isn't giving up, it's looking after yourself.", // 5 Sat
        "A restful day, slow and easy. You're allowed to simply be.", // 6 Sun
      ],
    },
    'cheerful': {
      'rest_day': [
        'Rest day! Starting the week gently is a great idea.', // 0 Mon
        'Rest day! Put your feet up and enjoy it. Rest is part of the journey.', // 1 Tue
        'Hooray for rest days! Your streak is still going strong.', // 2 Wed
        "A cosy rest day! Take it as easy as you like, it's all good.", // 3 Thu
        'Rest day! Your good days are safe, so enjoy the pause.', // 4 Fri
        'Taking a breather today? Lovely. Resting is a good thing to do.', // 5 Sat
        'Easy rest day! Cosy up and enjoy every minute of it.', // 6 Sun
      ],
    },
  },
  'sk': {
    'calm': {
      'rest_day': [
        'Deň odpočinku na začiatok týždňa. Aký láskavý spôsob, ako začať.', // 0 Mon
        'Deň odpočinku. Aj oddych patrí k chôdzi a dnes je presne na mieste.', // 1 Tue
        'Tichý deň na oddych. Vaše dobré dni sú stále s vami.', // 2 Wed
        'Dni odpočinku sú dôležité. Doprajte si pokoj a ticho.', // 3 Thu
        'Dnešok je na oddych, a to je láskavá voľba. Zajtrajšok počká, kým budete pripravení.', // 4 Fri
        'Jemná prestávka. Oddych nie je vzdávanie sa, je to starostlivosť o seba.', // 5 Sat
        'Pokojný deň, pomalý a ľahký. Môžete jednoducho len byť.', // 6 Sun
      ],
    },
    'cheerful': {
      'rest_day': [
        'Deň odpočinku! Začať týždeň zľahka je skvelý nápad.', // 0 Mon
        'Deň odpočinku! Vyložte si nohy a užite si to. Aj oddych patrí k ceste.', // 1 Tue
        'Hurá, deň odpočinku! Vaša séria pokračuje ďalej.', // 2 Wed
        'Útulný deň odpočinku! Berte to tak zľahka, ako chcete, všetko je v poriadku.', // 3 Thu
        'Deň odpočinku! Vaše dobré dni sú v bezpečí, tak si užite prestávku.', // 4 Fri
        'Dnes si vydýchnete? Krásne. Oddych je dobrá vec.', // 5 Sat
        'Pohodový deň odpočinku! Zababušte sa a užite si každú minútu.', // 6 Sun
      ],
    },
  },
  'cs': {
    'calm': {
      'rest_day': [
        'Den odpočinku na začátek týdne. Jaký laskavý způsob, jak začít.', // 0 Mon
        'Den odpočinku. I odpočinek patří k chůzi a dnes je přesně na místě.', // 1 Tue
        'Tichý den na odpočinek. Vaše dobré dny jsou pořád s vámi.', // 2 Wed
        'Dny odpočinku jsou důležité. Dopřejte si klid a ticho.', // 3 Thu
        'Dnešek je na odpočinek, a to je laskavá volba. Zítřek počká, až budete připraveni.', // 4 Fri
        'Jemná přestávka. Odpočinek není vzdávání se, je to péče o sebe.', // 5 Sat
        'Klidný den, pomalý a lehký. Můžete prostě jen být.', // 6 Sun
      ],
    },
    'cheerful': {
      'rest_day': [
        'Den odpočinku! Začít týden zlehka je skvělý nápad.', // 0 Mon
        'Den odpočinku! Dejte si nohy nahoru a užijte si to. I odpočinek patří k cestě.', // 1 Tue
        'Hurá, den odpočinku! Vaše série pokračuje dál.', // 2 Wed
        'Útulný den odpočinku! Berte to tak zlehka, jak chcete, všechno je v pořádku.', // 3 Thu
        'Den odpočinku! Vaše dobré dny jsou v bezpečí, tak si užijte přestávku.', // 4 Fri
        'Dnes si vydechnete? Krásné. Odpočinek je dobrá věc.', // 5 Sat
        'Pohodový den odpočinku! Zachumlejte se a užijte si každou minutu.', // 6 Sun
      ],
    },
  },
  'pl': {
    'calm': {
      'rest_day': [
        'Dzień odpoczynku na początek tygodnia. Co za życzliwy sposób, by zacząć.', // 0 Mon
        'Dzień odpoczynku. Odpoczynek też jest częścią chodzenia, a dziś jest w sam raz.', // 1 Tue
        'Spokojny dzień na odpoczynek. Twoje dobre dni wciąż są z tobą.', // 2 Wed
        'Dni odpoczynku są ważne. Pozwól sobie cieszyć się ciszą.', // 3 Thu
        'Dzisiejszy dzień jest na odpoczynek, i to życzliwy wybór. Jutro na ciebie poczeka.', // 4 Fri
        'Łagodna przerwa. Odpoczynek to nie poddawanie się, to troska o siebie.', // 5 Sat
        'Spokojny dzień, powolny i lekki. Możesz po prostu być.', // 6 Sun
      ],
    },
    'cheerful': {
      'rest_day': [
        'Dzień odpoczynku! Zacząć tydzień łagodnie to świetny pomysł.', // 0 Mon
        'Dzień odpoczynku! Połóż nogi wyżej i ciesz się tym. Odpoczynek też jest częścią drogi.', // 1 Tue
        'Hura, dzień odpoczynku! Twoja seria trwa dalej.', // 2 Wed
        'Przytulny dzień odpoczynku! Tyle luzu, ile chcesz, wszystko jest w porządku.', // 3 Thu
        'Dzień odpoczynku! Twoje dobre dni są bezpieczne, więc ciesz się przerwą.', // 4 Fri
        'Dziś chwila oddechu? Pięknie. Odpoczynek to dobra rzecz.', // 5 Sat
        'Spokojny dzień odpoczynku! Otul się kocem i ciesz się każdą minutą.', // 6 Sun
      ],
    },
  },
  'de': {
    'calm': {
      'rest_day': [
        'Ein Ruhetag zum Wochenbeginn. Was für ein freundlicher Anfang.', // 0 Mon
        'Ein Ruhetag. Auch Ruhe gehört zum Gehen, und heute ist sie genau richtig.', // 1 Tue
        'Ein stiller Tag zum Ausruhen. Deine guten Tage sind immer noch bei dir.', // 2 Wed
        'Ruhetage sind wichtig. Gönn dir die Stille.', // 3 Thu
        'Heute ist zum Ausruhen da, und das ist eine freundliche Wahl. Morgen wartet, bis du bereit bist.', // 4 Fri
        'Eine sanfte Pause. Ausruhen ist kein Aufgeben, es ist Fürsorge für dich.', // 5 Sat
        'Ein ruhiger Tag, langsam und leicht. Du darfst einfach sein.', // 6 Sun
      ],
    },
    'cheerful': {
      'rest_day': [
        'Ruhetag! Die Woche sanft zu beginnen, ist eine tolle Idee.', // 0 Mon
        'Ruhetag! Leg die Füße hoch und genieß es. Ruhe gehört zum Weg dazu.', // 1 Tue
        'Hurra, Ruhetag! Deine Serie läuft weiter.', // 2 Wed
        'Ein gemütlicher Ruhetag! Mach es dir so leicht, wie du magst, alles ist gut.', // 3 Thu
        'Ruhetag! Deine guten Tage sind sicher, also genieß die Pause.', // 4 Fri
        'Heute mal durchatmen? Schön. Ausruhen ist etwas Gutes.', // 5 Sat
        'Entspannter Ruhetag! Kuschel dich ein und genieß jede Minute.', // 6 Sun
      ],
    },
  },
  'es': {
    'calm': {
      'rest_day': [
        'Un día de descanso para empezar la semana. Qué forma tan amable de comenzar.', // 0 Mon
        'Un día de descanso. Descansar también es parte de caminar, y hoy es justo lo que toca.', // 1 Tue
        'Un día tranquilo para descansar. Tus días buenos siguen aquí contigo.', // 2 Wed
        'Los días de descanso importan. Disfruta de la calma.', // 3 Thu
        'Hoy es para descansar, y es una elección amable. Mañana te esperará cuando quieras.', // 4 Fri
        'Una pausa suave. Descansar no es rendirse, es cuidarte.', // 5 Sat
        'Un día de reposo, lento y tranquilo. Puedes simplemente estar.', // 6 Sun
      ],
    },
    'cheerful': {
      'rest_day': [
        '¡Día de descanso! Empezar la semana con calma es una gran idea.', // 0 Mon
        '¡Día de descanso! Sube los pies y disfrútalo. Descansar es parte del camino.', // 1 Tue
        '¡Viva los días de descanso! Tu racha sigue tan fuerte como siempre.', // 2 Wed
        '¡Un día de descanso acogedor! Tómatelo con toda la calma que quieras, todo está bien.', // 3 Thu
        '¡Día de descanso! Tus días buenos están a salvo, así que disfruta la pausa.', // 4 Fri
        '¿Hoy toca respirar un poco? Qué bien. Descansar es algo bueno.', // 5 Sat
        '¡Día de descanso tranquilo! Arrópate y disfruta cada minuto.', // 6 Sun
      ],
    },
  },
  'fr': {
    'calm': {
      'rest_day': [
        'Un jour de repos pour commencer la semaine. Quelle douce façon de démarrer.', // 0 Mon
        "Un jour de repos. Se reposer fait aussi partie de la marche, et c'est exactement ce qu'il faut aujourd'hui.", // 1 Tue
        'Un jour calme pour se reposer. Vos bons jours sont toujours là.', // 2 Wed
        'Les jours de repos comptent. Profitez du calme.', // 3 Thu
        "Aujourd'hui, c'est repos, et c'est un choix bienveillant. Demain attendra.", // 4 Fri
        "Une pause douce. Se reposer, ce n'est pas abandonner, c'est prendre soin de soi.", // 5 Sat
        'Un jour de repos, lent et paisible. Vous pouvez simplement être là.', // 6 Sun
      ],
    },
    'cheerful': {
      'rest_day': [
        "Jour de repos ! Commencer la semaine en douceur, c'est une super idée.", // 0 Mon
        "Jour de repos ! Les pieds en l'air, et profitez. Le repos fait partie du chemin.", // 1 Tue
        'Vive les jours de repos ! Votre série est toujours aussi solide.', // 2 Wed
        'Un jour de repos douillet ! Prenez tout votre temps, tout va bien.', // 3 Thu
        'Jour de repos ! Vos bons jours sont bien gardés, alors profitez de la pause.', // 4 Fri
        "Une petite pause pour souffler aujourd'hui ? Très bien. Le repos, c'est du bon.", // 5 Sat
        'Jour de repos tranquille ! Installez-vous confortablement et savourez chaque minute.', // 6 Sun
      ],
    },
  },
  'it': {
    'calm': {
      'rest_day': [
        'Un giorno di riposo per iniziare la settimana. Che modo gentile di cominciare.', // 0 Mon
        'Un giorno di riposo. Anche riposare fa parte del camminare, ed è proprio quello che serve oggi.', // 1 Tue
        'Un giorno tranquillo per riposare. I tuoi giorni buoni sono ancora qui con te.', // 2 Wed
        'I giorni di riposo contano. Goditi la calma.', // 3 Thu
        'Oggi è per riposare, ed è una scelta gentile. Domani ti aspetterà quando vuoi.', // 4 Fri
        'Una pausa dolce. Riposare non è arrendersi, è prendersi cura di sé.', // 5 Sat
        'Un giorno di riposo, lento e tranquillo. Puoi semplicemente esserci.', // 6 Sun
      ],
    },
    'cheerful': {
      'rest_day': [
        "Giorno di riposo! Iniziare la settimana con calma è un'ottima idea.", // 0 Mon
        'Giorno di riposo! Piedi in alto, e goditelo. Il riposo fa parte del cammino.', // 1 Tue
        'Evviva i giorni di riposo! La tua serie è forte come sempre.', // 2 Wed
        'Un giorno di riposo accogliente! Prenditela comoda quanto vuoi, va tutto bene.', // 3 Thu
        'Giorno di riposo! I tuoi giorni buoni sono al sicuro, quindi goditi la pausa.', // 4 Fri
        "Oggi si tira un po' il fiato? Benissimo. Riposare fa bene.", // 5 Sat
        'Giorno di riposo tranquillo! Mettiti a tuo agio e goditi ogni minuto.', // 6 Sun
      ],
    },
  },
};

const _freshStart = {
  'en': 'A fresh start today, and that is a lovely place to begin.',
  'sk': 'Dnes je nový začiatok, a to je krásna chvíľa začať.',
  'cs': 'Dnes je nový začátek, a to je krásná chvíle začít.',
  'pl': 'Dziś nowy początek, a to piękna chwila, by zacząć.',
  'de': 'Heute ein neuer Anfang, und das ist ein schöner Moment zum Beginnen.',
  'es': 'Hoy es un nuevo comienzo, y es un momento precioso para empezar.',
  'fr': "Aujourd'hui est un nouveau départ, et c'est un beau moment pour commencer.",
  'it': 'Oggi è un nuovo inizio, ed è un bel momento per cominciare.',
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

  /// Unit word only, so a big number can stand on its own ("steps" / "krokov").
  static String stepsWord(String language, int n) {
    final lang = _lang(language);
    final forms = _steps[lang] ?? _steps['en']!;
    final key = _plural(lang, n);
    final template = forms[key] ?? forms['other'] ?? _steps['en']!['other']!;
    return template.replaceAll('{n}', '').trim();
  }

  static String restDay(String language) =>
      _restDay[_lang(language)] ?? _restDay['en']!;

  /// Kind rest-day line for [day], picked by weekday.
  static String restDayLine(String language, String style, DateTime day) {
    final byLang = restDayLines[_lang(language)] ?? restDayLines['en']!;
    final lines = (byLang[style] ?? byLang['calm']!)['rest_day']!;
    return lines[weekdayIndex(day, lines.length)];
  }

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
