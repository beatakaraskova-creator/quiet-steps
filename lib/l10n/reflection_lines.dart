/// Evening reflection lines. Unknown language falls back to English.
/// group: 'met' | 'half' | 'under'. 7 closings each, index 0 = Monday ... 6 = Sunday.
library;

const reflectionClosings = <String, Map<String, List<String>>>{
  'en': {
    'met': [
      'Your goal is met, and the week has started well. Rest easy tonight.', // 0 Mon
      'You reached your goal today. Let the evening be soft and easy.', // 1 Tue
      'A good day of walking. You showed up for yourself, and that matters. Rest well.', // 2 Wed
      'Your steps added up beautifully today. Be proud, and be gentle with yourself tonight.', // 3 Thu
      'You gave yourself something good today. Let that settle in as you rest.', // 4 Fri
      'Goal met. Whatever else today held, this part went well. Sleep softly.', // 5 Sat
      'Goal met on a gentle day. Rest well, the new week can wait.', // 6 Sun
    ],
    'half': [
      "More than halfway, and the week is still young. That's a lovely start.", // 0 Mon
      'You moved more than halfway today. That counts, truly.', // 1 Tue
      'A steady day. Every step was real, and tomorrow is another gentle start.', // 2 Wed
      'Not every day needs to be a big one. Today was good in its own way.', // 3 Thu
      "You found time for your steps today. That's something to feel good about.", // 4 Fri
      'More than halfway. Be kind to yourself tonight, you did well.', // 5 Sat
      "A relaxed day, and still more than halfway. That's a lovely balance.", // 6 Sun
    ],
    'under': [
      "A quiet start to the week. There's plenty of time, and no hurry.", // 0 Mon
      "A quieter day. That's okay too. Rest is part of walking.", // 1 Tue
      'Some days are for resting. Be gentle with yourself tonight.', // 2 Wed
      "However today went, it's done now. Tomorrow is a fresh, gentle start.", // 3 Thu
      'A slow day is still a good day. See you tomorrow.', // 4 Fri
      "Not every day is a walking day, and that's perfectly fine. Rest well.", // 5 Sat
      'A restful day. Exactly what some days are for. Sleep well.', // 6 Sun
    ],
  },
  'sk': {
    'met': [
      'Cieľ je splnený a týždeň sa začal dobre. Dnes večer si pokojne oddýchnite.', // 0 Mon
      'Dnes ste dosiahli svoj cieľ. Nech je večer jemný a ľahký.', // 1 Tue
      'Dobrý deň chôdze. Boli ste tu pre seba, a na tom záleží. Dobre si oddýchnite.', // 2 Wed
      'Vaše kroky sa dnes krásne nazbierali. Buďte hrdí a dnes večer k sebe jemní.', // 3 Thu
      'Dnes ste si dopriali niečo dobré. Nechajte to doznieť, kým budete oddychovať.', // 4 Fri
      'Cieľ je splnený. Nech dnešok priniesol čokoľvek, táto časť sa vydarila. Sladké sny.', // 5 Sat
      'Pokojný deň a splnený cieľ. Oddýchnite si, nový týždeň počká.', // 6 Sun
    ],
    'half': [
      'Viac než polovica a týždeň je ešte mladý. To je krásny začiatok.', // 0 Mon
      'Dnes ste prešli viac než polovicu. To sa naozaj počíta.', // 1 Tue
      'Vyrovnaný deň. Každý krok bol skutočný a zajtra je ďalší jemný začiatok.', // 2 Wed
      'Nie každý deň musí byť veľký. Dnešok bol dobrý po svojom.', // 3 Thu
      'Dnes ste si našli čas na svoje kroky. To je dôvod na dobrý pocit.', // 4 Fri
      'Viac než polovica. Buďte dnes večer k sebe láskaví, išlo vám to dobre.', // 5 Sat
      'Pohodový deň, a aj tak viac než polovica. To je krásna rovnováha.', // 6 Sun
    ],
    'under': [
      'Tichý začiatok týždňa. Času je dosť a netreba sa ponáhľať.', // 0 Mon
      'Tichší deň. Aj to je v poriadku. Oddych patrí k chôdzi.', // 1 Tue
      'Niektoré dni sú na oddych. Buďte dnes večer k sebe jemní.', // 2 Wed
      'Nech bol dnešok akýkoľvek, už je za vami. Zajtra je nový, jemný začiatok.', // 3 Thu
      'Pomalý deň je stále dobrý deň. Uvidíme sa zajtra.', // 4 Fri
      'Nie každý deň je na chôdzu, a to je úplne v poriadku. Dobre si oddýchnite.', // 5 Sat
      'Oddychový deň. Presne na to niektoré dni sú. Dobrú noc.', // 6 Sun
    ],
  },
  'cs': {
    'met': [
      'Cíl je splněný a týden začal dobře. Dnes večer si v klidu odpočiňte.', // 0 Mon
      'Dnes jste dosáhli svého cíle. Ať je večer jemný a lehký.', // 1 Tue
      'Dobrý den chůze. Byli jste tu pro sebe, a na tom záleží. Dobře si odpočiňte.', // 2 Wed
      'Vaše kroky se dnes krásně sešly. Buďte hrdí a dnes večer k sobě jemní.', // 3 Thu
      'Dnes jste si dopřáli něco dobrého. Nechte to doznít, zatímco odpočíváte.', // 4 Fri
      'Cíl je splněný. Ať dnešek přinesl cokoli, tahle část se povedla. Sladké sny.', // 5 Sat
      'Klidný den a splněný cíl. Odpočiňte si, nový týden počká.', // 6 Sun
    ],
    'half': [
      'Víc než polovina a týden je ještě mladý. To je krásný začátek.', // 0 Mon
      'Dnes jste ušli víc než polovinu. To se opravdu počítá.', // 1 Tue
      'Vyrovnaný den. Každý krok byl skutečný a zítra je další jemný začátek.', // 2 Wed
      'Ne každý den musí být velký. Dnešek byl dobrý po svém.', // 3 Thu
      'Dnes jste si našli čas na své kroky. To je důvod k dobrému pocitu.', // 4 Fri
      'Víc než polovina. Buďte dnes večer k sobě laskaví, šlo vám to dobře.', // 5 Sat
      'Pohodový den, a přesto víc než polovina. To je krásná rovnováha.', // 6 Sun
    ],
    'under': [
      'Tichý začátek týdne. Času je dost a není kam spěchat.', // 0 Mon
      'Tišší den. I to je v pořádku. Odpočinek patří k chůzi.', // 1 Tue
      'Některé dny jsou na odpočinek. Buďte dnes večer k sobě jemní.', // 2 Wed
      'Ať byl dnešek jakýkoli, už je za vámi. Zítra je nový, jemný začátek.', // 3 Thu
      'Pomalý den je pořád dobrý den. Uvidíme se zítra.', // 4 Fri
      'Ne každý den je na chůzi, a to je úplně v pořádku. Dobře si odpočiňte.', // 5 Sat
      'Odpočinkový den. Přesně na to některé dny jsou. Dobrou noc.', // 6 Sun
    ],
  },
  'pl': {
    'met': [
      'Cel osiągnięty, a tydzień dobrze się zaczął. Odpocznij dziś spokojnie.', // 0 Mon
      'Dziś cel osiągnięty. Niech wieczór będzie miękki i lekki.', // 1 Tue
      'Dobry dzień chodzenia. Ten czas był dla ciebie, i to się liczy. Odpocznij dobrze.', // 2 Wed
      'Twoje kroki pięknie się dziś zebrały. To powód do dumy. Wieczorem traktuj siebie łagodnie.', // 3 Thu
      'Ten dzień przyniósł ci coś dobrego. Pozwól temu wybrzmieć podczas odpoczynku.', // 4 Fri
      'Cel osiągnięty. Cokolwiek jeszcze przyniósł dzień, ta część się udała. Spokojnej nocy.', // 5 Sat
      'Spokojny dzień i cel osiągnięty. Odpocznij, nowy tydzień poczeka.', // 6 Sun
    ],
    'half': [
      'Ponad połowa, a tydzień dopiero się zaczął. To piękny początek.', // 0 Mon
      'Dziś więcej niż połowa za tobą. To naprawdę się liczy.', // 1 Tue
      'Równy dzień. Każdy krok był prawdziwy, a jutro kolejny łagodny początek.', // 2 Wed
      'Nie każdy dzień musi być wielki. Dzisiejszy był dobry na swój sposób.', // 3 Thu
      'Dziś udało się znaleźć czas na kroki. To dobry powód do zadowolenia.', // 4 Fri
      'Ponad połowa. Potraktuj się dziś wieczorem życzliwie, dobrze poszło.', // 5 Sat
      'Spokojny dzień, a mimo to ponad połowa. Piękna równowaga.', // 6 Sun
    ],
    'under': [
      'Cichy początek tygodnia. Czasu jest dużo i nie ma pośpiechu.', // 0 Mon
      'Cichszy dzień. To też jest w porządku. Odpoczynek jest częścią chodzenia.', // 1 Tue
      'Niektóre dni są do odpoczynku. Potraktuj się dziś wieczorem łagodnie.', // 2 Wed
      'Jakikolwiek był dzisiejszy dzień, już minął. Jutro nowy, łagodny początek.', // 3 Thu
      'Powolny dzień to wciąż dobry dzień. Do jutra.', // 4 Fri
      'Nie każdy dzień jest do chodzenia, i to zupełnie w porządku. Odpocznij dobrze.', // 5 Sat
      'Dzień odpoczynku. Właśnie po to są niektóre dni. Dobranoc.', // 6 Sun
    ],
  },
  'de': {
    'met': [
      'Dein Ziel ist erreicht, und die Woche hat gut begonnen. Ruh dich heute Abend aus.', // 0 Mon
      'Du hast dein Ziel heute erreicht. Lass den Abend weich und leicht sein.', // 1 Tue
      'Ein guter Tag zu Fuß. Du warst für dich da, und das zählt. Ruh dich gut aus.', // 2 Wed
      'Deine Schritte haben sich heute wunderbar gesammelt. Sei stolz, und heute Abend sanft zu dir.', // 3 Thu
      'Du hast dir heute etwas Gutes getan. Lass es nachklingen, während du ruhst.', // 4 Fri
      'Ziel erreicht. Was der Tag sonst auch brachte, dieser Teil ist gelungen. Schlaf sanft.', // 5 Sat
      'Ziel erreicht an einem sanften Tag. Ruh dich aus, die neue Woche kann warten.', // 6 Sun
    ],
    'half': [
      'Mehr als die Hälfte, und die Woche ist noch jung. Ein schöner Anfang.', // 0 Mon
      'Du bist heute mehr als die Hälfte gegangen. Das zählt, wirklich.', // 1 Tue
      'Ein gleichmäßiger Tag. Jeder Schritt war echt, und morgen ist ein neuer sanfter Anfang.', // 2 Wed
      'Nicht jeder Tag muss groß sein. Heute war auf seine eigene Art gut.', // 3 Thu
      'Du hast heute Zeit für deine Schritte gefunden. Darüber kannst du dich freuen.', // 4 Fri
      'Mehr als die Hälfte. Sei heute Abend freundlich zu dir, du hast das gut gemacht.', // 5 Sat
      'Ein entspannter Tag, und trotzdem mehr als die Hälfte. Eine schöne Balance.', // 6 Sun
    ],
    'under': [
      'Ein ruhiger Wochenstart. Es ist genug Zeit, und keine Eile.', // 0 Mon
      'Ein leiserer Tag. Auch das ist in Ordnung. Ruhe gehört zum Gehen.', // 1 Tue
      'Manche Tage sind zum Ausruhen da. Sei heute Abend sanft zu dir.', // 2 Wed
      'Wie der Tag auch war, jetzt ist er vorbei. Morgen ist ein neuer, sanfter Anfang.', // 3 Thu
      'Ein langsamer Tag ist trotzdem ein guter Tag. Bis morgen.', // 4 Fri
      'Nicht jeder Tag ist ein Gehtag, und das ist völlig in Ordnung. Ruh dich gut aus.', // 5 Sat
      'Ein erholsamer Tag. Genau dafür sind manche Tage da. Schlaf gut.', // 6 Sun
    ],
  },
  'es': {
    'met': [
      'Tu meta está cumplida, y la semana empezó bien. Descansa tranquilamente esta noche.', // 0 Mon
      'Hoy alcanzaste tu meta. Que la noche sea suave y ligera.', // 1 Tue
      'Un buen día de caminar. Estuviste ahí para ti, y eso importa. Descansa bien.', // 2 Wed
      'Tus pasos se sumaron de maravilla hoy. Date ese mérito, y trátate con cariño esta noche.', // 3 Thu
      'Hoy te regalaste algo bueno. Deja que se asiente mientras descansas.', // 4 Fri
      'Meta cumplida. Pasara lo que pasara hoy, esta parte salió bien. Dulces sueños.', // 5 Sat
      'Meta cumplida en un día tranquilo. Descansa, la semana nueva puede esperar.', // 6 Sun
    ],
    'half': [
      'Más de la mitad, y la semana aún es joven. Es un comienzo precioso.', // 0 Mon
      'Hoy avanzaste más de la mitad. Eso cuenta, de verdad.', // 1 Tue
      'Un día constante. Cada paso fue real, y mañana es otro comienzo suave.', // 2 Wed
      'No todos los días tienen que ser grandes. Hoy fue bueno a su manera.', // 3 Thu
      'Hoy encontraste tiempo para tus pasos. Eso es para sentirse bien.', // 4 Fri
      'Más de la mitad. Trátate con cariño esta noche, lo hiciste bien.', // 5 Sat
      'Un día relajado, y aun así más de la mitad. Qué buen equilibrio.', // 6 Sun
    ],
    'under': [
      'Un comienzo de semana tranquilo. Hay tiempo de sobra, y ninguna prisa.', // 0 Mon
      'Un día más quieto. También está bien. Descansar es parte de caminar.', // 1 Tue
      'Algunos días son para descansar. Trátate con suavidad esta noche.', // 2 Wed
      'Haya ido como haya ido hoy, ya pasó. Mañana es un comienzo nuevo y suave.', // 3 Thu
      'Un día lento sigue siendo un buen día. Hasta mañana.', // 4 Fri
      'No todos los días son para caminar, y está perfectamente bien. Descansa bien.', // 5 Sat
      'Un día de reposo. Justo para eso son algunos días. Que descanses.', // 6 Sun
    ],
  },
  'fr': {
    'met': [
      'Votre objectif est atteint, et la semaine a bien commencé. Reposez-vous tranquillement ce soir.', // 0 Mon
      "Objectif atteint aujourd'hui. Que la soirée soit douce et légère.", // 1 Tue
      "Une belle journée de marche. Vous avez été là pour vous, et c'est important. Reposez-vous bien.", // 2 Wed
      "Vos pas se sont joliment additionnés aujourd'hui. Accordez-vous ce mérite, et douceur ce soir.", // 3 Thu
      "Vous vous êtes offert quelque chose de bien aujourd'hui. Laissez-le se poser pendant le repos.", // 4 Fri
      "Objectif atteint. Quoi qu'il se soit passé aujourd'hui, cette partie a bien marché. Douce nuit.", // 5 Sat
      'Objectif atteint un jour tranquille. Reposez-vous, la nouvelle semaine peut attendre.', // 6 Sun
    ],
    'half': [
      "Plus de la moitié, et la semaine est encore jeune. C'est un très beau début.", // 0 Mon
      "Plus de la moitié du chemin aujourd'hui. Cela compte, vraiment.", // 1 Tue
      'Une journée régulière. Chaque pas était réel, et demain est un autre doux départ.', // 2 Wed
      "Toutes les journées n'ont pas besoin d'être grandes. Aujourd'hui était bien, à sa façon.", // 3 Thu
      "Vous avez trouvé du temps pour vos pas aujourd'hui. C'est une bonne chose.", // 4 Fri
      "Plus de la moitié. Ménagez-vous ce soir, c'était une bonne journée.", // 5 Sat
      'Une journée détendue, et quand même plus de la moitié. Un bel équilibre.', // 6 Sun
    ],
    'under': [
      'Un début de semaine tranquille. Il y a tout le temps, et rien ne presse.', // 0 Mon
      "Une journée plus calme. C'est bien aussi. Le repos fait partie de la marche.", // 1 Tue
      'Certains jours sont faits pour le repos. Accordez-vous de la douceur ce soir.', // 2 Wed
      "Quelle qu'ait été la journée, elle est passée. Demain est un nouveau départ en douceur.", // 3 Thu
      'Une journée lente reste une bonne journée. À demain.', // 4 Fri
      "Tous les jours ne sont pas faits pour marcher, et c'est parfaitement bien. Reposez-vous bien.", // 5 Sat
      "Une journée de repos. C'est justement à ça que servent certains jours. Douce nuit.", // 6 Sun
    ],
  },
  'it': {
    'met': [
      'Il tuo obiettivo è raggiunto, e la settimana è iniziata bene. Riposa tranquillamente stasera.', // 0 Mon
      'Oggi hai raggiunto il tuo obiettivo. Che la serata sia dolce e leggera.', // 1 Tue
      'Una bella giornata di cammino. Hai pensato a te, e questo conta. Riposa bene.', // 2 Wed
      'I tuoi passi oggi si sono sommati benissimo. Riconoscitelo, e sii gentile con te stasera.', // 3 Thu
      'Oggi hai fatto qualcosa di buono per te. Lascia che si posi mentre riposi.', // 4 Fri
      "Obiettivo raggiunto. Qualunque cosa sia successa oggi, questa parte è andata bene. Sogni d'oro.", // 5 Sat
      'Obiettivo raggiunto in un giorno tranquillo. Riposa, la settimana nuova può aspettare.', // 6 Sun
    ],
    'half': [
      'Più della metà, e la settimana è ancora giovane. È un inizio bellissimo.', // 0 Mon
      'Oggi più della metà della strada. Conta, davvero.', // 1 Tue
      'Una giornata costante. Ogni passo era vero, e domani è un altro inizio dolce.', // 2 Wed
      'Non tutte le giornate devono essere grandi. Oggi è stata bella a modo suo.', // 3 Thu
      'Oggi hai trovato tempo per i tuoi passi. È una cosa bella.', // 4 Fri
      'Più della metà. Sii gentile con te stasera, è stata una buona giornata.', // 5 Sat
      "Una giornata rilassata, e comunque più della metà. Un bell'equilibrio.", // 6 Sun
    ],
    'under': [
      "Un inizio di settimana tranquillo. C'è tutto il tempo, e nessuna fretta.", // 0 Mon
      'Una giornata più quieta. Va bene anche così. Riposare fa parte del camminare.', // 1 Tue
      'Alcuni giorni sono fatti per riposare. Trattati con dolcezza stasera.', // 2 Wed
      'Comunque sia andata oggi, è passata. Domani è un nuovo inizio, con dolcezza.', // 3 Thu
      'Una giornata lenta è comunque una buona giornata. A domani.', // 4 Fri
      'Non tutti i giorni sono per camminare, ed è perfettamente normale. Riposa bene.', // 5 Sat
      'Un giorno di riposo. È proprio a questo che servono certi giorni. Riposa bene stanotte.', // 6 Sun
    ],
  },
};

