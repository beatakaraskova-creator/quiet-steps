import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/day_record.dart';
import '../models/walk_entry.dart';
import 'walks.dart';

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
  static const _kSkipPausedGap = 'skip_paused_gap';
  static const _kOnboardingDone = 'onboarding_done';
  static const _kMilestoneOn = 'milestone_on';
  static const _kSpeakOn = 'speak_on';
  static const _kVoiceSpeed = 'voice_speed';
  static const _kMilestoneStyle = 'milestone_style';
  static const _kQuietHours = 'quiet_hours';
  static const _kQuietStart = 'quiet_start';
  static const _kQuietEnd = 'quiet_end';
  static const _kLanguage = 'language';
  static const _kLanguagePicked = 'language_picked';
  static const _kFiredMilestones = 'fired_milestones';
  static const _kEveningReflection = 'evening_reflection';
  static const _kReflectionTime = 'reflection_time';
  static const _kLastReflection = 'last_reflection';
  static const _kWalkMood = 'walk_mood';
  static const _kWalkStartSteps = 'walk_start_steps';
  static const _kWalkStartMs = 'walk_start_ms';
  static const _kWalks = 'walks';
  static const _kBigSimple = 'big_simple';

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

  bool get skipPausedGap => _p.getBool(_kSkipPausedGap) ?? false;
  set skipPausedGap(bool v) => _p.setBool(_kSkipPausedGap, v);

  bool get onboardingDone => _p.getBool(_kOnboardingDone) ?? false;
  set onboardingDone(bool v) => _p.setBool(_kOnboardingDone, v);

  bool get milestoneMessages => _p.getBool(_kMilestoneOn) ?? true;
  set milestoneMessages(bool v) => _p.setBool(_kMilestoneOn, v);

  bool get speakMessages => _p.getBool(_kSpeakOn) ?? false;
  set speakMessages(bool v) => _p.setBool(_kSpeakOn, v);

  String get voiceSpeed => _p.getString(_kVoiceSpeed) ?? 'normal';
  set voiceSpeed(String v) => _p.setString(_kVoiceSpeed, v);

  String get milestoneStyle => _p.getString(_kMilestoneStyle) ?? 'calm';
  set milestoneStyle(String v) => _p.setString(_kMilestoneStyle, v);

  bool get quietHours => _p.getBool(_kQuietHours) ?? true;
  set quietHours(bool v) => _p.setBool(_kQuietHours, v);

  String get quietStart => _p.getString(_kQuietStart) ?? '22:00';
  set quietStart(String v) => _p.setString(_kQuietStart, v);

  String get quietEnd => _p.getString(_kQuietEnd) ?? '07:00';
  set quietEnd(String v) => _p.setString(_kQuietEnd, v);

  String get language => _p.getString(_kLanguage) ?? 'auto';
  set language(String v) => _p.setString(_kLanguage, v);

  bool get languagePicked => _p.getBool(_kLanguagePicked) ?? false;
  set languagePicked(bool v) => _p.setBool(_kLanguagePicked, v);

  String get firedMilestonesRaw => _p.getString(_kFiredMilestones) ?? '';
  set firedMilestonesRaw(String v) => _p.setString(_kFiredMilestones, v);

  bool get eveningReflection => _p.getBool(_kEveningReflection) ?? true;
  set eveningReflection(bool v) => _p.setBool(_kEveningReflection, v);

  String get reflectionTime => _p.getString(_kReflectionTime) ?? '20:30';
  set reflectionTime(String v) => _p.setString(_kReflectionTime, v);

  String get lastReflectionDate => _p.getString(_kLastReflection) ?? '';
  set lastReflectionDate(String v) => _p.setString(_kLastReflection, v);

  String get walkMood => _p.getString(_kWalkMood) ?? '';
  set walkMood(String v) => _p.setString(_kWalkMood, v);

  int get walkStartSteps => _p.getInt(_kWalkStartSteps) ?? 0;
  set walkStartSteps(int v) => _p.setInt(_kWalkStartSteps, v);

  int get walkStartMs => _p.getInt(_kWalkStartMs) ?? 0;
  set walkStartMs(int v) => _p.setInt(_kWalkStartMs, v);

  bool get walkActive => walkMood.isNotEmpty && walkStartMs > 0;

  bool get bigSimple => _p.getBool(_kBigSimple) ?? false;
  set bigSimple(bool v) => _p.setBool(_kBigSimple, v);

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

  void startWalk(String mood, int stepsNow, DateTime start) {
    walkMood = mood;
    walkStartSteps = stepsNow;
    walkStartMs = start.millisecondsSinceEpoch;
  }

  void clearWalk() {
    walkMood = '';
    walkStartSteps = 0;
    walkStartMs = 0;
  }

  List<WalkEntry> walks() {
    final raw = _p.getString(_kWalks);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => WalkEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveWalks(List<WalkEntry> items) async {
    await _p.setString(
      _kWalks,
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> addWalk(WalkEntry entry) async {
    await saveWalks(addWalkEntry(walks(), entry));
  }

  Future<void> deleteWalk(String id) async {
    await saveWalks(deleteWalkEntry(walks(), id));
  }
}
