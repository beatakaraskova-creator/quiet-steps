import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/look_pack.dart';
import 'easy_mode.dart';
import 'glance.dart';
import 'store.dart';

/// Live look. Swap a pack without touching step code.
class Look extends ChangeNotifier {
  Look._();
  static final Look instance = Look._();

  LookPack _base = LookPack.quietGold;
  bool bigSimple = false;
  double fontScale = 1.0;
  String? backgroundPath;
  int photoTick = 0;

  LookPack get pack => bigSimple ? accessibleLook(_base) : _base;
  LookPack get basePack => _base;

  static const _sourceName = 'look_bg_source.jpg';
  static const _croppedName = 'look_bg.png';

  Future<void> load() async {
    final s = Store.instance;
    if (s.lookCustom) {
      _base = LookPack.custom(
        bg: Color(s.lookBgColor),
        accent: Color(s.lookAccent),
      );
    } else {
      _base = LookPack.byId(s.lookId);
    }
    bigSimple = s.bigSimple;
    fontScale = s.fontScale;
    final path = s.backgroundPath;
    backgroundPath = (path != null && path.isNotEmpty) ? path : null;
    notifyListeners();
  }

  Future<void> setPack(LookPack next) async {
    _base = next;
    Store.instance.lookId = next.id;
    Store.instance.lookCustom = false;
    notifyListeners();
  }

  Future<void> setBigSimple(bool v) async {
    bigSimple = v;
    Store.instance.bigSimple = v;
    notifyListeners();
    scheduleQuietStepsWidgetPush(force: true);
  }

  Future<void> setCustomColors({Color? accent, Color? bg}) async {
    final nextAccent = accent ?? _base.accent;
    final nextBg = bg ?? _base.bg;
    _base = LookPack.custom(bg: nextBg, accent: nextAccent);
    final s = Store.instance;
    s.lookId = pack.id;
    s.lookCustom = true;
    s.lookAccent = nextAccent.toARGB32();
    s.lookBgColor = nextBg.toARGB32();
    notifyListeners();
  }

  Future<void> setFontScale(double v) async {
    fontScale = v.clamp(0.85, 1.35);
    Store.instance.fontScale = fontScale;
    notifyListeners();
  }

  Future<void> setBackgroundPath(String? path) async {
    backgroundPath = path;
    photoTick++;
    Store.instance.backgroundPath = path ?? '';
    notifyListeners();
  }

  Future<File> _doc(String name) async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, name));
  }

  Future<File?> pickPhotoFile() async {
    final shot = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 95,
      maxWidth: 4000,
    );
    if (shot == null) return null;
    final temp = await _doc('look_bg_pick.jpg');
    await File(shot.path).copy(temp.path);
    return temp;
  }

  Future<void> keepPickedSource(File pick) async {
    final source = await _doc(_sourceName);
    await pick.copy(source.path);
  }

  Future<File?> cropSourceFile() async {
    final src = await _doc(_sourceName);
    if (await src.exists()) return src;
    final current = backgroundPath;
    if (current != null && await File(current).exists()) {
      return File(current);
    }
    return null;
  }

  Future<void> saveCroppedPhoto(Uint8List png) async {
    final dest = await _doc(_croppedName);
    await dest.writeAsBytes(png, flush: true);
    await FileImage(dest).evict();
    await setBackgroundPath(dest.path);
  }

  Future<void> clearPhoto() async {
    final path = backgroundPath;
    if (path != null) {
      final f = File(path);
      if (await f.exists()) {
        await f.delete();
      }
    }
    for (final name in [_sourceName, _croppedName, 'look_bg.jpg']) {
      final f = await _doc(name);
      if (await f.exists()) {
        await f.delete();
      }
    }
    await setBackgroundPath(null);
  }

  ThemeData get theme {
    final packLook = pack;
    final brightness = packLook.light ? Brightness.light : Brightness.dark;
    final easy = bigSimple;
    final buttonMin = easy
        ? FilledButton.styleFrom(
            minimumSize: const Size(easyTapMin, easyTapMin),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            tapTargetSize: MaterialTapTargetSize.padded,
          )
        : null;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: packLook.bg,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: packLook.accent,
        onPrimary: packLook.onAccent,
        secondary: packLook.accent,
        onSecondary: packLook.ink,
        surface: packLook.card,
        onSurface: packLook.ink,
        error: const Color(0xFFC45C5C),
        onError: Colors.white,
      ),
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: packLook.ink, fontSize: 14 * fontScale),
        bodyLarge: TextStyle(color: packLook.ink, fontSize: 16 * fontScale),
        titleLarge: TextStyle(color: packLook.ink, fontSize: 22 * fontScale),
      ),
      filledButtonTheme: FilledButtonThemeData(style: buttonMin),
      outlinedButtonTheme: OutlinedButtonThemeData(style: buttonMin),
      textButtonTheme: TextButtonThemeData(style: buttonMin),
      appBarTheme: AppBarTheme(
        backgroundColor: packLook.bg.withValues(alpha: 0.0),
        foregroundColor: packLook.ink,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: easy ? 72 : kToolbarHeight,
      ),
    );
  }
}