const reflectionSummary = {
  'en': 'Today you walked {n} steps.',
  'sk': 'Dnes ste prešli {n} krokov.',
  'cs': 'Dnes jste ušli {n} kroků.',
  'pl': 'Dziś masz za sobą {n} kroków.',
  'de': 'Heute bist du {n} Schritte gegangen.',
  'es': 'Hoy caminaste {n} pasos.',
  'fr': 'Aujourd\'hui, vous avez marché {n} pas.',
  'it': 'Oggi hai camminato {n} passi.',
};

const reflectionUi = {
  'en': {
    'setting': 'Evening reflection',
    'reflectionTime': 'Reflection time',
    'card': "Today's reflection",
    'readAloud': 'Read aloud',
  },
  'sk': {
    'setting': 'Večerné zamyslenie',
    'reflectionTime': 'Čas zamyslenia',
    'card': 'Dnešné zamyslenie',
    'readAloud': 'Prečítať nahlas',
  },
  'cs': {
    'setting': 'Večerní zamyšlení',
    'reflectionTime': 'Čas zamyšlení',
    'card': 'Dnešní zamyšlení',
    'readAloud': 'Číst nahlas',
  },
  'pl': {
    'setting': 'Wieczorna refleksja',
    'reflectionTime': 'Czas refleksji',
    'card': 'Dzisiejsza refleksja',
    'readAloud': 'Przeczytaj na głos',
  },
  'de': {
    'setting': 'Abendliche Rückschau',
    'reflectionTime': 'Zeit der Rückschau',
    'card': 'Heutige Rückschau',
    'readAloud': 'Vorlesen',
  },
  'es': {
    'setting': 'Reflexión de la tarde',
    'reflectionTime': 'Hora de la reflexión',
    'card': 'Reflexión de hoy',
    'readAloud': 'Leer en voz alta',
  },
  'fr': {
    'setting': 'Regard du soir',
    'reflectionTime': 'Heure du regard',
    'card': 'Le regard d\'aujourd\'hui',
    'readAloud': 'Lire à voix haute',
  },
  'it': {
    'setting': 'Riflessione della sera',
    'reflectionTime': 'Orario della riflessione',
    'card': 'Riflessione di oggi',
    'readAloud': 'Leggi ad alta voce',
  },
};
