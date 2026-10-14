/// Evening reflection lines. Unknown language falls back to English.
/// group: 'met' | 'half' | 'under'
library;

const reflectionClosings = <String, Map<String, List<String>>>{
  'en': {
    'met': [
      'You reached your goal today. Let the evening be easy.',
      'A good day of walking. Rest well.',
      'Your steps added up nicely today.',
    ],
    'half': [
      'You moved more than halfway today. That counts.',
      'A steady day. Tomorrow is another gentle start.',
    ],
    'under': [
      "A quieter day. That's okay too.",
      'Rest is part of walking. See you tomorrow.',
    ],
  },
  'sk': {
    'met': [
      'Dnes ste splnili svoj cieľ. Nech je večer pokojný.',
      'Dobrý deň chôdze. Dobre si odpočiňte.',
      'Dnes sa vám kroky pekne nazbierali.',
    ],
    'half': [
      'Dnes ste prešli viac ako polovicu. To sa počíta.',
      'Pokojný, vyrovnaný deň. Zajtra je ďalší jemný začiatok.',
    ],
    'under': [
      'Tichší deň. Aj to je v poriadku.',
      'Odpočinok patrí k chôdzi. Zajtra na videnie.',
    ],
  },
  'cs': {
    'met': [
      'Dnes jste splnili svůj cíl. Ať je večer klidný.',
      'Dobrý den chůze. Dobře si odpočiňte.',
      'Dnes se vám kroky pěkně sešly.',
    ],
    'half': [
      'Dnes jste ušli víc než polovinu. To se počítá.',
      'Klidný, vyrovnaný den. Zítra je další jemný začátek.',
    ],
    'under': [
      'Tišší den. I to je v pořádku.',
      'Odpočinek patří k chůzi. Zítra nashledanou.',
    ],
  },
  'pl': {
    'met': [
      'Cel na dziś osiągnięty. Niech wieczór będzie spokojny.',
      'Dobry dzień spaceru. Odpocznij dobrze.',
      'Dziś kroki ładnie się zebrały.',
    ],
    'half': [
      'Dziś więcej niż połowa za tobą. To się liczy.',
      'Spokojny, równy dzień. Jutro kolejny łagodny początek.',
    ],
    'under': [
      'Cichszy dzień. To też jest w porządku.',
      'Odpoczynek jest częścią chodzenia. Do jutra.',
    ],
  },
  'de': {
    'met': [
      'Du hast dein Ziel heute erreicht. Lass den Abend ruhig sein.',
      'Ein guter Tag zum Gehen. Ruh dich gut aus.',
      'Deine Schritte haben sich heute schön gesammelt.',
    ],
    'half': [
      'Du bist heute mehr als die Hälfte gegangen. Das zählt.',
      'Ein ruhiger, stetiger Tag. Morgen ist ein weiterer sanfter Anfang.',
    ],
    'under': [
      'Ein leiserer Tag. Auch das ist in Ordnung.',
      'Ruhe gehört zum Gehen. Bis morgen.',
    ],
  },
  'es': {
    'met': [
      'Hoy alcanzaste tu meta. Que la noche sea suave.',
      'Un buen día de caminar. Descansa bien.',
      'Hoy tus pasos se juntaron con calma.',
    ],
    'half': [
      'Hoy avanzaste más de la mitad. Eso cuenta.',
      'Un día sereno. Mañana es otro comienzo suave.',
    ],
    'under': [
      'Un día más quieto. También está bien.',
      'Descansar es parte de caminar. Hasta mañana.',
    ],
  },
  'fr': {
    'met': [
      'Vous avez atteint votre objectif aujourd\'hui. Que la soirée soit douce.',
      'Une belle journée de marche. Reposez-vous bien.',
      'Vos pas se sont bien additionnés aujourd\'hui.',
    ],
    'half': [
      'Vous avez fait plus de la moitié du chemin. Cela compte.',
      'Une journée posée. Demain est un autre doux départ.',
    ],
    'under': [
      'Une journée plus calme. C\'est bien aussi.',
      'Le repos fait partie de la marche. À demain.',
    ],
  },
  'it': {
    'met': [
      'Oggi hai raggiunto il tuo obiettivo. Che la sera sia lieve.',
      'Una bella giornata di cammino. Riposa bene.',
      'Oggi i tuoi passi si sono raccolti con calma.',
    ],
    'half': [
      'Oggi hai fatto più della metà. Conta lo stesso.',
      'Una giornata serena. Domani è un altro inizio gentile.',
    ],
    'under': [
      'Una giornata più quieta. Va bene anche così.',
      'Il riposo fa parte del cammino. A domani.',
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
    'card': "Today's reflection",
    'readAloud': 'Read aloud',
  },
  'sk': {
    'setting': 'Večerné zamyslenie',
    'card': 'Dnešné zamyslenie',
    'readAloud': 'Prečítať nahlas',
  },
  'cs': {
    'setting': 'Večerní zamyšlení',
    'card': 'Dnešní zamyšlení',
    'readAloud': 'Číst nahlas',
  },
  'pl': {
    'setting': 'Wieczorna refleksja',
    'card': 'Dzisiejsza refleksja',
    'readAloud': 'Przeczytaj na głos',
  },
  'de': {
    'setting': 'Abendliche Rückschau',
    'card': 'Heutige Rückschau',
    'readAloud': 'Vorlesen',
  },
  'es': {
    'setting': 'Reflexión de la tarde',
    'card': 'Reflexión de hoy',
    'readAloud': 'Leer en voz alta',
  },
  'fr': {
    'setting': 'Regard du soir',
    'card': 'Le regard d\'aujourd\'hui',
    'readAloud': 'Lire à voix haute',
  },
  'it': {
    'setting': 'Riflessione della sera',
    'card': 'Riflessione di oggi',
    'readAloud': 'Leggi ad alta voce',
  },
};
