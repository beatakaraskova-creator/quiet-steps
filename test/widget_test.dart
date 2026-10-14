import 'package:flutter_test/flutter_test.dart';
import 'package:quiet_steps/services/step_math.dart';

void main() {
  test('todayKey is yyyy-MM-dd', () {
    final d = DateTime(2026, 9, 16);
    expect(todayKey(d), '2026-09-16');
  });
}
