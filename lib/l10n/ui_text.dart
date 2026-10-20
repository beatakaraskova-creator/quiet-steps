/// Remaining app chrome: onboarding, home, settings, look, history, errors,
/// notifications and the first-launch language picker.
/// Unknown language falls back to English.
library;

const ui = {
  'en': {
    'languageTitle': 'Your language',
    'continue': 'Continue',
    'languageAuto': 'Automatic',
    'skip': 'Skip',
    'next': 'Next',
    'getStarted': 'Get started',
    'appName': 'Quiet Steps',
    'page1Body': 'A calm step counter that lives only on your phone.',
    'page2Title': 'Private by design',
    'page2Body':
        'No account. No internet. No GPS. Your steps never leave this phone.',
    'page3Title': 'Your daily goal',
    'page3Body':
        'Next, allow Physical activity so your phone can count your steps.',
    'goalLabel': 'Daily goal (steps)',
    'goalMustBe100': 'Goal must be at least 100',
    'settings': 'Settings',
    'save': 'Save',
    'language': 'Language',
    'height': 'Height (cm)',
    'stride': 'Stride (cm)',
    'weight': 'Weight (kg) — for kcal estimate only',
    'milestoneMessages': 'Milestone messages',
    'speakMessages': 'Speak messages aloud',
    'voiceSpeed': 'Voice speed',
    'voiceSlow': 'Slow',
    'voiceNormal': 'Normal',
    'voice': 'Voice',
    'voiceFemale': 'Female',
    'voiceMale': 'Male',
    'voicePhone': "Phone's voice",
    'voicePlaySample': 'Play sample',
    'voiceTestIn10': 'Test milestone voice in 10 seconds',
    'latestMilestone': 'Today',
    'aboutTitle': 'About & credits',
    'privacyTitle': 'Privacy policy',
    'privacyHint': 'Read it in any browser at this address:',
    'privacyCopy': 'Copy link',
    'privacyCopied': 'Link copied',
    'aboutIntro':
        'Quiet Steps includes pre-recorded voices so it can speak without the internet. Piper voices are by rhasspy.',
    'aboutVoices':
        'English female — cori, public domain\n'
            'English male — norman, public domain\n'
            'Slovak female — lili, CC0\n'
            'Slovak male — jirka (Czech, reads Slovak), CC0\n'
            'Czech female — kasandra, CC BY 4.0\n'
            'Czech male — jirka, CC0\n'
            'Polish female — gosia, CC0\n'
            'Polish male — darkman, CC0\n'
            'German female — ramona, BSD-style\n'
            'German male — thorsten, CC0\n'
            'Spanish female — sharvard (speaker F), CC BY 3.0\n'
            'Spanish male — davefx, CC0\n'
            'French female — siwis, CC BY 4.0\n'
            'French male — upmc (pierre), CC BY-SA 4.0\n'
            'Italian female — paola, CC0\n'
            'Italian male — riccardo, BSD-style',
    'style': 'Style',
    'styleCalm': 'Calm',
    'styleCheerful': 'Cheerful',
    'quietHours': 'Quiet hours',
    'quietStart': 'Starts',
    'quietEnd': 'Ends',
    'medical':
        'Quiet Steps is not a medical device. It does not diagnose, treat, cure or prevent any condition.\n\n'
            'Steps come from the phone sensor. Distance and calories are estimates from the numbers you type here.\n\n'
            'Nothing is uploaded. There is no account. GPS is not used.',
    'look': 'Look',
    'history': 'History',
    'ofToday': 'of {n} today',
    'km': 'km',
    'kcal': 'kcal',
    'goalPct': 'goal',
    'permissionDenied':
        'Physical activity permission is needed so the phone can count steps. Location is not used.',
    'startCounting': 'Start counting',
    'pauseCounting': 'Pause counting',
    'resetToday': 'Reset today',
    'resetTodayTitle': 'Reset today?',
    'resetTodayBody': "Today's count goes back to zero. History stays.",
    'keep': 'Keep',
    'reset': 'Reset',
    'countingOn':
        'Counting in the background. Keep the notification on. No GPS. No internet. Data stays on this phone.',
    'countingOff':
        'Tap Start. Walk with the phone on you. You can leave the app — the notification means it is still counting.',
    'today': 'today',
    'needActivity':
        'Physical activity permission is needed so the phone can count steps.',
    'needNotifications':
        'Allow notifications so counting can stay on in the pocket.',
    'noSensorWalk':
        'This phone did not give a step sensor. Some models need a short walk first.',
    'noSensor': 'Step sensor is not available on this device.',
    'bgFailed':
        'Background counting did not start. Counting on this screen instead.',
    'lookTitle': 'Look',
    'yourColours': 'Your colours',
    'accent': 'Accent',
    'background': 'Background',
    'accentHint': 'The ring, buttons and highlights',
    'backgroundHint': 'The page behind the ring and cards',
    'packs': 'Packs',
    'backgroundPhoto': 'Background photo',
    'changePhoto': 'Change photo',
    'usePhoto': 'Use a photo (dog, walk, anything)',
    'cropPhoto': 'Crop photo',
    'removePhoto': 'Remove photo',
    'typeSize': 'Type size',
    'tapToPick': 'Tap to pick',
    'done': 'Done',
    'lookHint':
        'Tap a colour circle to pick any colour. Accent is the ring and buttons. Background is the page when there is no photo. A photo sits behind the numbers — crop it so the part you want fills the screen.',
    'pack_quiet_gold': 'Quiet gold',
    'pack_night_moss': 'Night moss',
    'pack_ember': 'Ember',
    'pack_paper': 'Paper',
    'pack_custom': 'Your colours',
    'noDaysYet': 'No days yet.',
    'cancel': 'Cancel',
    'fill': 'Fill',
    'use': 'Use',
    'fgChannelName': 'Quiet Steps',
    'fgChannelDesc': 'Step counting on this phone. Nothing is sent.',
    'fgCounting': 'Counting steps on this phone only',
    'fgStepsToday': '{n} steps today · on this phone only',
    'milestoneChannel': 'Milestone messages',
    'milestoneChannelDesc':
        'Gentle messages when you reach a walking milestone.',
    'reflectionChannel': 'Evening reflection',
    'reflectionChannelDesc': 'A gentle summary of the day.',
  },
  'sk': {
    'languageTitle': 'Váš jazyk',
    'continue': 'Pokračovať',
    'languageAuto': 'Automaticky',
    'skip': 'Preskočiť',
    'next': 'Ďalej',
    'getStarted': 'Začíname',
    'appName': 'Quiet Steps',
    'page1Body': 'Pokojný počítač krokov, ktorý žije len vo vašom telefóne.',
    'page2Title': 'Súkromné od začiatku',
    'page2Body':
        'Žiadny účet. Žiadny internet. Žiadne GPS. Vaše kroky z tohto telefónu nikam neodchádzajú.',
    'page3Title': 'Váš denný cieľ',
    'page3Body':
        'Potom povoľte Fyzickú aktivitu, aby telefón mohol počítať vaše kroky.',
    'goalLabel': 'Denný cieľ (kroky)',
    'goalMustBe100': 'Cieľ musí byť aspoň 100',
    'settings': 'Nastavenia',
    'save': 'Uložiť',
    'language': 'Jazyk',
    'height': 'Výška (cm)',
    'stride': 'Dĺžka kroku (cm)',
    'weight': 'Hmotnosť (kg) — len pre odhad kcal',
    'milestoneMessages': 'Správy pri míľnikoch',
    'speakMessages': 'Čítať správy nahlas',
    'voiceSpeed': 'Rýchlosť hlasu',
    'voiceSlow': 'Pomaly',
    'voiceNormal': 'Normálne',
    'voice': 'Hlas',
    'voiceFemale': 'Ženský',
    'voiceMale': 'Mužský',
    'voicePhone': 'Hlas telefónu',
    'voicePlaySample': 'Prehrať ukážku',
    'voiceTestIn10': 'Vyskúšať hlas míľnika o 10 sekúnd',
    'latestMilestone': 'Dnes',
    'aboutTitle': 'O aplikácii a poďakovania',
    'privacyTitle': 'Zásady ochrany súkromia',
    'privacyHint': 'Prečítajte si ich v ľubovoľnom prehliadači na tejto adrese:',
    'privacyCopy': 'Kopírovať odkaz',
    'privacyCopied': 'Odkaz skopírovaný',
    'aboutIntro':
        'Quiet Steps obsahuje vopred nahraté hlasy, aby mohol hovoriť bez internetu. Hlasy Piper sú od rhasspy.',
    'aboutVoices':
        'Angličtina, ženský — cori, public domain\n'
            'Angličtina, mužský — norman, public domain\n'
            'Slovenčina, ženský — lili, CC0\n'
            'Slovenčina, mužský — jirka (český, číta slovensky), CC0\n'
            'Čeština, ženský — kasandra, CC BY 4.0\n'
            'Čeština, mužský — jirka, CC0\n'
            'Poľština, ženský — gosia, CC0\n'
            'Poľština, mužský — darkman, CC0\n'
            'Nemčina, ženský — ramona, BSD-style\n'
            'Nemčina, mužský — thorsten, CC0\n'
            'Španielčina, ženský — sharvard (speaker F), CC BY 3.0\n'
            'Španielčina, mužský — davefx, CC0\n'
            'Francúzština, ženský — siwis, CC BY 4.0\n'
            'Francúzština, mužský — upmc (pierre), CC BY-SA 4.0\n'
            'Taliančina, ženský — paola, CC0\n'
            'Taliančina, mužský — riccardo, BSD-style',
    'style': 'Štýl',
    'styleCalm': 'Pokojný',
    'styleCheerful': 'Oživenejší',
    'quietHours': 'Tiché hodiny',
    'quietStart': 'Začínajú',
    'quietEnd': 'Končia',
    'medical':
        'Quiet Steps nie je zdravotnícka pomôcka. Nediagnostikuje, nelieči a nepredpisuje.\n\n'
            'Kroky prichádzajú zo senzora telefónu. Vzdialenosť a kalórie sú odhad z čísel, ktoré sem zadáte.\n\n'
            'Nič sa neodosiela. Žiadny účet. GPS sa nepoužíva.',
    'look': 'Vzhľad',
    'history': 'História',
    'ofToday': 'z {n} dnes',
    'km': 'km',
    'kcal': 'kcal',
    'goalPct': 'cieľ',
    'permissionDenied':
        'Na počítanie krokov treba povolenie Fyzická aktivita. Poloha sa nepoužíva.',
    'startCounting': 'Spustiť počítanie',
    'pauseCounting': 'Pozastaviť počítanie',
    'resetToday': 'Vynulovať dnes',
    'resetTodayTitle': 'Vynulovať dnešok?',
    'resetTodayBody': 'Dnešný počet sa vráti na nulu. História ostane.',
    'keep': 'Ponechať',
    'reset': 'Vynulovať',
    'countingOn':
        'Počíta na pozadí. Nechajte oznámenie zapnuté. Bez GPS. Bez internetu. Údaje ostávajú v tomto telefóne.',
    'countingOff':
        'Ťuknite na Štart. Choďte s telefónom pri sebe. Aplikáciu môžete opustiť — oznámenie znamená, že stále počíta.',
    'today': 'dnes',
    'needActivity':
        'Na počítanie krokov treba povolenie Fyzická aktivita.',
    'needNotifications':
        'Povoľte oznámenia, aby počítanie ostalo zapnuté aj v vrecku.',
    'noSensorWalk':
        'Tento telefón zatiaľ nedal senzor krokov. Niektoré modely potrebujú najprv krátku prechádzku.',
    'noSensor': 'Senzor krokov na tomto zariadení nie je k dispozícii.',
    'bgFailed':
        'Počítanie na pozadí sa nespustilo. Zatiaľ počítame na tejto obrazovke.',
    'lookTitle': 'Vzhľad',
    'yourColours': 'Vaše farby',
    'accent': 'Akcent',
    'background': 'Pozadie',
    'accentHint': 'Kruh, tlačidlá a zvýraznenia',
    'backgroundHint': 'Stránka za kruhom a kartami',
    'packs': 'Sady',
    'backgroundPhoto': 'Fotka na pozadí',
    'changePhoto': 'Zmeniť fotku',
    'usePhoto': 'Použiť fotku (pes, prechádzka, čokoľvek)',
    'cropPhoto': 'Orezať fotku',
    'removePhoto': 'Odstrániť fotku',
    'typeSize': 'Veľkosť písma',
    'tapToPick': 'Ťuknite a vyberte',
    'done': 'Hotovo',
    'lookHint':
        'Ťuknite na farebný kruh a vyberte ľubovoľnú farbu. Akcent je kruh a tlačidlá. Pozadie je stránka, keď nie je fotka. Fotka je za číslami — orežte ju tak, aby vyplnila obrazovku to, na čom vám záleží.',
    'pack_quiet_gold': 'Tiché zlato',
    'pack_night_moss': 'Nočný mach',
    'pack_ember': 'Žeravica',
    'pack_paper': 'Papier',
    'pack_custom': 'Vaše farby',
    'noDaysYet': 'Zatiaľ žiadne dni.',
    'cancel': 'Zrušiť',
    'fill': 'Vyplniť',
    'use': 'Použiť',
    'fgChannelName': 'Quiet Steps',
    'fgChannelDesc': 'Počítanie krokov v tomto telefóne. Nič sa neodosiela.',
    'fgCounting': 'Počítame kroky len v tomto telefóne',
    'fgStepsToday': '{n} krokov dnes · len v tomto telefóne',
    'milestoneChannel': 'Správy pri míľnikoch',
    'milestoneChannelDesc': 'Jemné správy, keď dosiahnete míľnik chôdze.',
    'reflectionChannel': 'Večerné zamyslenie',
    'reflectionChannelDesc': 'Jemný súhrn dňa.',
  },
  'cs': {
    'languageTitle': 'Váš jazyk',
    'continue': 'Pokračovat',
    'languageAuto': 'Automaticky',
    'skip': 'Přeskočit',
    'next': 'Další',
    'getStarted': 'Začínáme',
    'appName': 'Quiet Steps',
    'page1Body': 'Klidný počítač kroků, který žije jen ve vašem telefonu.',
    'page2Title': 'Soukromé od začátku',
    'page2Body':
        'Žádný účet. Žádný internet. Žádné GPS. Vaše kroky z tohoto telefonu nikam neodcházejí.',
    'page3Title': 'Váš denní cíl',
    'page3Body':
        'Pak povolte Fyzickou aktivitu, aby telefon mohl počítat vaše kroky.',
    'goalLabel': 'Denní cíl (kroky)',
    'goalMustBe100': 'Cíl musí být aspoň 100',
    'settings': 'Nastavení',
    'save': 'Uložit',
    'language': 'Jazyk',
    'height': 'Výška (cm)',
    'stride': 'Délka kroku (cm)',
    'weight': 'Hmotnost (kg) — jen pro odhad kcal',
    'milestoneMessages': 'Zprávy u milníků',
    'speakMessages': 'Číst zprávy nahlas',
    'voiceSpeed': 'Rychlost hlasu',
    'voiceSlow': 'Pomalu',
    'voiceNormal': 'Normálně',
    'voice': 'Hlas',
    'voiceFemale': 'Ženský',
    'voiceMale': 'Mužský',
    'voicePhone': 'Hlas telefonu',
    'voicePlaySample': 'Přehrát ukázku',
    'voiceTestIn10': 'Vyzkoušet hlas milníku za 10 sekund',
    'latestMilestone': 'Dnes',
    'aboutTitle': 'O aplikaci a poděkování',
    'privacyTitle': 'Zásady ochrany soukromí',
    'privacyHint': 'Přečtěte si je v libovolném prohlížeči na této adrese:',
    'privacyCopy': 'Kopírovat odkaz',
    'privacyCopied': 'Odkaz zkopírován',
    'aboutIntro':
        'Quiet Steps obsahuje předem nahrané hlasy, aby mohl mluvit bez internetu. Hlasy Piper jsou od rhasspy.',
    'aboutVoices':
        'Angličtina, ženský — cori, public domain\n'
            'Angličtina, mužský — norman, public domain\n'
            'Slovenština, ženský — lili, CC0\n'
            'Slovenština, mužský — jirka (český, čte slovensky), CC0\n'
            'Čeština, ženský — kasandra, CC BY 4.0\n'
            'Čeština, mužský — jirka, CC0\n'
            'Polština, ženský — gosia, CC0\n'
            'Polština, mužský — darkman, CC0\n'
            'Němčina, ženský — ramona, BSD-style\n'
            'Němčina, mužský — thorsten, CC0\n'
            'Španělština, ženský — sharvard (speaker F), CC BY 3.0\n'
            'Španělština, mužský — davefx, CC0\n'
            'Francouzština, ženský — siwis, CC BY 4.0\n'
            'Francouzština, mužský — upmc (pierre), CC BY-SA 4.0\n'
            'Italština, ženský — paola, CC0\n'
            'Italština, mužský — riccardo, BSD-style',
    'style': 'Styl',
    'styleCalm': 'Klidný',
    'styleCheerful': 'Veselejší',
    'quietHours': 'Tiché hodiny',
    'quietStart': 'Začínají',
    'quietEnd': 'Končí',
    'medical':
        'Quiet Steps není zdravotnická pomůcka. Nediagnostikuje, neléčí a nepředepisuje.\n\n'
            'Kroky přicházejí ze senzoru telefonu. Vzdálenost a kalorie jsou odhad z čísel, která sem zadáte.\n\n'
            'Nic se neodesílá. Žádný účet. GPS se nepoužívá.',
    'look': 'Vzhled',
    'history': 'Historie',
    'ofToday': 'z {n} dnes',
    'km': 'km',
    'kcal': 'kcal',
    'goalPct': 'cíl',
    'permissionDenied':
        'K počítání kroků je potřeba oprávnění Fyzická aktivita. Poloha se nepoužívá.',
    'startCounting': 'Spustit počítání',
    'pauseCounting': 'Pozastavit počítání',
    'resetToday': 'Vynulovat dnešek',
    'resetTodayTitle': 'Vynulovat dnešek?',
    'resetTodayBody': 'Dnešní počet se vrátí na nulu. Historie zůstane.',
    'keep': 'Ponechat',
    'reset': 'Vynulovat',
    'countingOn':
        'Počítá na pozadí. Nechte oznámení zapnuté. Bez GPS. Bez internetu. Data zůstávají v tomto telefonu.',
    'countingOff':
        'Klepněte na Start. Choďte s telefonem u sebe. Aplikaci můžete opustit — oznámení znamená, že pořád počítá.',
    'today': 'dnes',
    'needActivity':
        'K počítání kroků je potřeba oprávnění Fyzická aktivita.',
    'needNotifications':
        'Povolte oznámení, aby počítání zůstalo zapnuté i v kapse.',
    'noSensorWalk':
        'Tento telefon zatím nedal senzor kroků. Některé modely potřebují nejdřív krátkou procházku.',
    'noSensor': 'Senzor kroků na tomto zařízení není k dispozici.',
    'bgFailed':
        'Počítání na pozadí se nespustilo. Zatím počítáme na této obrazovce.',
    'lookTitle': 'Vzhled',
    'yourColours': 'Vaše barvy',
    'accent': 'Akcent',
    'background': 'Pozadí',
    'accentHint': 'Kruh, tlačítka a zvýraznění',
    'backgroundHint': 'Stránka za kruhem a kartami',
    'packs': 'Sady',
    'backgroundPhoto': 'Fotka na pozadí',
    'changePhoto': 'Změnit fotku',
    'usePhoto': 'Použít fotku (pes, procházka, cokoli)',
    'cropPhoto': 'Oříznout fotku',
    'removePhoto': 'Odstranit fotku',
    'typeSize': 'Velikost písma',
    'tapToPick': 'Klepněte a vyberte',
    'done': 'Hotovo',
    'lookHint':
        'Klepněte na barevný kruh a vyberte libovolnou barvu. Akcent je kruh a tlačítka. Pozadí je stránka, když není fotka. Fotka je za čísly — ořízněte ji tak, aby vyplnila obrazovku to, na čem vám záleží.',
    'pack_quiet_gold': 'Tiché zlato',
    'pack_night_moss': 'Noční mech',
    'pack_ember': 'Žhavé uhlíky',
    'pack_paper': 'Papír',
    'pack_custom': 'Vaše barvy',
    'noDaysYet': 'Zatím žádné dny.',
    'cancel': 'Zrušit',
    'fill': 'Vyplnit',
    'use': 'Použít',
    'fgChannelName': 'Quiet Steps',
    'fgChannelDesc': 'Počítání kroků v tomto telefonu. Nic se neodesílá.',
    'fgCounting': 'Počítáme kroky jen v tomto telefonu',
    'fgStepsToday': '{n} kroků dnes · jen v tomto telefonu',
    'milestoneChannel': 'Zprávy u milníků',
    'milestoneChannelDesc': 'Jemné zprávy, když dosáhnete milníku chůze.',
    'reflectionChannel': 'Večerní zamyšlení',
    'reflectionChannelDesc': 'Jemný souhrn dne.',
  },
  'pl': {
    'languageTitle': 'Twój język',
    'continue': 'Kontynuuj',
    'languageAuto': 'Automatycznie',
    'skip': 'Pomiń',
    'next': 'Dalej',
    'getStarted': 'Zaczynamy',
    'appName': 'Quiet Steps',
    'page1Body': 'Spokojny licznik kroków, który mieszka tylko w Twoim telefonie.',
    'page2Title': 'Prywatne z założenia',
    'page2Body':
        'Bez konta. Bez internetu. Bez GPS. Twoje kroki nie opuszczają tego telefonu.',
    'page3Title': 'Twój dzienny cel',
    'page3Body':
        'Następnie zezwól na Aktywność fizyczną, żeby telefon mógł liczyć kroki.',
    'goalLabel': 'Dzienny cel (kroki)',
    'goalMustBe100': 'Cel musi wynosić co najmniej 100',
    'settings': 'Ustawienia',
    'save': 'Zapisz',
    'language': 'Język',
    'height': 'Wzrost (cm)',
    'stride': 'Długość kroku (cm)',
    'weight': 'Waga (kg) — tylko do szacunku kcal',
    'milestoneMessages': 'Wiadomości przy kamieniach milowych',
    'speakMessages': 'Czytaj wiadomości na głos',
    'voiceSpeed': 'Tempo głosu',
    'voiceSlow': 'Wolno',
    'voiceNormal': 'Normalnie',
    'voice': 'Głos',
    'voiceFemale': 'Żeński',
    'voiceMale': 'Męski',
    'voicePhone': 'Głos telefonu',
    'voicePlaySample': 'Odtwórz próbkę',
    'voiceTestIn10': 'Przetestuj głos kamienia milowego za 10 sekund',
    'latestMilestone': 'Dziś',
    'aboutTitle': 'O aplikacji i podziękowania',
    'privacyTitle': 'Polityka prywatności',
    'privacyHint': 'Przeczytasz ją w dowolnej przeglądarce pod tym adresem:',
    'privacyCopy': 'Kopiuj link',
    'privacyCopied': 'Link skopiowany',
    'aboutIntro':
        'Quiet Steps zawiera nagrane wcześniej głosy, żeby mówić bez internetu. Głosy Piper pochodzą od rhasspy.',
    'aboutVoices':
        'Angielski, żeński — cori, public domain\n'
            'Angielski, męski — norman, public domain\n'
            'Słowacki, żeński — lili, CC0\n'
            'Słowacki, męski — jirka (czeski, czyta po słowacku), CC0\n'
            'Czeski, żeński — kasandra, CC BY 4.0\n'
            'Czeski, męski — jirka, CC0\n'
            'Polski, żeński — gosia, CC0\n'
            'Polski, męski — darkman, CC0\n'
            'Niemiecki, żeński — ramona, BSD-style\n'
            'Niemiecki, męski — thorsten, CC0\n'
            'Hiszpański, żeński — sharvard (speaker F), CC BY 3.0\n'
            'Hiszpański, męski — davefx, CC0\n'
            'Francuski, żeński — siwis, CC BY 4.0\n'
            'Francuski, męski — upmc (pierre), CC BY-SA 4.0\n'
            'Włoski, żeński — paola, CC0\n'
            'Włoski, męski — riccardo, BSD-style',
    'style': 'Styl',
    'styleCalm': 'Spokojny',
    'styleCheerful': 'Radosniejszy',
    'quietHours': 'Ciche godziny',
    'quietStart': 'Zaczynają się',
    'quietEnd': 'Kończą się',
    'medical':
        'Quiet Steps nie jest wyrobem medycznym. Nie diagnozuje, nie leczy i nie zapobiega.\n\n'
            'Kroki pochodzą z czujnika telefonu. Dystans i kalorie to szacunek z liczb, które tu wpiszesz.\n\n'
            'Nic nie jest wysyłane. Nie ma konta. GPS nie jest używany.',
    'look': 'Wygląd',
    'history': 'Historia',
    'ofToday': 'z {n} dziś',
    'km': 'km',
    'kcal': 'kcal',
    'goalPct': 'cel',
    'permissionDenied':
        'Do liczenia kroków potrzebne jest pozwolenie na aktywność fizyczną. Lokalizacja nie jest używana.',
    'startCounting': 'Włącz liczenie',
    'pauseCounting': 'Wstrzymaj liczenie',
    'resetToday': 'Zeruj dziś',
    'resetTodayTitle': 'Wyzerować dzień?',
    'resetTodayBody': 'Dzisiejszy licznik wróci do zera. Historia zostaje.',
    'keep': 'Zostaw',
    'reset': 'Zeruj',
    'countingOn':
        'Liczy w tle. Zostaw powiadomienie włączone. Bez GPS. Bez internetu. Dane zostają w tym telefonie.',
    'countingOff':
        'Dotknij Start. Idź z telefonem przy sobie. Możesz wyjść z aplikacji — powiadomienie znaczy, że nadal liczy.',
    'today': 'dziś',
    'needActivity':
        'Do liczenia kroków potrzebne jest pozwolenie na aktywność fizyczną.',
    'needNotifications':
        'Zezwól na powiadomienia, żeby liczenie działało także w kieszeni.',
    'noSensorWalk':
        'Ten telefon nie dał jeszcze czujnika kroków. Niektóre modele potrzebują najpierw krótkiego spaceru.',
    'noSensor': 'Czujnik kroków nie jest dostępny na tym urządzeniu.',
    'bgFailed':
        'Liczenie w tle się nie uruchomiło. Na razie liczymy na tym ekranie.',
    'lookTitle': 'Wygląd',
    'yourColours': 'Twoje kolory',
    'accent': 'Akcent',
    'background': 'Tło',
    'accentHint': 'Pierścień, przyciski i podkreślenia',
    'backgroundHint': 'Strona za pierścieniem i kartami',
    'packs': 'Zestawy',
    'backgroundPhoto': 'Zdjęcie w tle',
    'changePhoto': 'Zmień zdjęcie',
    'usePhoto': 'Użyj zdjęcia (pies, spacer, cokolwiek)',
    'cropPhoto': 'Przytnij zdjęcie',
    'removePhoto': 'Usuń zdjęcie',
    'typeSize': 'Rozmiar pisma',
    'tapToPick': 'Dotknij, by wybrać',
    'done': 'Gotowe',
    'lookHint':
        'Dotknij kółka, by wybrać dowolny kolor. Akcent to pierścień i przyciski. Tło to strona, gdy nie ma zdjęcia. Zdjęcie jest za liczbami — przytnij je tak, by wypełniło ekran to, na czym Ci zależy.',
    'pack_quiet_gold': 'Ciche złoto',
    'pack_night_moss': 'Nocny mech',
    'pack_ember': 'Żar',
    'pack_paper': 'Papier',
    'pack_custom': 'Twoje kolory',
    'noDaysYet': 'Jeszcze nie ma dni.',
    'cancel': 'Anuluj',
    'fill': 'Wypełnij',
    'use': 'Użyj',
    'fgChannelName': 'Quiet Steps',
    'fgChannelDesc': 'Liczenie kroków w tym telefonie. Nic nie jest wysyłane.',
    'fgCounting': 'Liczymy kroki tylko w tym telefonie',
    'fgStepsToday': '{n} kroków dziś · tylko w tym telefonie',
    'milestoneChannel': 'Wiadomości przy kamieniach milowych',
    'milestoneChannelDesc': 'Łagodne wiadomości, gdy dojdziesz do kolejnego etapu.',
    'reflectionChannel': 'Wieczorne spojrzenie',
    'reflectionChannelDesc': 'Łagodne podsumowanie dnia.',
  },
  'de': {
    'languageTitle': 'Ihre Sprache',
    'continue': 'Weiter',
    'languageAuto': 'Automatisch',
    'skip': 'Überspringen',
    'next': 'Weiter',
    'getStarted': 'Los geht’s',
    'appName': 'Quiet Steps',
    'page1Body': 'Ein ruhiger Schrittzähler, der nur auf Ihrem Telefon lebt.',
    'page2Title': 'Privat von Anfang an',
    'page2Body':
        'Kein Konto. Kein Internet. Kein GPS. Ihre Schritte verlassen dieses Telefon nicht.',
    'page3Title': 'Ihr Tagesziel',
    'page3Body':
        'Erlauben Sie als Nächstes Körperliche Aktivität, damit das Telefon Ihre Schritte zählen kann.',
    'goalLabel': 'Tagesziel (Schritte)',
    'goalMustBe100': 'Das Ziel muss mindestens 100 sein',
    'settings': 'Einstellungen',
    'save': 'Speichern',
    'language': 'Sprache',
    'height': 'Größe (cm)',
    'stride': 'Schrittlänge (cm)',
    'weight': 'Gewicht (kg) — nur für die kcal-Schätzung',
    'milestoneMessages': 'Meilenstein-Nachrichten',
    'speakMessages': 'Nachrichten vorlesen',
    'voiceSpeed': 'Sprechtempo',
    'voiceSlow': 'Langsam',
    'voiceNormal': 'Normal',
    'voice': 'Stimme',
    'voiceFemale': 'Weiblich',
    'voiceMale': 'Männlich',
    'voicePhone': 'Stimme des Telefons',
    'voicePlaySample': 'Beispiel abspielen',
    'voiceTestIn10': 'Meilenstein-Stimme in 10 Sekunden testen',
    'latestMilestone': 'Heute',
    'aboutTitle': 'Über die App und Danksagung',
    'privacyTitle': 'Datenschutzerklärung',
    'privacyHint': 'Sie können sie in jedem Browser unter dieser Adresse lesen:',
    'privacyCopy': 'Link kopieren',
    'privacyCopied': 'Link kopiert',
    'aboutIntro':
        'Quiet Steps enthält vorab aufgenommene Stimmen und spricht ohne Internet. Piper-Stimmen stammen von rhasspy.',
    'aboutVoices':
        'Englisch, weiblich — cori, public domain\n'
            'Englisch, männlich — norman, public domain\n'
            'Slowakisch, weiblich — lili, CC0\n'
            'Slowakisch, männlich — jirka (Tschechisch, liest Slowakisch), CC0\n'
            'Tschechisch, weiblich — kasandra, CC BY 4.0\n'
            'Tschechisch, männlich — jirka, CC0\n'
            'Polnisch, weiblich — gosia, CC0\n'
            'Polnisch, männlich — darkman, CC0\n'
            'Deutsch, weiblich — ramona, BSD-style\n'
            'Deutsch, männlich — thorsten, CC0\n'
            'Spanisch, weiblich — sharvard (speaker F), CC BY 3.0\n'
            'Spanisch, männlich — davefx, CC0\n'
            'Französisch, weiblich — siwis, CC BY 4.0\n'
            'Französisch, männlich — upmc (pierre), CC BY-SA 4.0\n'
            'Italienisch, weiblich — paola, CC0\n'
            'Italienisch, männlich — riccardo, BSD-style',
    'style': 'Stil',
    'styleCalm': 'Ruhig',
    'styleCheerful': 'Heiter',
    'quietHours': 'Ruhezeiten',
    'quietStart': 'Beginn',
    'quietEnd': 'Ende',
    'medical':
        'Quiet Steps ist kein Medizinprodukt. Es diagnostiziert, behandelt, heilt oder verhindert keine Erkrankung.\n\n'
            'Schritte kommen vom Telefonsensor. Distanz und Kalorien sind Schätzungen aus den Zahlen, die Sie hier eingeben.\n\n'
            'Nichts wird hochgeladen. Es gibt kein Konto. GPS wird nicht verwendet.',
    'look': 'Aussehen',
    'history': 'Verlauf',
    'ofToday': 'von {n} heute',
    'km': 'km',
    'kcal': 'kcal',
    'goalPct': 'Ziel',
    'permissionDenied':
        'Die Berechtigung „Körperliche Aktivität“ ist nötig, damit das Telefon Schritte zählen kann. Der Standort wird nicht verwendet.',
    'startCounting': 'Zählen starten',
    'pauseCounting': 'Zählen pausieren',
    'resetToday': 'Heute zurücksetzen',
    'resetTodayTitle': 'Heute zurücksetzen?',
    'resetTodayBody': 'Der heutige Zähler geht auf null. Der Verlauf bleibt.',
    'keep': 'Behalten',
    'reset': 'Zurücksetzen',
    'countingOn':
        'Zählt im Hintergrund. Lassen Sie die Benachrichtigung an. Kein GPS. Kein Internet. Die Daten bleiben auf diesem Telefon.',
    'countingOff':
        'Tippen Sie auf Start. Gehen Sie mit dem Telefon bei sich. Sie können die App verlassen — die Benachrichtigung bedeutet, dass weitergezählt wird.',
    'today': 'heute',
    'needActivity':
        'Die Berechtigung „Körperliche Aktivität“ ist nötig, damit das Telefon Schritte zählen kann.',
    'needNotifications':
        'Erlauben Sie Benachrichtigungen, damit das Zählen in der Tasche weiterläuft.',
    'noSensorWalk':
        'Dieses Telefon hat noch keinen Schrittsensor geliefert. Manche Modelle brauchen zuerst einen kurzen Spaziergang.',
    'noSensor': 'Auf diesem Gerät ist kein Schrittsensor verfügbar.',
    'bgFailed':
        'Das Zählen im Hintergrund hat nicht begonnen. Wir zählen vorerst auf diesem Bildschirm.',
    'lookTitle': 'Aussehen',
    'yourColours': 'Ihre Farben',
    'accent': 'Akzent',
    'background': 'Hintergrund',
    'accentHint': 'Ring, Tasten und Highlights',
    'backgroundHint': 'Die Seite hinter Ring und Karten',
    'packs': 'Sets',
    'backgroundPhoto': 'Hintergrundfoto',
    'changePhoto': 'Foto ändern',
    'usePhoto': 'Ein Foto nutzen (Hund, Spaziergang, irgendwas)',
    'cropPhoto': 'Foto zuschneiden',
    'removePhoto': 'Foto entfernen',
    'typeSize': 'Schriftgröße',
    'tapToPick': 'Tippen zum Wählen',
    'done': 'Fertig',
    'lookHint':
        'Tippen Sie auf einen Farbkreis, um eine Farbe zu wählen. Der Akzent ist Ring und Tasten. Der Hintergrund ist die Seite ohne Foto. Ein Foto liegt hinter den Zahlen — schneiden Sie es so zu, dass der gewünschte Teil den Bildschirm füllt.',
    'pack_quiet_gold': 'Ruhiges Gold',
    'pack_night_moss': 'Nachtmoos',
    'pack_ember': 'Glut',
    'pack_paper': 'Papier',
    'pack_custom': 'Ihre Farben',
    'noDaysYet': 'Noch keine Tage.',
    'cancel': 'Abbrechen',
    'fill': 'Füllen',
    'use': 'Übernehmen',
    'fgChannelName': 'Quiet Steps',
    'fgChannelDesc': 'Schrittzählen auf diesem Telefon. Es wird nichts gesendet.',
    'fgCounting': 'Zählt Schritte nur auf diesem Telefon',
    'fgStepsToday': '{n} Schritte heute · nur auf diesem Telefon',
    'milestoneChannel': 'Meilenstein-Nachrichten',
    'milestoneChannelDesc': 'Sanfte Nachrichten, wenn Sie einen Meilenstein erreichen.',
    'reflectionChannel': 'Abendliche Rückschau',
    'reflectionChannelDesc': 'Eine sanfte Zusammenfassung des Tages.',
  },
  'es': {
    'languageTitle': 'Tu idioma',
    'continue': 'Continuar',
    'languageAuto': 'Automático',
    'skip': 'Saltar',
    'next': 'Siguiente',
    'getStarted': 'Empezar',
    'appName': 'Quiet Steps',
    'page1Body': 'Un contador de pasos sereno que vive solo en tu teléfono.',
    'page2Title': 'Privado de origen',
    'page2Body':
        'Sin cuenta. Sin internet. Sin GPS. Tus pasos no salen de este teléfono.',
    'page3Title': 'Tu meta diaria',
    'page3Body':
        'Después, permite Actividad física para que el teléfono pueda contar tus pasos.',
    'goalLabel': 'Meta diaria (pasos)',
    'goalMustBe100': 'La meta debe ser al menos 100',
    'settings': 'Ajustes',
    'save': 'Guardar',
    'language': 'Idioma',
    'height': 'Estatura (cm)',
    'stride': 'Zancada (cm)',
    'weight': 'Peso (kg) — solo para estimar kcal',
    'milestoneMessages': 'Mensajes de hitos',
    'speakMessages': 'Leer los mensajes en voz alta',
    'voiceSpeed': 'Velocidad de la voz',
    'voiceSlow': 'Lenta',
    'voiceNormal': 'Normal',
    'voice': 'Voz',
    'voiceFemale': 'Femenina',
    'voiceMale': 'Masculina',
    'voicePhone': 'Voz del teléfono',
    'voicePlaySample': 'Reproducir muestra',
    'voiceTestIn10': 'Probar la voz del hito en 10 segundos',
    'latestMilestone': 'Hoy',
    'aboutTitle': 'Acerca de y créditos',
    'privacyTitle': 'Política de privacidad',
    'privacyHint': 'Puedes leerla en cualquier navegador en esta dirección:',
    'privacyCopy': 'Copiar enlace',
    'privacyCopied': 'Enlace copiado',
    'aboutIntro':
        'Quiet Steps incluye voces grabadas de antemano para hablar sin internet. Las voces de Piper son de rhasspy.',
    'aboutVoices':
        'Inglés, femenina — cori, public domain\n'
            'Inglés, masculina — norman, public domain\n'
            'Eslovaco, femenina — lili, CC0\n'
            'Eslovaco, masculina — jirka (checo, lee eslovaco), CC0\n'
            'Checo, femenina — kasandra, CC BY 4.0\n'
            'Checo, masculina — jirka, CC0\n'
            'Polaco, femenina — gosia, CC0\n'
            'Polaco, masculina — darkman, CC0\n'
            'Alemán, femenina — ramona, BSD-style\n'
            'Alemán, masculina — thorsten, CC0\n'
            'Español, femenina — sharvard (speaker F), CC BY 3.0\n'
            'Español, masculina — davefx, CC0\n'
            'Francés, femenina — siwis, CC BY 4.0\n'
            'Francés, masculina — upmc (pierre), CC BY-SA 4.0\n'
            'Italiano, femenina — paola, CC0\n'
            'Italiano, masculina — riccardo, BSD-style',
    'style': 'Estilo',
    'styleCalm': 'Sereno',
    'styleCheerful': 'Alegre',
    'quietHours': 'Horas tranquilas',
    'quietStart': 'Empiezan',
    'quietEnd': 'Terminan',
    'medical':
        'Quiet Steps no es un dispositivo médico. No diagnostica, trata, cura ni previene ninguna afección.\n\n'
            'Los pasos vienen del sensor del teléfono. Distancia y calorías son estimaciones a partir de los números que escribes aquí.\n\n'
            'No se sube nada. No hay cuenta. No se usa GPS.',
    'look': 'Apariencia',
    'history': 'Historial',
    'ofToday': 'de {n} hoy',
    'km': 'km',
    'kcal': 'kcal',
    'goalPct': 'meta',
    'permissionDenied':
        'Se necesita el permiso de Actividad física para que el teléfono cuente pasos. No se usa la ubicación.',
    'startCounting': 'Empezar a contar',
    'pauseCounting': 'Pausar el recuento',
    'resetToday': 'Reiniciar hoy',
    'resetTodayTitle': '¿Reiniciar hoy?',
    'resetTodayBody': 'El recuento de hoy vuelve a cero. El historial se queda.',
    'keep': 'Conservar',
    'reset': 'Reiniciar',
    'countingOn':
        'Cuenta en segundo plano. Deja el aviso encendido. Sin GPS. Sin internet. Los datos se quedan en este teléfono.',
    'countingOff':
        'Toca Empezar. Camina con el teléfono encima. Puedes salir de la app: el aviso significa que sigue contando.',
    'today': 'hoy',
    'needActivity':
        'Se necesita el permiso de Actividad física para que el teléfono cuente pasos.',
    'needNotifications':
        'Permite las notificaciones para que el recuento siga en el bolsillo.',
    'noSensorWalk':
        'Este teléfono aún no dio un sensor de pasos. Algunos modelos necesitan primero un paseo corto.',
    'noSensor': 'El sensor de pasos no está disponible en este dispositivo.',
    'bgFailed':
        'El recuento en segundo plano no arrancó. Por ahora contamos en esta pantalla.',
    'lookTitle': 'Apariencia',
    'yourColours': 'Tus colores',
    'accent': 'Acento',
    'background': 'Fondo',
    'accentHint': 'El anillo, los botones y los detalles',
    'backgroundHint': 'La página detrás del anillo y las tarjetas',
    'packs': 'Estilos',
    'backgroundPhoto': 'Foto de fondo',
    'changePhoto': 'Cambiar foto',
    'usePhoto': 'Usar una foto (perro, paseo, lo que sea)',
    'cropPhoto': 'Recortar foto',
    'removePhoto': 'Quitar foto',
    'typeSize': 'Tamaño de letra',
    'tapToPick': 'Toca para elegir',
    'done': 'Listo',
    'lookHint':
        'Toca un círculo de color para elegir cualquiera. El acento es el anillo y los botones. El fondo es la página cuando no hay foto. La foto queda detrás de los números: recórtala para que llene la pantalla lo que te importa.',
    'pack_quiet_gold': 'Oro sereno',
    'pack_night_moss': 'Musgo de noche',
    'pack_ember': 'Ascua',
    'pack_paper': 'Papel',
    'pack_custom': 'Tus colores',
    'noDaysYet': 'Aún no hay días.',
    'cancel': 'Cancelar',
    'fill': 'Llenar',
    'use': 'Usar',
    'fgChannelName': 'Quiet Steps',
    'fgChannelDesc': 'Recuento de pasos en este teléfono. No se envía nada.',
    'fgCounting': 'Contando pasos solo en este teléfono',
    'fgStepsToday': '{n} pasos hoy · solo en este teléfono',
    'milestoneChannel': 'Mensajes de hitos',
    'milestoneChannelDesc': 'Mensajes suaves cuando llegas a un hito al caminar.',
    'reflectionChannel': 'Reflexión de la tarde',
    'reflectionChannelDesc': 'Un resumen sereno del día.',
  },
  'fr': {
    'languageTitle': 'Votre langue',
    'continue': 'Continuer',
    'languageAuto': 'Automatique',
    'skip': 'Passer',
    'next': 'Suivant',
    'getStarted': 'C’est parti',
    'appName': 'Quiet Steps',
    'page1Body': 'Un compteur de pas calme, qui vit seulement sur votre téléphone.',
    'page2Title': 'Privé par conception',
    'page2Body':
        'Pas de compte. Pas d’internet. Pas de GPS. Vos pas ne quittent pas ce téléphone.',
    'page3Title': 'Votre objectif du jour',
    'page3Body':
        'Ensuite, autorisez l’Activité physique pour que le téléphone compte vos pas.',
    'goalLabel': 'Objectif du jour (pas)',
    'goalMustBe100': 'L’objectif doit être d’au moins 100',
    'settings': 'Réglages',
    'save': 'Enregistrer',
    'language': 'Langue',
    'height': 'Taille (cm)',
    'stride': 'Longueur de pas (cm)',
    'weight': 'Poids (kg) — uniquement pour l’estimation des kcal',
    'milestoneMessages': 'Messages aux paliers',
    'speakMessages': 'Lire les messages à voix haute',
    'voiceSpeed': 'Vitesse de la voix',
    'voiceSlow': 'Lente',
    'voiceNormal': 'Normale',
    'voice': 'Voix',
    'voiceFemale': 'Féminine',
    'voiceMale': 'Masculine',
    'voicePhone': 'Voix du téléphone',
    'voicePlaySample': 'Écouter un extrait',
    'voiceTestIn10': 'Tester la voix du palier dans 10 secondes',
    'latestMilestone': 'Aujourd\'hui',
    'aboutTitle': 'À propos et crédits',
    'privacyTitle': 'Politique de confidentialité',
    'privacyHint': 'Vous pouvez la lire dans n’importe quel navigateur à cette adresse :',
    'privacyCopy': 'Copier le lien',
    'privacyCopied': 'Lien copié',
    'aboutIntro':
        'Quiet Steps inclut des voix préenregistrées pour parler sans internet. Les voix Piper sont de rhasspy.',
    'aboutVoices':
        'Anglais, féminine — cori, public domain\n'
            'Anglais, masculine — norman, public domain\n'
            'Slovaque, féminine — lili, CC0\n'
            'Slovaque, masculine — jirka (tchèque, lit le slovaque), CC0\n'
            'Tchèque, féminine — kasandra, CC BY 4.0\n'
            'Tchèque, masculine — jirka, CC0\n'
            'Polonais, féminine — gosia, CC0\n'
            'Polonais, masculine — darkman, CC0\n'
            'Allemand, féminine — ramona, BSD-style\n'
            'Allemand, masculine — thorsten, CC0\n'
            'Espagnol, féminine — sharvard (speaker F), CC BY 3.0\n'
            'Espagnol, masculine — davefx, CC0\n'
            'Français, féminine — siwis, CC BY 4.0\n'
            'Français, masculine — upmc (pierre), CC BY-SA 4.0\n'
            'Italien, féminine — paola, CC0\n'
            'Italien, masculine — riccardo, BSD-style',
    'style': 'Style',
    'styleCalm': 'Calme',
    'styleCheerful': 'Enjoué',
    'quietHours': 'Heures calmes',
    'quietStart': 'Début',
    'quietEnd': 'Fin',
    'medical':
        'Quiet Steps n’est pas un dispositif médical. Il ne diagnostique, ne traite, ne guérit ni ne prévient aucune affection.\n\n'
            'Les pas viennent du capteur du téléphone. Distance et calories sont des estimations à partir des chiffres saisis ici.\n\n'
            'Rien n’est envoyé. Il n’y a pas de compte. Le GPS n’est pas utilisé.',
    'look': 'Apparence',
    'history': 'Historique',
    'ofToday': 'sur {n} aujourd’hui',
    'km': 'km',
    'kcal': 'kcal',
    'goalPct': 'objectif',
    'permissionDenied':
        'L’autorisation Activité physique est nécessaire pour que le téléphone compte les pas. La localisation n’est pas utilisée.',
    'startCounting': 'Démarrer le compte',
    'pauseCounting': 'Mettre en pause',
    'resetToday': 'Réinitialiser aujourd’hui',
    'resetTodayTitle': 'Réinitialiser aujourd’hui ?',
    'resetTodayBody': 'Le compte du jour revient à zéro. L’historique reste.',
    'keep': 'Garder',
    'reset': 'Réinitialiser',
    'countingOn':
        'Compte en arrière-plan. Laissez la notification allumée. Pas de GPS. Pas d’internet. Les données restent sur ce téléphone.',
    'countingOff':
        'Touchez Démarrer. Marchez avec le téléphone sur vous. Vous pouvez quitter l’app — la notification signifie que ça compte encore.',
    'today': 'aujourd’hui',
    'needActivity':
        'L’autorisation Activité physique est nécessaire pour que le téléphone compte les pas.',
    'needNotifications':
        'Autorisez les notifications pour que le compte continue dans la poche.',
    'noSensorWalk':
        'Ce téléphone n’a pas encore fourni de capteur de pas. Certains modèles ont besoin d’une courte marche d’abord.',
    'noSensor': 'Le capteur de pas n’est pas disponible sur cet appareil.',
    'bgFailed':
        'Le compte en arrière-plan n’a pas démarré. Pour l’instant, on compte sur cet écran.',
    'lookTitle': 'Apparence',
    'yourColours': 'Vos couleurs',
    'accent': 'Accent',
    'background': 'Fond',
    'accentHint': 'L’anneau, les boutons et les touches',
    'backgroundHint': 'La page derrière l’anneau et les cartes',
    'packs': 'Palettes',
    'backgroundPhoto': 'Photo d’arrière-plan',
    'changePhoto': 'Changer la photo',
    'usePhoto': 'Utiliser une photo (chien, marche, n’importe quoi)',
    'cropPhoto': 'Recadrer la photo',
    'removePhoto': 'Retirer la photo',
    'typeSize': 'Taille du texte',
    'tapToPick': 'Toucher pour choisir',
    'done': 'Terminé',
    'lookHint':
        'Touchez un cercle de couleur pour en choisir une. L’accent est l’anneau et les boutons. Le fond est la page sans photo. Une photo se place derrière les chiffres — recadrez-la pour que ce qui compte remplisse l’écran.',
    'pack_quiet_gold': 'Or calme',
    'pack_night_moss': 'Mousse de nuit',
    'pack_ember': 'Braise',
    'pack_paper': 'Papier',
    'pack_custom': 'Vos couleurs',
    'noDaysYet': 'Pas encore de jours.',
    'cancel': 'Annuler',
    'fill': 'Remplir',
    'use': 'Utiliser',
    'fgChannelName': 'Quiet Steps',
    'fgChannelDesc': 'Comptage des pas sur ce téléphone. Rien n’est envoyé.',
    'fgCounting': 'Comptage des pas uniquement sur ce téléphone',
    'fgStepsToday': '{n} pas aujourd’hui · uniquement sur ce téléphone',
    'milestoneChannel': 'Messages aux paliers',
    'milestoneChannelDesc': 'Des messages doux lorsque vous atteignez un palier.',
    'reflectionChannel': 'Regard du soir',
    'reflectionChannelDesc': 'Un résumé doux de la journée.',
  },
  'it': {
    'languageTitle': 'La tua lingua',
    'continue': 'Continua',
    'languageAuto': 'Automatico',
    'skip': 'Salta',
    'next': 'Avanti',
    'getStarted': 'Iniziamo',
    'appName': 'Quiet Steps',
    'page1Body': 'Un contapassi calmo che vive solo sul tuo telefono.',
    'page2Title': 'Privato di proposito',
    'page2Body':
        'Nessun account. Nessuna internet. Nessun GPS. I tuoi passi non lasciano questo telefono.',
    'page3Title': 'Il tuo obiettivo giornaliero',
    'page3Body':
        'Poi consenti Attività fisica così il telefono può contare i tuoi passi.',
    'goalLabel': 'Obiettivo giornaliero (passi)',
    'goalMustBe100': 'L’obiettivo deve essere almeno 100',
    'settings': 'Impostazioni',
    'save': 'Salva',
    'language': 'Lingua',
    'height': 'Altezza (cm)',
    'stride': 'Passo (cm)',
    'weight': 'Peso (kg) — solo per la stima delle kcal',
    'milestoneMessages': 'Messaggi alle tappe',
    'speakMessages': 'Leggi i messaggi ad alta voce',
    'voiceSpeed': 'Velocità della voce',
    'voiceSlow': 'Lenta',
    'voiceNormal': 'Normale',
    'voice': 'Voce',
    'voiceFemale': 'Femminile',
    'voiceMale': 'Maschile',
    'voicePhone': 'Voce del telefono',
    'voicePlaySample': 'Ascolta un campione',
    'voiceTestIn10': 'Prova la voce della tappa tra 10 secondi',
    'latestMilestone': 'Oggi',
    'aboutTitle': 'Informazioni e crediti',
    'privacyTitle': 'Informativa sulla privacy',
    'privacyHint': 'Puoi leggerla in qualsiasi browser a questo indirizzo:',
    'privacyCopy': 'Copia link',
    'privacyCopied': 'Link copiato',
    'aboutIntro':
        'Quiet Steps include voci preregistrate per parlare senza internet. Le voci Piper sono di rhasspy.',
    'aboutVoices':
        'Inglese, femminile — cori, public domain\n'
            'Inglese, maschile — norman, public domain\n'
            'Slovacco, femminile — lili, CC0\n'
            'Slovacco, maschile — jirka (ceco, legge lo slovacco), CC0\n'
            'Ceco, femminile — kasandra, CC BY 4.0\n'
            'Ceco, maschile — jirka, CC0\n'
            'Polacco, femminile — gosia, CC0\n'
            'Polacco, maschile — darkman, CC0\n'
            'Tedesco, femminile — ramona, BSD-style\n'
            'Tedesco, maschile — thorsten, CC0\n'
            'Spagnolo, femminile — sharvard (speaker F), CC BY 3.0\n'
            'Spagnolo, maschile — davefx, CC0\n'
            'Francese, femminile — siwis, CC BY 4.0\n'
            'Francese, maschile — upmc (pierre), CC BY-SA 4.0\n'
            'Italiano, femminile — paola, CC0\n'
            'Italiano, maschile — riccardo, BSD-style',
    'style': 'Stile',
    'styleCalm': 'Calmo',
    'styleCheerful': 'Allegro',
    'quietHours': 'Ore silenziose',
    'quietStart': 'Inizio',
    'quietEnd': 'Fine',
    'medical':
        'Quiet Steps non è un dispositivo medico. Non diagnostica, non cura e non previene alcuna condizione.\n\n'
            'I passi arrivano dal sensore del telefono. Distanza e calorie sono stime dai numeri che inserisci qui.\n\n'
            'Non viene caricato nulla. Non c’è un account. Il GPS non è usato.',
    'look': 'Aspetto',
    'history': 'Cronologia',
    'ofToday': 'di {n} oggi',
    'km': 'km',
    'kcal': 'kcal',
    'goalPct': 'obiettivo',
    'permissionDenied':
        'Serve l’autorizzazione Attività fisica perché il telefono possa contare i passi. La posizione non è usata.',
    'startCounting': 'Avvia il conteggio',
    'pauseCounting': 'Metti in pausa',
    'resetToday': 'Azzera oggi',
    'resetTodayTitle': 'Azzerare oggi?',
    'resetTodayBody': 'Il conteggio di oggi torna a zero. La cronologia resta.',
    'keep': 'Tieni',
    'reset': 'Azzera',
    'countingOn':
        'Conta in background. Lascia l’avviso acceso. Niente GPS. Niente internet. I dati restano su questo telefono.',
    'countingOff':
        'Tocca Avvia. Cammina con il telefono addosso. Puoi lasciare l’app: l’avviso significa che sta ancora contando.',
    'today': 'oggi',
    'needActivity':
        'Serve l’autorizzazione Attività fisica perché il telefono possa contare i passi.',
    'needNotifications':
        'Consenti le notifiche così il conteggio resta acceso in tasca.',
    'noSensorWalk':
        'Questo telefono non ha ancora dato un sensore di passi. Alcuni modelli hanno bisogno prima di una breve camminata.',
    'noSensor': 'Il sensore di passi non è disponibile su questo dispositivo.',
    'bgFailed':
        'Il conteggio in background non è partito. Per ora contiamo su questa schermata.',
    'lookTitle': 'Aspetto',
    'yourColours': 'I tuoi colori',
    'accent': 'Accento',
    'background': 'Sfondo',
    'accentHint': 'L’anello, i pulsanti e i dettagli',
    'backgroundHint': 'La pagina dietro l’anello e le schede',
    'packs': 'Palette',
    'backgroundPhoto': 'Foto di sfondo',
    'changePhoto': 'Cambia foto',
    'usePhoto': 'Usa una foto (cane, passeggiata, qualsiasi cosa)',
    'cropPhoto': 'Ritaglia foto',
    'removePhoto': 'Rimuovi foto',
    'typeSize': 'Dimensione del testo',
    'tapToPick': 'Tocca per scegliere',
    'done': 'Fatto',
    'lookHint':
        'Tocca un cerchio di colore per sceglierne uno. L’accento è l’anello e i pulsanti. Lo sfondo è la pagina senza foto. Una foto sta dietro i numeri: ritagliala così la parte che ti interessa riempie lo schermo.',
    'pack_quiet_gold': 'Oro quieto',
    'pack_night_moss': 'Muschio notturno',
    'pack_ember': 'Brace',
    'pack_paper': 'Carta',
    'pack_custom': 'I tuoi colori',
    'noDaysYet': 'Ancora nessun giorno.',
    'cancel': 'Annulla',
    'fill': 'Riempi',
    'use': 'Usa',
    'fgChannelName': 'Quiet Steps',
    'fgChannelDesc': 'Conteggio passi su questo telefono. Non viene inviato nulla.',
    'fgCounting': 'Conteggio passi solo su questo telefono',
    'fgStepsToday': '{n} passi oggi · solo su questo telefono',
    'milestoneChannel': 'Messaggi alle tappe',
    'milestoneChannelDesc': 'Messaggi gentili quando raggiungi una tappa a piedi.',
    'reflectionChannel': 'Riflessione della sera',
    'reflectionChannelDesc': 'Un riassunto gentile della giornata.',
  },
};

String uiLine(String language, String key) {
  return ui[_lang(language)]?[key] ?? ui['en']![key]!;
}

String uiFill(String language, String key, {required String n}) {
  return uiLine(language, key).replaceAll('{n}', n);
}

String _lang(String language) {
  return ui.containsKey(language) ? language : 'en';
}
