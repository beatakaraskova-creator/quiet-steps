/// Home card greetings shown before the first milestone of the day.
/// greetingLines[lang][style][key] -> 7 lines, index 0 = Monday ... 6 = Sunday.
/// key: 'greeting_morning' | 'greeting_afternoon' | 'greeting_evening'.
/// Not part of milestoneLines, so they are not in the spoken catalog (no voice clips).
/// Unknown language falls back to English.
library;

import 'day_pick.dart';

const greetingKeys = ['greeting_morning', 'greeting_afternoon', 'greeting_evening'];

const greetingLines = <String, Map<String, Map<String, List<String>>>>{
  'en': {
    'calm': {
      'greeting_morning': [
        'Good morning. A new week begins, and you can meet it gently.', // 0 Mon
        "Good morning. Take today at your own pace. There's no rush at all.", // 1 Tue
        'Good morning. A new day, and you get to begin it gently.', // 2 Wed
        "Good morning. However you're feeling, today can start softly.", // 3 Thu
        "Good morning. A few slow steps whenever you're ready. The day will wait.", // 4 Fri
        "Good morning. It's nice to have you here. Let's take it easy today.", // 5 Sat
        'Good morning. A slow, easy start today. Nothing to hurry for.', // 6 Sun
      ],
      'greeting_afternoon': [
        'Good afternoon. The week is just getting going. Take it one step at a time.', // 0 Mon
        'Good afternoon. Whatever the morning held, the rest of the day can be gentle.', // 1 Tue
        "Good afternoon. A short, slow walk is always here if you'd like one.", // 2 Wed
        "Good afternoon. There's still plenty of day left, and no hurry at all.", // 3 Thu
        'Good afternoon. Even a few steps can be a lovely little pause.', // 4 Fri
        "Good afternoon. It's never too late in the day to begin.", // 5 Sat
        'Good afternoon. A lazy, unhurried afternoon is a lovely thing.', // 6 Sun
      ],
      'greeting_evening': [
        "Good evening. The week has begun, and you've done just fine. Be gentle tonight.", // 0 Mon
        "Good evening. However today went, you're here now, and that's enough.", // 1 Tue
        'Good evening. A slow evening stroll, or simply rest. Both are good choices.', // 2 Wed
        "Good evening. Let the day soften. There's nothing you need to catch up on.", // 3 Thu
        'Good evening. A few quiet steps, or none at all. Tomorrow is a fresh start.', // 4 Fri
        'Good evening. Be gentle with yourself tonight.', // 5 Sat
        'Good evening. Let tonight be slow and cosy, with nothing left to do.', // 6 Sun
      ],
    },
    'cheerful': {
      'greeting_morning': [
        'Good morning! A brand new week, full of gentle possibilities.', // 0 Mon
        'Good morning! A fresh new day, all yours.', // 1 Tue
        'Morning! Ready for a gentle stroll whenever you are.', // 2 Wed
        "Good morning! Here's to a lovely, easy day.", // 3 Thu
        'Rise and shine! Your first steps can be small ones.', // 4 Fri
        "Good morning! So nice to see you. Let's make today a kind one.", // 5 Sat
        'Good morning! A lazy, lovely day ahead. Take it easy.', // 6 Sun
      ],
      'greeting_afternoon': [
        "Good afternoon! The new week's off to a good start. Fancy a little stroll?", // 0 Mon
        'Good afternoon! A perfect time for a little wander.', // 1 Tue
        'Hello there! How about a few easy steps this afternoon?', // 2 Wed
        'Good afternoon! The day still has plenty of lovely moments left.', // 3 Thu
        "Afternoon! Even a tiny walk counts. You've got this.", // 4 Fri
        "Good afternoon! So glad you stopped by. Let's go gently.", // 5 Sat
        'Good afternoon! Perfect for a slow, easy wander, or a nice long rest.', // 6 Sun
      ],
      'greeting_evening': [
        "Good evening! The new week's begun, and you're doing just fine.", // 0 Mon
        'Good evening! Fancy a gentle little stroll, or a cosy rest instead?', // 1 Tue
        'Evening! Whatever today held, you made it here. Lovely.', // 2 Wed
        'Good evening! A few easy steps or a comfy sofa. Both sound great.', // 3 Thu
        "Hello, evening! It's a lovely time for a slow wander, if you like.", // 4 Fri
        'Good evening! Tomorrow is a brand new day, and today was enough.', // 5 Sat
        'Good evening! A cosy evening sounds perfect. Enjoy every slow minute.', // 6 Sun
      ],
    },
  },
  'sk': {
    'calm': {
      'greeting_morning': [
        'Dobré ráno. Začína nový týždeň a môžete ho privítať zľahka.', // 0 Mon
        'Dobré ráno. Dnešok môže plynúť vaším tempom. Nikam sa netreba ponáhľať.', // 1 Tue
        'Dobré ráno. Nový deň, a môžete ho začať jemne.', // 2 Wed
        'Dobré ráno. Nech sa cítite akokoľvek, dnešok môže začať pokojne.', // 3 Thu
        'Dobré ráno. Pár pomalých krokov, keď budete pripravení. Deň počká.', // 4 Fri
        'Dobré ráno. Je milé, že ste tu. Dnes to vezmeme zľahka.', // 5 Sat
        'Dobré ráno. Pomalý, pokojný začiatok dňa. Niet sa kam ponáhľať.', // 6 Sun
      ],
      'greeting_afternoon': [
        'Dobré popoludnie. Týždeň sa len rozbieha. Krok za krokom.', // 0 Mon
        'Dobré popoludnie. Nech prinieslo dopoludnie čokoľvek, zvyšok dňa môže byť jemný.', // 1 Tue
        'Dobré popoludnie. Krátka, pomalá prechádzka tu na vás vždy počká, ak budete chcieť.', // 2 Wed
        'Dobré popoludnie. Z dňa ostáva ešte veľa a vôbec sa netreba ponáhľať.', // 3 Thu
        'Dobré popoludnie. Aj pár krokov môže byť krásnou malou prestávkou.', // 4 Fri
        'Dobré popoludnie. Na začiatok nie je nikdy neskoro.', // 5 Sat
        'Dobré popoludnie. Pohodové popoludnie bez náhlenia je krásna vec.', // 6 Sun
      ],
      'greeting_evening': [
        'Dobrý večer. Týždeň sa začal a zvládate to dobre. Večer si doprajte pokoj.', // 0 Mon
        'Dobrý večer. Nech bol dnešok akýkoľvek, teraz ste tu, a to stačí.', // 1 Tue
        'Dobrý večer. Pomalá večerná prechádzka alebo len oddych. Obe sú dobrá voľba.', // 2 Wed
        'Dobrý večer. Nechajte deň zmäknúť. Nič nemusíte dobiehať.', // 3 Thu
        'Dobrý večer. Pár tichých krokov, alebo žiadne. Zajtra je nový začiatok.', // 4 Fri
        'Dobrý večer. Buďte dnes večer k sebe jemní.', // 5 Sat
        'Dobrý večer. Nech je dnešný večer pomalý a útulný, bez akýchkoľvek povinností.', // 6 Sun
      ],
    },
    'cheerful': {
      'greeting_morning': [
        'Dobré ráno! Úplne nový týždeň, plný milých možností.', // 0 Mon
        'Dobré ráno! Svieži nový deň, celý len pre vás.', // 1 Tue
        'Dobré ráno! Pokojná prechádzka na vás počká, kedykoľvek budete chcieť.', // 2 Wed
        'Dobré ráno! Nech je dnešok krásny a ľahký.', // 3 Thu
        'Nový deň je tu! Prvé kroky môžu byť pokojne malé.', // 4 Fri
        'Dobré ráno! Je milé vás vidieť. Spravme z dneška láskavý deň.', // 5 Sat
        'Dobré ráno! Pred vami je pohodový, krásny deň. Pekne zľahka.', // 6 Sun
      ],
      'greeting_afternoon': [
        'Dobré popoludnie! Nový týždeň sa rozbehol dobre. Čo tak malá prechádzka?', // 0 Mon
        'Dobré popoludnie! Ideálny čas trochu sa prejsť.', // 1 Tue
        'Dobrý deň! Čo tak pár pohodových krokov toto popoludnie?', // 2 Wed
        'Dobré popoludnie! Deň má pred sebou ešte veľa krásnych chvíľ.', // 3 Thu
        'Popoludnie je tu! Aj krátka prechádzka sa ráta. Zvládnete to.', // 4 Fri
        'Dobré popoludnie! Je milé, že ste sa zastavili. Poďme na to zľahka.', // 5 Sat
        'Dobré popoludnie! Ideálne na pomalú prechádzku, alebo na dlhý, príjemný oddych.', // 6 Sun
      ],
      'greeting_evening': [
        'Dobrý večer! Nový týždeň sa začal a darí sa vám dobre.', // 0 Mon
        'Dobrý večer! Čo tak krátka pokojná prechádzka, alebo radšej útulný oddych?', // 1 Tue
        'Dobrý večer! Nech priniesol dnešok čokoľvek, ste tu. Krásne.', // 2 Wed
        'Dobrý večer! Pár ľahkých krokov alebo pohodlný gauč. Oboje znie skvele.', // 3 Thu
        'Dobrý večer! Krásny čas na pomalú prechádzku, ak máte chuť.', // 4 Fri
        'Dobrý večer! Zajtra je úplne nový deň a dnešok bol dosť.', // 5 Sat
        'Dobrý večer! Útulný večer znie dokonale. Užite si každú pomalú minútu.', // 6 Sun
      ],
    },
  },
  'cs': {
    'calm': {
      'greeting_morning': [
        'Dobré ráno. Začíná nový týden a můžete ho přivítat zlehka.', // 0 Mon
        'Dobré ráno. Dnešek může plynout vaším tempem. Není kam spěchat.', // 1 Tue
        'Dobré ráno. Nový den, a můžete ho začít jemně.', // 2 Wed
        'Dobré ráno. Ať se cítíte jakkoli, dnešek může začít klidně.', // 3 Thu
        'Dobré ráno. Pár pomalých kroků, až budete připraveni. Den počká.', // 4 Fri
        'Dobré ráno. Je milé, že jste tu. Dnes to vezmeme zlehka.', // 5 Sat
        'Dobré ráno. Pomalý, klidný začátek dne. Nikam se nespěchá.', // 6 Sun
      ],
      'greeting_afternoon': [
        'Dobré odpoledne. Týden se teprve rozjíždí. Krok za krokem.', // 0 Mon
        'Dobré odpoledne. Ať přineslo dopoledne cokoli, zbytek dne může být jemný.', // 1 Tue
        'Dobré odpoledne. Krátká, pomalá procházka tu na vás vždycky počká, jestli budete chtít.', // 2 Wed
        'Dobré odpoledne. Ze dne zbývá ještě hodně a vůbec není kam spěchat.', // 3 Thu
        'Dobré odpoledne. I pár kroků může být krásnou malou přestávkou.', // 4 Fri
        'Dobré odpoledne. Na začátek není nikdy pozdě.', // 5 Sat
        'Dobré odpoledne. Pohodové odpoledne bez spěchu je krásná věc.', // 6 Sun
      ],
      'greeting_evening': [
        'Dobrý večer. Týden začal a zvládáte to dobře. Večer si dopřejte klid.', // 0 Mon
        'Dobrý večer. Ať byl dnešek jakýkoli, teď jste tady, a to stačí.', // 1 Tue
        'Dobrý večer. Pomalá večerní procházka, nebo jen odpočinek. Obojí je dobrá volba.', // 2 Wed
        'Dobrý večer. Nechte den zjemnit. Nic nemusíte dohánět.', // 3 Thu
        'Dobrý večer. Pár tichých kroků, nebo žádné. Zítra je nový začátek.', // 4 Fri
        'Dobrý večer. Buďte dnes večer k sobě jemní.', // 5 Sat
        'Dobrý večer. Ať je dnešní večer pomalý a útulný, bez jakýchkoli povinností.', // 6 Sun
      ],
    },
    'cheerful': {
      'greeting_morning': [
        'Dobré ráno! Úplně nový týden, plný milých možností.', // 0 Mon
        'Dobré ráno! Svěží nový den, celý jen pro vás.', // 1 Tue
        'Dobré ráno! Klidná procházka na vás počká, kdykoli budete chtít.', // 2 Wed
        'Dobré ráno! Ať je dnešek krásný a lehký.', // 3 Thu
        'Nový den je tady! První kroky můžou být klidně malé.', // 4 Fri
        'Dobré ráno! Je milé vás vidět. Udělejme z dneška laskavý den.', // 5 Sat
        'Dobré ráno! Před vámi je pohodový, krásný den. Pěkně zlehka.', // 6 Sun
      ],
      'greeting_afternoon': [
        'Dobré odpoledne! Nový týden se rozjel dobře. Co takhle malá procházka?', // 0 Mon
        'Dobré odpoledne! Ideální čas trochu se projít.', // 1 Tue
        'Dobrý den! Co takhle pár pohodových kroků tohle odpoledne?', // 2 Wed
        'Dobré odpoledne! Den má před sebou ještě spoustu krásných chvil.', // 3 Thu
        'Odpoledne je tu! I krátká procházka se počítá. Zvládnete to.', // 4 Fri
        'Dobré odpoledne! Je milé, že jste se zastavili. Pojďme na to zlehka.', // 5 Sat
        'Dobré odpoledne! Ideální na pomalou procházku, nebo na dlouhý, příjemný odpočinek.', // 6 Sun
      ],
      'greeting_evening': [
        'Dobrý večer! Nový týden začal a daří se vám dobře.', // 0 Mon
        'Dobrý večer! Co takhle krátká klidná procházka, nebo radši útulný odpočinek?', // 1 Tue
        'Dobrý večer! Ať přinesl dnešek cokoli, jste tady. Krásné.', // 2 Wed
        'Dobrý večer! Pár lehkých kroků, nebo pohodlný gauč. Obojí zní skvěle.', // 3 Thu
        'Dobrý večer! Krásný čas na pomalou procházku, jestli máte chuť.', // 4 Fri
        'Dobrý večer! Zítra je úplně nový den a dnešek stačil.', // 5 Sat
        'Dobrý večer! Útulný večer zní dokonale. Užijte si každou pomalou minutu.', // 6 Sun
      ],
    },
  },
  'pl': {
    'calm': {
      'greeting_morning': [
        'Dzień dobry. Zaczyna się nowy tydzień i możesz go przywitać łagodnie.', // 0 Mon
        'Dzień dobry. Niech dzisiejszy dzień płynie w twoim tempie. Nie ma pośpiechu.', // 1 Tue
        'Dzień dobry. Nowy dzień, który możesz zacząć łagodnie.', // 2 Wed
        'Dzień dobry. Jakkolwiek się czujesz, dzień może zacząć się spokojnie.', // 3 Thu
        'Dzień dobry. Kilka powolnych kroków, kiedy zechcesz. Dzień poczeka.', // 4 Fri
        'Dzień dobry. Miło, że jesteś. Dziś na spokojnie.', // 5 Sat
        'Dzień dobry. Powolny, spokojny początek dnia. Nie ma się do czego spieszyć.', // 6 Sun
      ],
      'greeting_afternoon': [
        'Miłego popołudnia. Tydzień dopiero się rozkręca. Krok po kroku.', // 0 Mon
        'Miłego popołudnia. Cokolwiek przyniósł poranek, reszta dnia może być łagodna.', // 1 Tue
        'Miłego popołudnia. Krótki, powolny spacer zawsze tu na ciebie czeka, jeśli zechcesz.', // 2 Wed
        'Miłego popołudnia. Zostało jeszcze sporo dnia i zupełnie nie ma pośpiechu.', // 3 Thu
        'Miłego popołudnia. Nawet kilka kroków może być piękną małą przerwą.', // 4 Fri
        'Miłego popołudnia. Nigdy nie jest za późno, żeby zacząć.', // 5 Sat
        'Miłego popołudnia. Spokojne popołudnie bez pośpiechu to piękna rzecz.', // 6 Sun
      ],
      'greeting_evening': [
        'Dobry wieczór. Tydzień się zaczął i świetnie sobie radzisz. Wieczorem pozwól sobie na spokój.', // 0 Mon
        'Dobry wieczór. Jakikolwiek był dzisiejszy dzień, jesteś tutaj, i to wystarczy.', // 1 Tue
        'Dobry wieczór. Powolny wieczorny spacer albo po prostu odpoczynek. Jedno i drugie jest dobre.', // 2 Wed
        'Dobry wieczór. Pozwól, by dzień złagodniał. Nie musisz niczego nadrabiać.', // 3 Thu
        'Dobry wieczór. Kilka cichych kroków albo żadnego. Jutro nowy początek.', // 4 Fri
        'Dobry wieczór. Potraktuj się dziś wieczorem łagodnie.', // 5 Sat
        'Dobry wieczór. Niech ten wieczór będzie powolny i przytulny, bez żadnych obowiązków.', // 6 Sun
      ],
    },
    'cheerful': {
      'greeting_morning': [
        'Dzień dobry! Zupełnie nowy tydzień, pełen miłych możliwości.', // 0 Mon
        'Dzień dobry! Świeży nowy dzień, cały dla ciebie.', // 1 Tue
        'Hej, dzień dobry! Spokojny spacer czeka, kiedy tylko zechcesz.', // 2 Wed
        'Dzień dobry! Niech dzisiaj będzie pięknie i lekko.', // 3 Thu
        'Pobudka, nowy dzień! Pierwsze kroki mogą być malutkie.', // 4 Fri
        'Dzień dobry! Miło cię widzieć. Niech dzisiejszy dzień będzie życzliwy.', // 5 Sat
        'Dzień dobry! Przed tobą spokojny, piękny dzień. Na luzie.', // 6 Sun
      ],
      'greeting_afternoon': [
        'Miłego popołudnia! Nowy tydzień dobrze się zaczął. Może mały spacer?', // 0 Mon
        'Miłego popołudnia! Idealna pora na krótką przechadzkę.', // 1 Tue
        'Cześć! Może kilka luźnych kroków tego popołudnia?', // 2 Wed
        'Miłego popołudnia! Przed tobą jeszcze mnóstwo pięknych chwil.', // 3 Thu
        'Popołudnie! Nawet krótki spacer się liczy. Dasz radę.', // 4 Fri
        'Miłego popołudnia! Miło, że zaglądasz. Chodźmy spokojnie.', // 5 Sat
        'Miłego popołudnia! Idealnie na powolny spacer albo długi, przyjemny odpoczynek.', // 6 Sun
      ],
      'greeting_evening': [
        'Dobry wieczór! Nowy tydzień się zaczął i świetnie ci idzie.', // 0 Mon
        'Dobry wieczór! Może krótki, spokojny spacer, a może raczej przytulny odpoczynek?', // 1 Tue
        'Dobry wieczór! Cokolwiek przyniósł dzisiejszy dzień, jesteś tutaj. Pięknie.', // 2 Wed
        'Dobry wieczór! Kilka lekkich kroków albo wygodna kanapa. Oba plany brzmią świetnie.', // 3 Thu
        'Dobry wieczór! Piękna pora na powolny spacer, jeśli masz ochotę.', // 4 Fri
        'Dobry wieczór! Jutro zupełnie nowy dzień, a dzisiejszy wystarczył.', // 5 Sat
        'Dobry wieczór! Przytulny wieczór brzmi idealnie. Ciesz się każdą spokojną minutą.', // 6 Sun
      ],
    },
  },
  'de': {
    'calm': {
      'greeting_morning': [
        'Guten Morgen. Eine neue Woche beginnt, und du kannst ihr sanft begegnen.', // 0 Mon
        'Guten Morgen. Nimm den Tag in deinem eigenen Tempo. Es gibt keine Eile.', // 1 Tue
        'Guten Morgen. Ein neuer Tag, und du darfst ihn sanft beginnen.', // 2 Wed
        'Guten Morgen. Wie es dir auch geht, der Tag darf leise anfangen.', // 3 Thu
        'Guten Morgen. Ein paar langsame Schritte, wann immer du bereit bist. Der Tag wartet.', // 4 Fri
        'Guten Morgen. Schön, dass du da bist. Lass es uns heute ruhig angehen.', // 5 Sat
        'Guten Morgen. Ein langsamer, entspannter Start heute. Nichts drängt.', // 6 Sun
      ],
      'greeting_afternoon': [
        'Schönen Nachmittag. Die Woche kommt gerade erst in Gang. Nimm es Schritt für Schritt.', // 0 Mon
        'Schönen Nachmittag. Was der Vormittag auch gebracht hat, der Rest des Tages darf sanft sein.', // 1 Tue
        'Schönen Nachmittag. Ein kurzer, langsamer Spaziergang ist immer da, wenn du magst.', // 2 Wed
        'Schönen Nachmittag. Es ist noch viel Tag übrig, und keine Eile.', // 3 Thu
        'Schönen Nachmittag. Schon ein paar Schritte können eine schöne kleine Pause sein.', // 4 Fri
        'Schönen Nachmittag. Es ist nie zu spät am Tag, um anzufangen.', // 5 Sat
        'Schönen Nachmittag. Ein gemütlicher Nachmittag ohne Eile ist etwas Schönes.', // 6 Sun
      ],
      'greeting_evening': [
        'Guten Abend. Die Woche hat begonnen, und du machst das gut. Gönn dir heute Abend Ruhe.', // 0 Mon
        'Guten Abend. Wie der Tag auch war, jetzt bist du hier, und das ist genug.', // 1 Tue
        'Guten Abend. Ein langsamer Abendspaziergang, oder einfach Ruhe. Beides ist gut.', // 2 Wed
        'Guten Abend. Lass den Tag weich werden. Du musst nichts nachholen.', // 3 Thu
        'Guten Abend. Ein paar stille Schritte, oder gar keine. Morgen ist ein neuer Anfang.', // 4 Fri
        'Guten Abend. Sei heute Abend sanft zu dir.', // 5 Sat
        'Guten Abend. Lass den Abend langsam und gemütlich sein, ohne jede Pflicht.', // 6 Sun
      ],
    },
    'cheerful': {
      'greeting_morning': [
        'Guten Morgen! Eine ganz neue Woche, voller sanfter Möglichkeiten.', // 0 Mon
        'Guten Morgen! Ein frischer neuer Tag, ganz für dich.', // 1 Tue
        'Morgen! Ein gemütlicher Spaziergang wartet, wann immer du magst.', // 2 Wed
        'Guten Morgen! Auf einen schönen, leichten Tag.', // 3 Thu
        'Ein neuer Tag ist da! Deine ersten Schritte dürfen klein sein.', // 4 Fri
        'Guten Morgen! Schön, dich zu sehen. Lass uns heute einen freundlichen Tag draus machen.', // 5 Sat
        'Guten Morgen! Ein entspannter, schöner Tag liegt vor dir. Ganz gemütlich.', // 6 Sun
      ],
      'greeting_afternoon': [
        'Schönen Nachmittag! Die neue Woche hat gut angefangen. Lust auf einen kleinen Spaziergang?', // 0 Mon
        'Schönen Nachmittag! Die perfekte Zeit für eine kleine Runde.', // 1 Tue
        'Hallo du! Wie wäre es mit ein paar lockeren Schritten heute Nachmittag?', // 2 Wed
        'Schönen Nachmittag! Der Tag hat noch viele schöne Momente übrig.', // 3 Thu
        'Nachmittag! Auch ein kurzer Spaziergang zählt. Du schaffst das.', // 4 Fri
        'Schönen Nachmittag! Schön, dass du vorbeischaust. Lass es uns sanft angehen.', // 5 Sat
        'Schönen Nachmittag! Perfekt für ein langsames Schlendern, oder eine lange, schöne Pause.', // 6 Sun
      ],
      'greeting_evening': [
        'Guten Abend! Die neue Woche hat begonnen, und du machst das prima.', // 0 Mon
        'Guten Abend! Lust auf einen kleinen, sanften Spaziergang, oder lieber eine gemütliche Pause?', // 1 Tue
        'Abend! Was der Tag auch gebracht hat, du bist hier. Schön.', // 2 Wed
        'Guten Abend! Ein paar lockere Schritte oder ein bequemes Sofa. Beides klingt toll.', // 3 Thu
        'Hallo, Abend! Eine schöne Zeit für ein langsames Schlendern, wenn du magst.', // 4 Fri
        'Guten Abend! Morgen ist ein ganz neuer Tag, und heute war genug.', // 5 Sat
        'Guten Abend! Ein gemütlicher Abend klingt perfekt. Genieß jede ruhige Minute.', // 6 Sun
      ],
    },
  },
  'es': {
    'calm': {
      'greeting_morning': [
        'Buenos días. Empieza una semana nueva, y puedes recibirla con suavidad.', // 0 Mon
        'Buenos días. Vive el día a tu ritmo. No hay ninguna prisa.', // 1 Tue
        'Buenos días. Un día nuevo, y puedes empezarlo con calma.', // 2 Wed
        'Buenos días. Te sientas como te sientas, el día puede empezar con suavidad.', // 3 Thu
        'Buenos días. Unos pasos lentos cuando te apetezca. El día esperará.', // 4 Fri
        'Buenos días. Qué bien tenerte aquí. Hoy, con calma.', // 5 Sat
        'Buenos días. Un comienzo lento y tranquilo. No hay nada por lo que correr.', // 6 Sun
      ],
      'greeting_afternoon': [
        'Buenas tardes. La semana apenas arranca. Paso a paso.', // 0 Mon
        'Buenas tardes. Haya traído lo que haya traído la mañana, el resto del día puede ser suave.', // 1 Tue
        'Buenas tardes. Un paseo corto y lento siempre está aquí, si te apetece.', // 2 Wed
        'Buenas tardes. Aún queda mucho día, y ninguna prisa.', // 3 Thu
        'Buenas tardes. Incluso unos pocos pasos pueden ser una pequeña pausa preciosa.', // 4 Fri
        'Buenas tardes. Nunca es tarde para empezar.', // 5 Sat
        'Buenas tardes. Una tarde tranquila y sin prisas es algo precioso.', // 6 Sun
      ],
      'greeting_evening': [
        'Buenas noches. La semana ya empezó, y lo estás haciendo bien. Esta noche, date calma.', // 0 Mon
        'Buenas noches. Haya ido como haya ido el día, ahora estás aquí, y eso basta.', // 1 Tue
        'Buenas noches. Un paseo lento al anochecer, o simplemente descansar. Las dos cosas están bien.', // 2 Wed
        'Buenas noches. Deja que el día se suavice. No tienes nada que recuperar.', // 3 Thu
        'Buenas noches. Unos pasos tranquilos, o ninguno. Mañana es un nuevo comienzo.', // 4 Fri
        'Buenas noches. Trátate con cariño esta noche.', // 5 Sat
        'Buenas noches. Que esta noche sea lenta y acogedora, sin nada pendiente.', // 6 Sun
      ],
    },
    'cheerful': {
      'greeting_morning': [
        '¡Buenos días! Una semana nueva, llena de posibilidades bonitas.', // 0 Mon
        '¡Buenos días! Un día nuevo y fresco, todo para ti.', // 1 Tue
        '¡Buen día! Un paseo tranquilo te espera cuando quieras.', // 2 Wed
        '¡Buenos días! Por un día bonito y ligero.', // 3 Thu
        '¡Arriba, que ya es de día! Tus primeros pasos pueden ser pequeñitos.', // 4 Fri
        '¡Buenos días! Qué alegría verte. Hagamos de hoy un día amable.', // 5 Sat
        '¡Buenos días! Te espera un día tranquilo y bonito. Con calma.', // 6 Sun
      ],
      'greeting_afternoon': [
        '¡Buenas tardes! La semana nueva va bien. ¿Te apetece un paseíto?', // 0 Mon
        '¡Buenas tardes! Un momento perfecto para dar una vuelta.', // 1 Tue
        '¡Hola! ¿Qué tal unos pasos tranquilos esta tarde?', // 2 Wed
        '¡Buenas tardes! Al día aún le quedan muchos momentos bonitos.', // 3 Thu
        '¡Buenas tardes! Hasta un paseo cortito cuenta. Tú puedes.', // 4 Fri
        '¡Buenas tardes! Qué bien que pases por aquí. Vamos con calma.', // 5 Sat
        '¡Buenas tardes! Perfecta para un paseo lento, o para un descanso largo y agradable.', // 6 Sun
      ],
      'greeting_evening': [
        '¡Buenas noches! La semana nueva ya empezó, y lo llevas muy bien.', // 0 Mon
        '¡Buenas noches! ¿Un paseíto tranquilo, o mejor un descanso acogedor?', // 1 Tue
        '¡Buenas noches! Haya traído lo que haya traído el día, aquí estás. Qué bien.', // 2 Wed
        '¡Buenas noches! Unos pasos suaves o un sofá cómodo. Las dos cosas suenan genial.', // 3 Thu
        '¡Hola, noche! Es un momento precioso para un paseo lento, si te apetece.', // 4 Fri
        '¡Buenas noches! Mañana es un día totalmente nuevo, y hoy fue suficiente.', // 5 Sat
        '¡Buenas noches! Una noche acogedora suena perfecta. Disfruta cada minuto tranquilo.', // 6 Sun
      ],
    },
  },
  'fr': {
    'calm': {
      'greeting_morning': [
        "Bonjour. Une nouvelle semaine commence, et vous pouvez l'accueillir en douceur.", // 0 Mon
        'Bonjour. Vivez la journée à votre rythme. Rien ne presse.', // 1 Tue
        'Bonjour. Une nouvelle journée, et vous pouvez la commencer calmement.', // 2 Wed
        'Bonjour. Quelle que soit votre humeur, la journée peut commencer en douceur.', // 3 Thu
        'Bonjour. Quelques pas lents quand vous en aurez envie. La journée attendra.', // 4 Fri
        "Bonjour. C'est bon de vous voir. Aujourd'hui, doucement.", // 5 Sat
        'Bonjour. Un début lent et paisible. Rien ne presse.', // 6 Sun
      ],
      'greeting_afternoon': [
        "Bon après-midi. La semaine ne fait que commencer. Un pas après l'autre.", // 0 Mon
        "Bon après-midi. Quoi qu'ait apporté la matinée, la suite peut être douce.", // 1 Tue
        "Bon après-midi. Une petite marche lente est toujours là, si l'envie vous prend.", // 2 Wed
        'Bon après-midi. Il reste beaucoup de journée, et rien ne presse.', // 3 Thu
        'Bon après-midi. Même quelques pas peuvent être une jolie petite pause.', // 4 Fri
        "Bon après-midi. Il n'est jamais trop tard pour commencer.", // 5 Sat
        "Bon après-midi. Un après-midi calme et sans hâte, c'est précieux.", // 6 Sun
      ],
      'greeting_evening': [
        'Bonsoir. La semaine est lancée, et tout va bien. Ce soir, accordez-vous du calme.', // 0 Mon
        "Bonsoir. Quelle qu'ait été la journée, vous êtes là maintenant, et cela suffit.", // 1 Tue
        'Bonsoir. Une marche lente au crépuscule, ou simplement du repos. Les deux sont bien.', // 2 Wed
        "Bonsoir. Laissez la journée s'adoucir. Il n'y a rien à rattraper.", // 3 Thu
        'Bonsoir. Quelques pas tranquilles, ou aucun. Demain est un nouveau départ.', // 4 Fri
        'Bonsoir. Accordez-vous de la douceur ce soir.', // 5 Sat
        'Bonsoir. Que ce soir soit lent et douillet, sans rien à faire.', // 6 Sun
      ],
    },
    'cheerful': {
      'greeting_morning': [
        'Bonjour ! Une nouvelle semaine, pleine de jolies possibilités.', // 0 Mon
        'Bonjour ! Une journée toute neuve, rien que pour vous.', // 1 Tue
        'Bonjour ! Une marche tranquille vous attend quand vous voulez.', // 2 Wed
        'Bonjour ! À une journée belle et légère.', // 3 Thu
        'Debout, le jour est levé ! Vos premiers pas peuvent être tout petits.', // 4 Fri
        'Bonjour ! Quel plaisir de vous voir. Faisons de cette journée une journée douce.', // 5 Sat
        'Bonjour ! Une journée paisible et belle vous attend. Tout doucement.', // 6 Sun
      ],
      'greeting_afternoon': [
        'Bon après-midi ! La nouvelle semaine se passe bien. Une petite balade vous tente ?', // 0 Mon
        'Bon après-midi ! Un moment parfait pour une petite promenade.', // 1 Tue
        'Coucou ! Et si on faisait quelques pas tranquilles cet après-midi ?', // 2 Wed
        'Bon après-midi ! La journée a encore plein de beaux moments en réserve.', // 3 Thu
        'Bon après-midi ! Même une petite balade compte. Vous pouvez le faire.', // 4 Fri
        'Bon après-midi ! Quel plaisir de vous voir. Allons-y doucement.', // 5 Sat
        'Bon après-midi ! Parfait pour une balade lente, ou un long moment de repos.', // 6 Sun
      ],
      'greeting_evening': [
        'Bonsoir ! La nouvelle semaine est lancée, et tout se passe très bien.', // 0 Mon
        'Bonsoir ! Une petite balade tranquille, ou plutôt un moment douillet ?', // 1 Tue
        "Bonsoir ! Quoi qu'ait apporté la journée, vous voilà. C'est très bien.", // 2 Wed
        'Bonsoir ! Quelques pas doux ou un canapé confortable. Les deux sont tentants.', // 3 Thu
        "Bonsoir, la soirée ! Un joli moment pour une marche lente, si l'envie vous prend.", // 4 Fri
        "Bonsoir ! Demain est une toute nouvelle journée, et aujourd'hui a suffi.", // 5 Sat
        "Bonsoir ! Une soirée douillette, c'est parfait. Savourez chaque minute tranquille.", // 6 Sun
      ],
    },
  },
  'it': {
    'calm': {
      'greeting_morning': [
        'Buongiorno. Inizia una settimana nuova, e puoi accoglierla con dolcezza.', // 0 Mon
        "Buongiorno. Vivi la giornata al tuo ritmo. Non c'è fretta.", // 1 Tue
        'Buongiorno. Un giorno nuovo, e puoi iniziarlo con calma.', // 2 Wed
        'Buongiorno. Comunque ti senta, la giornata può cominciare con dolcezza.', // 3 Thu
        'Buongiorno. Qualche passo lento quando ti va. La giornata aspetterà.', // 4 Fri
        'Buongiorno. È bello vederti. Oggi, con calma.', // 5 Sat
        "Buongiorno. Un inizio lento e tranquillo. Non c'è niente per cui correre.", // 6 Sun
      ],
      'greeting_afternoon': [
        'Buon pomeriggio. La settimana è appena partita. Un passo alla volta.', // 0 Mon
        'Buon pomeriggio. Qualunque cosa abbia portato la mattina, il resto della giornata può essere dolce.', // 1 Tue
        'Buon pomeriggio. Una breve passeggiata lenta è sempre qui, se ti va.', // 2 Wed
        'Buon pomeriggio. Resta ancora tanta giornata, e nessuna fretta.', // 3 Thu
        'Buon pomeriggio. Anche pochi passi possono essere una piccola, bella pausa.', // 4 Fri
        'Buon pomeriggio. Non è mai troppo tardi per iniziare.', // 5 Sat
        'Buon pomeriggio. Un pomeriggio calmo e senza fretta è qualcosa di prezioso.', // 6 Sun
      ],
      'greeting_evening': [
        "Buonasera. La settimana è partita, e va tutto bene. Stasera concediti un po' di calma.", // 0 Mon
        'Buonasera. Comunque sia andata la giornata, adesso sei qui, e basta così.', // 1 Tue
        'Buonasera. Una passeggiata lenta al tramonto, o semplicemente riposo. Vanno bene entrambi.', // 2 Wed
        "Buonasera. Lascia che la giornata si addolcisca. Non c'è niente da recuperare.", // 3 Thu
        'Buonasera. Qualche passo tranquillo, o nessuno. Domani è un nuovo inizio.', // 4 Fri
        'Buonasera. Sii gentile con te stasera.', // 5 Sat
        'Buonasera. Che stasera sia lenta e accogliente, senza niente da fare.', // 6 Sun
      ],
    },
    'cheerful': {
      'greeting_morning': [
        'Buongiorno! Una settimana nuova, piena di belle possibilità.', // 0 Mon
        'Buongiorno! Una giornata nuova e fresca, tutta per te.', // 1 Tue
        'Buongiorno! Una passeggiata tranquilla ti aspetta quando vuoi.', // 2 Wed
        'Buongiorno! A una giornata bella e leggera.', // 3 Thu
        'Su, che il giorno è già qui! I tuoi primi passi possono essere piccolissimi.', // 4 Fri
        'Buongiorno! Che bello vederti. Facciamo di oggi una giornata gentile.', // 5 Sat
        'Buongiorno! Ti aspetta una giornata tranquilla e bella. Con calma.', // 6 Sun
      ],
      'greeting_afternoon': [
        'Buon pomeriggio! La settimana nuova va bene. Ti va una passeggiatina?', // 0 Mon
        'Buon pomeriggio! Un momento perfetto per fare due passi.', // 1 Tue
        'Ciao! Che ne dici di qualche passo tranquillo questo pomeriggio?', // 2 Wed
        'Buon pomeriggio! La giornata ha ancora tanti bei momenti in serbo.', // 3 Thu
        'Buon pomeriggio! Anche una passeggiata breve conta. Puoi farcela.', // 4 Fri
        'Buon pomeriggio! Che bello che passi di qui. Andiamo con calma.', // 5 Sat
        'Buon pomeriggio! Perfetto per una passeggiata lenta, o per una lunga e piacevole pausa.', // 6 Sun
      ],
      'greeting_evening': [
        'Buonasera! La settimana nuova è partita, e sta andando benissimo.', // 0 Mon
        'Buonasera! Una passeggiatina tranquilla, o meglio un momento accogliente?', // 1 Tue
        'Buonasera! Qualunque cosa abbia portato la giornata, eccoti qui. Che bello.', // 2 Wed
        'Buonasera! Qualche passo leggero o un divano comodo. Suonano bene entrambi.', // 3 Thu
        'Ciao, sera! È un bel momento per una passeggiata lenta, se ti va.', // 4 Fri
        'Buonasera! Domani è un giorno tutto nuovo, e oggi è bastato.', // 5 Sat
        'Buonasera! Una serata accogliente sembra perfetta. Goditi ogni minuto tranquillo.', // 6 Sun
      ],
    },
  },
};

/// Morning 04:00-11:59, afternoon 12:00-17:59, evening 18:00-03:59.
String greetingKeyFor(DateTime now) {
  final h = now.hour;
  if (h >= 4 && h < 12) return 'greeting_morning';
  if (h >= 12 && h < 18) return 'greeting_afternoon';
  return 'greeting_evening';
}

/// Same greeting all day for each part of the day.
String pickGreeting({
  required String language,
  required String style,
  required DateTime now,
}) {
  final byLang = greetingLines[language] ?? greetingLines['en']!;
  final byStyle = byLang[style] ?? byLang['calm']!;
  final lines = byStyle[greetingKeyFor(now)]!;
  return lines[weekdayIndex(now, lines.length)];
}
