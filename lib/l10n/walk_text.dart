/// Walk-with-intention copy. Unknown language falls back to English.
/// Moods: clear, gratitude, move, slow, energy. 7 lines each, index 0 = Monday ... 6 = Sunday.
library;

const walkMoodIds = ['clear', 'gratitude', 'move', 'slow', 'energy'];

const walkLines = <String, Map<String, List<String>>>{
  'en': {
    'clear': [
      'A clear head for a new week. Thank you for taking this time.', // 0 Mon
      'Hopefully your mind feels a little lighter now. Thank you for giving it some space.', // 1 Tue
      'A little room to think, all your own. Well done for taking it.', // 2 Wed
      'Whatever you carried into this walk, may it feel a little lighter now.', // 3 Thu
      'Some quiet steps, some quiet thoughts. That was time well spent.', // 4 Fri
      'Thank you for giving your thoughts some room to breathe.', // 5 Sat
      'No hurry, no noise, just your own thoughts. Lovely.', // 6 Sun
    ],
    'gratitude': [
      'A thankful start to the week. What a gentle gift to give yourself.', // 0 Mon
      'Thank you for taking this time for yourself. It mattered.', // 1 Tue
      'A walk full of small good things. May you carry a few of them with you.', // 2 Wed
      'What a lovely thing, to walk with a thankful heart.', // 3 Thu
      'Even the smallest good things are worth noticing, and you noticed them.', // 4 Fri
      'Thank you for this gentle walk. The world is a little kinder with you in it.', // 5 Sat
      'A slow, thankful walk. May the rest of the day feel just as kind.', // 6 Sun
    ],
    'move': [
      "A walk to start the week. That's a lovely little promise to yourself.", // 0 Mon
      'Every step counted. Nice work, truly.', // 1 Tue
      "You moved, and that's what matters. Be proud of that.", // 2 Wed
      "You chose to move today. That's a kind thing to do for yourself.", // 3 Thu
      'Short or long, every walk is a good walk. Well done.', // 4 Fri
      'There, you did it. A little movement, and a lot of kindness to yourself.', // 5 Sat
      'An easy walk on an easy day. Just right for today.', // 6 Sun
    ],
    'slow': [
      'A slow walk to ease into the week. How lovely.', // 0 Mon
      'Gentle and unhurried. Just right.', // 1 Tue
      'You gave yourself some calm. Hold on to it a little longer.', // 2 Wed
      'Slow steps, soft thoughts. What a lovely way to spend some time.', // 3 Thu
      'No rush, no pressure. Just you and a quiet walk. Beautiful.', // 4 Fri
      "You let yourself slow down. That's a quiet kind of wisdom.", // 5 Sat
      'Slow and lazy, the best kind of walk. Enjoy the calm.', // 6 Sun
    ],
    'energy': [
      'What a lively way to start the week! Well done.', // 0 Mon
      'That should wake you up nicely! Well done.', // 1 Tue
      'Feel that spark? Lovely work!', // 2 Wed
      'What a bright little boost! You did that for yourself.', // 3 Thu
      'Brilliant! What a lively, cheerful walk.', // 4 Fri
      'Look at you, full of go! That was a great walk.', // 5 Sat
      'A happy burst of energy on an easy day! Lovely.', // 6 Sun
    ],
  },
  'sk': {
    'clear': [
      'Čistá hlava do nového týždňa. Vďaka, že ste si na to našli čas.', // 0 Mon
      'Snáď máte teraz o čosi ľahšiu myseľ. Vďaka, že ste jej dali trochu priestoru.', // 1 Tue
      'Trochu priestoru na premýšľanie, len pre vás. Dobre, že ste si ho dopriali.', // 2 Wed
      'Nech ste si na túto prechádzku priniesli čokoľvek, nech je to teraz o niečo ľahšie.', // 3 Thu
      'Pár tichých krokov, pár tichých myšlienok. To bol dobre strávený čas.', // 4 Fri
      'Vďaka, že ste svojim myšlienkam dopriali trochu voľnosti.', // 5 Sat
      'Žiadny zhon, žiadny hluk, len vaše vlastné myšlienky. Krásne.', // 6 Sun
    ],
    'gratitude': [
      'Vďačný začiatok týždňa. Aký jemný darček pre seba.', // 0 Mon
      'Vďaka, že ste si vzali tento čas pre seba. Malo to zmysel.', // 1 Tue
      'Prechádzka plná malých dobrých vecí. Nech si pár z nich odnesiete so sebou.', // 2 Wed
      'Aká krásna vec, kráčať s vďačným srdcom.', // 3 Thu
      'Aj tie najmenšie dobré veci stoja za povšimnutie, a vy ste si ich všimli.', // 4 Fri
      'Vďaka za túto jemnú prechádzku. Svet je s vami o kúsok láskavejší.', // 5 Sat
      'Pomalá, vďačná prechádzka. Nech je zvyšok dňa rovnako láskavý.', // 6 Sun
    ],
    'move': [
      'Prechádzka na začiatok týždňa. To je krásny malý sľub sebe samým.', // 0 Mon
      'Každý krok sa počítal. Naozaj pekná práca.', // 1 Tue
      'Hýbali ste sa, a na tom záleží. Buďte na to hrdí.', // 2 Wed
      'Dnes ste sa rozhodli hýbať. To je láskavé rozhodnutie pre seba.', // 3 Thu
      'Krátka či dlhá, každá prechádzka je dobrá prechádzka. Výborne.', // 4 Fri
      'A je to. Trochu pohybu a veľa láskavosti k sebe.', // 5 Sat
      'Ľahká prechádzka v pohodovom dni. Presne akurát.', // 6 Sun
    ],
    'slow': [
      'Pomalá prechádzka na vkĺznutie do týždňa. Aké krásne.', // 0 Mon
      'Jemne a bez ponáhľania. Presne tak.', // 1 Tue
      'Dopriali ste si trochu pokoja. Podržte si ho ešte chvíľu.', // 2 Wed
      'Pomalé kroky, jemné myšlienky. Aký krásny spôsob, ako stráviť čas.', // 3 Thu
      'Žiadny zhon, žiadny tlak. Len vy a tichá prechádzka. Nádhera.', // 4 Fri
      'Dovolili ste si spomaliť. To je tichá múdrosť.', // 5 Sat
      'Pomaly a pohodovo, najlepší druh prechádzky. Užite si ten pokoj.', // 6 Sun
    ],
    'energy': [
      'Aký svieži začiatok týždňa! Výborne.', // 0 Mon
      'To by vás malo pekne prebudiť! Výborne.', // 1 Tue
      'Cítite tú iskru? Krásna práca!', // 2 Wed
      'Aké veselé malé nabitie! To ste urobili pre seba.', // 3 Thu
      'Skvelé! Aká živá, veselá prechádzka.', // 4 Fri
      'Len sa pozrite, koľko energie! To bola skvelá prechádzka.', // 5 Sat
      'Radostný príval energie v pohodovom dni! Krásne.', // 6 Sun
    ],
  },
  'cs': {
    'clear': [
      'Čistá hlava do nového týdne. Díky, že jste si na to našli čas.', // 0 Mon
      'Snad máte teď o něco lehčí mysl. Díky, že jste jí dali trochu prostoru.', // 1 Tue
      'Trochu prostoru na přemýšlení, jen pro vás. Dobře, že jste si ho dopřáli.', // 2 Wed
      'Ať jste si na tuhle procházku přinesli cokoli, ať je to teď o něco lehčí.', // 3 Thu
      'Pár tichých kroků, pár tichých myšlenek. To byl dobře strávený čas.', // 4 Fri
      'Díky, že jste svým myšlenkám dopřáli trochu volnosti.', // 5 Sat
      'Žádný spěch, žádný hluk, jen vaše vlastní myšlenky. Krásné.', // 6 Sun
    ],
    'gratitude': [
      'Vděčný začátek týdne. Jaký jemný dárek pro sebe.', // 0 Mon
      'Díky, že jste si vzali tenhle čas pro sebe. Mělo to smysl.', // 1 Tue
      'Procházka plná malých dobrých věcí. Ať si pár z nich odnesete s sebou.', // 2 Wed
      'Jaká krásná věc, jít s vděčným srdcem.', // 3 Thu
      'I ty nejmenší dobré věci stojí za povšimnutí, a vy jste si jich všimli.', // 4 Fri
      'Díky za tuhle jemnou procházku. Svět je s vámi o kousek laskavější.', // 5 Sat
      'Pomalá, vděčná procházka. Ať je zbytek dne stejně laskavý.', // 6 Sun
    ],
    'move': [
      'Procházka na začátek týdne. To je krásný malý slib sobě samým.', // 0 Mon
      'Každý krok se počítal. Opravdu pěkná práce.', // 1 Tue
      'Hýbali jste se, a na tom záleží. Buďte na to hrdí.', // 2 Wed
      'Dnes jste se rozhodli hýbat. To je laskavé rozhodnutí pro sebe.', // 3 Thu
      'Krátká nebo dlouhá, každá procházka je dobrá procházka. Výborně.', // 4 Fri
      'A je to. Trochu pohybu a hodně laskavosti k sobě.', // 5 Sat
      'Lehká procházka v pohodovém dni. Přesně akorát.', // 6 Sun
    ],
    'slow': [
      'Pomalá procházka na rozjezd týdne. Jak krásné.', // 0 Mon
      'Jemně a bez spěchu. Přesně tak.', // 1 Tue
      'Dopřáli jste si trochu klidu. Podržte si ho ještě chvíli.', // 2 Wed
      'Pomalé kroky, jemné myšlenky. Jaký krásný způsob, jak strávit čas.', // 3 Thu
      'Žádný spěch, žádný tlak. Jen vy a tichá procházka. Nádhera.', // 4 Fri
      'Dovolili jste si zpomalit. To je tichá moudrost.', // 5 Sat
      'Pomalu a v pohodě, nejlepší druh procházky. Užijte si ten klid.', // 6 Sun
    ],
    'energy': [
      'Jaký svěží začátek týdne! Výborně.', // 0 Mon
      'To by vás mělo hezky probrat! Výborně.', // 1 Tue
      'Cítíte tu jiskru? Krásná práce!', // 2 Wed
      'Jaké veselé malé nabití! To jste udělali pro sebe.', // 3 Thu
      'Skvělé! Jaká živá, veselá procházka.', // 4 Fri
      'Jen se podívejte, kolik energie! To byla skvělá procházka.', // 5 Sat
      'Radostný příval energie v pohodovém dni! Krásné.', // 6 Sun
    ],
  },
  'pl': {
    'clear': [
      'Jasna głowa na nowy tydzień. Dzięki, że znajdujesz na to czas.', // 0 Mon
      'Oby umysł był teraz trochę lżejszy. Dzięki, że dajesz mu trochę przestrzeni.', // 1 Tue
      'Trochę miejsca na myśli, tylko dla ciebie. Dobrze, że udało się je znaleźć.', // 2 Wed
      'Cokolwiek niesiesz w sobie na tym spacerze, niech teraz będzie trochę lżejsze.', // 3 Thu
      'Kilka cichych kroków, kilka cichych myśli. To był dobrze spędzony czas.', // 4 Fri
      'Dzięki, że dajesz swoim myślom trochę oddechu.', // 5 Sat
      'Bez pośpiechu, bez hałasu, tylko twoje własne myśli. Pięknie.', // 6 Sun
    ],
    'gratitude': [
      'Wdzięczny początek tygodnia. Co za łagodny prezent dla siebie.', // 0 Mon
      'Dzięki, że ten czas jest dla ciebie. To miało znaczenie.', // 1 Tue
      'Spacer pełen małych dobrych rzeczy. Niech kilka z nich zostanie z tobą.', // 2 Wed
      'Co za piękna rzecz, iść z wdzięcznym sercem.', // 3 Thu
      'Nawet najmniejsze dobre rzeczy warto zauważać, a te zostały zauważone.', // 4 Fri
      'Dzięki za ten łagodny spacer. Świat jest z tobą odrobinę życzliwszy.', // 5 Sat
      'Powolny, wdzięczny spacer. Niech reszta dnia będzie równie życzliwa.', // 6 Sun
    ],
    'move': [
      'Spacer na początek tygodnia. To piękna mała obietnica dla siebie.', // 0 Mon
      'Każdy krok się liczył. Naprawdę dobra robota.', // 1 Tue
      'Był ruch, i to się liczy. To powód do dumy.', // 2 Wed
      'Dziś wybór padł na ruch. To życzliwa decyzja dla siebie.', // 3 Thu
      'Krótki czy długi, każdy spacer to dobry spacer. Brawo.', // 4 Fri
      'I gotowe. Trochę ruchu i mnóstwo życzliwości dla siebie.', // 5 Sat
      'Lekki spacer w spokojny dzień. W sam raz.', // 6 Sun
    ],
    'slow': [
      'Powolny spacer na wejście w tydzień. Jak pięknie.', // 0 Mon
      'Łagodnie i bez pośpiechu. Właśnie tak.', // 1 Tue
      'Trochę spokoju tylko dla ciebie. Zatrzymaj go jeszcze na chwilę.', // 2 Wed
      'Powolne kroki, łagodne myśli. Co za piękny sposób na spędzenie czasu.', // 3 Thu
      'Bez pośpiechu, bez presji. Tylko ty i cichy spacer. Cudownie.', // 4 Fri
      'Udało się zwolnić. To cicha mądrość.', // 5 Sat
      'Powoli i na luzie, najlepszy rodzaj spaceru. Ciesz się spokojem.', // 6 Sun
    ],
    'energy': [
      'Co za żwawy początek tygodnia! Brawo.', // 0 Mon
      'To powinno cię ładnie rozbudzić! Brawo.', // 1 Tue
      'Czujesz tę iskrę? Pięknie!', // 2 Wed
      'Co za radosny mały zastrzyk energii! To wszystko dla ciebie.', // 3 Thu
      'Świetnie! Co za żywy, radosny spacer.', // 4 Fri
      'Spójrz tylko, ile energii! To był świetny spacer.', // 5 Sat
      'Radosny przypływ energii w spokojny dzień! Super.', // 6 Sun
    ],
  },
  'de': {
    'clear': [
      'Ein klarer Kopf für eine neue Woche. Danke, dass du dir diese Zeit nimmst.', // 0 Mon
      'Hoffentlich fühlt sich dein Kopf jetzt etwas leichter an. Danke, dass du ihm Raum gegeben hast.', // 1 Tue
      'Ein bisschen Raum zum Nachdenken, ganz für dich. Schön, dass du ihn dir genommen hast.', // 2 Wed
      'Was du auch mit auf diesen Weg genommen hast, möge es sich jetzt etwas leichter anfühlen.', // 3 Thu
      'Ein paar stille Schritte, ein paar stille Gedanken. Das war gut verbrachte Zeit.', // 4 Fri
      'Danke, dass du deinen Gedanken ein wenig Luft gegeben hast.', // 5 Sat
      'Keine Eile, kein Lärm, nur deine eigenen Gedanken. Schön.', // 6 Sun
    ],
    'gratitude': [
      'Ein dankbarer Wochenbeginn. Was für ein sanftes Geschenk an dich.', // 0 Mon
      'Danke, dass du dir diese Zeit für dich genommen hast. Es war wichtig.', // 1 Tue
      'Ein Spaziergang voller kleiner guter Dinge. Mögest du ein paar davon mitnehmen.', // 2 Wed
      'Wie schön, mit einem dankbaren Herzen zu gehen.', // 3 Thu
      'Auch die kleinsten guten Dinge sind es wert, bemerkt zu werden, und du hast sie bemerkt.', // 4 Fri
      'Danke für diesen sanften Spaziergang. Die Welt ist mit dir ein bisschen freundlicher.', // 5 Sat
      'Ein langsamer, dankbarer Spaziergang. Möge der Rest des Tages genauso freundlich sein.', // 6 Sun
    ],
    'move': [
      'Ein Spaziergang zum Wochenstart. Ein schönes kleines Versprechen an dich.', // 0 Mon
      'Jeder Schritt hat gezählt. Wirklich schön gemacht.', // 1 Tue
      'Du hast dich bewegt, und das zählt. Sei stolz darauf.', // 2 Wed
      'Du hast dich heute für Bewegung entschieden. Das ist freundlich zu dir selbst.', // 3 Thu
      'Kurz oder lang, jeder Spaziergang ist ein guter Spaziergang. Gut gemacht.', // 4 Fri
      'Da, geschafft. Ein bisschen Bewegung und ganz viel Freundlichkeit zu dir.', // 5 Sat
      'Ein leichter Spaziergang an einem leichten Tag. Genau richtig für heute.', // 6 Sun
    ],
    'slow': [
      'Ein langsamer Spaziergang, um sanft in die Woche zu kommen. Wie schön.', // 0 Mon
      'Sanft und ohne Eile. Genau richtig.', // 1 Tue
      'Du hast dir etwas Ruhe geschenkt. Halte sie noch ein bisschen fest.', // 2 Wed
      'Langsame Schritte, sanfte Gedanken. Was für eine schöne Art, Zeit zu verbringen.', // 3 Thu
      'Keine Eile, kein Druck. Nur du und ein stiller Spaziergang. Wunderschön.', // 4 Fri
      'Du hast dir erlaubt, langsamer zu werden. Das ist eine leise Art von Weisheit.', // 5 Sat
      'Langsam und gemütlich, die schönste Art Spaziergang. Genieß die Ruhe.', // 6 Sun
    ],
    'energy': [
      'Was für ein lebendiger Wochenstart! Gut gemacht.', // 0 Mon
      'Das sollte dich schön wach machen! Super gemacht.', // 1 Tue
      'Spürst du den Funken? Schön gemacht!', // 2 Wed
      'Was für ein fröhlicher kleiner Schwung! Den hast du dir selbst geschenkt.', // 3 Thu
      'Großartig! Was für ein lebendiger, fröhlicher Spaziergang.', // 4 Fri
      'Schau dich an, voller Elan! Das war ein toller Spaziergang.', // 5 Sat
      'Ein fröhlicher Energieschub an einem entspannten Tag! Schön.', // 6 Sun
    ],
  },
  'es': {
    'clear': [
      'Una mente despejada para una semana nueva. Gracias por regalarte este tiempo.', // 0 Mon
      'Ojalá tu mente se sienta ahora un poco más ligera. Gracias por darle espacio.', // 1 Tue
      'Un poco de espacio para pensar, todo tuyo. Bien por tomártelo.', // 2 Wed
      'Lo que sea que trajeras a este paseo, que ahora pese un poco menos.', // 3 Thu
      'Unos pasos tranquilos, unos pensamientos tranquilos. Fue tiempo bien empleado.', // 4 Fri
      'Gracias por dejar que tus pensamientos respiren un poco.', // 5 Sat
      'Sin prisa, sin ruido, solo tus propios pensamientos. Qué bonito.', // 6 Sun
    ],
    'gratitude': [
      'Un comienzo de semana agradecido. Qué regalo tan suave para ti.', // 0 Mon
      'Gracias por tomarte este tiempo para ti. Ha valido la pena.', // 1 Tue
      'Un paseo lleno de pequeñas cosas buenas. Que te lleves algunas contigo.', // 2 Wed
      'Qué cosa tan bonita, caminar con el corazón agradecido.', // 3 Thu
      'Hasta las cosas buenas más pequeñas merecen ser vistas, y tú las viste.', // 4 Fri
      'Gracias por este paseo tranquilo. El mundo es un poco más amable contigo en él.', // 5 Sat
      'Un paseo lento y agradecido. Que el resto del día sea igual de amable.', // 6 Sun
    ],
    'move': [
      'Un paseo para empezar la semana. Es una pequeña promesa preciosa contigo.', // 0 Mon
      'Cada paso contó. Muy buen trabajo, de verdad.', // 1 Tue
      'Te moviste, y eso es lo que importa. Siéntete bien por ello.', // 2 Wed
      'Hoy elegiste moverte. Es un gesto amable contigo.', // 3 Thu
      'Corto o largo, cada paseo es un buen paseo. Bien hecho.', // 4 Fri
      'Ahí está, lo hiciste. Un poco de movimiento y mucho cariño contigo.', // 5 Sat
      'Un paseo sencillo en un día sencillo. Justo lo que tocaba.', // 6 Sun
    ],
    'slow': [
      'Un paseo lento para entrar suavemente en la semana. Qué bonito.', // 0 Mon
      'Suave y sin prisas. Justo así.', // 1 Tue
      'Te regalaste un poco de calma. Guárdala un ratito más.', // 2 Wed
      'Pasos lentos, pensamientos suaves. Qué forma tan bonita de pasar el tiempo.', // 3 Thu
      'Sin prisa, sin presión. Solo tú y un paseo tranquilo. Precioso.', // 4 Fri
      'Te permitiste bajar el ritmo. Eso es una sabiduría tranquila.', // 5 Sat
      'Lento y sin agobios, el mejor tipo de paseo. Disfruta la calma.', // 6 Sun
    ],
    'energy': [
      '¡Qué manera tan animada de empezar la semana! Bien hecho.', // 0 Mon
      '¡Eso debería despertarte de maravilla! Bien hecho.', // 1 Tue
      '¿Sientes esa chispa? ¡Qué buen trabajo!', // 2 Wed
      '¡Qué subidón tan alegre! Te lo has regalado tú.', // 3 Thu
      '¡Genial! Qué paseo tan vivo y alegre.', // 4 Fri
      '¡Cuánta energía! Ha sido un paseo estupendo.', // 5 Sat
      '¡Una ráfaga de energía feliz en un día tranquilo! Qué bien.', // 6 Sun
    ],
  },
  'fr': {
    'clear': [
      'Un esprit clair pour une nouvelle semaine. Merci de vous accorder ce temps.', // 0 Mon
      "J'espère que votre esprit est un peu plus léger maintenant. Merci de lui laisser de la place.", // 1 Tue
      "Un peu d'espace pour penser, rien qu'à vous. C'est bien de l'avoir pris.", // 2 Wed
      'Quoi que vous ayez emporté dans cette marche, que ce soit un peu moins lourd maintenant.', // 3 Thu
      'Quelques pas tranquilles, quelques pensées tranquilles. Un temps bien employé.', // 4 Fri
      'Merci de laisser vos pensées respirer un peu.', // 5 Sat
      "Sans hâte, sans bruit, juste vos propres pensées. C'est beau.", // 6 Sun
    ],
    'gratitude': [
      'Un début de semaine plein de gratitude. Quel doux cadeau pour vous.', // 0 Mon
      "Merci d'avoir pris ce temps pour vous. Il en valait la peine.", // 1 Tue
      'Une marche pleine de petites choses belles. Gardez-en quelques-unes avec vous.', // 2 Wed
      'Quelle belle chose, marcher le cœur reconnaissant.', // 3 Thu
      "Même les plus petites joies méritent d'être vues, et vous les avez vues.", // 4 Fri
      'Merci pour cette marche tranquille. Le monde est un peu plus doux avec vous dedans.', // 5 Sat
      'Une marche lente et reconnaissante. Que le reste de la journée soit aussi doux.', // 6 Sun
    ],
    'move': [
      'Une marche pour commencer la semaine. Une jolie petite promesse envers vous.', // 0 Mon
      'Chaque pas a compté. Vraiment, beau travail.', // 1 Tue
      "Vous avez bougé, et c'est ce qui compte. Savourez ce moment.", // 2 Wed
      "Aujourd'hui, vous avez choisi de bouger. C'est une attention envers vous.", // 3 Thu
      'Courte ou longue, chaque marche est une bonne marche. Bravo.', // 4 Fri
      "Et voilà, c'est fait. Un peu de mouvement et beaucoup de douceur envers vous.", // 5 Sat
      "Une marche simple un jour simple. Exactement ce qu'il fallait.", // 6 Sun
    ],
    'slow': [
      "Une marche lente pour entrer doucement dans la semaine. C'est beau.", // 0 Mon
      'Doux et sans hâte. Exactement comme ça.', // 1 Tue
      'Vous vous êtes offert un peu de calme. Gardez-le encore un moment.', // 2 Wed
      'Pas lents, pensées douces. Une belle façon de passer le temps.', // 3 Thu
      "Sans hâte, sans pression. Juste vous et une marche tranquille. C'est beau.", // 4 Fri
      "Vous vous êtes permis de ralentir. C'est une sagesse tranquille.", // 5 Sat
      'Lente et paisible, la meilleure des marches. Savourez le calme.', // 6 Sun
    ],
    'energy': [
      "Quelle façon pleine d'entrain de commencer la semaine ! Bravo.", // 0 Mon
      'De quoi bien vous réveiller ! Bravo.', // 1 Tue
      'Vous sentez cette étincelle ? Beau travail !', // 2 Wed
      "Quel joyeux regain d'énergie ! C'est vous qui vous l'êtes offert.", // 3 Thu
      'Génial ! Quelle marche vive et joyeuse.', // 4 Fri
      "Que d'énergie ! C'était une super marche.", // 5 Sat
      'Un élan de joie un jour tranquille ! Très bien.', // 6 Sun
    ],
  },
  'it': {
    'clear': [
      'Una mente limpida per una settimana nuova. Grazie per aver dedicato questo tempo a te.', // 0 Mon
      "Spero che la tua mente adesso sia un po' più leggera. Grazie per averle dato spazio.", // 1 Tue
      "Un po' di spazio per pensare, tutto tuo. È bello concederselo.", // 2 Wed
      "Qualunque cosa avessi con te in questa passeggiata, che adesso pesi un po' meno.", // 3 Thu
      'Qualche passo tranquillo, qualche pensiero tranquillo. Tempo ben speso.', // 4 Fri
      "Grazie per aver lasciato respirare un po' i tuoi pensieri.", // 5 Sat
      'Senza fretta, senza rumore, solo i tuoi pensieri. Che bello.', // 6 Sun
    ],
    'gratitude': [
      'Un inizio di settimana pieno di gratitudine. Che dolce regalo per te.', // 0 Mon
      'Grazie per aver preso questo tempo per te. Ne è valsa la pena.', // 1 Tue
      'Una passeggiata piena di piccole cose belle. Portane qualcuna con te.', // 2 Wed
      'Che cosa bella, camminare con il cuore grato.', // 3 Thu
      'Anche le cose belle più piccole meritano di essere viste, e tu le hai viste.', // 4 Fri
      "Grazie per questa passeggiata tranquilla. Il mondo è un po' più gentile con te dentro.", // 5 Sat
      'Una passeggiata lenta e grata. Che il resto della giornata sia altrettanto gentile.', // 6 Sun
    ],
    'move': [
      'Una passeggiata per iniziare la settimana. Una piccola, bella promessa a te.', // 0 Mon
      'Ogni passo ha contato. Davvero un bel lavoro.', // 1 Tue
      'Hai fatto movimento, ed è questo che conta. Goditi la sensazione.', // 2 Wed
      'Oggi hai scelto di muoverti. È un gesto gentile verso di te.', // 3 Thu
      'Breve o lunga, ogni passeggiata è una buona passeggiata. Complimenti.', // 4 Fri
      "Ecco, fatto. Un po' di movimento e tanta gentilezza verso di te.", // 5 Sat
      'Una passeggiata semplice in un giorno semplice. Proprio quello che ci voleva.', // 6 Sun
    ],
    'slow': [
      'Una passeggiata lenta per entrare dolcemente nella settimana. Che bello.', // 0 Mon
      'Dolce e senza fretta. Proprio così.', // 1 Tue
      "Un po' di calma, tutta per te. Tienila con te ancora un po'.", // 2 Wed
      'Passi lenti, pensieri dolci. Che bel modo di passare il tempo.', // 3 Thu
      'Senza fretta, senza pressione. Solo tu e una passeggiata tranquilla. Bellissimo.', // 4 Fri
      'Hai scelto di rallentare. È una saggezza tranquilla.', // 5 Sat
      'Lenta e senza pensieri, la passeggiata migliore. Goditi la calma.', // 6 Sun
    ],
    'energy': [
      'Che modo vivace di iniziare la settimana! Complimenti.', // 0 Mon
      'Questo dovrebbe svegliarti per bene! Complimenti.', // 1 Tue
      'Senti quella scintilla? Bel lavoro!', // 2 Wed
      'Che allegra carica di energia! Te la sei regalata tu.', // 3 Thu
      'Fantastico! Che passeggiata vivace e allegra.', // 4 Fri
      'Quanta energia! È stata una passeggiata splendida.', // 5 Sat
      'Una ventata di energia felice in un giorno tranquillo! Che bello.', // 6 Sun
    ],
  },
};

