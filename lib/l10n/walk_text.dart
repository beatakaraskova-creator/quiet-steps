/// Walk-with-intention copy. Unknown language falls back to English.
/// Moods: clear, gratitude, move, slow, energy.
library;

const walkMoodIds = ['clear', 'gratitude', 'move', 'slow', 'energy'];

const walkLines = <String, Map<String, List<String>>>{
  'en': {
    'clear': [
      'Hopefully your mind feels a little lighter now.',
      'Fresh air, clearer thoughts. Well done.',
    ],
    'gratitude': [
      'Thank you for taking this time for yourself.',
      'A walk full of small good things.',
    ],
    'move': [
      'Every step counted. Nice work.',
      "You moved. That's what matters.",
    ],
    'slow': [
      'Gentle and unhurried. Just right.',
      'You gave yourself some calm.',
    ],
    'energy': [
      'That should wake you up nicely!',
      'Feel that energy? Well done!',
    ],
  },
  'sk': {
    'clear': [
      'Dúfame, že máte teraz o čosi ľahšiu myseľ.',
      'Čerstvý vzduch, jasnejšie myšlienky. Výborne.',
    ],
    'gratitude': [
      'Ďakujeme, že ste si vzali tento čas pre seba.',
      'Prechádzka plná malých dobrých vecí.',
    ],
    'move': [
      'Každý krok sa počítal. Pekná práca.',
      'Hýbali ste sa. Na tom záleží.',
    ],
    'slow': [
      'Jemne a bez ponáhľania. Presne tak.',
      'Dopriali ste si pokoj.',
    ],
    'energy': [
      'To by vás malo pekne prebudiť!',
      'Cítite tú energiu? Výborne!',
    ],
  },
  'cs': {
    'clear': [
      'Snad je teď mysl o něco lehčí.',
      'Čerstvý vzduch, jasnější myšlenky. Výborně.',
    ],
    'gratitude': [
      'Děkujeme, že jste si vzali tenhle čas pro sebe.',
      'Procházka plná malých dobrých věcí.',
    ],
    'move': [
      'Každý krok se počítal. Pěkná práce.',
      'Hýbali jste se. Na tom záleží.',
    ],
    'slow': [
      'Jemně a bez spěchu. Přesně tak.',
      'Dopřáli jste si klid.',
    ],
    'energy': [
      'To by vás mělo hezky probrat!',
      'Cítíte tu energii? Výborně!',
    ],
  },
  'pl': {
    'clear': [
      'Oby umysł był teraz trochę lżejszy.',
      'Świeże powietrze, jaśniejsze myśli. Brawo.',
    ],
    'gratitude': [
      'Dziękujemy, że wzięto ten czas dla siebie.',
      'Spacer pełen małych dobrych rzeczy.',
    ],
    'move': [
      'Każdy krok się liczył. Dobra robota.',
      'Był ruch. To się liczy.',
    ],
    'slow': [
      'Łagodnie i bez pośpiechu. W sam raz.',
      'Była chwila spokoju dla siebie.',
    ],
    'energy': [
      'To powinno miło rozbudzić!',
      'Czujecie tę energię? Brawo!',
    ],
  },
  'de': {
    'clear': [
      'Hoffentlich fühlt sich der Kopf jetzt ein wenig leichter an.',
      'Frische Luft, klarere Gedanken. Gut gemacht.',
    ],
    'gratitude': [
      'Danke, dass du dir diese Zeit genommen hast.',
      'Ein Spaziergang voller kleiner guter Dinge.',
    ],
    'move': [
      'Jeder Schritt hat gezählt. Schön gemacht.',
      'Du hast dich bewegt. Darauf kommt es an.',
    ],
    'slow': [
      'Sanft und ohne Eile. Genau richtig.',
      'Du hast dir etwas Ruhe geschenkt.',
    ],
    'energy': [
      'Das sollte dich schön wach machen!',
      'Spürst du die Energie? Gut gemacht!',
    ],
  },
  'es': {
    'clear': [
      'Ojalá la mente se sienta ahora un poco más ligera.',
      'Aire fresco, ideas más claras. Bien hecho.',
    ],
    'gratitude': [
      'Gracias por tomarte este tiempo para ti.',
      'Un paseo lleno de pequeñas cosas buenas.',
    ],
    'move': [
      'Cada paso contó. Buen trabajo.',
      'Te has movido. Eso es lo que importa.',
    ],
    'slow': [
      'Suave y sin prisa. Justo así.',
      'Te has dado un rato de calma.',
    ],
    'energy': [
      '¡Eso debería despertarte con suavidad!',
      '¿Sientes esa energía? ¡Bien hecho!',
    ],
  },
  'fr': {
    'clear': [
      'Espérons que l\'esprit se sente un peu plus léger.',
      'Air frais, idées plus claires. Bravo.',
    ],
    'gratitude': [
      'Merci d\'avoir pris ce temps pour vous.',
      'Une promenade pleine de petites bonnes choses.',
    ],
    'move': [
      'Chaque pas a compté. Beau travail.',
      'Vous avez bougé. C\'est l\'essentiel.',
    ],
    'slow': [
      'Tout en douceur, sans se presser. Juste bien.',
      'Vous vous êtes offert un peu de calme.',
    ],
    'energy': [
      'Cela devrait vous réveiller tout en douceur !',
      'Vous sentez cette énergie ? Bravo !',
    ],
  },
  'it': {
    'clear': [
      'Speriamo che la mente sia un po\' più leggera adesso.',
      'Aria fresca, pensieri più chiari. Ben fatto.',
    ],
    'gratitude': [
      'Grazie per esserti preso questo tempo.',
      'Una camminata piena di piccole cose buone.',
    ],
    'move': [
      'Ogni passo ha contato. Bel lavoro.',
      'C\'è stato movimento. È questo che conta.',
    ],
    'slow': [
      'Dolce, senza fretta. Proprio così.',
      'Un po\' di calma, donata a te.',
    ],
    'energy': [
      'Dovrebbe svegliarti proprio bene!',
      'Senti quell\'energia? Ben fatto!',
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
