/// Monthly postcard copy. Unknown language falls back to English.
library;

const postcardLines = <String, Map<String, String>>{
  'en': {
    'mostly': 'A month of steady steps, each one a kindness to yourself. Be proud.',
    'some': 'Step by step, you kept showing up for yourself. That matters.',
    'quiet': 'A quieter month, and every step still counted. Next month is a fresh page.',
  },
  'sk': {
    'mostly': 'Mesiac stálych krokov, každý z nich láskavosť k sebe. Buďte hrdí.',
    'some': 'Krok za krokom ste tu stále boli pre seba. Na tom záleží.',
    'quiet': 'Tichší mesiac, a každý krok sa aj tak počítal. Ďalší mesiac je nová stránka.',
  },
  'cs': {
    'mostly': 'Měsíc stálých kroků, každý z nich laskavost k sobě. Buďte hrdí.',
    'some': 'Krok za krokem jste tu pořád byli pro sebe. Na tom záleží.',
    'quiet': 'Tišší měsíc, a každý krok se přesto počítal. Další měsíc je nová stránka.',
  },
  'pl': {
    'mostly': 'Miesiąc spokojnych kroków, każdy z nich to życzliwość dla siebie.',
    'some': 'Krok po kroku, dzień za dniem, ten czas był dla ciebie. To się liczy.',
    'quiet': 'Cichszy miesiąc, a każdy krok i tak się liczył. Kolejny miesiąc to nowa karta.',
  },
  'de': {
    'mostly': 'Ein Monat ruhiger Schritte, jeder davon gut zu dir. Sei stolz.',
    'some': 'Schritt für Schritt warst du immer wieder für dich da. Das zählt.',
    'quiet': 'Ein ruhigerer Monat, doch jeder Schritt hat gezählt. Bald ein neues Blatt.',
  },
  'es': {
    'mostly': 'Un mes de pasos firmes, cada uno un gesto de cariño contigo.',
    'some': 'Paso a paso, seguiste ahí para ti. Eso importa.',
    'quiet': 'Un mes más tranquilo, y aun así cada paso contó. Ahora, una página nueva.',
  },
  'fr': {
    'mostly': 'Un mois de pas réguliers, chacun une attention envers vous.',
    'some': "Pas à pas, vous avez été là pour vous. C'est important.",
    'quiet': 'Un mois plus calme, et pourtant chaque pas a compté. Place à une page neuve.',
  },
  'it': {
    'mostly': 'Un mese di passi costanti, ognuno un gesto di cura verso di te.',
    'some': 'Passo dopo passo, hai pensato a te. Questo conta.',
    'quiet': 'Un mese più tranquillo, e ogni passo ha contato. Il prossimo è una pagina nuova.',
  },
};