const walkMoodLabels = {
  'en': {
    'clear': 'Clear my head',
    'gratitude': 'Gratitude',
    'move': 'Just move',
    'slow': 'Slow down',
    'energy': 'Energy boost',
  },
  'sk': {
    'clear': 'Vyčistiť si hlavu',
    'gratitude': 'Vďačnosť',
    'move': 'Len sa hýbať',
    'slow': 'Spomaliť',
    'energy': 'Nabudiť sa',
  },
  'cs': {
    'clear': 'Vyčistit si hlavu',
    'gratitude': 'Vděčnost',
    'move': 'Jen se hýbat',
    'slow': 'Zpomalit',
    'energy': 'Nabít energií',
  },
  'pl': {
    'clear': 'Przewietrzyć głowę',
    'gratitude': 'Wdzięczność',
    'move': 'Po prostu iść',
    'slow': 'Zwolnić',
    'energy': 'Zastrzyk energii',
  },
  'de': {
    'clear': 'Den Kopf frei bekommen',
    'gratitude': 'Dankbarkeit',
    'move': 'Einfach bewegen',
    'slow': 'Langsamer gehen',
    'energy': 'Energieschub',
  },
  'es': {
    'clear': 'Despejar la mente',
    'gratitude': 'Gratitud',
    'move': 'Solo moverme',
    'slow': 'Ir despacio',
    'energy': 'Un poco de energía',
  },
  'fr': {
    'clear': 'Me vider la tête',
    'gratitude': 'Gratitude',
    'move': 'Juste bouger',
    'slow': 'Ralentir',
    'energy': 'Un regain d\'énergie',
  },
  'it': {
    'clear': 'Schiarirmi la mente',
    'gratitude': 'Gratitudine',
    'move': 'Solo muovermi',
    'slow': 'Rallentare',
    'energy': 'Carica di energia',
  },
};

