import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/day_record.dart';

/// All data stays on this phone. No network keys exist here.
class Store {
  Store._();
  static final Store instance = Store._();

  static const _kGoal = 'goal';
  static const _kHeight = 'height_cm';
  static const _kStride = 'stride_cm';
  static const _kWeight = 'weight_kg';
  static const _kDate = 'today_date';
  static const _kOffset = 'today_offset';
  static const _kToday = 'today_steps';
  static const _kLastRaw = 'last_raw';
  static const _kHistory = 'history';
  static const _kCounting = 'counting';
  static const _kLook = 'look_id';
  static const _kFont = 'font_scale';
  static const _kBg = 'bg_path';
  static const _kLookCustom = 'look_custom';
  static const _kLookAccent = 'look_accent';
  static const _kLookBgColor = 'look_bg_color';

  late SharedPreferences _p;

  Future<void> init() async {
    _p = await SharedPreferences.getInstance();
  }

  Future<void> reload() async {
    await _p.reload();
  }

  int get goal => _p.getInt(_kGoal) ?? 8000;
  set goal(int v) => _p.setInt(_kGoal, v);

  int get heightCm => _p.getInt(_kHeight) ?? 170;
  set heightCm(int v) => _p.setInt(_kHeight, v);

  int get strideCm {
    final stored = _p.getInt(_kStride);
    if (stored != null) return stored;
    return (heightCm * 0.43).round();
  }

  set strideCm(int v) => _p.setInt(_kStride, v);

  int get weightKg => _p.getInt(_kWeight) ?? 75;
  set weightKg(int v) => _p.setInt(_kWeight, v);

  String get todayDate => _p.getString(_kDate) ?? '';
  set todayDate(String v) => _p.setString(_kDate, v);

  int get todayOffset => _p.getInt(_kOffset) ?? 0;
  set todayOffset(int v) => _p.setInt(_kOffset, v);

  int get todaySteps => _p.getInt(_kToday) ?? 0;
  set todaySteps(int v) => _p.setInt(_kToday, v);

  int get lastRaw => _p.getInt(_kLastRaw) ?? 0;
  set lastRaw(int v) => _p.setInt(_kLastRaw, v);

  bool get counting => _p.getBool(_kCounting) ?? false;
  set counting(bool v) => _p.setBool(_kCounting, v);

  String get lookId => _p.getString(_kLook) ?? 'quiet_gold';
  set lookId(String v) => _p.setString(_kLook, v);

  double get fontScale => _p.getDouble(_kFont) ?? 1.0;
  set fontScale(double v) => _p.setDouble(_kFont, v);

  String? get backgroundPath => _p.getString(_kBg);
  set backgroundPath(String v) => _p.setString(_kBg, v);

  bool get lookCustom => _p.getBool(_kLookCustom) ?? false;
  set lookCustom(bool v) => _p.setBool(_kLookCustom, v);

  int get lookAccent => _p.getInt(_kLookAccent) ?? 0xFFC4A574;
  set lookAccent(int v) => _p.setInt(_kLookAccent, v);

  int get lookBgColor => _p.getInt(_kLookBgColor) ?? 0xFF141412;
  set lookBgColor(int v) => _p.setInt(_kLookBgColor, v);

  List<DayRecord> history() {
    final raw = _p.getString(_kHistory);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => DayRecord.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> saveHistory(List<DayRecord> items) async {
    items.sort((a, b) => b.date.compareTo(a.date));
    if (items.length > 90) {
      items = items.take(90).toList();
    }
    await _p.setString(
      _kHistory,
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> lockDay(String date, int steps) async {
    final items = history();
    final i = items.indexWhere((e) => e.date == date);
    if (i >= 0) {
      items[i] = DayRecord(date: date, steps: steps);
    } else {
      items.add(DayRecord(date: date, steps: steps));
    }
    await saveHistory(items);
  }

  double get kmToday {
    return todaySteps * (strideCm / 100.0) / 1000.0;
  }

  int get kcalToday {
    // ~0.5 kcal per kg per km of walking
    return (0.5 * weightKg * kmToday).round();
  }
}