const postcardUi = {
  'en': {
    'title': 'Monthly postcard',
    'save': 'Save to phone',
    'share': 'Share',
    'saved': 'Saved to Pictures/Quiet Steps',
    'needPermission': 'Permission is needed to save the picture.',
    'saveFailed': 'Could not save the picture this time.',
    'shareFailed': 'Could not share this time.',
    'best': 'Best day',
    'walksOne': '{n} walk',
    'walksFew': '{n} walks',
    'walksOther': '{n} walks',
    'brand': 'Quiet Steps',
  },
  'sk': {
    'title': 'Mesačná pohľadnica',
    'save': 'Uložiť do telefónu',
    'share': 'Zdieľať',
    'saved': 'Uložené do Pictures/Quiet Steps',
    'needPermission': 'Na uloženie obrázka treba povolenie.',
    'saveFailed': 'Obrázok sa tentoraz nepodarilo uložiť.',
    'shareFailed': 'Tentoraz sa nepodarilo zdieľať.',
    'best': 'Najlepší deň',
    'walksOne': '{n} prechádzka',
    'walksFew': '{n} prechádzky',
    'walksOther': '{n} prechádzok',
    'brand': 'Quiet Steps',
  },
  'cs': {
    'title': 'Měsíční pohlednice',
    'save': 'Uložit do telefonu',
    'share': 'Sdílet',
    'saved': 'Uloženo do Pictures/Quiet Steps',
    'needPermission': 'K uložení obrázku je potřeba povolení.',
    'saveFailed': 'Obrázek se tentokrát nepodařilo uložit.',
    'shareFailed': 'Tentokrát se nepodařilo sdílet.',
    'best': 'Nejlepší den',
    'walksOne': '{n} procházka',
    'walksFew': '{n} procházky',
    'walksOther': '{n} procházek',
    'brand': 'Quiet Steps',
  },
  'pl': {
    'title': 'Miesięczna pocztówka',
    'save': 'Zapisz w telefonie',
    'share': 'Udostępnij',
    'saved': 'Zapisano w Pictures/Quiet Steps',
    'needPermission': 'Do zapisania obrazu potrzebne jest pozwolenie.',
    'saveFailed': 'Tym razem nie udało się zapisać obrazu.',
    'shareFailed': 'Tym razem nie udało się udostępnić.',
    'best': 'Najlepszy dzień',
    'walksOne': '{n} spacer',
    'walksFew': '{n} spacery',
    'walksOther': '{n} spacerów',
    'brand': 'Quiet Steps',
  },
  'de': {
    'title': 'Monatskarte',
    'save': 'Auf dem Telefon speichern',
    'share': 'Teilen',
    'saved': 'Gespeichert unter Pictures/Quiet Steps',
    'needPermission': 'Zum Speichern des Bildes ist eine Berechtigung nötig.',
    'saveFailed': 'Das Bild konnte diesmal nicht gespeichert werden.',
    'shareFailed': 'Teilen hat diesmal nicht geklappt.',
    'best': 'Bester Tag',
    'walksOne': '{n} Spaziergang',
    'walksFew': '{n} Spaziergänge',
    'walksOther': '{n} Spaziergänge',
    'brand': 'Quiet Steps',
  },
  'es': {
    'title': 'Postal del mes',
    'save': 'Guardar en el teléfono',
    'share': 'Compartir',
    'saved': 'Guardado en Pictures/Quiet Steps',
    'needPermission': 'Hace falta permiso para guardar la imagen.',
    'saveFailed': 'No se pudo guardar la imagen esta vez.',
    'shareFailed': 'No se pudo compartir esta vez.',
    'best': 'Mejor día',
    'walksOne': '{n} paseo',
    'walksFew': '{n} paseos',
    'walksOther': '{n} paseos',
    'brand': 'Quiet Steps',
  },
  'fr': {
    'title': 'Carte du mois',
    'save': 'Enregistrer sur le téléphone',
    'share': 'Partager',
    'saved': 'Enregistré dans Pictures/Quiet Steps',
    'needPermission': 'Une autorisation est nécessaire pour enregistrer l\'image.',
    'saveFailed': 'L\'image n\'a pas pu être enregistrée cette fois.',
    'shareFailed': 'Le partage n\'a pas fonctionné cette fois.',
    'best': 'Meilleur jour',
    'walksOne': '{n} marche',
    'walksFew': '{n} marches',
    'walksOther': '{n} marches',
    'brand': 'Quiet Steps',
  },
  'it': {
    'title': 'Cartolina del mese',
    'save': 'Salva sul telefono',
    'share': 'Condividi',
    'saved': 'Salvata in Pictures/Quiet Steps',
    'needPermission': 'Serve il permesso per salvare l\'immagine.',
    'saveFailed': 'Questa volta non è stato possibile salvare l\'immagine.',
    'shareFailed': 'Questa volta non è stato possibile condividere.',
    'best': 'Giorno migliore',
    'walksOne': '{n} camminata',
    'walksFew': '{n} camminate',
    'walksOther': '{n} camminate',
    'brand': 'Quiet Steps',
  },
};