const walkUi = {
  'en': {
    'start': 'Start a walk',
    'end': 'End walk',
    'journal': 'Walk journal',
    'noteHint': 'How was your walk?',
    'save': 'Save',
    'delete': 'Delete',
    'keep': 'Keep',
    'deleteTitle': 'Delete this walk?',
    'deleteBody': 'It will be removed from this phone.',
    'empty': 'No walks yet.',
    'choose': 'How would you like this walk to feel?',
    'minOne': '{n} min',
    'minOther': '{n} min',
  },
  'sk': {
    'start': 'Začať prechádzku',
    'end': 'Ukončiť prechádzku',
    'journal': 'Denník prechádzok',
    'noteHint': 'Aké to bolo?',
    'save': 'Uložiť',
    'delete': 'Odstrániť',
    'keep': 'Ponechať',
    'deleteTitle': 'Odstrániť túto prechádzku?',
    'deleteBody': 'Zmizne z tohto telefónu.',
    'empty': 'Zatiaľ žiadne prechádzky.',
    'choose': 'Ako chcete, aby sa táto prechádzka cítila?',
    'minOne': '{n} min',
    'minOther': '{n} min',
  },
  'cs': {
    'start': 'Začít procházku',
    'end': 'Ukončit procházku',
    'journal': 'Deník procházek',
    'noteHint': 'Jaká to byla?',
    'save': 'Uložit',
    'delete': 'Odstranit',
    'keep': 'Ponechat',
    'deleteTitle': 'Odstranit tuhle procházku?',
    'deleteBody': 'Zmizí z tohoto telefonu.',
    'empty': 'Zatím žádné procházky.',
    'choose': 'Jak chcete, aby tahle procházka působila?',
    'minOne': '{n} min',
    'minOther': '{n} min',
  },
  'pl': {
    'start': 'Zacznij spacer',
    'end': 'Zakończ spacer',
    'journal': 'Dziennik spacerów',
    'noteHint': 'Jaki był spacer?',
    'save': 'Zapisz',
    'delete': 'Usuń',
    'keep': 'Zostaw',
    'deleteTitle': 'Usunąć ten spacer?',
    'deleteBody': 'Zniknie z tego telefonu.',
    'empty': 'Nie ma jeszcze spacerów.',
    'choose': 'Jaki nastrój ma mieć ten spacer?',
    'minOne': '{n} min',
    'minOther': '{n} min',
  },
  'de': {
    'start': 'Spaziergang beginnen',
    'end': 'Spaziergang beenden',
    'journal': 'Spaziergangstagebuch',
    'noteHint': 'Wie war der Spaziergang?',
    'save': 'Speichern',
    'delete': 'Löschen',
    'keep': 'Behalten',
    'deleteTitle': 'Diesen Spaziergang löschen?',
    'deleteBody': 'Er wird von diesem Telefon entfernt.',
    'empty': 'Noch keine Spaziergänge.',
    'choose': 'Wie soll sich dieser Spaziergang anfühlen?',
    'minOne': '{n} Min.',
    'minOther': '{n} Min.',
  },
  'es': {
    'start': 'Empezar un paseo',
    'end': 'Terminar el paseo',
    'journal': 'Diario de paseos',
    'noteHint': '¿Qué tal el paseo?',
    'save': 'Guardar',
    'delete': 'Borrar',
    'keep': 'Conservar',
    'deleteTitle': '¿Borrar este paseo?',
    'deleteBody': 'Se quitará de este teléfono.',
    'empty': 'Aún no hay paseos.',
    'choose': '¿Cómo quieres que se sienta este paseo?',
    'minOne': '{n} min',
    'minOther': '{n} min',
  },
  'fr': {
    'start': 'Commencer une marche',
    'end': 'Terminer la marche',
    'journal': 'Journal des marches',
    'noteHint': 'Comment était la marche ?',
    'save': 'Enregistrer',
    'delete': 'Supprimer',
    'keep': 'Garder',
    'deleteTitle': 'Supprimer cette marche ?',
    'deleteBody': 'Elle sera retirée de ce téléphone.',
    'empty': 'Pas encore de marches.',
    'choose': 'Quelle intention pour cette marche ?',
    'minOne': '{n} min',
    'minOther': '{n} min',
  },
  'it': {
    'start': 'Inizia una camminata',
    'end': 'Termina la camminata',
    'journal': 'Diario delle camminate',
    'noteHint': 'Com\'è andata la camminata?',
    'save': 'Salva',
    'delete': 'Elimina',
    'keep': 'Tieni',
    'deleteTitle': 'Eliminare questa camminata?',
    'deleteBody': 'Verrà tolta da questo telefono.',
    'empty': 'Nessuna camminata ancora.',
    'choose': 'Che sapore vuoi per questa camminata?',
    'minOne': '{n} min',
    'minOther': '{n} min',
  },
};
