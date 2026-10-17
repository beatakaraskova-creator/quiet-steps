/// Milestone lines for Quiet Steps.
/// lines[languageCode][style][milestone] -> 7 lines, index 0 = Monday ... 6 = Sunday.
/// Pick by weekday with weekdayIndex (day_pick.dart), not at random.
/// style: 'calm' | 'cheerful'.
/// milestone: '2500' | '5000' | '7500' | 'goal' | 'beyond' | 'round_10000' |
/// 'round_15000' | 'round_20000' | 'round_25000' | 'round_30000' | 'care_30k'.
/// Unknown language -> fall back to 'en'.
const Map<String, Map<String, Map<String, List<String>>>> milestoneLines = {
  'en': {
    'calm': {
      '2500': [
        'A fresh week, a fresh little start. 2,500 steps, taken gently.', // 0 Mon
        'Look at you, already out there. Every step today is a little gift to yourself.', // 1 Tue
        "2,500 steps. A soft beginning, and it's all yours. There's no rush at all.", // 2 Wed
        "The day has started moving with you. That's a lovely thing to notice.", // 3 Thu
        "2,500 steps already. However you're feeling, this is a kind way to spend a moment.", // 4 Fri
        'A gentle start. Small steps still count, and these ones are yours.', // 5 Sat
        '2,500 easy steps. Let today be slow and unhurried, just the way you like it.', // 6 Sun
      ],
      '5000': [
        "5,000 steps into a brand new week. You're finding your rhythm, gently.", // 0 Mon
        "Halfway. Notice the air, the sky, how your body feels. You're doing something good for you.", // 1 Tue
        "5,000 steps. Steady and unhurried, just as you are. That's worth a quiet smile.", // 2 Wed
        "Take a slow breath and let this moment be easy. You're doing well.", // 3 Thu
        '5,000 steps, one at a time. Thank you for making a little room for yourself today.', // 4 Fri
        'However far today goes, this part already counts. Be gentle with yourself as you go.', // 5 Sat
        'A slow, easy day, and 5,000 steps already. Enjoy every unhurried moment.', // 6 Sun
      ],
      '7500': [
        '7,500 steps. A lovely way to begin the week, one calm step at a time.', // 0 Mon
        'So close now. However today has been, you kept going, and that matters.', // 1 Tue
        "7,500 steps. Look how far you've come today, one quiet step at a time.", // 2 Wed
        'Every one of these steps was a small kindness to yourself. Take that in.', // 3 Thu
        '7,500 steps. Whatever pace feels right to you is the right pace.', // 4 Fri
        "You've been showing up for yourself all day. That's a quiet kind of strength.", // 5 Sat
        "7,500 steps at your own easy pace. There's nothing to rush for today.", // 6 Sun
      ],
      'goal': [
        'Goal reached, and the week has started kindly. Be proud of this beginning.', // 0 Mon
        'You did it. Whatever else happened today, you showed up for yourself. Be proud.', // 1 Tue
        "That's your goal, reached. Rest now, or simply let yourself enjoy the moment.", // 2 Wed
        'Goal reached. Every step that brought you here was yours. Well done, truly.', // 3 Thu
        'You made it. Take a breath and let yourself feel a little proud of today.', // 4 Fri
        'Your goal is met. Anything from here is just for the joy of it, if you like.', // 5 Sat
        'You did it, and gently too. Let the rest of today be slow and lovely.', // 6 Sun
      ],
      'beyond': [
        'Your goal is met. Let the rest of today be light, a soft start to the week.', // 0 Mon
        'Your goal is already met. These extra steps are simply yours to enjoy.', // 1 Tue
        "There's nothing more to prove today. If you're still walking, just enjoy it.", // 2 Wed
        'Past your goal now. Go as gently as you like, and stop whenever it feels right.', // 3 Thu
        'A little extra, just because. Today has already been a good one.', // 4 Fri
        'Nothing to chase now. Let these steps be easy and unhurried.', // 5 Sat
        'Past your goal on a slow, easy day. Wander if you like, or simply rest.', // 6 Sun
      ],
      'round_10000': [
        '10,000 steps to open the week. What a gentle, generous beginning.', // 0 Mon
        '10,000 steps. A lovely, round number. Take a quiet moment with that.', // 1 Tue
        "10,000 steps today. That's a lot of quiet moments spent looking after yourself.", // 2 Wed
        'What a generous day. 10,000 steps, and every single one was yours.', // 3 Thu
        "10,000 steps. There's nothing more you need to do today. Just enjoy how far you've come.", // 4 Fri
        "A full, round 10,000. However you got here, slowly or quickly, it's lovely.", // 5 Sat
        '10,000 unhurried steps. Let the rest of the day be cosy and slow.', // 6 Sun
      ],
      'round_15000': [
        '15,000 steps, and the week has only just begun. Go easy on yourself now.', // 0 Mon
        '15,000 steps. Such a generous day. Let the rest of it be soft and easy.', // 1 Tue
        "You've given today so much. 15,000 steps is more than enough.", // 2 Wed
        '15,000 steps. Perhaps a sit down soon, with something nice to drink.', // 3 Thu
        'A long, full day of walking. Be gentle with yourself for the rest of it.', // 4 Fri
        "15,000 steps. You've done plenty, and plenty is wonderful.", // 5 Sat
        '15,000 steps. A lovely full day. Time to slow right down and relax.', // 6 Sun
      ],
      'round_20000': [
        '20,000 steps to start the week. Please have some water, and rest your feet.', // 0 Mon
        '20,000 steps. Please have some water, and rest your feet when you can.', // 1 Tue
        'What a day. A glass of water and a little rest for your feet would be lovely now.', // 2 Wed
        '20,000 steps. Your feet have carried you so far. Let them rest a while.', // 3 Thu
        "You've done so much today. Some water, a comfy seat, and nothing more to do.", // 4 Fri
        '20,000 steps. Time to be kind to yourself. A drink of water, and a quiet rest.', // 5 Sat
        '20,000 steps. A cool drink and a long, lazy rest for your feet would be perfect now.', // 6 Sun
      ],
      'round_25000': [
        '25,000 steps. A big start to the week. Some water, and rest your feet now.', // 0 Mon
        '25,000 steps. Pause for some water, and let your feet rest for a while.', // 1 Tue
        'Such a long day on your feet. Please sit, sip some water, and take a breath.', // 2 Wed
        "25,000 steps. There's nothing left to prove. Water and rest are yours now.", // 3 Thu
        "You've walked so far today. Be gentle with your feet, and have a drink.", // 4 Fri
        '25,000 steps. A little water and a long rest would be lovely now.', // 5 Sat
        '25,000 steps. Time for a long, slow rest, and plenty of water.', // 6 Sun
      ],
      'round_30000': [
        '30,000 steps. What a start to the week. Please be kind to your body now.', // 0 Mon
        '30,000 steps. What an amazing day. Please be kind to your body now.', // 1 Tue
        '30,000 steps, truly extraordinary. Rest, drink some water, and be gentle with yourself.', // 2 Wed
        "You've done more than enough today. Your body deserves care and a long rest.", // 3 Thu
        '30,000 steps. This is a good moment to stop and rest. Be kind to your body.', // 4 Fri
        'Such a remarkable day. Please look after yourself now, with water and rest.', // 5 Sat
        '30,000 steps. Let the rest of today be all rest. Be kind to your body.', // 6 Sun
      ],
      'care_30k': [
        'Such a big day. Please be kind to your body, and let the week unfold gently.', // 0 Mon
        'An amazing day. Please be kind to your body, and rest when you can.', // 1 Tue
        "You've walked so very far. Rest your feet, drink some water, and be gentle.", // 2 Wed
        'That is more than enough for one day. You can stop now, with nothing left undone.', // 3 Thu
        'Your body has carried you a long way today. Please give it rest and care.', // 4 Fri
        "Whatever brought you this far today, it's time to rest. Water, a seat, and kindness.", // 5 Sat
        "You've walked so far. Let the rest of today be slow, restful and kind.", // 6 Sun
      ],
    },
    'cheerful': {
      '2500': [
        'Hello, new week! 2,500 steps already. What a lovely start.', // 0 Mon
        '2,500 steps! What a lovely start. Every one of them is a little gift to you.', // 1 Tue
        "And you're off! A bright little start to your day.", // 2 Wed
        "Hello, 2,500! It's so nice to be walking with you today.", // 3 Thu
        'Look at you go! A cheerful start, one easy step at a time.', // 4 Fri
        "2,500 steps already! Small steps, big smile. You're doing great.", // 5 Sat
        '2,500 easy steps! No rush today, just enjoy yourself.', // 6 Sun
      ],
      '5000': [
        "5,000! The week's off to a lovely start. You're doing great.", // 0 Mon
        '5,000 steps! Look at you. Enjoy the air, the sky, and this good moment.', // 1 Tue
        "High five! 5,000 lovely steps, and you're doing something good for you.", // 2 Wed
        "5,000! What a nice rhythm you've found. Enjoy it.", // 3 Thu
        "Hooray, halfway! You're doing brilliantly, at just your own pace.", // 4 Fri
        "Look how far you've come already! Every step today is a happy one.", // 5 Sat
        '5,000 relaxed steps! What a nice, easy day this is.', // 6 Sun
      ],
      '7500': [
        "7,500! What a bright start to the week. You're nearly there.", // 0 Mon
        '7,500 steps! So close now, and you should be really pleased with yourself.', // 1 Tue
        "Wow, 7,500! However today's been, you showed up. That's wonderful.", // 2 Wed
        "Nearly there! Enjoy every step, there's no rush at all.", // 3 Thu
        "7,500! You're doing such a lovely thing for yourself today.", // 4 Fri
        'Look at you, still going strong! Whatever pace feels good is perfect.', // 5 Sat
        '7,500 steps! Lovely and easy does it. No hurry at all.', // 6 Sun
      ],
      'goal': [
        'Goal reached! What a happy way to start the week. Well done!', // 0 Mon
        'You did it! Goal reached. Whatever else happened today, be proud of this.', // 1 Tue
        "Yes! That's your goal. What a wonderful thing you did for yourself today.", // 2 Wed
        'Goal reached! Give yourself a big smile, you really earned it.', // 3 Thu
        'Hooray! You made it. Rest, celebrate, or just enjoy the feeling.', // 4 Fri
        'There it is, your goal! Well done, truly. Today is a good day.', // 5 Sat
        'You did it! Now put your feet up and enjoy the rest of the day.', // 6 Sun
      ],
      'beyond': [
        "Past your goal! The week's off to a flying start. Go easy now.", // 0 Mon
        'Past your goal! Any extra steps now are just for fun.', // 1 Tue
        'Goal done and still strolling? Lovely. Enjoy it, with no pressure at all.', // 2 Wed
        'A little bonus walk! Today is already a win, so go easy.', // 3 Thu
        "Extra steps, just because! Stop whenever you like, you've done brilliantly.", // 4 Fri
        'Look at you, beyond your goal! This bit is all for the joy of it.', // 5 Sat
        'Bonus steps on an easy day! Lovely. Rest whenever you like.', // 6 Sun
      ],
      'round_10000': [
        '10,000 steps! What a wonderful way to begin the week.', // 0 Mon
        '10,000 steps! What a lovely round number. Take a moment to enjoy it.', // 1 Tue
        "Wow, 10,000! That's a beautiful day of walking.", // 2 Wed
        "10,000 steps! Give yourself a little cheer, you've earned it.", // 3 Thu
        'Hello, 10,000! What a happy, generous day this has been.', // 4 Fri
        "10,000! A big round number, and there's nothing else you need to do today.", // 5 Sat
        '10,000 steps! Time for a cosy, lazy rest of the day.', // 6 Sun
      ],
      'round_15000': [
        "15,000! The week's barely begun, and look at you. Rest up now.", // 0 Mon
        '15,000 steps! What a generous day. Let the rest of it be easy.', // 1 Tue
        "Wow, 15,000! You've done plenty, and that's wonderful.", // 2 Wed
        '15,000! Maybe a comfy seat and a nice drink soon? You deserve it.', // 3 Thu
        'What a full, bright day! 15,000 steps, and every one was yours.', // 4 Fri
        "15,000 steps! That's something to feel proud of. Let the rest of the day be gentle.", // 5 Sat
        "15,000 steps! Time to kick back and relax. You've done plenty.", // 6 Sun
      ],
      'round_20000': [
        '20,000 steps! Big start to the week. Water, then a rest for your feet.', // 0 Mon
        '20,000 steps! Amazing. Have some water, and rest your feet when you can.', // 1 Tue
        'Wow, 20,000! A big glass of water and a little sit down sound perfect.', // 2 Wed
        '20,000! What a day. Your feet deserve a lovely long rest.', // 3 Thu
        'Amazing day! Grab some water, and put your feet up when you can.', // 4 Fri
        '20,000 steps! Time to treat yourself kindly. Water first, then a rest for your feet.', // 5 Sat
        '20,000! Grab a cool drink and give your feet a lovely lazy rest.', // 6 Sun
      ],
      'round_25000': [
        '25,000 steps! Wow, what a start. Please have water and rest your feet.', // 0 Mon
        '25,000 steps! Incredible. Have a drink of water, and rest your feet.', // 1 Tue
        'Wow, 25,000! Time for water, a seat, and a big, cosy rest.', // 2 Wed
        '25,000! Your feet have had quite the adventure. Let them rest now.', // 3 Thu
        'What a day! Please have some water, and be gentle with your feet.', // 4 Fri
        "25,000 steps! You've done more than enough. Water and rest, please.", // 5 Sat
        '25,000! Time for a long, lazy rest and a big glass of water.', // 6 Sun
      ],
      'round_30000': [
        '30,000 steps! Amazing start to the week. Be kind to your body now.', // 0 Mon
        '30,000 steps! What an amazing day. Please be kind to your body now.', // 1 Tue
        'Wow, 30,000! Extraordinary. Rest, water, and lots of kindness to yourself.', // 2 Wed
        "30,000! That's more than enough. Time to look after yourself.", // 3 Thu
        'What a remarkable day! Your body deserves a long, cosy rest now.', // 4 Fri
        '30,000 steps! Be proud, then be gentle. Water and rest are calling.', // 5 Sat
        '30,000! What a day. Now rest, relax, and be kind to your body.', // 6 Sun
      ],
      'care_30k': [
        'What a big start to the week! Please be kind to your body now.', // 0 Mon
        'What an amazing day of walking! Please be kind to your body now.', // 1 Tue
        "You've gone so far today! Rest your feet, and have some water.", // 2 Wed
        'More than enough for today! Time for a seat, a drink, and a rest.', // 3 Thu
        'Wow, what a day! Please look after yourself now, gently.', // 4 Fri
        "Such a big day! Let your body rest. There's nothing else to do.", // 5 Sat
        'So many steps! Let the rest of today be lazy, cosy and kind.', // 6 Sun
      ],
    },
  },
  'sk': {
    'calm': {
      '2500': [
        'Nový týždeň, nový malý začiatok. 2 500 krokov, pekne zľahka.', // 0 Mon
        'Pozrite sa na seba, už ste na ceste. Každý dnešný krok je malý darček pre vás.', // 1 Tue
        '2 500 krokov. Jemný začiatok, a celý patrí vám. Nikam sa netreba ponáhľať.', // 2 Wed
        'Deň sa rozbehol spolu s vami. To je krásne si všimnúť.', // 3 Thu
        'Už 2 500 krokov. Nech sa cítite akokoľvek, toto je láskavo strávená chvíľa.', // 4 Fri
        'Pokojný začiatok. Aj malé kroky sa rátajú a tieto sú vaše.', // 5 Sat
        '2 500 pokojných krokov. Nech je dnešok pomalý a bez náhlenia, presne podľa vás.', // 6 Sun
      ],
      '5000': [
        '5 000 krokov do úplne nového týždňa. Pomaly nachádzate svoj rytmus.', // 0 Mon
        'Polovica. Všimnite si vzduch, oblohu, ako sa cíti vaše telo. Robíte pre seba niečo dobré.', // 1 Tue
        '5 000 krokov. Pokojne a bez náhlenia, vaším vlastným tempom. To si zaslúži tichý úsmev.', // 2 Wed
        'Pomaly sa nadýchnite a nechajte túto chvíľu plynúť. Darí sa vám.', // 3 Thu
        '5 000 krokov, jeden po druhom. Vďaka, že ste si dnes našli chvíľku pre seba.', // 4 Fri
        'Nech dnešok dôjde kamkoľvek, táto časť sa už počíta. Buďte k sebe po ceste jemní.', // 5 Sat
        'Pomalý, pokojný deň a už 5 000 krokov. Užite si každú chvíľu bez náhlenia.', // 6 Sun
      ],
      '7500': [
        '7 500 krokov. Krásny začiatok týždňa, krok za krokom, v pokoji.', // 0 Mon
        'Už je to blízko. Nech bol dnešok akýkoľvek, vydržali ste, a na tom záleží.', // 1 Tue
        '7 500 krokov. Pozrite sa, koľko ste dnes prešli, jeden tichý krok za druhým.', // 2 Wed
        'Každý z týchto krokov bol malou láskavosťou k sebe. Doprajte si to precítiť.', // 3 Thu
        '7 500 krokov. Tempo, ktoré je vám príjemné, je to správne tempo.', // 4 Fri
        'Celý deň ste tu pre seba. To je tichá sila.', // 5 Sat
        '7 500 krokov vaším pohodovým tempom. Dnes sa nie je kam ponáhľať.', // 6 Sun
      ],
      'goal': [
        'Cieľ je splnený a týždeň začal láskavo. Buďte hrdí na tento začiatok.', // 0 Mon
        'Dokázali ste to. Nech sa dnes stalo čokoľvek, boli ste tu pre seba. Buďte na seba hrdí.', // 1 Tue
        'Váš cieľ je splnený. Teraz si oddýchnite, alebo si len vychutnajte túto chvíľu.', // 2 Wed
        'Cieľ je splnený. Každý krok, ktorý vás sem priviedol, bol váš. Naozaj skvelé.', // 3 Thu
        'Zvládli ste to. Nadýchnite sa a dovoľte si byť na dnešok trochu hrdí.', // 4 Fri
        'Cieľ máte splnený. Všetko, čo príde teraz, je už len pre radosť, ak chcete.', // 5 Sat
        'Dokázali ste to, a ešte k tomu pokojne. Nech je zvyšok dňa pomalý a krásny.', // 6 Sun
      ],
      'beyond': [
        'Cieľ je splnený. Nech je zvyšok dňa ľahký, jemný začiatok týždňa.', // 0 Mon
        'Cieľ už máte splnený. Tieto kroky navyše sú len pre vašu radosť.', // 1 Tue
        'Dnes už nemusíte nič dokazovať. Ak ešte kráčate, len si to užívajte.', // 2 Wed
        'Už ste za cieľom. Choďte tak zľahka, ako chcete, a zastavte, kedy vám to bude príjemné.', // 3 Thu
        'Kúsok navyše, len tak. Dnešok už bol dobrý.', // 4 Fri
        'Teraz už nie je čo naháňať. Nech sú tieto kroky ľahké a pokojné.', // 5 Sat
        'Ste za cieľom a deň je pomalý a pohodový. Prejdite sa, ak chcete, alebo si oddýchnite.', // 6 Sun
      ],
      'round_10000': [
        '10 000 krokov na úvod týždňa. Aký jemný, štedrý začiatok.', // 0 Mon
        '10 000 krokov. Pekné okrúhle číslo. Doprajte si s ním tichú chvíľku.', // 1 Tue
        'Dnes 10 000 krokov. To je veľa tichých chvíľ, keď ste sa starali o seba.', // 2 Wed
        'Aký štedrý deň. 10 000 krokov a každý jeden bol váš.', // 3 Thu
        '10 000 krokov. Dnes už nemusíte urobiť nič viac. Len si vychutnajte, koľko ste prešli.', // 4 Fri
        'Plných, okrúhlych 10 000. Pomaly či rýchlo, je to krásne.', // 5 Sat
        '10 000 krokov bez náhlenia. Nech je zvyšok dňa útulný a pomalý.', // 6 Sun
      ],
      'round_15000': [
        '15 000 krokov a týždeň sa len začal. Teraz to so sebou berte zľahka.', // 0 Mon
        '15 000 krokov. Taký štedrý deň. Nech je jeho zvyšok jemný a ľahký.', // 1 Tue
        'Dnešku ste dali toľko. 15 000 krokov je viac než dosť.', // 2 Wed
        '15 000 krokov. Možno si čoskoro sadnite a dajte si niečo dobré na pitie.', // 3 Thu
        'Dlhý, plný deň chôdze. Buďte k sebe jemní po zvyšok dňa.', // 4 Fri
        '15 000 krokov. Urobili ste veľa, a to je nádherné.', // 5 Sat
        '15 000 krokov. Krásny, plný deň. Čas spomaliť a oddýchnuť si.', // 6 Sun
      ],
      'round_20000': [
        '20 000 krokov na začiatok týždňa. Napite sa vody a doprajte nohám oddych.', // 0 Mon
        '20 000 krokov. Napite sa vody a keď môžete, doprajte nohám oddych.', // 1 Tue
        'Aký deň. Pohár vody a chvíľka oddychu pre nohy by teraz padli vhod.', // 2 Wed
        '20 000 krokov. Nohy vás dnes niesli tak ďaleko. Nechajte ich chvíľu oddychovať.', // 3 Thu
        'Dnes ste urobili toľko. Trochu vody, pohodlné sedenie a nič viac.', // 4 Fri
        '20 000 krokov. Čas byť k sebe láskaví. Pohár vody a tichý oddych.', // 5 Sat
        '20 000 krokov. Niečo osviežujúce na pitie a dlhý, pokojný oddych pre nohy by teraz bol ideálny.', // 6 Sun
      ],
      'round_25000': [
        '25 000 krokov. Veľký začiatok týždňa. Trochu vody a teraz oddych pre nohy.', // 0 Mon
        '25 000 krokov. Zastavte sa na vodu a nechajte nohy chvíľu oddychovať.', // 1 Tue
        'Taký dlhý deň na nohách. Sadnite si, napite sa a nadýchnite sa.', // 2 Wed
        '25 000 krokov. Už nie je čo dokazovať. Voda a oddych sú teraz pre vás.', // 3 Thu
        'Dnes ste prešli tak veľa. Buďte jemní k nohám a dajte si niečo na pitie.', // 4 Fri
        '25 000 krokov. Trochu vody a dlhý oddych by teraz boli krásne.', // 5 Sat
        '25 000 krokov. Čas na dlhý, pomalý oddych a veľa vody.', // 6 Sun
      ],
      'round_30000': [
        '30 000 krokov. Aký začiatok týždňa. Buďte teraz, prosím, k telu láskaví.', // 0 Mon
        '30 000 krokov. Aký úžasný deň. Buďte teraz, prosím, k telu láskaví.', // 1 Tue
        '30 000 krokov, naozaj mimoriadne. Oddýchnite si, napite sa a buďte k sebe jemní.', // 2 Wed
        'Dnes ste urobili viac než dosť. Vaše telo si zaslúži starostlivosť a dlhý oddych.', // 3 Thu
        '30 000 krokov. Toto je dobrá chvíľa zastaviť a oddýchnuť si. Buďte k telu láskaví.', // 4 Fri
        'Taký výnimočný deň. Postarajte sa teraz o seba, vodou a oddychom.', // 5 Sat
        '30 000 krokov. Nech je zvyšok dňa len oddych. Buďte k telu láskaví.', // 6 Sun
      ],
      'care_30k': [
        'Taký veľký deň. Buďte, prosím, k telu láskaví a nechajte týždeň plynúť pokojne.', // 0 Mon
        'Úžasný deň. Buďte, prosím, k telu láskaví a oddýchnite si, keď môžete.', // 1 Tue
        'Prešli ste naozaj veľmi veľa. Doprajte nohám oddych, napite sa a buďte k sebe jemní.', // 2 Wed
        'Na jeden deň je to viac než dosť. Teraz môžete prestať, nič nezostalo nedokončené.', // 3 Thu
        'Vaše telo vás dnes nieslo veľmi ďaleko. Doprajte mu oddych a starostlivosť.', // 4 Fri
        'Nech vás sem dnes priviedlo čokoľvek, je čas oddychovať. Voda, sedenie a láskavosť.', // 5 Sat
        'Prešli ste tak veľa. Nech je zvyšok dňa pomalý, pokojný a láskavý.', // 6 Sun
      ],
    },
    'cheerful': {
      '2500': [
        'Ahoj, nový týždeň! Už 2 500 krokov. Aký krásny začiatok.', // 0 Mon
        '2 500 krokov! Aký krásny štart. Každý z nich je malý darček pre vás.', // 1 Tue
        'A ide sa! Veselý malý začiatok dňa.', // 2 Wed
        'Ahoj, 2 500! Je také milé kráčať dnes s vami.', // 3 Thu
        'Len sa pozrite! Veselý začiatok, krok za krokom, zľahka.', // 4 Fri
        'Už 2 500 krokov! Malé kroky, veľký úsmev. Darí sa vám skvele.', // 5 Sat
        '2 500 pohodových krokov! Dnes žiadny zhon, len si to užite.', // 6 Sun
      ],
      '5000': [
        '5 000! Týždeň sa začal krásne. Ide vám to skvele.', // 0 Mon
        '5 000 krokov! Len sa pozrite. Užite si vzduch, oblohu a túto dobrú chvíľu.', // 1 Tue
        'Plácnime si! 5 000 krásnych krokov a robíte pre seba niečo dobré.', // 2 Wed
        '5 000! Aký pekný rytmus ste našli. Užite si ho.', // 3 Thu
        'Hurá, polovica! Idete skvele, presne vaším tempom.', // 4 Fri
        'Pozrite, koľko ste už prešli! Každý dnešný krok je radostný.', // 5 Sat
        '5 000 pohodových krokov! Aký príjemný, pokojný deň.', // 6 Sun
      ],
      '7500': [
        '7 500! Aký veselý začiatok týždňa. Už ste skoro v cieli.', // 0 Mon
        '7 500 krokov! Už je to blízko a môžete byť na seba naozaj hrdí.', // 1 Tue
        'Páni, 7 500! Nech bol dnešok akýkoľvek, boli ste tu pre seba. To je nádherné.', // 2 Wed
        'Skoro v cieli! Užite si každý krok, vôbec sa netreba ponáhľať.', // 3 Thu
        '7 500! Robíte dnes pre seba takú krásnu vec.', // 4 Fri
        'Len sa pozrite, stále vám to ide! Každé tempo, ktoré je vám príjemné, je dokonalé.', // 5 Sat
        '7 500 krokov! Pekne v pohode. Žiadny zhon.', // 6 Sun
      ],
      'goal': [
        'Cieľ je splnený! Aký radostný začiatok týždňa. Výborne!', // 0 Mon
        'Dokázali ste to! Cieľ je splnený. Nech sa dnes dialo čokoľvek, buďte na to hrdí.', // 1 Tue
        'Áno! To je váš cieľ. Akú krásnu vec ste dnes pre seba urobili.', // 2 Wed
        'Cieľ je splnený! Venujte si veľký úsmev, naozaj si ho zaslúžite.', // 3 Thu
        'Hurá! Zvládli ste to. Oddýchnite si, oslávte to, alebo si len užite ten pocit.', // 4 Fri
        'A je tu, váš cieľ! Naozaj výborne. Dnešok je dobrý deň.', // 5 Sat
        'Dokázali ste to! Teraz si vyložte nohy a užite si zvyšok dňa.', // 6 Sun
      ],
      'beyond': [
        'Za cieľom! Týždeň sa rozbehol skvele. Teraz už zľahka.', // 0 Mon
        'Za cieľom! Každý krok navyše je teraz len pre zábavu.', // 1 Tue
        'Cieľ je splnený a ešte sa prechádzate? Krásne. Užite si to, bez akéhokoľvek tlaku.', // 2 Wed
        'Malá prechádzka navyše! Dnešok je už vyhraný, tak zľahka.', // 3 Thu
        'Kroky navyše, len tak! Zastavte, kedy chcete, išlo vám to skvele.', // 4 Fri
        'Pozrite sa, ste za cieľom! Tento kúsok je len pre radosť.', // 5 Sat
        'Bonusové kroky v pohodovom dni! Krásne. Oddýchnite si, kedy chcete.', // 6 Sun
      ],
      'round_10000': [
        '10 000 krokov! Aký nádherný začiatok týždňa.', // 0 Mon
        '10 000 krokov! Aké pekné okrúhle číslo. Užite si túto chvíľu.', // 1 Tue
        'Páni, 10 000! To je nádherný deň plný chôdze.', // 2 Wed
        '10 000 krokov! Zatlieskajte si, zaslúžite si to.', // 3 Thu
        'Ahoj, 10 000! Aký radostný, štedrý deň to bol.', // 4 Fri
        '10 000! Veľké okrúhle číslo a dnes už nemusíte robiť nič iné.', // 5 Sat
        '10 000 krokov! Čas na útulný a pohodový zvyšok dňa.', // 6 Sun
      ],
      'round_15000': [
        '15 000! Týždeň sa sotva začal, a pozrite sa na seba. Teraz si oddýchnite.', // 0 Mon
        '15 000 krokov! Aký štedrý deň. Nech je jeho zvyšok ľahký.', // 1 Tue
        'Páni, 15 000! Spravili ste toho veľa, a to je skvelé.', // 2 Wed
        '15 000! Čo tak čoskoro pohodlné kreslo a niečo dobré na pitie? Zaslúžite si to.', // 3 Thu
        'Aký plný, veselý deň! 15 000 krokov a každý bol váš.', // 4 Fri
        '15 000 krokov! Na to môžete byť hrdí. Nech je zvyšok dňa jemný.', // 5 Sat
        '15 000 krokov! Čas vyložiť si nohy a oddýchnuť. Máte toho za sebou dosť.', // 6 Sun
      ],
      'round_20000': [
        '20 000 krokov! Veľký začiatok týždňa. Najprv voda, potom oddych pre nohy.', // 0 Mon
        '20 000 krokov! Úžasné. Napite sa vody a keď môžete, doprajte nohám oddych.', // 1 Tue
        'Páni, 20 000! Veľký pohár vody a chvíľka sedenia znejú dokonale.', // 2 Wed
        '20 000! Aký deň. Vaše nohy si zaslúžia krásny dlhý oddych.', // 3 Thu
        'Úžasný deň! Dajte si vodu a keď môžete, vyložte si nohy.', // 4 Fri
        '20 000 krokov! Čas byť k sebe milí. Pohár vody a potom pokoj pre nohy.', // 5 Sat
        '20 000! Dajte si niečo osviežujúce a doprajte nohám krásny pohodový oddych.', // 6 Sun
      ],
      'round_25000': [
        '25 000 krokov! Páni, aký začiatok. Napite sa, prosím, a doprajte nohám oddych.', // 0 Mon
        '25 000 krokov! Neuveriteľné. Napite sa vody a nechajte nohy oddychovať.', // 1 Tue
        'Páni, 25 000! Čas na vodu, pohodlné sedenie a veľký, útulný oddych.', // 2 Wed
        '25 000! Vaše nohy zažili poriadne dobrodružstvo. Teraz ich nechajte oddychovať.', // 3 Thu
        'Aký deň! Napite sa, prosím, a buďte jemní k svojim nohám.', // 4 Fri
        '25 000 krokov! Urobili ste viac než dosť. Voda a oddych, prosím.', // 5 Sat
        '25 000! Čas na dlhý, pohodový oddych a veľký pohár vody.', // 6 Sun
      ],
      'round_30000': [
        '30 000 krokov! Úžasný začiatok týždňa. Buďte teraz k telu láskaví.', // 0 Mon
        '30 000 krokov! Aký úžasný deň. Buďte teraz, prosím, k telu láskaví.', // 1 Tue
        'Páni, 30 000! Mimoriadne. Oddych, voda a veľa láskavosti k sebe.', // 2 Wed
        '30 000! To je viac než dosť. Čas postarať sa o seba.', // 3 Thu
        'Aký výnimočný deň! Vaše telo si teraz zaslúži dlhý, útulný oddych.', // 4 Fri
        '30 000 krokov! Buďte hrdí, a potom jemní. Voda a oddych už čakajú.', // 5 Sat
        '30 000! Aký deň. Teraz oddych, pohoda a láskavosť k telu.', // 6 Sun
      ],
      'care_30k': [
        'Aký veľký začiatok týždňa! Buďte teraz, prosím, k telu láskaví.', // 0 Mon
        'Aký úžasný deň chôdze! Postarajte sa teraz, prosím, o svoje telo.', // 1 Tue
        'Dnes ste prešli tak veľa! Doprajte nohám oddych a napite sa vody.', // 2 Wed
        'Na dnes viac než dosť! Čas sadnúť si, napiť sa a oddýchnuť.', // 3 Thu
        'Páni, aký deň! Postarajte sa teraz o seba, jemne.', // 4 Fri
        'Taký veľký deň! Doprajte telu oddych. Už nie je čo robiť.', // 5 Sat
        'Toľko krokov! Nech je zvyšok dňa pohodový, útulný a láskavý.', // 6 Sun
      ],
    },
  },
  'cs': {
    'calm': {
      '2500': [
        'Nový týden, nový malý začátek. 2 500 kroků, pěkně zlehka.', // 0 Mon
        'Podívejte se na sebe, už jste na cestě. Každý dnešní krok je malý dárek pro vás.', // 1 Tue
        '2 500 kroků. Jemný začátek, a celý patří vám. Není kam spěchat.', // 2 Wed
        'Den se rozběhl spolu s vámi. To je krásné si všimnout.', // 3 Thu
        'Už 2 500 kroků. Ať se cítíte jakkoli, tohle je laskavě strávená chvíle.', // 4 Fri
        'Klidný začátek. I malé kroky se počítají a tyhle jsou vaše.', // 5 Sat
        '2 500 pohodových kroků. Ať je dnešek pomalý a bez spěchu, přesně podle vás.', // 6 Sun
      ],
      '5000': [
        '5 000 kroků do úplně nového týdne. Pomalu nacházíte svůj rytmus.', // 0 Mon
        'Polovina. Všimněte si vzduchu, oblohy, jak se cítí vaše tělo. Děláte pro sebe něco dobrého.', // 1 Tue
        '5 000 kroků. Klidně a bez spěchu, vlastním tempem. To si zaslouží tichý úsměv.', // 2 Wed
        'Pomalu se nadechněte a nechte tuhle chvíli plynout. Daří se vám.', // 3 Thu
        '5 000 kroků, jeden po druhém. Díky, že jste si dnes našli chvilku pro sebe.', // 4 Fri
        'Ať dnešek dojde kamkoli, tahle část už se počítá. Buďte k sobě cestou jemní.', // 5 Sat
        'Pomalý, klidný den a už 5 000 kroků. Užijte si každou chvíli bez spěchu.', // 6 Sun
      ],
      '7500': [
        '7 500 kroků. Krásný začátek týdne, krok za krokem, v klidu.', // 0 Mon
        'Už je to blízko. Ať byl dnešek jakýkoli, vydrželi jste, a na tom záleží.', // 1 Tue
        '7 500 kroků. Podívejte se, kolik jste dnes ušli, jeden tichý krok za druhým.', // 2 Wed
        'Každý z těch kroků byl malou laskavostí k sobě. Dopřejte si to procítit.', // 3 Thu
        '7 500 kroků. Tempo, které je vám příjemné, je to správné tempo.', // 4 Fri
        'Celý den jste tu sami pro sebe. To je tichá síla.', // 5 Sat
        '7 500 kroků vaším pohodovým tempem. Dnes se nikam nespěchá.', // 6 Sun
      ],
      'goal': [
        'Cíl je splněný a týden začal laskavě. Buďte hrdí na tenhle začátek.', // 0 Mon
        'Dokázali jste to. Ať se dnes stalo cokoli, byli jste tu pro sebe. Buďte na sebe hrdí.', // 1 Tue
        'Váš cíl je splněný. Teď si odpočiňte, nebo si jen vychutnejte tuhle chvíli.', // 2 Wed
        'Cíl je splněný. Každý krok, který vás sem přivedl, byl váš. Opravdu skvělé.', // 3 Thu
        'Zvládli jste to. Nadechněte se a dovolte si být na dnešek trochu hrdí.', // 4 Fri
        'Cíl máte splněný. Všechno, co přijde teď, je už jen pro radost, jestli chcete.', // 5 Sat
        'Dokázali jste to, a ještě k tomu v klidu. Ať je zbytek dne pomalý a krásný.', // 6 Sun
      ],
      'beyond': [
        'Cíl je splněný. Ať je zbytek dne lehký, jemný začátek týdne.', // 0 Mon
        'Cíl už máte splněný. Tyhle kroky navíc jsou jen pro vaši radost.', // 1 Tue
        'Dnes už nemusíte nic dokazovat. Jestli ještě jdete, jen si to užívejte.', // 2 Wed
        'Už jste za cílem. Jděte tak zlehka, jak chcete, a zastavte, kdy vám to bude příjemné.', // 3 Thu
        'Kousek navíc, jen tak. Dnešek už byl dobrý.', // 4 Fri
        'Teď už není co honit. Ať jsou tyhle kroky lehké a klidné.', // 5 Sat
        'Jste za cílem a den je pomalý a pohodový. Projděte se, jestli chcete, nebo si odpočiňte.', // 6 Sun
      ],
      'round_10000': [
        '10 000 kroků na úvod týdne. Jaký jemný, štědrý začátek.', // 0 Mon
        '10 000 kroků. Pěkné kulaté číslo. Dopřejte si s ním tichou chvilku.', // 1 Tue
        'Dnes 10 000 kroků. To je spousta tichých chvil, kdy jste pečovali o sebe.', // 2 Wed
        'Jaký štědrý den. 10 000 kroků a každý z nich byl váš.', // 3 Thu
        '10 000 kroků. Dnes už nemusíte dělat nic víc. Jen si vychutnejte, kolik jste ušli.', // 4 Fri
        'Plných, kulatých 10 000. Pomalu nebo rychle, je to krásné.', // 5 Sat
        '10 000 kroků bez spěchu. Ať je zbytek dne útulný a pomalý.', // 6 Sun
      ],
      'round_15000': [
        '15 000 kroků a týden teprve začal. Teď to se sebou berte zlehka.', // 0 Mon
        '15 000 kroků. Takový štědrý den. Ať je jeho zbytek jemný a lehký.', // 1 Tue
        'Dnešku jste dali tolik. 15 000 kroků je víc než dost.', // 2 Wed
        '15 000 kroků. Možná si brzy sedněte a dejte si něco dobrého k pití.', // 3 Thu
        'Dlouhý, plný den chůze. Buďte k sobě jemní po zbytek dne.', // 4 Fri
        '15 000 kroků. Udělali jste toho hodně, a to je nádherné.', // 5 Sat
        '15 000 kroků. Krásný, plný den. Čas zpomalit a odpočinout si.', // 6 Sun
      ],
      'round_20000': [
        '20 000 kroků na začátek týdne. Napijte se vody a dopřejte nohám odpočinek.', // 0 Mon
        '20 000 kroků. Napijte se vody a až budete moci, dopřejte nohám odpočinek.', // 1 Tue
        'Jaký den. Sklenice vody a chvilka odpočinku pro nohy by teď přišly vhod.', // 2 Wed
        '20 000 kroků. Nohy vás dnes nesly tak daleko. Nechte je chvíli odpočívat.', // 3 Thu
        'Dnes jste toho udělali tolik. Trochu vody, pohodlné sezení a nic víc.', // 4 Fri
        '20 000 kroků. Čas být k sobě laskaví. Sklenice vody a tichý odpočinek.', // 5 Sat
        '20 000 kroků. Něco osvěžujícího k pití a dlouhý, klidný odpočinek pro nohy by teď byl ideální.', // 6 Sun
      ],
      'round_25000': [
        '25 000 kroků. Velký začátek týdne. Trochu vody a teď odpočinek pro nohy.', // 0 Mon
        '25 000 kroků. Zastavte se na vodu a nechte nohy chvíli odpočívat.', // 1 Tue
        'Takový dlouhý den na nohou. Sedněte si, napijte se a nadechněte se.', // 2 Wed
        '25 000 kroků. Už není co dokazovat. Voda a odpočinek jsou teď pro vás.', // 3 Thu
        'Dnes jste ušli tolik. Buďte k nohám jemní a dejte si něco k pití.', // 4 Fri
        '25 000 kroků. Trochu vody a dlouhý odpočinek by teď byly krásné.', // 5 Sat
        '25 000 kroků. Čas na dlouhý, pomalý odpočinek a hodně vody.', // 6 Sun
      ],
      'round_30000': [
        '30 000 kroků. Jaký začátek týdne. Buďte teď, prosím, k tělu laskaví.', // 0 Mon
        '30 000 kroků. Jaký úžasný den. Buďte teď, prosím, k tělu laskaví.', // 1 Tue
        '30 000 kroků, opravdu mimořádné. Odpočiňte si, napijte se a buďte k sobě jemní.', // 2 Wed
        'Dnes jste udělali víc než dost. Vaše tělo si zaslouží péči a dlouhý odpočinek.', // 3 Thu
        '30 000 kroků. Teď je dobrá chvíle zastavit a odpočinout si. Buďte k tělu laskaví.', // 4 Fri
        'Takový výjimečný den. Postarejte se teď o sebe, vodou a odpočinkem.', // 5 Sat
        '30 000 kroků. Ať je zbytek dne jen odpočinek. Buďte k tělu laskaví.', // 6 Sun
      ],
      'care_30k': [
        'Takový velký den. Buďte, prosím, k tělu laskaví a nechte týden plynout v klidu.', // 0 Mon
        'Úžasný den. Buďte, prosím, k tělu laskaví a odpočiňte si, až budete moci.', // 1 Tue
        'Ušli jste opravdu hodně. Dopřejte nohám odpočinek, napijte se a buďte k sobě jemní.', // 2 Wed
        'Na jeden den je to víc než dost. Teď můžete přestat, nic nezůstalo nedodělané.', // 3 Thu
        'Vaše tělo vás dnes neslo hodně daleko. Dopřejte mu odpočinek a péči.', // 4 Fri
        'Ať vás sem dnes přivedlo cokoli, je čas odpočívat. Voda, sezení a laskavost.', // 5 Sat
        'Ušli jste toho tolik. Ať je zbytek dne pomalý, klidný a laskavý.', // 6 Sun
      ],
    },
    'cheerful': {
      '2500': [
        'Ahoj, nový týdne! Už 2 500 kroků. Jaký krásný začátek.', // 0 Mon
        '2 500 kroků! Jaký krásný start. Každý z nich je malý dárek pro vás.', // 1 Tue
        'A jde se! Veselý malý začátek dne.', // 2 Wed
        'Ahoj, 2 500! Je tak milé jít dnes s vámi.', // 3 Thu
        'Jen se podívejte! Veselý začátek, krok za krokem, zlehka.', // 4 Fri
        'Už 2 500 kroků! Malé kroky, velký úsměv. Daří se vám skvěle.', // 5 Sat
        '2 500 pohodových kroků! Dnes žádný spěch, jen si to užijte.', // 6 Sun
      ],
      '5000': [
        '5 000! Týden začal krásně. Jde vám to skvěle.', // 0 Mon
        '5 000 kroků! Jen se podívejte. Užijte si vzduch, oblohu a tuhle dobrou chvíli.', // 1 Tue
        'Plácněte si! 5 000 krásných kroků a děláte pro sebe něco dobrého.', // 2 Wed
        '5 000! Jaký pěkný rytmus jste našli. Užijte si ho.', // 3 Thu
        'Hurá, polovina! Jdete skvěle, přesně vaším tempem.', // 4 Fri
        'Podívejte, kolik jste už ušli! Každý dnešní krok je radostný.', // 5 Sat
        '5 000 pohodových kroků! Jaký příjemný, klidný den.', // 6 Sun
      ],
      '7500': [
        '7 500! Jaký veselý začátek týdne. Už jste skoro v cíli.', // 0 Mon
        '7 500 kroků! Už je to blízko a můžete být na sebe opravdu hrdí.', // 1 Tue
        'Páni, 7 500! Ať byl dnešek jakýkoli, byli jste tu pro sebe. To je nádherné.', // 2 Wed
        'Skoro v cíli! Užijte si každý krok, vůbec není kam spěchat.', // 3 Thu
        '7 500! Děláte dnes pro sebe tak krásnou věc.', // 4 Fri
        'Jen se podívejte, pořád vám to jde! Každé tempo, které je vám příjemné, je dokonalé.', // 5 Sat
        '7 500 kroků! Pěkně v pohodě. Žádný spěch.', // 6 Sun
      ],
      'goal': [
        'Cíl je splněný! Jaký radostný začátek týdne. Výborně!', // 0 Mon
        'Dokázali jste to! Cíl je splněný. Ať se dnes dělo cokoli, buďte na to hrdí.', // 1 Tue
        'Ano! To je váš cíl. Jakou krásnou věc jste dnes pro sebe udělali.', // 2 Wed
        'Cíl je splněný! Věnujte si velký úsměv, opravdu si ho zasloužíte.', // 3 Thu
        'Hurá! Zvládli jste to. Odpočiňte si, oslavte to, nebo si jen užijte ten pocit.', // 4 Fri
        'A je tu, váš cíl! Opravdu výborně. Dnešek je dobrý den.', // 5 Sat
        'Dokázali jste to! Teď si dejte nohy nahoru a užijte si zbytek dne.', // 6 Sun
      ],
      'beyond': [
        'Za cílem! Týden se rozjel skvěle. Teď už zlehka.', // 0 Mon
        'Za cílem! Každý krok navíc je teď jen pro zábavu.', // 1 Tue
        'Cíl je splněný a ještě se procházíte? Krásné. Užijte si to, bez jakéhokoli tlaku.', // 2 Wed
        'Malá procházka navíc! Dnešek je už vyhraný, tak zlehka.', // 3 Thu
        'Kroky navíc, jen tak! Zastavte, kdy chcete, šlo vám to skvěle.', // 4 Fri
        'Podívejte se, jste za cílem! Tenhle kousek je jen pro radost.', // 5 Sat
        'Bonusové kroky v pohodovém dni! Krásné. Odpočiňte si, kdy chcete.', // 6 Sun
      ],
      'round_10000': [
        '10 000 kroků! Jaký nádherný začátek týdne.', // 0 Mon
        '10 000 kroků! Jaké pěkné kulaté číslo. Užijte si tuhle chvíli.', // 1 Tue
        'Páni, 10 000! To je nádherný den plný chůze.', // 2 Wed
        '10 000 kroků! Zatleskejte si, zasloužíte si to.', // 3 Thu
        'Ahoj, 10 000! Jaký radostný, štědrý den to byl.', // 4 Fri
        '10 000! Velké kulaté číslo a dnes už nemusíte dělat nic jiného.', // 5 Sat
        '10 000 kroků! Čas na útulný a pohodový zbytek dne.', // 6 Sun
      ],
      'round_15000': [
        '15 000! Týden sotva začal, a podívejte se na sebe. Teď si odpočiňte.', // 0 Mon
        '15 000 kroků! Jaký štědrý den. Ať je jeho zbytek lehký.', // 1 Tue
        'Páni, 15 000! Udělali jste toho hodně, a to je skvělé.', // 2 Wed
        '15 000! Co takhle brzy pohodlné křeslo a něco dobrého k pití? Zasloužíte si to.', // 3 Thu
        'Jaký plný, veselý den! 15 000 kroků a každý byl váš.', // 4 Fri
        '15 000 kroků! Na to můžete být hrdí. Ať je zbytek dne jemný.', // 5 Sat
        '15 000 kroků! Čas dát si nohy nahoru a odpočinout si. Máte toho dost za sebou.', // 6 Sun
      ],
      'round_20000': [
        '20 000 kroků! Velký začátek týdne. Nejdřív voda, pak odpočinek pro nohy.', // 0 Mon
        '20 000 kroků! Úžasné. Napijte se vody a až budete moci, dopřejte nohám odpočinek.', // 1 Tue
        'Páni, 20 000! Velká sklenice vody a chvilka sezení zní dokonale.', // 2 Wed
        '20 000! Jaký den. Vaše nohy si zaslouží krásný dlouhý odpočinek.', // 3 Thu
        'Úžasný den! Dejte si vodu a až budete moci, dejte si nohy nahoru.', // 4 Fri
        '20 000 kroků! Čas být k sobě milí. Sklenice vody a pak klid pro nohy.', // 5 Sat
        '20 000! Dejte si něco osvěžujícího a dopřejte nohám krásný pohodový odpočinek.', // 6 Sun
      ],
      'round_25000': [
        '25 000 kroků! Páni, jaký začátek. Napijte se, prosím, a dopřejte nohám odpočinek.', // 0 Mon
        '25 000 kroků! Neuvěřitelné. Napijte se vody a dopřejte nohám klid.', // 1 Tue
        'Páni, 25 000! Čas na vodu, pohodlné sezení a velký, útulný odpočinek.', // 2 Wed
        '25 000! Vaše nohy zažily pořádné dobrodružství. Teď je nechte odpočívat.', // 3 Thu
        'Jaký den! Napijte se, prosím, a buďte jemní ke svým nohám.', // 4 Fri
        '25 000 kroků! Udělali jste víc než dost. Voda a odpočinek, prosím.', // 5 Sat
        '25 000! Čas na dlouhý, pohodový odpočinek a velkou sklenici vody.', // 6 Sun
      ],
      'round_30000': [
        '30 000 kroků! Úžasný začátek týdne. Buďte teď k tělu laskaví.', // 0 Mon
        '30 000 kroků! Jaký úžasný den. Buďte teď, prosím, k tělu laskaví.', // 1 Tue
        'Páni, 30 000! Mimořádné. Odpočinek, voda a spousta laskavosti k sobě.', // 2 Wed
        '30 000! To je víc než dost. Čas postarat se o sebe.', // 3 Thu
        'Jaký výjimečný den! Vaše tělo si teď zaslouží dlouhý, útulný odpočinek.', // 4 Fri
        '30 000 kroků! Buďte hrdí, a pak jemní. Voda a odpočinek už čekají.', // 5 Sat
        '30 000! Jaký den. Teď odpočinek, pohoda a laskavost k tělu.', // 6 Sun
      ],
      'care_30k': [
        'Jaký velký začátek týdne! Buďte teď, prosím, k tělu laskaví.', // 0 Mon
        'Jaký úžasný den chůze! Postarejte se teď, prosím, o své tělo.', // 1 Tue
        'Dnes jste ušli tolik! Dopřejte nohám odpočinek a napijte se vody.', // 2 Wed
        'Na dnešek víc než dost! Čas si sednout, napít se a odpočinout.', // 3 Thu
        'Páni, jaký den! Postarejte se teď o sebe, jemně.', // 4 Fri
        'Takový velký den! Dopřejte tělu odpočinek. Už není co dělat.', // 5 Sat
        'Tolik kroků! Ať je zbytek dne pohodový, útulný a laskavý.', // 6 Sun
      ],
    },
  },
  'pl': {
    'calm': {
      '2500': [
        'Nowy tydzień, nowy mały początek. 2500 kroków, spokojnie i łagodnie.', // 0 Mon
        'Spójrz tylko, już jesteś w drodze. Każdy dzisiejszy krok to mały prezent dla ciebie.', // 1 Tue
        '2500 kroków. Łagodny początek, cały twój. Nie ma żadnego pośpiechu.', // 2 Wed
        'Dzień ruszył razem z tobą. Miło to zauważyć.', // 3 Thu
        'Już 2500 kroków. Jakkolwiek się czujesz, to dobrze spędzona chwila.', // 4 Fri
        'Spokojny początek. Małe kroki też się liczą, a te są twoje.', // 5 Sat
        '2500 spokojnych kroków. Niech dzisiaj będzie powoli i bez pośpiechu, tak jak lubisz.', // 6 Sun
      ],
      '5000': [
        '5000 kroków w zupełnie nowym tygodniu. Powoli łapiesz swój rytm.', // 0 Mon
        'Połowa. Zauważ powietrze, niebo i to, jak czuje się twoje ciało. Robisz dla siebie coś dobrego.', // 1 Tue
        '5000 kroków. Spokojnie i bez pośpiechu, we własnym tempie. To zasługuje na cichy uśmiech.', // 2 Wed
        'Weź powolny oddech i pozwól tej chwili być lekką. Dobrze ci idzie.', // 3 Thu
        '5000 kroków, jeden po drugim. Dzięki, że znajdujesz dziś chwilę dla siebie.', // 4 Fri
        'Dokądkolwiek zaprowadzi cię ten dzień, ta część już się liczy. Traktuj siebie łagodnie po drodze.', // 5 Sat
        'Powolny, spokojny dzień i już 5000 kroków. Ciesz się każdą chwilą bez pośpiechu.', // 6 Sun
      ],
      '7500': [
        '7500 kroków. Piękny początek tygodnia, krok po kroku, w spokoju.', // 0 Mon
        'Już blisko. Jakikolwiek był dzisiejszy dzień, idziesz dalej, i to się liczy.', // 1 Tue
        '7500 kroków. Zobacz, ile już dziś masz za sobą, cichy krok po kroku.', // 2 Wed
        'Każdy z tych kroków był małą życzliwością wobec siebie. Pozwól sobie to poczuć.', // 3 Thu
        '7500 kroków. Tempo, które ci odpowiada, jest właściwym tempem.', // 4 Fri
        'Przez cały dzień jesteś tu dla siebie. To cicha siła.', // 5 Sat
        '7500 kroków w twoim spokojnym tempie. Dziś nie ma się po co spieszyć.', // 6 Sun
      ],
      'goal': [
        'Cel osiągnięty, a tydzień zaczął się łagodnie. Piękny początek i powód do dumy.', // 0 Mon
        'Udało się. Cokolwiek jeszcze dziś się działo, ten czas był dla ciebie. To powód do dumy.', // 1 Tue
        'Twój cel jest osiągnięty. Odpocznij teraz albo po prostu ciesz się tą chwilą.', // 2 Wed
        'Cel osiągnięty. Każdy krok, który cię tu przyprowadził, był twój. Naprawdę brawo.', // 3 Thu
        'Udało ci się. Weź oddech i pozwól sobie poczuć odrobinę dumy z dzisiejszego dnia.', // 4 Fri
        'Cel na dziś masz za sobą. Wszystko, co dalej, to już tylko dla przyjemności, jeśli chcesz.', // 5 Sat
        'Udało się, i to spokojnie. Niech reszta dnia będzie powolna i piękna.', // 6 Sun
      ],
      'beyond': [
        'Cel osiągnięty. Niech reszta dnia będzie lekka, łagodny początek tygodnia.', // 0 Mon
        'Cel masz już za sobą. Te dodatkowe kroki są tylko dla twojej radości.', // 1 Tue
        'Dziś nie musisz już niczego udowadniać. Jeśli wciąż idziesz, po prostu się tym ciesz.', // 2 Wed
        'Jesteś już po celu. Idź tak łagodnie, jak chcesz, i zatrzymaj się, kiedy zechcesz.', // 3 Thu
        'Trochę więcej, tak po prostu. Dzisiejszy dzień już był dobry.', // 4 Fri
        'Teraz nie trzeba niczego gonić. Niech te kroki będą lekkie i spokojne.', // 5 Sat
        'Po celu, a dzień jest powolny i spokojny. Pospaceruj, jeśli chcesz, albo odpocznij.', // 6 Sun
      ],
      'round_10000': [
        '10 000 kroków na otwarcie tygodnia. Co za łagodny, hojny początek.', // 0 Mon
        '10 000 kroków. Piękna, okrągła liczba. Pobądź z nią chwilę w ciszy.', // 1 Tue
        'Dziś 10 000 kroków. To wiele cichych chwil, w których dbasz o siebie.', // 2 Wed
        'Co za hojny dzień. 10 000 kroków i każdy z nich był twój.', // 3 Thu
        '10 000 kroków. Dziś nie musisz już robić nic więcej. Po prostu ciesz się tym, ile masz za sobą.', // 4 Fri
        'Pełne, okrągłe 10 000. Powoli czy szybko, to piękne.', // 5 Sat
        '10 000 kroków bez pośpiechu. Niech reszta dnia będzie przytulna i powolna.', // 6 Sun
      ],
      'round_15000': [
        '15 000 kroków, a tydzień dopiero się zaczął. Teraz potraktuj siebie łagodnie.', // 0 Mon
        '15 000 kroków. Taki hojny dzień. Niech jego reszta będzie miękka i lekka.', // 1 Tue
        'Ten dzień dostał od ciebie tak wiele. 15 000 kroków to więcej niż dość.', // 2 Wed
        '15 000 kroków. Może wkrótce chwila w wygodnym fotelu i coś dobrego do picia.', // 3 Thu
        'Długi, pełny dzień chodzenia. Traktuj siebie czule do końca dnia.', // 4 Fri
        '15 000 kroków. Masz za sobą sporo, i to jest wspaniałe.', // 5 Sat
        '15 000 kroków. Piękny, pełny dzień. Czas zwolnić i odpocząć.', // 6 Sun
      ],
      'round_20000': [
        '20 000 kroków na początek tygodnia. Napij się wody i daj odpocząć stopom.', // 0 Mon
        '20 000 kroków. Napij się wody i daj odpocząć stopom, kiedy tylko możesz.', // 1 Tue
        'Co za dzień. Szklanka wody i chwila odpoczynku dla stóp byłyby teraz cudowne.', // 2 Wed
        '20 000 kroków. Stopy niosły cię dziś tak daleko. Pozwól im chwilę odpocząć.', // 3 Thu
        'Dziś tyle za tobą. Trochę wody, wygodny fotel i nic więcej do zrobienia.', // 4 Fri
        '20 000 kroków. Czas na życzliwość wobec siebie. Szklanka wody i cichy odpoczynek.', // 5 Sat
        '20 000 kroków. Coś chłodnego do picia i długi, spokojny odpoczynek dla stóp to teraz idealny plan.', // 6 Sun
      ],
      'round_25000': [
        '25 000 kroków. Wielki początek tygodnia. Trochę wody, a teraz odpoczynek dla stóp.', // 0 Mon
        '25 000 kroków. Zatrzymaj się na łyk wody i pozwól stopom chwilę odpocząć.', // 1 Tue
        'Taki długi dzień na nogach. Usiądź, napij się wody i weź oddech.', // 2 Wed
        '25 000 kroków. Nie ma już czego udowadniać. Woda i odpoczynek są teraz dla ciebie.', // 3 Thu
        'Dziś masz za sobą tak wiele. Potraktuj stopy łagodnie i napij się czegoś.', // 4 Fri
        '25 000 kroków. Trochę wody i długi odpoczynek byłyby teraz cudowne.', // 5 Sat
        '25 000 kroków. Czas na długi, powolny odpoczynek i dużo wody.', // 6 Sun
      ],
      'round_30000': [
        '30 000 kroków. Co za początek tygodnia. Proszę, okaż teraz ciału życzliwość.', // 0 Mon
        '30 000 kroków. Co za niesamowity dzień. Proszę, zadbaj teraz czule o swoje ciało.', // 1 Tue
        '30 000 kroków, naprawdę niezwykle. Odpocznij, napij się wody i traktuj siebie łagodnie.', // 2 Wed
        'Dziś masz za sobą więcej niż dość. Twoje ciało zasługuje na troskę i długi odpoczynek.', // 3 Thu
        '30 000 kroków. To dobra chwila, by się zatrzymać i odpocząć. Okaż ciału życzliwość.', // 4 Fri
        'Taki wyjątkowy dzień. Zadbaj teraz o siebie, wodą i odpoczynkiem.', // 5 Sat
        '30 000 kroków. Niech reszta dnia będzie samym odpoczynkiem. Okaż ciału czułość.', // 6 Sun
      ],
      'care_30k': [
        'Taki wielki dzień. Proszę, okaż ciału życzliwość i pozwól, by tydzień płynął łagodnie.', // 0 Mon
        'Niesamowity dzień. Proszę, zadbaj o swoje ciało i odpocznij, kiedy możesz.', // 1 Tue
        'Masz za sobą naprawdę długą drogę. Daj odpocząć stopom, napij się wody i traktuj siebie łagodnie.', // 2 Wed
        'To więcej niż dość jak na jeden dzień. Możesz już przestać, nic nie zostało niedokończone.', // 3 Thu
        'Twoje ciało niosło cię dziś bardzo daleko. Daj mu odpoczynek i troskę.', // 4 Fri
        'Cokolwiek przyprowadziło cię tak daleko, czas odpocząć. Woda, fotel i życzliwość.', // 5 Sat
        'Tyle kroków za tobą. Niech reszta dnia będzie powolna, spokojna i czuła.', // 6 Sun
      ],
    },
    'cheerful': {
      '2500': [
        'Witaj, nowy tygodniu! Już 2500 kroków. Co za piękny początek.', // 0 Mon
        '2500 kroków! Co za piękny start. Każdy z nich to mały prezent dla ciebie.', // 1 Tue
        'No i ruszamy! Radosny mały początek dnia.', // 2 Wed
        'Cześć, 2500! Tak miło iść dziś razem z tobą.', // 3 Thu
        'Spójrz tylko! Radosny start, krok po kroku, na luzie.', // 4 Fri
        'Już 2500 kroków! Małe kroki, wielki uśmiech. Świetnie ci idzie.', // 5 Sat
        '2500 spokojnych kroków! Dziś bez pośpiechu, po prostu baw się dobrze.', // 6 Sun
      ],
      '5000': [
        '5000! Tydzień zaczął się pięknie. Idzie ci super.', // 0 Mon
        '5000 kroków! Spójrz tylko. Ciesz się powietrzem, niebem i tą dobrą chwilą.', // 1 Tue
        'Przybij piątkę! 5000 pięknych kroków, a ty robisz dla siebie coś dobrego.', // 2 Wed
        '5000! Jaki fajny rytm udało ci się złapać. Ciesz się nim.', // 3 Thu
        'Hura, połowa! Idzie ci znakomicie, dokładnie w twoim tempie.', // 4 Fri
        'Zobacz, ile już masz za sobą! Każdy dzisiejszy krok jest radosny.', // 5 Sat
        '5000 luźnych kroków! Co za miły, spokojny dzień.', // 6 Sun
      ],
      '7500': [
        '7500! Co za radosny początek tygodnia. Już prawie u celu.', // 0 Mon
        '7500 kroków! Już blisko, a to naprawdę powód do zadowolenia.', // 1 Tue
        'Wow, 7500! Jakikolwiek był dzisiejszy dzień, jesteś tu dla siebie. To cudowne.', // 2 Wed
        'Prawie u celu! Ciesz się każdym krokiem, nie ma żadnego pośpiechu.', // 3 Thu
        '7500! Robisz dziś dla siebie coś naprawdę pięknego.', // 4 Fri
        'Spójrz, wciąż w świetnej formie! Każde tempo, które ci pasuje, jest idealne.', // 5 Sat
        '7500 kroków! Spokojnie i na luzie. Bez pośpiechu.', // 6 Sun
      ],
      'goal': [
        'Cel osiągnięty! Co za radosny początek tygodnia. Brawo!', // 0 Mon
        'Udało się! Cel osiągnięty. Cokolwiek jeszcze dziś się działo, to powód do dumy.', // 1 Tue
        'Tak! To twój cel. Co za wspaniała rzecz dla siebie na dziś.', // 2 Wed
        'Cel osiągnięty! Uśmiechnij się szeroko, naprawdę na to zasługujesz.', // 3 Thu
        'Hura! Udało ci się. Odpocznij, świętuj albo po prostu ciesz się tym uczuciem.', // 4 Fri
        'Oto on, twój cel! Naprawdę brawo. Dziś jest dobry dzień.', // 5 Sat
        'Udało się! Teraz połóż nogi wyżej i ciesz się resztą dnia.', // 6 Sun
      ],
      'beyond': [
        'Po celu! Tydzień ruszył z kopyta. Teraz już spokojnie.', // 0 Mon
        'Po celu! Każdy dodatkowy krok jest teraz tylko dla frajdy.', // 1 Tue
        'Cel zrobiony, a ty wciąż spacerujesz? Pięknie. Ciesz się tym, bez żadnej presji.', // 2 Wed
        'Mały spacer w bonusie! Dzisiejszy dzień już jest wygrany, więc na spokojnie.', // 3 Thu
        'Dodatkowe kroki, tak po prostu! Zatrzymaj się, kiedy chcesz, poszło świetnie.', // 4 Fri
        'Spójrz, jesteś za celem! Ten kawałek jest tylko dla radości.', // 5 Sat
        'Bonusowe kroki w spokojny dzień! Pięknie. Odpocznij, kiedy chcesz.', // 6 Sun
      ],
      'round_10000': [
        '10 000 kroków! Co za cudowny początek tygodnia.', // 0 Mon
        '10 000 kroków! Co za piękna okrągła liczba. Ciesz się tą chwilą.', // 1 Tue
        'Wow, 10 000! To piękny dzień pełen chodzenia.', // 2 Wed
        '10 000 kroków! Daj sobie małe brawa, zasługujesz na nie.', // 3 Thu
        'Cześć, 10 000! Co za radosny, hojny dzień.', // 4 Fri
        '10 000! Wielka okrągła liczba, a dziś nie musisz już robić nic więcej.', // 5 Sat
        '10 000 kroków! Czas na przytulną, spokojną resztę dnia.', // 6 Sun
      ],
      'round_15000': [
        '15 000! Tydzień ledwo się zaczął, a spójrz tylko. Teraz odpocznij.', // 0 Mon
        '15 000 kroków! Co za hojny dzień. Niech jego reszta będzie lekka.', // 1 Tue
        'Wow, 15 000! Tyle za tobą, i to jest super.', // 2 Wed
        '15 000! Może niedługo wygodny fotel i coś dobrego do picia? Zasługujesz na to.', // 3 Thu
        'Co za pełny, radosny dzień! 15 000 kroków i każdy był twój.', // 4 Fri
        '15 000 kroków! To powód do dumy. Niech reszta dnia będzie łagodna.', // 5 Sat
        '15 000 kroków! Czas wrzucić na luz i odpocząć. Dość już za tobą.', // 6 Sun
      ],
      'round_20000': [
        '20 000 kroków! Wielki start tygodnia. Najpierw woda, potem odpoczynek dla stóp.', // 0 Mon
        '20 000 kroków! Niesamowite. Napij się wody i daj stopom odpocząć, kiedy możesz.', // 1 Tue
        'Wow, 20 000! Duża szklanka wody i chwila siedzenia brzmią idealnie.', // 2 Wed
        '20 000! Co za dzień. Twoje stopy zasługują na piękny, długi odpoczynek.', // 3 Thu
        'Niesamowity dzień! Napij się wody i połóż nogi wyżej, kiedy możesz.', // 4 Fri
        '20 000 kroków! Czas na trochę czułości dla siebie. Szklanka wody i spokój dla stóp.', // 5 Sat
        '20 000! Weź coś chłodnego do picia i daj stopom piękny, błogi odpoczynek.', // 6 Sun
      ],
      'round_25000': [
        '25 000 kroków! Wow, co za start. Proszę, napij się wody i daj odpocząć stopom.', // 0 Mon
        '25 000 kroków! Niewiarygodne. Łyk wody, a potem spokój dla stóp.', // 1 Tue
        'Wow, 25 000! Czas na wodę, wygodny fotel i duży, przytulny odpoczynek.', // 2 Wed
        '25 000! Twoje stopy przeżyły niezłą przygodę. Teraz pozwól im odpocząć.', // 3 Thu
        'Co za dzień! Proszę, napij się wody i obchodź się czule ze stopami.', // 4 Fri
        '25 000 kroków! To więcej niż dość. Woda i odpoczynek, proszę.', // 5 Sat
        '25 000! Czas na długi, błogi odpoczynek i dużą szklankę wody.', // 6 Sun
      ],
      'round_30000': [
        '30 000 kroków! Niesamowity początek tygodnia. Teraz okaż ciału życzliwość.', // 0 Mon
        '30 000 kroków! Co za niesamowity dzień. Proszę, zadbaj teraz o swoje ciało.', // 1 Tue
        'Wow, 30 000! Niezwykle. Odpoczynek, woda i mnóstwo życzliwości dla siebie.', // 2 Wed
        '30 000! To więcej niż dość. Czas zadbać o siebie.', // 3 Thu
        'Co za wyjątkowy dzień! Twoje ciało zasługuje teraz na długi, przytulny odpoczynek.', // 4 Fri
        '30 000 kroków! Najpierw duma, potem łagodność. Woda i odpoczynek już czekają.', // 5 Sat
        '30 000! Co za dzień. Teraz odpoczynek, relaks i czułość dla ciała.', // 6 Sun
      ],
      'care_30k': [
        'Co za wielki początek tygodnia! Proszę, zadbaj teraz o swoje ciało.', // 0 Mon
        'Co za niesamowity dzień chodzenia! Proszę, okaż teraz ciału życzliwość.', // 1 Tue
        'Tyle dziś za tobą! Daj odpocząć stopom i napij się wody.', // 2 Wed
        'Na dziś więcej niż dość! Czas usiąść, napić się i odpocząć.', // 3 Thu
        'Wow, co za dzień! Zadbaj teraz o siebie, łagodnie.', // 4 Fri
        'Taki wielki dzień! Pozwól ciału odpocząć. Nie ma już nic do zrobienia.', // 5 Sat
        'Tyle kroków! Niech reszta dnia będzie spokojna, przytulna i czuła.', // 6 Sun
      ],
    },
  },
  'de': {
    'calm': {
      '2500': [
        'Eine neue Woche, ein kleiner neuer Anfang. 2.500 Schritte, ganz sanft.', // 0 Mon
        'Schau dich an, schon unterwegs. Jeder Schritt heute ist ein kleines Geschenk an dich.', // 1 Tue
        '2.500 Schritte. Ein sanfter Anfang, ganz für dich. Es gibt keine Eile.', // 2 Wed
        'Der Tag ist mit dir in Bewegung gekommen. Schön, das zu bemerken.', // 3 Thu
        'Schon 2.500 Schritte. Wie es dir auch geht, das ist ein freundlich verbrachter Moment.', // 4 Fri
        'Ein ruhiger Anfang. Auch kleine Schritte zählen, und diese gehören dir.', // 5 Sat
        '2.500 entspannte Schritte. Lass den Tag heute langsam und ohne Eile sein, ganz wie du magst.', // 6 Sun
      ],
      '5000': [
        '5.000 Schritte in eine ganz neue Woche. Du findest sanft deinen Rhythmus.', // 0 Mon
        'Halbzeit. Spür die Luft, den Himmel, wie sich dein Körper anfühlt. Du tust dir etwas Gutes.', // 1 Tue
        '5.000 Schritte. Ruhig und ohne Eile, in deinem eigenen Tempo. Das ist ein stilles Lächeln wert.', // 2 Wed
        'Atme langsam ein und lass diesen Moment leicht sein. Du machst das gut.', // 3 Thu
        '5.000 Schritte, einer nach dem anderen. Danke, dass du dir heute ein wenig Raum gibst.', // 4 Fri
        'Wie weit der Tag auch geht, dieser Teil zählt schon. Sei unterwegs sanft zu dir.', // 5 Sat
        'Ein langsamer, entspannter Tag, und schon 5.000 Schritte. Genieß jeden Moment ohne Eile.', // 6 Sun
      ],
      '7500': [
        '7.500 Schritte. Ein schöner Wochenbeginn, Schritt für Schritt, in Ruhe.', // 0 Mon
        'Jetzt ist es nah. Wie der Tag auch war, du bist drangeblieben, und das zählt.', // 1 Tue
        '7.500 Schritte. Schau, wie weit du heute gekommen bist, ein leiser Schritt nach dem anderen.', // 2 Wed
        'Jeder dieser Schritte war eine kleine Freundlichkeit dir selbst gegenüber. Lass das wirken.', // 3 Thu
        '7.500 Schritte. Das Tempo, das sich für dich richtig anfühlt, ist das richtige.', // 4 Fri
        'Du bist den ganzen Tag für dich da. Das ist eine leise Art von Stärke.', // 5 Sat
        '7.500 Schritte in deinem gemütlichen Tempo. Heute gibt es nichts zu hetzen.', // 6 Sun
      ],
      'goal': [
        'Ziel erreicht, und die Woche hat freundlich begonnen. Sei stolz auf diesen Anfang.', // 0 Mon
        'Geschafft. Was heute auch sonst passiert ist, du warst für dich da. Sei stolz.', // 1 Tue
        'Dein Ziel ist erreicht. Ruh dich jetzt aus, oder genieß einfach den Moment.', // 2 Wed
        'Ziel erreicht. Jeder Schritt, der dich hierher gebracht hat, war deiner. Wirklich gut gemacht.', // 3 Thu
        'Du hast es geschafft. Atme durch und erlaub dir, ein bisschen stolz auf heute zu sein.', // 4 Fri
        'Dein Ziel ist geschafft. Alles ab jetzt ist nur noch Freude, wenn du magst.', // 5 Sat
        'Geschafft, und ganz in Ruhe. Lass den Rest des Tages langsam und schön sein.', // 6 Sun
      ],
      'beyond': [
        'Dein Ziel ist erreicht. Lass den Rest des Tages leicht sein, ein sanfter Wochenstart.', // 0 Mon
        'Dein Ziel ist schon erreicht. Diese Extraschritte sind einfach zum Genießen da.', // 1 Tue
        'Heute musst du nichts mehr beweisen. Wenn du noch gehst, genieß es einfach.', // 2 Wed
        'Jetzt über dem Ziel. Geh so sanft, wie du magst, und hör auf, wann es sich richtig anfühlt.', // 3 Thu
        'Ein bisschen extra, einfach so. Der Tag war schon ein guter.', // 4 Fri
        'Nichts mehr zu jagen. Lass diese Schritte leicht und ohne Eile sein.', // 5 Sat
        'Über dem Ziel an einem ruhigen, entspannten Tag. Schlendere, wenn du magst, oder ruh dich aus.', // 6 Sun
      ],
      'round_10000': [
        '10.000 Schritte zum Wochenbeginn. Was für ein sanfter, großzügiger Anfang.', // 0 Mon
        '10.000 Schritte. Eine schöne, runde Zahl. Nimm dir einen stillen Moment dafür.', // 1 Tue
        'Heute 10.000 Schritte. Das sind viele stille Momente, in denen du gut für dich sorgst.', // 2 Wed
        'Was für ein großzügiger Tag. 10.000 Schritte, und jeder einzelne war deiner.', // 3 Thu
        '10.000 Schritte. Heute musst du nichts mehr tun. Genieß einfach, wie weit du gekommen bist.', // 4 Fri
        'Volle, runde 10.000. Ob langsam oder schnell, es ist schön.', // 5 Sat
        '10.000 Schritte ohne Eile. Lass den Rest des Tages gemütlich und langsam sein.', // 6 Sun
      ],
      'round_15000': [
        '15.000 Schritte, und die Woche hat gerade erst begonnen. Mach jetzt langsam mit dir.', // 0 Mon
        '15.000 Schritte. So ein großzügiger Tag. Lass den Rest weich und leicht sein.', // 1 Tue
        'Du hast dem Tag so viel gegeben. 15.000 Schritte sind mehr als genug.', // 2 Wed
        '15.000 Schritte. Vielleicht bald ein Sitzplatz und etwas Schönes zu trinken.', // 3 Thu
        'Ein langer, voller Tag zu Fuß. Sei für den Rest des Tages sanft zu dir.', // 4 Fri
        '15.000 Schritte. Du hast reichlich getan, und reichlich ist wunderbar.', // 5 Sat
        '15.000 Schritte. Ein schöner, voller Tag. Zeit, ganz langsam zu werden und zu entspannen.', // 6 Sun
      ],
      'round_20000': [
        '20.000 Schritte zum Wochenstart. Trink bitte etwas Wasser und lass deine Füße ruhen.', // 0 Mon
        '20.000 Schritte. Trink bitte etwas Wasser und lass deine Füße ruhen, wenn du kannst.', // 1 Tue
        'Was für ein Tag. Ein Glas Wasser und eine kleine Pause für die Füße wären jetzt schön.', // 2 Wed
        '20.000 Schritte. Deine Füße haben dich so weit getragen. Lass sie eine Weile ruhen.', // 3 Thu
        'Du hast heute so viel getan. Etwas Wasser, ein bequemer Platz, und sonst nichts mehr.', // 4 Fri
        '20.000 Schritte. Zeit, gut zu dir zu sein. Ein Glas Wasser und eine stille Pause.', // 5 Sat
        '20.000 Schritte. Etwas Kühles zu trinken und eine lange, gemütliche Pause für die Füße wären jetzt perfekt.', // 6 Sun
      ],
      'round_25000': [
        '25.000 Schritte. Ein großer Wochenbeginn. Etwas Wasser, und jetzt Ruhe für die Füße.', // 0 Mon
        '25.000 Schritte. Halt kurz für etwas Wasser an und lass die Füße eine Weile ruhen.', // 1 Tue
        'So ein langer Tag auf den Beinen. Setz dich bitte, trink einen Schluck und atme durch.', // 2 Wed
        '25.000 Schritte. Es gibt nichts mehr zu beweisen. Wasser und Ruhe gehören jetzt dir.', // 3 Thu
        'Du bist heute so weit gegangen. Sei sanft zu deinen Füßen und trink etwas.', // 4 Fri
        '25.000 Schritte. Ein wenig Wasser und eine lange Pause wären jetzt schön.', // 5 Sat
        '25.000 Schritte. Zeit für eine lange, langsame Pause und viel Wasser.', // 6 Sun
      ],
      'round_30000': [
        '30.000 Schritte. Was für ein Wochenstart. Sei jetzt bitte gut zu deinem Körper.', // 0 Mon
        '30.000 Schritte. Was für ein wunderbarer Tag. Sei jetzt bitte gut zu deinem Körper.', // 1 Tue
        '30.000 Schritte, wirklich außergewöhnlich. Ruh dich aus, trink etwas Wasser und sei sanft zu dir.', // 2 Wed
        'Du hast heute mehr als genug getan. Dein Körper verdient Fürsorge und eine lange Pause.', // 3 Thu
        '30.000 Schritte. Ein guter Moment, um anzuhalten und zu ruhen. Sei gut zu deinem Körper.', // 4 Fri
        'So ein bemerkenswerter Tag. Pass jetzt gut auf dich auf, mit Wasser und Ruhe.', // 5 Sat
        '30.000 Schritte. Lass den Rest des Tages nur Ruhe sein. Sei gut zu deinem Körper.', // 6 Sun
      ],
      'care_30k': [
        'So ein großer Tag. Sei bitte gut zu deinem Körper und lass die Woche sanft beginnen.', // 0 Mon
        'Ein wunderbarer Tag. Sei bitte gut zu deinem Körper und ruh dich aus, wenn du kannst.', // 1 Tue
        'Du bist so weit gegangen. Lass die Füße ruhen, trink etwas Wasser und sei sanft zu dir.', // 2 Wed
        'Das ist mehr als genug für einen Tag. Du kannst jetzt aufhören, es bleibt nichts offen.', // 3 Thu
        'Dein Körper hat dich heute weit getragen. Gönn ihm Ruhe und Fürsorge.', // 4 Fri
        'Was dich heute auch so weit gebracht hat, jetzt ist Zeit zum Ausruhen. Wasser, ein Platz und Freundlichkeit.', // 5 Sat
        'Du bist so viel gegangen. Lass den Rest des Tages langsam, ruhig und freundlich sein.', // 6 Sun
      ],
    },
    'cheerful': {
      '2500': [
        'Hallo, neue Woche! Schon 2.500 Schritte. Was für ein schöner Start.', // 0 Mon
        '2.500 Schritte! Was für ein schöner Anfang. Jeder davon ist ein kleines Geschenk an dich.', // 1 Tue
        "Und los geht's! Ein fröhlicher kleiner Start in den Tag.", // 2 Wed
        'Hallo, 2.500! Wie schön, heute mit dir unterwegs zu sein.', // 3 Thu
        'Schau dich an! Ein fröhlicher Start, ganz locker Schritt für Schritt.', // 4 Fri
        'Schon 2.500 Schritte! Kleine Schritte, großes Lächeln. Du machst das toll.', // 5 Sat
        '2.500 entspannte Schritte! Heute keine Eile, genieß es einfach.', // 6 Sun
      ],
      '5000': [
        '5.000! Die Woche startet wunderbar. Du bist super unterwegs.', // 0 Mon
        '5.000 Schritte! Schau dich an. Genieß die Luft, den Himmel und diesen schönen Moment.', // 1 Tue
        'High five! 5.000 schöne Schritte, und du tust dir etwas Gutes.', // 2 Wed
        '5.000! Was für einen schönen Rhythmus du gefunden hast. Genieß ihn.', // 3 Thu
        'Juhu, Halbzeit! Du machst das großartig, ganz in deinem Tempo.', // 4 Fri
        'Schau, wie weit du schon gekommen bist! Jeder Schritt heute ist ein fröhlicher.', // 5 Sat
        '5.000 entspannte Schritte! Was für ein schöner, gemütlicher Tag.', // 6 Sun
      ],
      '7500': [
        '7.500! Was für ein fröhlicher Wochenstart. Du bist fast da.', // 0 Mon
        '7.500 Schritte! Jetzt ganz nah, und du kannst richtig zufrieden mit dir sein.', // 1 Tue
        'Wow, 7.500! Wie der Tag auch war, du warst für dich da. Wunderbar.', // 2 Wed
        'Fast geschafft! Genieß jeden Schritt, es gibt gar keine Eile.', // 3 Thu
        '7.500! Du tust heute etwas so Schönes für dich.', // 4 Fri
        'Schau dich an, immer noch voll dabei! Jedes Tempo, das sich gut anfühlt, ist perfekt.', // 5 Sat
        '7.500 Schritte! Schön locker. Ganz ohne Eile.', // 6 Sun
      ],
      'goal': [
        'Ziel erreicht! Was für ein fröhlicher Wochenstart. Gut gemacht!', // 0 Mon
        'Geschafft! Ziel erreicht. Was heute sonst auch war, darauf kannst du stolz sein.', // 1 Tue
        'Ja! Das ist dein Ziel. Was für ein wunderbares Geschenk an dich heute.', // 2 Wed
        'Ziel erreicht! Schenk dir ein breites Lächeln, du hast es dir wirklich verdient.', // 3 Thu
        'Juhu! Du hast es geschafft. Ausruhen, feiern oder einfach das Gefühl genießen.', // 4 Fri
        'Da ist es, dein Ziel! Wirklich gut gemacht. Heute ist ein guter Tag.', // 5 Sat
        'Geschafft! Jetzt Füße hoch und den Rest des Tages genießen.', // 6 Sun
      ],
      'beyond': [
        'Über dem Ziel! Die Woche startet mit Schwung. Jetzt ganz locker.', // 0 Mon
        'Über dem Ziel! Jeder Extraschritt ist jetzt nur noch zum Spaß.', // 1 Tue
        'Ziel geschafft und noch am Schlendern? Schön. Genieß es, ganz ohne Druck.', // 2 Wed
        'Ein kleiner Bonusspaziergang! Heute ist schon gewonnen, also ganz entspannt.', // 3 Thu
        'Extraschritte, einfach so! Hör auf, wann du magst, das war großartig.', // 4 Fri
        'Schau dich an, über dem Ziel! Dieses Stück ist nur zur Freude.', // 5 Sat
        'Bonusschritte an einem entspannten Tag! Schön. Ruh dich aus, wann du magst.', // 6 Sun
      ],
      'round_10000': [
        '10.000 Schritte! Was für ein wunderbarer Wochenbeginn.', // 0 Mon
        '10.000 Schritte! Was für eine schöne runde Zahl. Genieß den Moment.', // 1 Tue
        'Wow, 10.000! Was für ein schöner Tag zu Fuß.', // 2 Wed
        '10.000 Schritte! Gönn dir einen kleinen Jubel, du hast ihn dir verdient.', // 3 Thu
        'Hallo, 10.000! Was für ein fröhlicher, großzügiger Tag.', // 4 Fri
        '10.000! Eine große runde Zahl, und heute musst du sonst nichts mehr tun.', // 5 Sat
        '10.000 Schritte! Zeit für einen gemütlichen, entspannten Rest des Tages.', // 6 Sun
      ],
      'round_15000': [
        '15.000! Die Woche hat kaum begonnen, und schau dich an. Jetzt gut ausruhen.', // 0 Mon
        '15.000 Schritte! Was für ein großzügiger Tag. Lass den Rest leicht sein.', // 1 Tue
        'Wow, 15.000! Das ist eine Menge, und das ist wunderbar.', // 2 Wed
        '15.000! Vielleicht bald ein bequemer Sessel und ein schönes Getränk? Du hast es verdient.', // 3 Thu
        'Was für ein voller, heller Tag! 15.000 Schritte, und jeder war deiner.', // 4 Fri
        '15.000 Schritte! Darauf kannst du stolz sein. Lass den Rest des Tages sanft sein.', // 5 Sat
        '15.000 Schritte! Zeit, die Beine hochzulegen und zu entspannen. Du hast genug getan.', // 6 Sun
      ],
      'round_20000': [
        '20.000 Schritte! Großer Wochenstart. Erst Wasser, dann Ruhe für die Füße.', // 0 Mon
        '20.000 Schritte! Toll. Trink etwas Wasser und lass die Füße ruhen, wenn du kannst.', // 1 Tue
        'Wow, 20.000! Ein großes Glas Wasser und kurz hinsetzen klingt perfekt.', // 2 Wed
        '20.000! Was für ein Tag. Deine Füße verdienen eine schöne lange Pause.', // 3 Thu
        'Toller Tag! Hol dir etwas Wasser und leg die Füße hoch, wenn du kannst.', // 4 Fri
        '20.000 Schritte! Zeit, lieb zu dir zu sein. Ein Glas Wasser, und dann eine Pause.', // 5 Sat
        '20.000! Hol dir etwas Kühles und gönn deinen Füßen eine schöne gemütliche Pause.', // 6 Sun
      ],
      'round_25000': [
        '25.000 Schritte! Wow, was für ein Start. Trink bitte Wasser und lass die Füße ruhen.', // 0 Mon
        '25.000 Schritte! Unglaublich. Trink einen Schluck Wasser und gönn den Füßen Ruhe.', // 1 Tue
        'Wow, 25.000! Zeit für Wasser, einen Sitzplatz und eine große, gemütliche Pause.', // 2 Wed
        '25.000! Deine Füße hatten ein ganz schönes Abenteuer. Lass sie jetzt ruhen.', // 3 Thu
        'Was für ein Tag! Trink bitte etwas Wasser und sei sanft zu deinen Füßen.', // 4 Fri
        '25.000 Schritte! Du hast mehr als genug getan. Wasser und Ruhe, bitte.', // 5 Sat
        '25.000! Zeit für eine lange, gemütliche Pause und ein großes Glas Wasser.', // 6 Sun
      ],
      'round_30000': [
        '30.000 Schritte! Toller Wochenstart. Sei jetzt gut zu deinem Körper.', // 0 Mon
        '30.000 Schritte! Was für ein wunderbarer Tag. Sei jetzt bitte gut zu deinem Körper.', // 1 Tue
        'Wow, 30.000! Außergewöhnlich. Ruhe, Wasser und ganz viel Freundlichkeit zu dir.', // 2 Wed
        '30.000! Das ist mehr als genug. Zeit, auf dich aufzupassen.', // 3 Thu
        'Was für ein bemerkenswerter Tag! Dein Körper verdient jetzt eine lange, gemütliche Pause.', // 4 Fri
        '30.000 Schritte! Sei stolz, und dann sanft. Wasser und Ruhe warten schon.', // 5 Sat
        '30.000! Was für ein Tag. Jetzt ausruhen, entspannen und gut zu deinem Körper sein.', // 6 Sun
      ],
      'care_30k': [
        'Was für ein großer Wochenstart! Sei jetzt bitte gut zu deinem Körper.', // 0 Mon
        'Was für ein wunderbarer Tag zu Fuß! Pass jetzt bitte gut auf deinen Körper auf.', // 1 Tue
        'Du bist heute so weit gekommen! Lass die Füße ruhen und trink etwas Wasser.', // 2 Wed
        'Mehr als genug für heute! Zeit zum Hinsetzen, Trinken und Ausruhen.', // 3 Thu
        'Wow, was für ein Tag! Pass jetzt gut auf dich auf, ganz sanft.', // 4 Fri
        'So ein großer Tag! Lass deinen Körper ruhen. Es gibt nichts mehr zu tun.', // 5 Sat
        'So viele Schritte! Lass den Rest des Tages gemütlich, kuschelig und freundlich sein.', // 6 Sun
      ],
    },
  },
  'es': {
    'calm': {
      '2500': [
        'Una semana nueva, un pequeño comienzo. 2500 pasos, con suavidad.', // 0 Mon
        'Mírate, ya en camino. Cada paso de hoy es un pequeño regalo para ti.', // 1 Tue
        '2500 pasos. Un comienzo suave, y todo tuyo. No hay ninguna prisa.', // 2 Wed
        'El día se ha puesto en marcha contigo. Qué bonito darse cuenta.', // 3 Thu
        'Ya 2500 pasos. Te sientas como te sientas, es una forma amable de pasar el rato.', // 4 Fri
        'Un comienzo tranquilo. Los pasos pequeños también cuentan, y estos son tuyos.', // 5 Sat
        '2500 pasos tranquilos. Que hoy sea lento y sin prisas, justo como te gusta.', // 6 Sun
      ],
      '5000': [
        '5000 pasos en una semana recién estrenada. Vas encontrando tu ritmo, con calma.', // 0 Mon
        'A mitad de camino. Fíjate en el aire, en el cielo, en cómo se siente tu cuerpo. Estás haciendo algo bueno por ti.', // 1 Tue
        '5000 pasos. Con calma y sin prisa, a tu manera. Eso merece una sonrisa tranquila.', // 2 Wed
        'Respira despacio y deja que este momento sea ligero. Lo estás haciendo bien.', // 3 Thu
        '5000 pasos, uno a uno. Gracias por regalarte hoy un poco de espacio.', // 4 Fri
        'Llegue hasta donde llegue el día, esta parte ya cuenta. Trátate con cariño por el camino.', // 5 Sat
        'Un día lento y tranquilo, y ya 5000 pasos. Disfruta cada momento sin prisa.', // 6 Sun
      ],
      '7500': [
        '7500 pasos. Una forma preciosa de empezar la semana, paso a paso, con calma.', // 0 Mon
        'Ya queda poco. Haya sido como haya sido el día, has seguido, y eso importa.', // 1 Tue
        '7500 pasos. Mira todo lo que has avanzado hoy, un paso tranquilo tras otro.', // 2 Wed
        'Cada uno de estos pasos fue un pequeño gesto de cariño contigo. Siéntelo.', // 3 Thu
        '7500 pasos. El ritmo que te resulte cómodo es el ritmo correcto.', // 4 Fri
        'Llevas todo el día cuidándote. Esa es una fuerza tranquila.', // 5 Sat
        '7500 pasos a tu ritmo, sin agobios. Hoy no hay nada por lo que correr.', // 6 Sun
      ],
      'goal': [
        'Meta alcanzada, y la semana empieza con cariño. Qué buen comienzo.', // 0 Mon
        'Lo lograste. Pasara lo que pasara hoy, estuviste ahí para ti. Date ese reconocimiento.', // 1 Tue
        'Esa es tu meta, alcanzada. Descansa ahora, o simplemente disfruta del momento.', // 2 Wed
        'Meta alcanzada. Cada paso que te trajo hasta aquí fue tuyo. Muy bien hecho, de verdad.', // 3 Thu
        'Lo has conseguido. Respira y permítete sentir un poco de orgullo por hoy.', // 4 Fri
        'Tu meta está cumplida. Todo lo que venga ahora es solo por el gusto de hacerlo, si quieres.', // 5 Sat
        'Lo lograste, y con calma. Que el resto del día sea lento y bonito.', // 6 Sun
      ],
      'beyond': [
        'Tu meta está cumplida. Que el resto del día sea ligero, un comienzo suave de semana.', // 0 Mon
        'Tu meta ya está cumplida. Estos pasos de más son solo para disfrutarlos.', // 1 Tue
        'Hoy ya no tienes nada que demostrar. Si sigues caminando, simplemente disfrútalo.', // 2 Wed
        'Ya superaste tu meta. Ve tan suave como quieras, y para cuando te parezca bien.', // 3 Thu
        'Un poquito más, porque sí. Hoy ya ha sido un buen día.', // 4 Fri
        'Ya no hay nada que perseguir. Que estos pasos sean ligeros y sin prisa.', // 5 Sat
        'Más allá de tu meta, en un día lento y tranquilo. Pasea si te apetece, o simplemente descansa.', // 6 Sun
      ],
      'round_10000': [
        '10.000 pasos para abrir la semana. Qué comienzo tan suave y generoso.', // 0 Mon
        '10.000 pasos. Un número bonito y redondo. Quédate un momento con eso.', // 1 Tue
        'Hoy, 10.000 pasos. Son muchos momentos tranquilos dedicados a cuidarte.', // 2 Wed
        'Qué día tan generoso. 10.000 pasos, y cada uno fue tuyo.', // 3 Thu
        '10.000 pasos. Hoy no necesitas hacer nada más. Disfruta de todo lo que has avanzado.', // 4 Fri
        'Unos 10.000 completos y redondos. Despacio o deprisa, es precioso.', // 5 Sat
        '10.000 pasos sin prisa. Que el resto del día sea acogedor y lento.', // 6 Sun
      ],
      'round_15000': [
        '15.000 pasos, y la semana acaba de empezar. Ahora tómatelo con calma.', // 0 Mon
        '15.000 pasos. Qué día tan generoso. Que el resto sea suave y ligero.', // 1 Tue
        'Le has dado tanto a este día. 15.000 pasos es más que suficiente.', // 2 Wed
        '15.000 pasos. Quizá pronto un descanso en un buen asiento, con algo rico de beber.', // 3 Thu
        'Un día largo y lleno de pasos. Trátate con suavidad el resto del día.', // 4 Fri
        '15.000 pasos. Has hecho mucho, y eso es maravilloso.', // 5 Sat
        '15.000 pasos. Un día precioso y completo. Es hora de bajar el ritmo y relajarte.', // 6 Sun
      ],
      'round_20000': [
        '20.000 pasos para empezar la semana. Bebe un poco de agua y descansa los pies.', // 0 Mon
        '20.000 pasos. Bebe un poco de agua y descansa los pies cuando puedas.', // 1 Tue
        'Qué día. Un vaso de agua y un pequeño descanso para los pies vendrían genial ahora.', // 2 Wed
        '20.000 pasos. Tus pies te han llevado muy lejos. Déjalos descansar un rato.', // 3 Thu
        'Has hecho tanto hoy. Un poco de agua, un asiento cómodo y nada más que hacer.', // 4 Fri
        '20.000 pasos. Es momento de ser amable contigo. Un vaso de agua y un descanso tranquilo.', // 5 Sat
        '20.000 pasos. Una bebida fresca y un descanso largo y tranquilo para los pies serían perfectos ahora.', // 6 Sun
      ],
      'round_25000': [
        '25.000 pasos. Un gran comienzo de semana. Un poco de agua, y ahora descansa los pies.', // 0 Mon
        '25.000 pasos. Haz una pausa para beber agua y deja descansar los pies un rato.', // 1 Tue
        'Un día tan largo de pie. Siéntate, bebe un sorbo de agua y respira.', // 2 Wed
        '25.000 pasos. No queda nada por demostrar. El agua y el descanso son tuyos ahora.', // 3 Thu
        'Has caminado mucho hoy. Sé suave con tus pies y bebe algo.', // 4 Fri
        '25.000 pasos. Un poco de agua y un buen descanso serían preciosos ahora.', // 5 Sat
        '25.000 pasos. Hora de un descanso largo y lento, y mucha agua.', // 6 Sun
      ],
      'round_30000': [
        '30.000 pasos. Qué comienzo de semana. Por favor, sé amable con tu cuerpo ahora.', // 0 Mon
        '30.000 pasos. Qué día tan increíble. Por favor, sé amable con tu cuerpo.', // 1 Tue
        '30.000 pasos, algo realmente extraordinario. Descansa, bebe agua y trátate con suavidad.', // 2 Wed
        'Hoy has hecho más que suficiente. Tu cuerpo merece cuidado y un largo descanso.', // 3 Thu
        '30.000 pasos. Es un buen momento para parar y descansar. Sé amable con tu cuerpo.', // 4 Fri
        'Qué día tan especial. Cuídate ahora, con agua y descanso.', // 5 Sat
        '30.000 pasos. Que el resto del día sea solo descanso. Cuida bien de tu cuerpo.', // 6 Sun
      ],
      'care_30k': [
        'Qué día tan grande. Por favor, sé amable con tu cuerpo y deja que la semana avance con suavidad.', // 0 Mon
        'Un día increíble. Por favor, sé amable con tu cuerpo y descansa cuando puedas.', // 1 Tue
        'Has caminado muchísimo. Descansa los pies, bebe agua y trátate con suavidad.', // 2 Wed
        'Es más que suficiente para un día. Ya puedes parar, no queda nada pendiente.', // 3 Thu
        'Tu cuerpo te ha llevado muy lejos hoy. Dale descanso y cuidado.', // 4 Fri
        'Te haya traído lo que te haya traído hasta aquí, es hora de descansar. Agua, un asiento y cariño.', // 5 Sat
        'Has caminado tanto. Que el resto del día sea lento, tranquilo y amable.', // 6 Sun
      ],
    },
    'cheerful': {
      '2500': [
        '¡Hola, semana nueva! Ya 2500 pasos. Qué buena manera de empezar.', // 0 Mon
        '¡2500 pasos! Qué comienzo tan bonito. Cada uno es un pequeño regalo para ti.', // 1 Tue
        '¡Y allá vamos! Un comienzo alegre para tu día.', // 2 Wed
        '¡Hola, 2500! Qué gusto caminar contigo hoy.', // 3 Thu
        '¡Mírate! Un comienzo alegre, paso a paso, sin esfuerzo.', // 4 Fri
        '¡Ya 2500 pasos! Pasos pequeños, sonrisa grande. Lo estás haciendo genial.', // 5 Sat
        '¡2500 pasos tranquilos! Hoy sin prisas, solo disfruta.', // 6 Sun
      ],
      '5000': [
        '¡5000! La semana empieza de maravilla. Vas genial.', // 0 Mon
        '¡5000 pasos! Mírate. Disfruta del aire, del cielo y de este buen momento.', // 1 Tue
        '¡Choca esos cinco! 5000 pasos preciosos, y estás haciendo algo bueno por ti.', // 2 Wed
        '¡5000! Qué buen ritmo has encontrado. Disfrútalo.', // 3 Thu
        '¡Bien, la mitad! Lo estás haciendo de maravilla, a tu propio ritmo.', // 4 Fri
        '¡Mira todo lo que llevas ya! Cada paso de hoy es un paso feliz.', // 5 Sat
        '¡5000 pasos relajados! Qué día tan agradable y tranquilo.', // 6 Sun
      ],
      '7500': [
        '¡7500! Qué comienzo de semana tan alegre. Ya casi llegas.', // 0 Mon
        '¡7500 pasos! Ya queda muy poco, y puedes sentirte muy bien contigo.', // 1 Tue
        '¡Guau, 7500! Haya sido como haya sido el día, aquí estás. Es maravilloso.', // 2 Wed
        '¡Ya casi! Disfruta cada paso, no hay ninguna prisa.', // 3 Thu
        '¡7500! Estás haciendo algo precioso por ti hoy.', // 4 Fri
        '¡Mírate, con toda la energía! El ritmo que te siente bien es perfecto.', // 5 Sat
        '¡7500 pasos! Con calma y sin agobios. Sin ninguna prisa.', // 6 Sun
      ],
      'goal': [
        '¡Meta alcanzada! Qué forma tan feliz de empezar la semana. ¡Bien hecho!', // 0 Mon
        '¡Lo lograste! Meta alcanzada. Pasara lo que pasara hoy, esto es motivo de orgullo.', // 1 Tue
        '¡Sí! Esa es tu meta. Qué cosa tan bonita has hecho hoy por ti.', // 2 Wed
        '¡Meta alcanzada! Regálate una gran sonrisa, de verdad te la has ganado.', // 3 Thu
        '¡Bravo! Lo conseguiste. Descansa, celebra o simplemente disfruta la sensación.', // 4 Fri
        '¡Ahí está, tu meta! Muy bien hecho, de verdad. Hoy es un buen día.', // 5 Sat
        '¡Lo lograste! Ahora sube los pies y disfruta del resto del día.', // 6 Sun
      ],
      'beyond': [
        '¡Más allá de la meta! La semana arranca a lo grande. Ahora con calma.', // 0 Mon
        '¡Meta superada! Cada paso extra ahora es solo por diversión.', // 1 Tue
        '¿Meta cumplida y sigues paseando? Qué bien. Disfrútalo, sin ninguna presión.', // 2 Wed
        '¡Un paseíto extra! Hoy ya es un día ganado, así que con calma.', // 3 Thu
        '¡Pasos extra, porque sí! Para cuando quieras, lo has hecho genial.', // 4 Fri
        '¡Mírate, más allá de tu meta! Este tramo es solo por el placer de hacerlo.', // 5 Sat
        '¡Pasos de regalo en un día tranquilo! Qué bien. Descansa cuando quieras.', // 6 Sun
      ],
      'round_10000': [
        '¡10.000 pasos! Qué manera tan maravillosa de empezar la semana.', // 0 Mon
        '¡10.000 pasos! Qué número tan bonito y redondo. Tómate un momento para disfrutarlo.', // 1 Tue
        '¡Guau, 10.000! Es un día precioso de caminar.', // 2 Wed
        '¡10.000 pasos! Date un pequeño aplauso, te lo has ganado.', // 3 Thu
        '¡Hola, 10.000! Qué día tan feliz y generoso ha sido.', // 4 Fri
        '¡10.000! Un gran número redondo, y hoy no necesitas hacer nada más.', // 5 Sat
        '¡10.000 pasos! Que el resto del día sea acogedor y tranquilo.', // 6 Sun
      ],
      'round_15000': [
        '¡15.000! La semana apenas empieza, y mírate. Ahora a descansar.', // 0 Mon
        '¡15.000 pasos! Qué día tan generoso. Que el resto sea ligero.', // 1 Tue
        '¡Guau, 15.000! Has hecho muchísimo, y eso es genial.', // 2 Wed
        '¡15.000! ¿Pronto un sillón cómodo y algo rico de beber? Te lo mereces.', // 3 Thu
        '¡Qué día tan lleno y luminoso! 15.000 pasos, y cada uno fue tuyo.', // 4 Fri
        '¡15.000 pasos! Es motivo de orgullo. Que el resto del día sea suave.', // 5 Sat
        '¡15.000 pasos! Hora de relajarte y descansar. Ya has hecho bastante.', // 6 Sun
      ],
      'round_20000': [
        '¡20.000 pasos! Gran comienzo de semana. Primero agua, luego descanso para los pies.', // 0 Mon
        '¡20.000 pasos! Increíble. Bebe agua y descansa los pies cuando puedas.', // 1 Tue
        '¡Guau, 20.000! Un buen vaso de agua y un ratito de descanso suenan perfectos.', // 2 Wed
        '¡20.000! Qué día. Tus pies se merecen un descanso largo y bonito.', // 3 Thu
        '¡Qué día tan increíble! Toma un poco de agua y sube los pies cuando puedas.', // 4 Fri
        '¡20.000 pasos! Hora de mimarte. Un vaso de agua y luego un buen descanso.', // 5 Sat
        '¡20.000! Tómate algo fresquito y regala a tus pies un descanso de lo más tranquilo.', // 6 Sun
      ],
      'round_25000': [
        '¡25.000 pasos! Guau, qué comienzo. Por favor, bebe agua y descansa los pies.', // 0 Mon
        '¡25.000 pasos! Increíble. Toma un trago de agua y deja descansar los pies.', // 1 Tue
        '¡Guau, 25.000! Hora de agua, un asiento y un descanso grande y acogedor.', // 2 Wed
        '¡25.000! Tus pies han vivido toda una aventura. Déjalos descansar ahora.', // 3 Thu
        '¡Qué día! Por favor, bebe un poco de agua y sé suave con tus pies.', // 4 Fri
        '¡25.000 pasos! Has hecho más que suficiente. Agua y descanso, por favor.', // 5 Sat
        '¡25.000! Hora de un descanso largo y tranquilo, y un buen vaso de agua.', // 6 Sun
      ],
      'round_30000': [
        '¡30.000 pasos! Un comienzo de semana increíble. Sé amable con tu cuerpo ahora.', // 0 Mon
        '¡30.000 pasos! Qué día tan increíble. Por favor, sé amable con tu cuerpo ahora.', // 1 Tue
        '¡Guau, 30.000! Extraordinario. Descanso, agua y mucho cariño para ti.', // 2 Wed
        '¡30.000! Es más que suficiente. Hora de cuidarte.', // 3 Thu
        '¡Qué día tan especial! Tu cuerpo se merece ahora un descanso largo y acogedor.', // 4 Fri
        '¡30.000 pasos! Primero el orgullo, luego la calma. El agua y el descanso te esperan.', // 5 Sat
        '¡30.000! Qué día. Ahora descansa, relájate y sé amable con tu cuerpo.', // 6 Sun
      ],
      'care_30k': [
        '¡Qué comienzo de semana tan grande! Por favor, sé amable con tu cuerpo ahora.', // 0 Mon
        '¡Qué día tan increíble de caminar! Por favor, cuida de tu cuerpo ahora.', // 1 Tue
        '¡Has llegado muy lejos hoy! Descansa los pies y bebe un poco de agua.', // 2 Wed
        '¡Más que suficiente por hoy! Hora de sentarte, beber algo y descansar.', // 3 Thu
        '¡Guau, qué día! Cuídate ahora, con suavidad.', // 4 Fri
        '¡Qué día tan grande! Deja descansar tu cuerpo. Ya no hay nada más que hacer.', // 5 Sat
        '¡Cuántos pasos! Que el resto del día sea tranquilo, acogedor y amable.', // 6 Sun
      ],
    },
  },
  'fr': {
    'calm': {
      '2500': [
        'Une nouvelle semaine, un petit début. 2 500 pas, tout en douceur.', // 0 Mon
        "Regardez, vous voilà en route. Chaque pas d'aujourd'hui est un petit cadeau pour vous.", // 1 Tue
        "2 500 pas. Un début tranquille, rien qu'à vous. Rien ne presse.", // 2 Wed
        "La journée s'est mise en marche avec vous. C'est agréable à remarquer.", // 3 Thu
        "Déjà 2 500 pas. Quelle que soit votre humeur, c'est une jolie façon de passer le temps.", // 4 Fri
        'Un début paisible. Les petits pas comptent aussi, et ceux-ci sont les vôtres.', // 5 Sat
        "2 500 pas tranquilles. Que la journée soit lente et douce, comme vous l'aimez.", // 6 Sun
      ],
      '5000': [
        '5 000 pas dans une semaine toute neuve. Vous trouvez votre rythme, en douceur.', // 0 Mon
        "À mi-chemin. Remarquez l'air, le ciel, ce que ressent votre corps. Vous faites quelque chose de bien pour vous.", // 1 Tue
        '5 000 pas. Calmement, sans hâte, à votre façon. Cela mérite un sourire tranquille.', // 2 Wed
        'Respirez lentement et laissez ce moment rester léger. Vous vous en sortez très bien.', // 3 Thu
        "5 000 pas, un à la fois. Merci de vous offrir un peu d'espace aujourd'hui.", // 4 Fri
        'Quoi que la journée vous réserve, cette partie compte déjà. Accordez-vous de la douceur en chemin.', // 5 Sat
        'Une journée lente et paisible, et déjà 5 000 pas. Savourez chaque instant sans hâte.', // 6 Sun
      ],
      '7500': [
        '7 500 pas. Une belle façon de commencer la semaine, pas à pas, avec calme.', // 0 Mon
        "Plus très loin. Quelle qu'ait été la journée, vous avez continué, et c'est précieux.", // 1 Tue
        "7 500 pas. Regardez tout ce chemin parcouru aujourd'hui, un pas tranquille après l'autre.", // 2 Wed
        'Chacun de ces pas était une petite attention envers vous. Prenez le temps de le sentir.', // 3 Thu
        '7 500 pas. Le rythme qui vous convient est le bon.', // 4 Fri
        "Vous prenez soin de vous depuis ce matin. C'est une force tranquille.", // 5 Sat
        "7 500 pas à votre rythme, sans pression. Rien ne vous presse aujourd'hui.", // 6 Sun
      ],
      'goal': [
        'Objectif atteint, et la semaine commence avec douceur. Un beau départ.', // 0 Mon
        "C'est fait. Quoi qu'il se soit passé aujourd'hui, vous avez été là pour vous. Accordez-vous ce mérite.", // 1 Tue
        "Voilà votre objectif, atteint. Reposez-vous maintenant, ou savourez simplement l'instant.", // 2 Wed
        "Objectif atteint. Chaque pas jusqu'ici était le vôtre. Vraiment bravo.", // 3 Thu
        "Objectif atteint. Respirez, et laissez-vous un peu de fierté pour aujourd'hui.", // 4 Fri
        "Votre objectif est atteint. Tout le reste, c'est pour le plaisir, si l'envie vous en dit.", // 5 Sat
        "C'est fait, et en douceur. Que le reste de la journée soit lent et agréable.", // 6 Sun
      ],
      'beyond': [
        'Votre objectif est atteint. Que le reste de la journée soit léger, un doux début de semaine.', // 0 Mon
        'Votre objectif est déjà atteint. Ces pas en plus sont juste pour le plaisir.', // 1 Tue
        "Plus rien à prouver aujourd'hui. Si vous continuez à marcher, profitez-en simplement.", // 2 Wed
        'Objectif dépassé. Allez aussi doucement que vous le souhaitez, et arrêtez-vous quand bon vous semble.', // 3 Thu
        'Encore un petit peu, juste pour le plaisir. La journée est déjà belle.', // 4 Fri
        'Plus rien à poursuivre. Que ces pas soient légers et sans hâte.', // 5 Sat
        "Au-delà de l'objectif, un jour lent et paisible. Flânez si l'envie vous prend, ou reposez-vous.", // 6 Sun
      ],
      'round_10000': [
        '10 000 pas pour ouvrir la semaine. Un début doux et généreux.', // 0 Mon
        '10 000 pas. Un joli chiffre rond. Savourez-le un instant.', // 1 Tue
        "10 000 pas aujourd'hui. Autant de moments tranquilles passés à prendre soin de vous.", // 2 Wed
        'Quelle journée généreuse. 10 000 pas, et chacun était le vôtre.', // 3 Thu
        "10 000 pas. Rien de plus à faire aujourd'hui. Profitez de tout ce chemin.", // 4 Fri
        "Un beau 10 000 tout rond. Lentement ou vite, c'est magnifique.", // 5 Sat
        '10 000 pas sans hâte. Que le reste de la journée soit douillet et lent.', // 6 Sun
      ],
      'round_15000': [
        '15 000 pas, et la semaine ne fait que commencer. Prenez votre temps maintenant.', // 0 Mon
        '15 000 pas. Quelle journée généreuse. Que la suite soit douce et légère.', // 1 Tue
        "Vous avez tant donné à cette journée. 15 000 pas, c'est largement suffisant.", // 2 Wed
        '15 000 pas. Bientôt peut-être une pause dans un bon fauteuil, avec une boisson agréable.', // 3 Thu
        'Une longue journée bien remplie. Ménagez-vous pour le reste de la journée.', // 4 Fri
        "15 000 pas. Vous avez fait beaucoup, et c'est merveilleux.", // 5 Sat
        "15 000 pas. Une belle journée bien remplie. C'est le moment de ralentir.", // 6 Sun
      ],
      'round_20000': [
        "20 000 pas pour commencer la semaine. Buvez un peu d'eau et reposez vos pieds.", // 0 Mon
        "20 000 pas. Buvez un peu d'eau et reposez vos pieds dès que possible.", // 1 Tue
        "Quelle journée. Un verre d'eau et une petite pause pour les pieds feraient du bien maintenant.", // 2 Wed
        '20 000 pas. Vos pieds ont fait un si long chemin. Laissez-les se reposer un moment.', // 3 Thu
        "Vous avez tant fait aujourd'hui. Un peu d'eau, un siège confortable, et plus rien à faire.", // 4 Fri
        "20 000 pas. C'est le moment de vous ménager. Un verre d'eau et une pause tranquille.", // 5 Sat
        '20 000 pas. Une boisson fraîche et une longue pause pour vos pieds, ce serait parfait.', // 6 Sun
      ],
      'round_25000': [
        "25 000 pas. Un grand début de semaine. Un peu d'eau, et maintenant reposez vos pieds.", // 0 Mon
        '25 000 pas. Faites une pause pour boire et laissez vos pieds se reposer un moment.', // 1 Tue
        "Une si longue journée debout. Asseyez-vous, buvez une gorgée d'eau et respirez.", // 2 Wed
        "25 000 pas. Plus rien à prouver. L'eau et le repos vous attendent.", // 3 Thu
        "Vous avez beaucoup marché aujourd'hui. Ménagez vos pieds et buvez quelque chose.", // 4 Fri
        "25 000 pas. Un peu d'eau et un bon repos, ce serait idéal maintenant.", // 5 Sat
        "25 000 pas. L'heure d'une longue pause tranquille, et de beaucoup d'eau.", // 6 Sun
      ],
      'round_30000': [
        '30 000 pas. Quel début de semaine. Prenez bien soin de votre corps maintenant.', // 0 Mon
        '30 000 pas. Quelle journée incroyable. Prenez bien soin de votre corps.', // 1 Tue
        "30 000 pas, c'est vraiment exceptionnel. Reposez-vous, buvez de l'eau et ménagez-vous.", // 2 Wed
        "Vous en avez fait plus qu'assez aujourd'hui. Votre corps mérite de l'attention et un long repos.", // 3 Thu
        "30 000 pas. C'est un bon moment pour s'arrêter et se reposer. Prenez soin de votre corps.", // 4 Fri
        "Quelle journée particulière. Prenez soin de vous maintenant, avec de l'eau et du repos.", // 5 Sat
        '30 000 pas. Que le reste de la journée soit fait de repos. Prenez soin de votre corps.', // 6 Sun
      ],
      'care_30k': [
        'Quelle grande journée. Prenez soin de votre corps et laissez la semaine avancer en douceur.', // 0 Mon
        'Une journée incroyable. Prenez soin de votre corps et reposez-vous dès que possible.', // 1 Tue
        "Vous avez énormément marché. Reposez vos pieds, buvez de l'eau et ménagez-vous.", // 2 Wed
        "C'est largement assez pour une journée. Vous pouvez vous arrêter, plus rien n'attend.", // 3 Thu
        "Votre corps a fait un très long chemin aujourd'hui. Offrez-lui du repos et de l'attention.", // 4 Fri
        "Quelle que soit la raison de ces pas, c'est l'heure du repos. De l'eau, un siège et de la douceur.", // 5 Sat
        'Vous avez tant marché. Que le reste de la journée soit lent, calme et doux.', // 6 Sun
      ],
    },
    'cheerful': {
      '2500': [
        'Bonjour la nouvelle semaine ! Déjà 2 500 pas. Quelle belle façon de commencer.', // 0 Mon
        '2 500 pas ! Quel joli début. Chacun est un petit cadeau pour vous.', // 1 Tue
        "Et c'est parti ! Un début joyeux pour votre journée.", // 2 Wed
        "Bonjour, 2 500 ! Quel plaisir de marcher avec vous aujourd'hui.", // 3 Thu
        'Regardez-vous ! Un début joyeux, pas à pas, sans effort.', // 4 Fri
        'Déjà 2 500 pas ! Petits pas, grand sourire. Vous vous débrouillez très bien.', // 5 Sat
        "2 500 pas tranquilles ! Rien ne presse aujourd'hui, profitez simplement.", // 6 Sun
      ],
      '5000': [
        "5 000 ! La semaine commence à merveille. C'est super.", // 0 Mon
        "5 000 pas ! Regardez-vous. Profitez de l'air, du ciel et de ce bon moment.", // 1 Tue
        'Tope là ! 5 000 jolis pas, et vous faites quelque chose de bien pour vous.', // 2 Wed
        '5 000 ! Quel beau rythme vous avez trouvé. Savourez-le.', // 3 Thu
        'Hourra, la moitié ! Vous vous en sortez à merveille, à votre propre rythme.', // 4 Fri
        "Regardez tout ce chemin déjà ! Chaque pas d'aujourd'hui est un pas joyeux.", // 5 Sat
        '5 000 pas détendus ! Quelle journée agréable et tranquille.', // 6 Sun
      ],
      '7500': [
        '7 500 ! Quel joyeux début de semaine. Vous y êtes presque.', // 0 Mon
        "7 500 pas ! C'est presque fini, et c'est une belle satisfaction.", // 1 Tue
        "Waouh, 7 500 ! Quelle qu'ait été la journée, vous voilà. C'est formidable.", // 2 Wed
        'Presque ! Savourez chaque pas, rien ne presse.', // 3 Thu
        "7 500 ! Vous faites quelque chose de très beau pour vous aujourd'hui.", // 4 Fri
        'Quelle énergie ! Le rythme qui vous fait du bien est parfait.', // 5 Sat
        '7 500 pas ! Tranquille et sans pression. Rien ne presse du tout.', // 6 Sun
      ],
      'goal': [
        'Objectif atteint ! Quelle belle façon de commencer la semaine. Bravo !', // 0 Mon
        "C'est fait ! Objectif atteint. Quoi qu'il se soit passé aujourd'hui, c'est une vraie fierté.", // 1 Tue
        "Oui ! Voilà votre objectif. Quel beau cadeau vous vous êtes fait aujourd'hui.", // 2 Wed
        "Objectif atteint ! Offrez-vous un grand sourire, c'est bien mérité.", // 3 Thu
        "Bravo ! C'est réussi. Reposez-vous, fêtez ça, ou savourez simplement ce moment.", // 4 Fri
        "Le voilà, votre objectif ! Vraiment bravo. Aujourd'hui est une belle journée.", // 5 Sat
        "C'est fait ! Maintenant, les pieds en l'air et profitez du reste de la journée.", // 6 Sun
      ],
      'beyond': [
        "Au-delà de l'objectif ! La semaine démarre en beauté. Doucement maintenant.", // 0 Mon
        "Objectif dépassé ! Chaque pas en plus, c'est juste pour le plaisir.", // 1 Tue
        'Objectif atteint et encore en balade ? Super. Profitez-en, sans aucune pression.', // 2 Wed
        'Une petite balade en bonus ! La journée est déjà gagnée, alors doucement.', // 3 Thu
        "Des pas en plus, juste pour le plaisir ! Arrêtez-vous quand vous voulez, c'est formidable.", // 4 Fri
        "Regardez-vous, au-delà de l'objectif ! Ce bout de chemin, c'est pour le plaisir.", // 5 Sat
        'Des pas en bonus un jour tranquille ! Très bien. Reposez-vous quand vous voulez.', // 6 Sun
      ],
      'round_10000': [
        '10 000 pas ! Quelle merveilleuse façon de commencer la semaine.', // 0 Mon
        '10 000 pas ! Quel joli chiffre rond. Prenez un instant pour le savourer.', // 1 Tue
        "Waouh, 10 000 ! C'est une belle journée de marche.", // 2 Wed
        "10 000 pas ! Offrez-vous un petit applaudissement, c'est mérité.", // 3 Thu
        'Bonjour, 10 000 ! Quelle journée joyeuse et généreuse.', // 4 Fri
        "10 000 ! Un beau chiffre rond, et plus rien à faire aujourd'hui.", // 5 Sat
        '10 000 pas ! Que le reste de la journée soit douillet et tranquille.', // 6 Sun
      ],
      'round_15000': [
        '15 000 ! La semaine commence à peine, et regardez-vous. Place au repos.', // 0 Mon
        '15 000 pas ! Quelle journée généreuse. Que la suite soit légère.', // 1 Tue
        "Waouh, 15 000 ! Vous avez fait énormément, c'est génial.", // 2 Wed
        '15 000 ! Bientôt un fauteuil douillet et une bonne boisson ? Vous le méritez.', // 3 Thu
        'Quelle journée lumineuse et bien remplie ! 15 000 pas, et chacun était le vôtre.', // 4 Fri
        '15 000 pas ! De quoi sourire de cette journée. Que la suite soit douce.', // 5 Sat
        "15 000 pas ! L'heure de se détendre et de se reposer. Vous en avez assez fait.", // 6 Sun
      ],
      'round_20000': [
        "20 000 pas ! Superbe début de semaine. D'abord de l'eau, puis du repos pour les pieds.", // 0 Mon
        "20 000 pas ! Incroyable. Buvez de l'eau et reposez vos pieds dès que possible.", // 1 Tue
        "Waouh, 20 000 ! Un grand verre d'eau et une petite pause, ce serait parfait.", // 2 Wed
        '20 000 ! Quelle journée. Vos pieds méritent une longue et belle pause.', // 3 Thu
        "Quelle journée incroyable ! Un peu d'eau, et les pieds en l'air dès que possible.", // 4 Fri
        "20 000 pas ! L'heure de vous chouchouter. Un verre d'eau, puis une bonne pause.", // 5 Sat
        '20 000 ! Une boisson fraîche, et offrez à vos pieds la pause la plus tranquille qui soit.', // 6 Sun
      ],
      'round_25000': [
        "25 000 pas ! Waouh, quel début. Buvez de l'eau et reposez vos pieds, s'il vous plaît.", // 0 Mon
        "25 000 pas ! Incroyable. Une gorgée d'eau, et laissez vos pieds se reposer.", // 1 Tue
        "Waouh, 25 000 ! L'heure de l'eau, d'un siège et d'une grande pause douillette.", // 2 Wed
        '25 000 ! Vos pieds ont vécu toute une aventure. Laissez-les se reposer maintenant.', // 3 Thu
        "Quelle journée ! Buvez un peu d'eau et ménagez vos pieds, s'il vous plaît.", // 4 Fri
        "25 000 pas ! Vous en avez fait plus qu'assez. De l'eau et du repos, s'il vous plaît.", // 5 Sat
        "25 000 ! L'heure d'une longue pause tranquille, avec un grand verre d'eau.", // 6 Sun
      ],
      'round_30000': [
        '30 000 pas ! Un début de semaine incroyable. Prenez soin de votre corps maintenant.', // 0 Mon
        '30 000 pas ! Quelle journée incroyable. Prenez bien soin de votre corps maintenant.', // 1 Tue
        "Waouh, 30 000 ! Exceptionnel. Du repos, de l'eau et beaucoup de douceur pour vous.", // 2 Wed
        "30 000 ! C'est largement assez. L'heure de prendre soin de vous.", // 3 Thu
        'Quelle journée particulière ! Votre corps mérite maintenant un long repos douillet.', // 4 Fri
        "30 000 pas ! D'abord la fierté, ensuite le calme. L'eau et le repos vous attendent.", // 5 Sat
        '30 000 ! Quelle journée. Maintenant, reposez-vous, détendez-vous et prenez soin de votre corps.', // 6 Sun
      ],
      'care_30k': [
        'Quel grand début de semaine ! Prenez bien soin de votre corps maintenant.', // 0 Mon
        'Quelle journée de marche incroyable ! Prenez soin de votre corps maintenant.', // 1 Tue
        "Quel chemin parcouru aujourd'hui ! Reposez vos pieds et buvez un peu d'eau.", // 2 Wed
        "Largement assez pour aujourd'hui ! L'heure de s'asseoir, de boire et de se reposer.", // 3 Thu
        'Waouh, quelle journée ! Prenez soin de vous maintenant, tout doucement.', // 4 Fri
        "Quelle grande journée ! Laissez votre corps se reposer. Plus rien d'autre à faire.", // 5 Sat
        'Que de pas ! Que le reste de la journée soit calme, douillet et doux.', // 6 Sun
      ],
    },
  },
  'it': {
    'calm': {
      '2500': [
        'Una settimana nuova, un piccolo inizio. 2.500 passi, con dolcezza.', // 0 Mon
        'Guardati, sei già in cammino. Ogni passo di oggi è un piccolo regalo per te.', // 1 Tue
        "2.500 passi. Un inizio delicato, tutto tuo. Non c'è nessuna fretta.", // 2 Wed
        'La giornata si è messa in moto insieme a te. È bello accorgersene.', // 3 Thu
        'Già 2.500 passi. Comunque ti senta, è un modo gentile di passare il tempo.', // 4 Fri
        'Un inizio tranquillo. Anche i piccoli passi contano, e questi sono tuoi.', // 5 Sat
        '2.500 passi tranquilli. Che oggi sia lento e senza fretta, proprio come ti piace.', // 6 Sun
      ],
      '5000': [
        '5.000 passi in una settimana nuova di zecca. Stai trovando il tuo ritmo, con calma.', // 0 Mon
        "A metà strada. Nota l'aria, il cielo, come si sente il tuo corpo. Stai facendo qualcosa di buono per te.", // 1 Tue
        '5.000 passi. Con calma e senza fretta, a modo tuo. Merita un sorriso tranquillo.', // 2 Wed
        'Respira piano e lascia che questo momento resti leggero. Stai andando benissimo.', // 3 Thu
        "5.000 passi, uno alla volta. Che bello, un po' di spazio tutto per te oggi.", // 4 Fri
        'Ovunque ti porti la giornata, questa parte conta già. Sii gentile con te lungo la strada.', // 5 Sat
        'Una giornata lenta e tranquilla, e già 5.000 passi. Goditi ogni momento senza fretta.', // 6 Sun
      ],
      '7500': [
        '7.500 passi. Un bel modo di iniziare la settimana, passo dopo passo, con calma.', // 0 Mon
        'Manca poco. Comunque sia andata la giornata, hai continuato, e questo conta.', // 1 Tue
        "7.500 passi. Guarda quanta strada hai fatto oggi, un passo tranquillo dopo l'altro.", // 2 Wed
        'Ognuno di questi passi è stato un piccolo gesto di cura verso di te. Sentilo.', // 3 Thu
        '7.500 passi. Il ritmo che ti fa stare bene è quello giusto.', // 4 Fri
        'Ti stai prendendo cura di te per tutto il giorno. È una forza tranquilla.', // 5 Sat
        "7.500 passi al tuo ritmo, senza pressioni. Oggi non c'è niente per cui correre.", // 6 Sun
      ],
      'goal': [
        'Obiettivo raggiunto, e la settimana inizia con dolcezza. Che bel modo di cominciare.', // 0 Mon
        "Ce l'hai fatta. Qualunque cosa sia successa oggi, hai pensato a te. Riconoscitelo.", // 1 Tue
        'Ecco il tuo obiettivo, raggiunto. Ora riposa, o goditi semplicemente il momento.', // 2 Wed
        'Obiettivo raggiunto. Ogni passo fin qui è stato tuo. Davvero, complimenti.', // 3 Thu
        "Ce l'hai fatta. Respira, e concediti un po' di orgoglio per oggi.", // 4 Fri
        'Il tuo obiettivo è raggiunto. Tutto il resto è solo per il piacere di farlo, se ti va.', // 5 Sat
        "Ce l'hai fatta, e con calma. Che il resto della giornata sia lento e bello.", // 6 Sun
      ],
      'beyond': [
        'Il tuo obiettivo è raggiunto. Che il resto del giorno sia leggero, un dolce inizio di settimana.', // 0 Mon
        'Il tuo obiettivo è già raggiunto. Questi passi in più sono solo da godersi.', // 1 Tue
        'Oggi non hai più niente da dimostrare. Se continui a camminare, goditelo e basta.', // 2 Wed
        'Hai già superato il tuo obiettivo. Vai piano quanto vuoi, e fermati quando ti sembra giusto.', // 3 Thu
        'Ancora un pochino, solo perché sì. Oggi è già stata una bella giornata.', // 4 Fri
        "Non c'è più niente da inseguire. Che questi passi siano leggeri e senza fretta.", // 5 Sat
        "Oltre l'obiettivo, in un giorno lento e tranquillo. Passeggia se ti va, o semplicemente riposa.", // 6 Sun
      ],
      'round_10000': [
        '10.000 passi per aprire la settimana. Che inizio dolce e generoso.', // 0 Mon
        '10.000 passi. Un bel numero tondo. Resta un momento con questa sensazione.', // 1 Tue
        'Oggi 10.000 passi. Sono tanti momenti tranquilli passati a prenderti cura di te.', // 2 Wed
        'Che giornata generosa. 10.000 passi, e ognuno è stato tuo.', // 3 Thu
        '10.000 passi. Oggi non serve fare altro. Goditi tutta la strada fatta.', // 4 Fri
        'Un bel 10.000 tondo tondo. Piano o veloce, è bellissimo.', // 5 Sat
        '10.000 passi senza fretta. Che il resto della giornata sia accogliente e lento.', // 6 Sun
      ],
      'round_15000': [
        '15.000 passi, e la settimana è appena cominciata. Adesso prenditela con calma.', // 0 Mon
        '15.000 passi. Che giornata generosa. Che il resto sia dolce e leggero.', // 1 Tue
        'Hai dato tanto a questa giornata. 15.000 passi sono più che abbastanza.', // 2 Wed
        '15.000 passi. Forse presto una pausa su una bella poltrona, con qualcosa di buono da bere.', // 3 Thu
        'Una giornata lunga e piena. Trattati con dolcezza per il resto del giorno.', // 4 Fri
        '15.000 passi. Hai fatto tanto, ed è meraviglioso.', // 5 Sat
        '15.000 passi. Una giornata bella e piena. È il momento di rallentare e rilassarti.', // 6 Sun
      ],
      'round_20000': [
        "20.000 passi per iniziare la settimana. Bevi un po' d'acqua e fai riposare i piedi.", // 0 Mon
        "20.000 passi. Bevi un po' d'acqua e fai riposare i piedi quando puoi.", // 1 Tue
        "Che giornata. Un bicchiere d'acqua e una piccola pausa per i piedi farebbero bene adesso.", // 2 Wed
        "20.000 passi. I tuoi piedi hanno fatto tanta strada. Lasciali riposare un po'.", // 3 Thu
        "Hai fatto tanto oggi. Un po' d'acqua, un posto comodo e nient'altro da fare.", // 4 Fri
        "20.000 passi. È il momento di essere gentile con te. Un bicchiere d'acqua e una pausa tranquilla.", // 5 Sat
        '20.000 passi. Una bibita fresca e una lunga pausa tranquilla per i piedi sarebbero perfette.', // 6 Sun
      ],
      'round_25000': [
        "25.000 passi. Un grande inizio di settimana. Un po' d'acqua, e adesso riposa i piedi.", // 0 Mon
        "25.000 passi. Fai una pausa per bere e lascia riposare i piedi per un po'.", // 1 Tue
        "Una giornata così lunga in piedi. Siediti, bevi un sorso d'acqua e respira.", // 2 Wed
        '25.000 passi. Non resta niente da dimostrare. Acqua e riposo ora sono tuoi.', // 3 Thu
        'Hai camminato tanto oggi. Tratta con delicatezza i tuoi piedi e bevi qualcosa.', // 4 Fri
        "25.000 passi. Un po' d'acqua e un buon riposo sarebbero bellissimi adesso.", // 5 Sat
        "25.000 passi. È l'ora di una pausa lunga e lenta, e di tanta acqua.", // 6 Sun
      ],
      'round_30000': [
        '30.000 passi. Che inizio di settimana. Adesso, per favore, sii gentile con il tuo corpo.', // 0 Mon
        '30.000 passi. Che giornata incredibile. Per favore, sii gentile con il tuo corpo.', // 1 Tue
        '30.000 passi, qualcosa di davvero straordinario. Riposa, bevi acqua e trattati con dolcezza.', // 2 Wed
        'Oggi hai fatto più che abbastanza. Il tuo corpo merita cura e un lungo riposo.', // 3 Thu
        '30.000 passi. È un buon momento per fermarsi e riposare. Sii gentile con il tuo corpo.', // 4 Fri
        'Che giornata speciale. Prenditi cura di te adesso, con acqua e riposo.', // 5 Sat
        '30.000 passi. Che il resto della giornata sia solo riposo. Prenditi cura del tuo corpo.', // 6 Sun
      ],
      'care_30k': [
        'Che grande giornata. Sii gentile con il tuo corpo e lascia che la settimana scorra piano.', // 0 Mon
        'Una giornata incredibile. Sii gentile con il tuo corpo e riposa quando puoi.', // 1 Tue
        'Hai camminato tantissimo. Riposa i piedi, bevi acqua e trattati con dolcezza.', // 2 Wed
        "È più che abbastanza per un giorno. Puoi fermarti, non c'è più niente in sospeso.", // 3 Thu
        'Il tuo corpo ha fatto tanta strada oggi. Dagli riposo e cura.', // 4 Fri
        'Qualunque sia il motivo di questi passi, ora è il momento di riposare. Acqua, un posto comodo e dolcezza.', // 5 Sat
        'Hai camminato così tanto. Che il resto della giornata sia lento, calmo e gentile.', // 6 Sun
      ],
    },
    'cheerful': {
      '2500': [
        'Ciao, settimana nuova! Già 2.500 passi. Che bel modo di cominciare.', // 0 Mon
        "2.500 passi! Che bell'inizio. Ognuno è un piccolo regalo per te.", // 1 Tue
        'E si parte! Un inizio allegro per la tua giornata.', // 2 Wed
        'Ciao, 2.500! Che bello camminare con te oggi.', // 3 Thu
        'Guardati! Un inizio allegro, passo dopo passo, senza fatica.', // 4 Fri
        'Già 2.500 passi! Piccoli passi, grande sorriso. Stai andando alla grande.', // 5 Sat
        '2.500 passi tranquilli! Oggi niente fretta, goditela e basta.', // 6 Sun
      ],
      '5000': [
        '5.000! La settimana parte alla grande. Stai andando benissimo.', // 0 Mon
        "5.000 passi! Guardati. Goditi l'aria, il cielo e questo bel momento.", // 1 Tue
        'Batti cinque! 5.000 bei passi, e stai facendo qualcosa di buono per te.', // 2 Wed
        '5.000! Che bel ritmo hai trovato. Goditelo.', // 3 Thu
        'Evviva, a metà! Stai andando a meraviglia, con il tuo ritmo.', // 4 Fri
        'Guarda quanta strada già! Ogni passo di oggi è un passo felice.', // 5 Sat
        '5.000 passi rilassati! Che giornata piacevole e tranquilla.', // 6 Sun
      ],
      '7500': [
        '7.500! Che allegro inizio di settimana. Ci sei quasi.', // 0 Mon
        '7.500 passi! Manca pochissimo, e puoi sentirti davvero bene.', // 1 Tue
        'Wow, 7.500! Comunque sia andata la giornata, eccoti qui. È fantastico.', // 2 Wed
        "Quasi! Goditi ogni passo, non c'è nessuna fretta.", // 3 Thu
        '7.500! Oggi stai facendo qualcosa di bellissimo per te.', // 4 Fri
        'Che energia! Il ritmo che ti fa stare bene è perfetto.', // 5 Sat
        '7.500 passi! Con calma e senza pressioni. Nessuna fretta.', // 6 Sun
      ],
      'goal': [
        'Obiettivo raggiunto! Che modo felice di iniziare la settimana. Complimenti!', // 0 Mon
        "Ce l'hai fatta! Obiettivo raggiunto. Qualunque cosa sia successa oggi, è un vero motivo d'orgoglio.", // 1 Tue
        'Sì! Ecco il tuo obiettivo. Che bella cosa hai fatto per te oggi.', // 2 Wed
        'Obiettivo raggiunto! Regalati un grande sorriso, te lo sei proprio meritato.', // 3 Thu
        "Evviva! Ce l'hai fatta. Riposa, festeggia o goditi semplicemente la sensazione.", // 4 Fri
        'Eccolo, il tuo obiettivo! Davvero, complimenti. Oggi è una bella giornata.', // 5 Sat
        "Ce l'hai fatta! Adesso piedi in alto, e goditi il resto della giornata.", // 6 Sun
      ],
      'beyond': [
        "Oltre l'obiettivo! La settimana parte alla grande. Adesso con calma.", // 0 Mon
        'Obiettivo superato! Ogni passo in più adesso è solo per divertimento.', // 1 Tue
        'Obiettivo raggiunto e ancora a passeggio? Bellissimo. Goditela, senza nessuna pressione.', // 2 Wed
        'Una passeggiatina extra! La giornata è già vinta, quindi con calma.', // 3 Thu
        'Passi in più, solo perché sì! Fermati quando vuoi, è stato fantastico.', // 4 Fri
        'Guardati, oltre il tuo obiettivo! Questo tratto è solo per il piacere di farlo.', // 5 Sat
        'Passi in regalo in un giorno tranquillo! Che bello. Riposa quando vuoi.', // 6 Sun
      ],
      'round_10000': [
        '10.000 passi! Che modo meraviglioso di iniziare la settimana.', // 0 Mon
        '10.000 passi! Che bel numero tondo. Prenditi un momento per goderlo.', // 1 Tue
        'Wow, 10.000! È una bellissima giornata di cammino.', // 2 Wed
        '10.000 passi! Concediti un piccolo applauso, te lo sei meritato.', // 3 Thu
        'Ciao, 10.000! Che giornata felice e generosa.', // 4 Fri
        '10.000! Un bel numero tondo, e oggi non serve fare altro.', // 5 Sat
        '10.000 passi! Che il resto della giornata sia accogliente e tranquillo.', // 6 Sun
      ],
      'round_15000': [
        '15.000! La settimana è appena iniziata, e guardati. Adesso spazio al riposo.', // 0 Mon
        '15.000 passi! Che giornata generosa. Che il resto sia leggero.', // 1 Tue
        'Wow, 15.000! Hai fatto tantissimo, ed è fantastico.', // 2 Wed
        '15.000! Presto una poltrona comoda e qualcosa di buono da bere? Te lo meriti.', // 3 Thu
        'Che giornata piena e luminosa! 15.000 passi, e ognuno è stato tuo.', // 4 Fri
        "15.000 passi! Un motivo d'orgoglio. Che il resto della giornata sia dolce.", // 5 Sat
        '15.000 passi! È ora di rilassarti e riposare. Hai fatto abbastanza.', // 6 Sun
      ],
      'round_20000': [
        '20.000 passi! Grande inizio di settimana. Prima acqua, poi riposo per i piedi.', // 0 Mon
        "20.000 passi! Incredibile. Bevi un po' d'acqua e riposa i piedi quando puoi.", // 1 Tue
        "Wow, 20.000! Un bel bicchiere d'acqua e una piccola pausa sembrano perfetti.", // 2 Wed
        '20.000! Che giornata. I tuoi piedi meritano una pausa lunga e bella.', // 3 Thu
        "Che giornata incredibile! Un po' d'acqua, e piedi in alto appena puoi.", // 4 Fri
        "20.000 passi! È ora di coccolarti. Un bicchiere d'acqua, poi una bella pausa.", // 5 Sat
        '20.000! Una bibita fresca, e regala ai tuoi piedi la pausa più tranquilla che ci sia.', // 6 Sun
      ],
      'round_25000': [
        '25.000 passi! Wow, che inizio. Per favore, bevi acqua e riposa i piedi.', // 0 Mon
        "25.000 passi! Incredibile. Un sorso d'acqua, e lascia riposare i piedi.", // 1 Tue
        "Wow, 25.000! È l'ora di acqua, un posto comodo e una lunga pausa accogliente.", // 2 Wed
        '25.000! I tuoi piedi hanno vissuto una vera avventura. Lasciali riposare adesso.', // 3 Thu
        "Che giornata! Per favore, bevi un po' d'acqua e tratta con delicatezza i tuoi piedi.", // 4 Fri
        '25.000 passi! Hai fatto più che abbastanza. Acqua e riposo, per favore.', // 5 Sat
        "25.000! È l'ora di una pausa lunga e tranquilla, con un bel bicchiere d'acqua.", // 6 Sun
      ],
      'round_30000': [
        '30.000 passi! Un inizio di settimana incredibile. Sii gentile con il tuo corpo adesso.', // 0 Mon
        '30.000 passi! Che giornata incredibile. Per favore, sii gentile con il tuo corpo adesso.', // 1 Tue
        'Wow, 30.000! Straordinario. Riposo, acqua e tanta dolcezza per te.', // 2 Wed
        '30.000! È più che abbastanza. È ora di prenderti cura di te.', // 3 Thu
        'Che giornata speciale! Il tuo corpo adesso merita un riposo lungo e accogliente.', // 4 Fri
        "30.000 passi! Prima l'orgoglio, poi la calma. Acqua e riposo ti aspettano.", // 5 Sat
        '30.000! Che giornata. Adesso riposa, rilassati e sii gentile con il tuo corpo.', // 6 Sun
      ],
      'care_30k': [
        'Che grande inizio di settimana! Per favore, sii gentile con il tuo corpo adesso.', // 0 Mon
        'Che giornata di cammino incredibile! Per favore, prenditi cura del tuo corpo adesso.', // 1 Tue
        "Quanta strada oggi! Riposa i piedi e bevi un po' d'acqua.", // 2 Wed
        'Più che abbastanza per oggi! È ora di sedersi, bere qualcosa e riposare.', // 3 Thu
        'Wow, che giornata! Prenditi cura di te adesso, con dolcezza.', // 4 Fri
        "Che grande giornata! Lascia riposare il tuo corpo. Non c'è altro da fare.", // 5 Sat
        'Quanti passi! Che il resto della giornata sia calmo, accogliente e gentile.', // 6 Sun
      ],
    },
  },
};