/// NEW. postcardDayLines[lang][group] -> 7 lines, index 0 = Monday ... 6 = Sunday.
/// postcardLines above keeps one line per group (the Tuesday line) for callers
/// and tests that want a single string.
const postcardDayLines = <String, Map<String, List<String>>>{
  'en': {
    'mostly': [
      "A month of showing up for yourself. Here's to the next one, gently.", // 0 Mon
      'A month of steady steps, each one a kindness to yourself. Be proud.', // 1 Tue
      'Look at this month. You showed up again and again. Be proud.', // 2 Wed
      'So many good days this month. Thank you for looking after yourself.', // 3 Thu
      'Look how often you walked this month. Every day was a kindness.', // 4 Fri
      "Good day after good day. What a lovely month you've had.", // 5 Sat
      'A steady, gentle month. Rest, smile, and be proud of it.', // 6 Sun
    ],
    'some': [
      "A month of small steps forward. Here's to a gentle next one.", // 0 Mon
      'Step by step, you kept showing up for yourself. That matters.', // 1 Tue
      'Some good days, some quiet ones. All of them were yours.', // 2 Wed
      "This month, you found your way back to your steps. That's lovely.", // 3 Thu
      'Every good day this month was a small gift to yourself.', // 4 Fri
      "Walks and rests, side by side. That's a lovely month.", // 5 Sat
      'Step by step, this month was yours. Be proud of every walk.', // 6 Sun
    ],
    'quiet': [
      'A quieter month. A new one is coming, and you can begin gently.', // 0 Mon
      'A quieter month, and every step still counted. Next month is a fresh page.', // 1 Tue
      'A gentle month. Every step still counted, and so do you.', // 2 Wed
      'Quiet months are part of the path too. Be kind to yourself.', // 3 Thu
      'Some months are for resting. Every step still mattered.', // 4 Fri
      'A slow month is still your month. Be gentle with yourself.', // 5 Sat
      "Rest well. Your steps will be here whenever you're ready.", // 6 Sun
    ],
  },
  'sk': {
    'mostly': [
      'Mesiac, keď ste tu boli pre seba. Nech je ten ďalší rovnako jemný.', // 0 Mon
      'Mesiac stálych krokov, každý z nich láskavosť k sebe. Buďte hrdí.', // 1 Tue
      'Pozrite sa na tento mesiac. Znova a znova ste tu boli pre seba.', // 2 Wed
      'Toľko dobrých dní tento mesiac. Vďaka, že sa o seba staráte.', // 3 Thu
      'Pozrite, ako často ste tento mesiac chodili. Každý deň bol láskavosťou.', // 4 Fri
      'Dobrý deň za dobrým dňom. Aký krásny mesiac.', // 5 Sat
      'Stály, jemný mesiac. Oddýchnite si, usmejte sa a buďte naň hrdí.', // 6 Sun
    ],
    'some': [
      'Mesiac malých krokov vpred. Nech je ten ďalší jemný.', // 0 Mon
      'Krok za krokom ste tu stále boli pre seba. Na tom záleží.', // 1 Tue
      'Pár dobrých dní, pár tichších. Všetky boli vaše.', // 2 Wed
      'Tento mesiac ste si našli cestu späť k svojim krokom. To je krásne.', // 3 Thu
      'Každý dobrý deň tento mesiac bol malým darčekom pre vás.', // 4 Fri
      'Prechádzky aj oddych, ruka v ruke. To je krásny mesiac.', // 5 Sat
      'Krok za krokom, tento mesiac bol váš. Buďte hrdí na každú prechádzku.', // 6 Sun
    ],
    'quiet': [
      'Tichší mesiac. Prichádza nový a môžete ho začať zľahka.', // 0 Mon
      'Tichší mesiac, a každý krok sa aj tak počítal. Ďalší mesiac je nová stránka.', // 1 Tue
      'Jemný mesiac. Každý krok sa počítal, a rovnako aj vy.', // 2 Wed
      'Aj tiché mesiace patria k ceste. Buďte k sebe láskaví.', // 3 Thu
      'Niektoré mesiace sú na oddych. Každý krok mal svoj zmysel.', // 4 Fri
      'Pomalý mesiac je stále váš mesiac. Buďte k sebe jemní.', // 5 Sat
      'Oddýchnite si. Vaše kroky tu budú, kedykoľvek budete pripravení.', // 6 Sun
    ],
  },
  'cs': {
    'mostly': [
      'Měsíc, kdy jste tu byli pro sebe. Ať je ten další stejně jemný.', // 0 Mon
      'Měsíc stálých kroků, každý z nich laskavost k sobě. Buďte hrdí.', // 1 Tue
      'Podívejte se na tenhle měsíc. Znovu a znovu jste tu byli pro sebe.', // 2 Wed
      'Tolik dobrých dnů tento měsíc. Díky, že o sebe pečujete.', // 3 Thu
      'Podívejte, jak často jste tento měsíc chodili. Každý den byl laskavostí.', // 4 Fri
      'Dobrý den za dobrým dnem. Jaký krásný měsíc.', // 5 Sat
      'Stálý, jemný měsíc. Odpočiňte si, usmějte se a buďte na něj hrdí.', // 6 Sun
    ],
    'some': [
      'Měsíc malých kroků vpřed. Ať je ten další jemný.', // 0 Mon
      'Krok za krokem jste tu pořád byli pro sebe. Na tom záleží.', // 1 Tue
      'Pár dobrých dnů, pár tišších. Všechny byly vaše.', // 2 Wed
      'Tento měsíc jste si našli cestu zpět ke svým krokům. To je krásné.', // 3 Thu
      'Každý dobrý den tento měsíc byl malým dárkem pro vás.', // 4 Fri
      'Procházky i odpočinek, ruku v ruce. To je krásný měsíc.', // 5 Sat
      'Krok za krokem, tento měsíc byl váš. Buďte hrdí na každou procházku.', // 6 Sun
    ],
    'quiet': [
      'Tišší měsíc. Přichází nový a můžete ho začít zlehka.', // 0 Mon
      'Tišší měsíc, a každý krok se přesto počítal. Další měsíc je nová stránka.', // 1 Tue
      'Jemný měsíc. Každý krok se počítal, a vy také.', // 2 Wed
      'I tiché měsíce patří k cestě. Buďte k sobě laskaví.', // 3 Thu
      'Některé měsíce jsou na odpočinek. Každý krok měl svůj smysl.', // 4 Fri
      'Pomalý měsíc je pořád váš měsíc. Buďte k sobě jemní.', // 5 Sat
      'Odpočiňte si. Vaše kroky tu budou, kdykoli budete připraveni.', // 6 Sun
    ],
  },
  'pl': {
    'mostly': [
      'Miesiąc, w którym ten czas był dla ciebie. Niech następny będzie równie łagodny.', // 0 Mon
      'Miesiąc spokojnych kroków, każdy z nich to życzliwość dla siebie.', // 1 Tue
      'Spójrz na ten miesiąc. Raz za razem ten czas był dla ciebie.', // 2 Wed
      'Tyle dobrych dni w tym miesiącu. Dzięki, że o siebie dbasz.', // 3 Thu
      'Zobacz, jak często w tym miesiącu był spacer. Każdy dzień był życzliwością.', // 4 Fri
      'Dobry dzień za dobrym dniem. Co za piękny miesiąc.', // 5 Sat
      'Równy, łagodny miesiąc. Odpocznij, uśmiechnij się, to powód do dumy.', // 6 Sun
    ],
    'some': [
      'Miesiąc małych kroków naprzód. Niech następny będzie łagodny.', // 0 Mon
      'Krok po kroku, dzień za dniem, ten czas był dla ciebie. To się liczy.', // 1 Tue
      'Kilka dobrych dni, kilka cichszych. Wszystkie były twoje.', // 2 Wed
      'W tym miesiącu udało się wrócić do swoich kroków. To piękne.', // 3 Thu
      'Każdy dobry dzień w tym miesiącu był małym prezentem dla ciebie.', // 4 Fri
      'Spacery i odpoczynek, ramię w ramię. To piękny miesiąc.', // 5 Sat
      'Krok po kroku, ten miesiąc był twój. Każdy spacer to powód do dumy.', // 6 Sun
    ],
    'quiet': [
      'Cichszy miesiąc. Nadchodzi nowy i możesz zacząć go łagodnie.', // 0 Mon
      'Cichszy miesiąc, a każdy krok i tak się liczył. Kolejny miesiąc to nowa karta.', // 1 Tue
      'Łagodny miesiąc. Każdy krok się liczył, i ty też.', // 2 Wed
      'Ciche miesiące też są częścią drogi. Traktuj siebie życzliwie.', // 3 Thu
      'Niektóre miesiące są do odpoczynku. Każdy krok miał znaczenie.', // 4 Fri
      'Powolny miesiąc to wciąż twój miesiąc. Traktuj siebie łagodnie.', // 5 Sat
      'Odpocznij. Twoje kroki będą tu, kiedy tylko zechcesz.', // 6 Sun
    ],
  },
  'de': {
    'mostly': [
      'Ein Monat, in dem du für dich da warst. Auf den nächsten, ganz sanft.', // 0 Mon
      'Ein Monat ruhiger Schritte, jeder davon gut zu dir. Sei stolz.', // 1 Tue
      'Schau dir diesen Monat an. Du warst immer wieder für dich da.', // 2 Wed
      'So viele gute Tage in diesem Monat. Danke, dass du gut für dich sorgst.', // 3 Thu
      'Schau, wie oft du diesen Monat gegangen bist. Jeder Tag war ein Geschenk.', // 4 Fri
      'Ein guter Tag nach dem anderen. Was für ein schöner Monat.', // 5 Sat
      'Ein stetiger, sanfter Monat. Ruh dich aus, lächle und sei stolz darauf.', // 6 Sun
    ],
    'some': [
      'Ein Monat kleiner Schritte nach vorn. Auf einen sanften nächsten.', // 0 Mon
      'Schritt für Schritt warst du immer wieder für dich da. Das zählt.', // 1 Tue
      'Ein paar gute Tage, ein paar ruhige. Alle gehörten dir.', // 2 Wed
      'Diesen Monat hast du den Weg zurück zu deinen Schritten gefunden. Wie schön.', // 3 Thu
      'Jeder gute Tag in diesem Monat war ein kleines Geschenk an dich.', // 4 Fri
      'Spaziergänge und Pausen, Seite an Seite. Ein schöner Monat.', // 5 Sat
      'Schritt für Schritt war dieser Monat deiner. Sei stolz auf jeden Weg.', // 6 Sun
    ],
    'quiet': [
      'Ein ruhigerer Monat. Ein neuer kommt, und du kannst sanft beginnen.', // 0 Mon
      'Ein ruhigerer Monat, doch jeder Schritt hat gezählt. Bald ein neues Blatt.', // 1 Tue
      'Ein sanfter Monat. Jeder Schritt hat gezählt, und du auch.', // 2 Wed
      'Auch ruhige Monate gehören zum Weg. Sei gut zu dir.', // 3 Thu
      'Manche Monate sind zum Ausruhen da. Jeder Schritt war wichtig.', // 4 Fri
      'Ein langsamer Monat ist trotzdem dein Monat. Sei sanft zu dir.', // 5 Sat
      'Ruh dich gut aus. Deine Schritte sind da, wann immer du bereit bist.', // 6 Sun
    ],
  },
  'es': {
    'mostly': [
      'Un mes cuidándote. Por el próximo, con suavidad.', // 0 Mon
      'Un mes de pasos firmes, cada uno un gesto de cariño contigo.', // 1 Tue
      'Mira este mes. Una y otra vez estuviste ahí para ti.', // 2 Wed
      'Cuántos días buenos este mes. Gracias por cuidarte.', // 3 Thu
      'Mira cuántas veces caminaste este mes. Cada día fue un regalo.', // 4 Fri
      'Un buen día tras otro. Qué mes tan bonito.', // 5 Sat
      'Un mes constante y suave. Descansa, sonríe y date ese mérito.', // 6 Sun
    ],
    'some': [
      'Un mes de pequeños pasos hacia delante. Por un próximo mes suave.', // 0 Mon
      'Paso a paso, seguiste ahí para ti. Eso importa.', // 1 Tue
      'Algunos días buenos, otros más tranquilos. Todos fueron tuyos.', // 2 Wed
      'Este mes encontraste el camino de vuelta a tus pasos. Qué bonito.', // 3 Thu
      'Cada día bueno de este mes fue un pequeño regalo para ti.', // 4 Fri
      'Paseos y descansos, de la mano. Un mes precioso.', // 5 Sat
      'Paso a paso, este mes fue tuyo. Cada paseo cuenta.', // 6 Sun
    ],
    'quiet': [
      'Un mes más tranquilo. Llega uno nuevo, y puedes empezarlo con calma.', // 0 Mon
      'Un mes más tranquilo, y aun así cada paso contó. Ahora, una página nueva.', // 1 Tue
      'Un mes suave. Cada paso contó, y tú también.', // 2 Wed
      'Los meses tranquilos también son parte del camino. Trátate con cariño.', // 3 Thu
      'Algunos meses son para descansar. Cada paso tuvo su valor.', // 4 Fri
      'Un mes lento sigue siendo tu mes. Trátate con suavidad.', // 5 Sat
      'Descansa. Tus pasos estarán aquí cuando quieras volver.', // 6 Sun
    ],
  },
  'fr': {
    'mostly': [
      'Un mois à prendre soin de vous. Au suivant, en douceur.', // 0 Mon
      'Un mois de pas réguliers, chacun une attention envers vous.', // 1 Tue
      'Regardez ce mois. Encore et encore, vous avez été là pour vous.', // 2 Wed
      'Tant de bons jours ce mois-ci. Merci de prendre soin de vous.', // 3 Thu
      'Que de marches ce mois-ci. Chaque jour était un cadeau.', // 4 Fri
      "Une bonne journée après l'autre. Quel beau mois.", // 5 Sat
      'Un mois régulier et doux. Reposez-vous, souriez, accordez-vous ce mérite.', // 6 Sun
    ],
    'some': [
      'Un mois de petits pas en avant. À un mois prochain tout en douceur.', // 0 Mon
      "Pas à pas, vous avez été là pour vous. C'est important.", // 1 Tue
      "Quelques bons jours, d'autres plus calmes. Tous étaient les vôtres.", // 2 Wed
      "Ce mois-ci, vous avez retrouvé le chemin de vos pas. C'est beau.", // 3 Thu
      'Chaque bonne journée de ce mois était un petit cadeau pour vous.', // 4 Fri
      'Marches et repos, main dans la main. Un très beau mois.', // 5 Sat
      'Pas à pas, ce mois était le vôtre. Chaque marche compte.', // 6 Sun
    ],
    'quiet': [
      'Un mois plus calme. Un nouveau arrive, et vous pouvez le commencer en douceur.', // 0 Mon
      'Un mois plus calme, et pourtant chaque pas a compté. Place à une page neuve.', // 1 Tue
      'Un mois tout en douceur. Chaque pas a compté, et vous aussi.', // 2 Wed
      'Les mois calmes font aussi partie du chemin. Prenez soin de vous.', // 3 Thu
      'Certains mois sont faits pour le repos. Chaque pas avait sa valeur.', // 4 Fri
      'Un mois lent reste votre mois. Ménagez-vous.', // 5 Sat
      'Reposez-vous. Vos pas seront là quand vous voudrez revenir.', // 6 Sun
    ],
  },
  'it': {
    'mostly': [
      'Un mese passato a prenderti cura di te. Al prossimo, con dolcezza.', // 0 Mon
      'Un mese di passi costanti, ognuno un gesto di cura verso di te.', // 1 Tue
      'Guarda questo mese. Ancora e ancora, hai pensato a te.', // 2 Wed
      'Tanti giorni buoni questo mese. Grazie per prenderti cura di te.', // 3 Thu
      'Guarda quante volte hai camminato questo mese. Ogni giorno è stato un regalo.', // 4 Fri
      "Una buona giornata dopo l'altra. Che bel mese.", // 5 Sat
      'Un mese costante e dolce. Riposa, sorridi e riconoscitelo.', // 6 Sun
    ],
    'some': [
      'Un mese di piccoli passi avanti. A un prossimo mese dolce.', // 0 Mon
      'Passo dopo passo, hai pensato a te. Questo conta.', // 1 Tue
      'Alcuni giorni buoni, altri più tranquilli. Tutti erano tuoi.', // 2 Wed
      'Questo mese hai ritrovato la strada dei tuoi passi. Che bello.', // 3 Thu
      'Ogni giorno buono di questo mese è stato un piccolo regalo per te.', // 4 Fri
      'Passeggiate e riposo, mano nella mano. Un mese bellissimo.', // 5 Sat
      'Passo dopo passo, questo mese è stato tuo. Ogni passeggiata conta.', // 6 Sun
    ],
    'quiet': [
      'Un mese più tranquillo. Ne arriva uno nuovo, e puoi iniziarlo con calma.', // 0 Mon
      'Un mese più tranquillo, e ogni passo ha contato. Il prossimo è una pagina nuova.', // 1 Tue
      'Un mese dolce. Ogni passo ha contato, e anche tu.', // 2 Wed
      'Anche i mesi tranquilli fanno parte del cammino. Sii gentile con te.', // 3 Thu
      'Alcuni mesi sono fatti per riposare. Ogni passo ha avuto il suo valore.', // 4 Fri
      'Un mese lento è comunque il tuo mese. Trattati con dolcezza.', // 5 Sat
      'Riposa. I tuoi passi saranno qui quando vorrai tornare.', // 6 Sun
    ],
  },
};
