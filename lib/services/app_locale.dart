import 'package:flutter/foundation.dart';

import 'milestones.dart';
import 'store.dart';

/// Live language. Screens read [code]; Settings and the first-launch picker write it.
class AppLocale extends ChangeNotifier {
  AppLocale._();
  static final AppLocale instance = AppLocale._();

  String code = 'en';

  void load({String? deviceLanguageCode}) {
    code = resolveLanguage(
      stored: Store.instance.language,
      deviceLanguageCode:
          deviceLanguageCode ?? PlatformDispatcher.instance.locale.languageCode,
    );
    notifyListeners();
  }

  Future<void> setStored(String stored, {String? deviceLanguageCode}) async {
    Store.instance.language = stored;
    load(deviceLanguageCode: deviceLanguageCode);
  }
}

String currentLanguage({String? deviceLanguageCode}) {
  if (AppLocale.instance.code.isNotEmpty) return AppLocale.instance.code;
  return resolveLanguage(
    stored: Store.instance.language,
    deviceLanguageCode:
        deviceLanguageCode ?? PlatformDispatcher.instance.locale.languageCode,
  );
}

/// Phone language if it is one of the eight, otherwise English.
String suggestedLanguage({String? deviceLanguageCode}) {
  return resolveLanguage(
    stored: 'auto',
    deviceLanguageCode:
        deviceLanguageCode ?? PlatformDispatcher.instance.locale.languageCode,
  );
}
