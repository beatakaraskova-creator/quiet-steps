/// Milestone lines for Quiet Steps.
/// lines[languageCode][style][milestone] -> list of lines (pick one at random).
/// style: 'calm' | 'cheerful'. milestone: '2500' | '5000' | '7500' | 'goal'.
/// Unknown language -> fall back to 'en'.
const Map<String, Map<String, Map<String, List<String>>>> milestoneLines = {
  'en': {
    'calm': {
      '2500': ['A gentle start. 2,500 steps.', 'Nice and easy. 2,500 steps so far.', 'Your day is moving. 2,500 steps.'],
      '5000': ['Halfway there. Take a breath.', '5,000 steps. Steady and calm.', 'Look at you go. 5,000 steps.'],
      '7500': ['7,500 steps. Almost home.', 'Three quarters done. Keep it gentle.', 'Lovely pace. 7,500 steps.'],
      'goal': ['You reached your goal today. Well done.', 'Goal reached. Be proud of this.', "That's your goal. Rest if you like."],
    },
    'cheerful': {
      '2500': ['2,500 steps! Great start!', "You're off! 2,500 already!", 'Nice one! 2,500 steps!'],
      '5000': ['Halfway! 5,000 steps!', "5,000! You're on a roll!", 'High five! 5,000 steps!'],
      '7500': ['7,500! Nearly there!', 'So close! 7,500 steps!', 'Keep going! 7,500 done!'],
      'goal': ['Goal smashed! Brilliant!', 'You did it! Goal reached!', 'Yes! Goal complete!'],
    },
  },
  'sk': {
    'calm': {
      '2500': ['Pokojný začiatok. 2 500 krokov.', 'Pekne zľahka. Zatiaľ 2 500 krokov.', 'Deň sa hýbe. 2 500 krokov.'],
      '5000': ['Polovica cesty. Nadýchnite sa.', '5 000 krokov. Pokojne a vyrovnane.', 'Darí sa vám. 5 000 krokov.'],
      '7500': ['7 500 krokov. Takmer v cieli.', 'Tri štvrtiny za vami. Zľahka ďalej.', 'Krásne tempo. 7 500 krokov.'],
      'goal': ['Dnes ste dosiahli svoj cieľ. Výborne.', 'Cieľ splnený. Môžete byť na seba hrdí.', 'To je váš cieľ. Ak chcete, oddýchnite si.'],
    },
    'cheerful': {
      '2500': ['2 500 krokov! Skvelý začiatok!', 'Ide sa! Už 2 500!', 'Paráda! 2 500 krokov!'],
      '5000': ['Polovica! 5 000 krokov!', '5 000! Ide vám to!', 'Plácnime si! 5 000 krokov!'],
      '7500': ['7 500! Už len kúsok!', 'Tak blízko! 7 500 krokov!', 'Len tak ďalej! 7 500 hotovo!'],
      'goal': ['Cieľ zdolaný! Úžasné!', 'Dokázali ste to! Cieľ splnený!', 'Áno! Cieľ hotový!'],
    },
  },
  'cs': {
    'calm': {
      '2500': ['Klidný začátek. 2 500 kroků.', 'Pěkně zlehka. Zatím 2 500 kroků.', 'Den se dává do pohybu. 2 500 kroků.'],
      '5000': ['Polovina cesty. Nadechněte se.', '5 000 kroků. Klidně a vyrovnaně.', 'Daří se vám. 5 000 kroků.'],
      '7500': ['7 500 kroků. Skoro v cíli.', 'Tři čtvrtiny za vámi. Zlehka dál.', 'Krásné tempo. 7 500 kroků.'],
      'goal': ['Dnes jste dosáhli svého cíle. Výborně.', 'Cíl splněn. Můžete být na sebe hrdí.', 'To je váš cíl. Pokud chcete, odpočiňte si.'],
    },
    'cheerful': {
      '2500': ['2 500 kroků! Skvělý začátek!', 'Jde se! Už 2 500!', 'Paráda! 2 500 kroků!'],
      '5000': ['Polovina! 5 000 kroků!', '5 000! Jde vám to!', 'Plácněte si! 5 000 kroků!'],
      '7500': ['7 500! Už jen kousek!', 'Tak blízko! 7 500 kroků!', 'Jen tak dál! 7 500 hotovo!'],
      'goal': ['Cíl pokořen! Úžasné!', 'Dokázali jste to! Cíl splněn!', 'Ano! Cíl hotový!'],
    },
  },
  'pl': {
    'calm': {
      '2500': ['Spokojny początek. 2500 kroków.', 'Powoli i spokojnie. Na razie 2500 kroków.', 'Dzień nabiera ruchu. 2500 kroków.'],
      '5000': ['Połowa drogi. Weź oddech.', '5000 kroków. Spokojnie i równo.', 'Świetnie ci idzie. 5000 kroków.'],
      '7500': ['7500 kroków. Prawie u celu.', 'Trzy czwarte za tobą. Spokojnie dalej.', 'Piękne tempo. 7500 kroków.'],
      'goal': ['Dziś cel osiągnięty. Brawo.', 'Cel osiągnięty. Bądź z siebie dumny.', 'To twój cel. Odpocznij, jeśli chcesz.'],
    },
    'cheerful': {
      '2500': ['2500 kroków! Świetny start!', 'Ruszamy! Już 2500!', 'Super! 2500 kroków!'],
      '5000': ['Połowa! 5000 kroków!', '5000! Idzie ci świetnie!', 'Przybij piątkę! 5000 kroków!'],
      '7500': ['7500! Już prawie!', 'Tak blisko! 7500 kroków!', 'Tak trzymaj! 7500 zrobione!'],
      'goal': ['Cel zdobyty! Rewelacja!', 'Udało się! Cel osiągnięty!', 'Tak! Cel wykonany!'],
    },
  },
  'de': {
    'calm': {
      '2500': ['Ein sanfter Anfang. 2.500 Schritte.', 'Ganz entspannt. Bisher 2.500 Schritte.', 'Dein Tag kommt in Bewegung. 2.500 Schritte.'],
      '5000': ['Halbzeit. Atme einmal tief durch.', '5.000 Schritte. Ruhig und gleichmäßig.', 'Schön, wie du gehst. 5.000 Schritte.'],
      '7500': ['7.500 Schritte. Fast geschafft.', 'Drei Viertel geschafft. Ganz in Ruhe weiter.', 'Schönes Tempo. 7.500 Schritte.'],
      'goal': ['Du hast dein Tagesziel erreicht. Gut gemacht.', 'Ziel erreicht. Darauf kannst du stolz sein.', 'Das ist dein Ziel. Ruh dich gern aus.'],
    },
    'cheerful': {
      '2500': ['2.500 Schritte! Toller Start!', 'Los geht\'s! Schon 2.500!', 'Super! 2.500 Schritte!'],
      '5000': ['Halbzeit! 5.000 Schritte!', '5.000! Du bist in Fahrt!', 'High five! 5.000 Schritte!'],
      '7500': ['7.500! Fast da!', 'So nah! 7.500 Schritte!', 'Weiter so! 7.500 geschafft!'],
      'goal': ['Ziel geknackt! Großartig!', 'Geschafft! Ziel erreicht!', 'Ja! Ziel erledigt!'],
    },
  },
  'es': {
    'calm': {
      '2500': ['Un comienzo tranquilo. 2500 pasos.', 'Con calma. 2500 pasos hasta ahora.', 'Tu día se pone en marcha. 2500 pasos.'],
      '5000': ['A mitad de camino. Respira hondo.', '5000 pasos. Con calma y constancia.', 'Qué bien vas. 5000 pasos.'],
      '7500': ['7500 pasos. Ya casi llegas.', 'Tres cuartos hechos. Sigue con calma.', 'Buen ritmo. 7500 pasos.'],
      'goal': ['Hoy has alcanzado tu meta. Bien hecho.', 'Meta alcanzada. Siéntete orgulloso.', 'Esa es tu meta. Descansa si quieres.'],
    },
    'cheerful': {
      '2500': ['¡2500 pasos! ¡Gran comienzo!', '¡En marcha! ¡Ya 2500!', '¡Genial! ¡2500 pasos!'],
      '5000': ['¡La mitad! ¡5000 pasos!', '¡5000! ¡Vas imparable!', '¡Choca esos cinco! ¡5000 pasos!'],
      '7500': ['¡7500! ¡Casi lo tienes!', '¡Muy cerca! ¡7500 pasos!', '¡Sigue así! ¡7500 hechos!'],
      'goal': ['¡Meta superada! ¡Brillante!', '¡Lo lograste! ¡Meta alcanzada!', '¡Sí! ¡Meta cumplida!'],
    },
  },
  'fr': {
    'calm': {
      '2500': ['Un début en douceur. 2 500 pas.', 'Tout doucement. 2 500 pas pour l\'instant.', 'Votre journée se met en mouvement. 2 500 pas.'],
      '5000': ['À mi-chemin. Prenez une respiration.', '5 000 pas. Calme et régulier.', 'Vous avancez bien. 5 000 pas.'],
      '7500': ['7 500 pas. Presque arrivé.', 'Trois quarts du chemin. Doucement.', 'Joli rythme. 7 500 pas.'],
      'goal': ['Objectif atteint aujourd\'hui. Bravo.', 'Objectif atteint. Soyez-en fier.', 'C\'est votre objectif. Reposez-vous si vous le souhaitez.'],
    },
    'cheerful': {
      '2500': ['2 500 pas ! Super départ !', 'C\'est parti ! Déjà 2 500 !', 'Bien joué ! 2 500 pas !'],
      '5000': ['La moitié ! 5 000 pas !', '5 000 ! Vous êtes lancé !', 'Tope là ! 5 000 pas !'],
      '7500': ['7 500 ! Presque là !', 'Si près ! 7 500 pas !', 'Continuez ! 7 500 de faits !'],
      'goal': ['Objectif pulvérisé ! Génial !', 'Vous l\'avez fait ! Objectif atteint !', 'Oui ! Objectif accompli !'],
    },
  },
  'it': {
    'calm': {
      '2500': ['Un inizio dolce. 2.500 passi.', 'Con calma. Finora 2.500 passi.', 'La tua giornata si muove. 2.500 passi.'],
      '5000': ['A metà strada. Fai un bel respiro.', '5.000 passi. Calmo e costante.', 'Stai andando bene. 5.000 passi.'],
      '7500': ['7.500 passi. Quasi arrivato.', 'Tre quarti fatti. Avanti con calma.', 'Bel ritmo. 7.500 passi.'],
      'goal': ['Oggi hai raggiunto il tuo obiettivo. Ben fatto.', 'Obiettivo raggiunto. Puoi esserne fiero.', 'Ecco il tuo obiettivo. Riposa, se vuoi.'],
    },
    'cheerful': {
      '2500': ['2.500 passi! Ottimo inizio!', 'Si parte! Già 2.500!', 'Grande! 2.500 passi!'],
      '5000': ['Metà! 5.000 passi!', '5.000! Sei lanciato!', 'Batti cinque! 5.000 passi!'],
      '7500': ['7.500! Quasi fatto!', 'Così vicino! 7.500 passi!', 'Continua così! 7.500 fatti!'],
      'goal': ['Obiettivo battuto! Fantastico!', 'Ce l\'hai fatta! Obiettivo raggiunto!', 'Sì! Obiettivo completato!'],
    },
  },
};
