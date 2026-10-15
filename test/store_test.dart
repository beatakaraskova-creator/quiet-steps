import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiet_steps/services/store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('onboarding flag is saved', () async {
    SharedPreferences.setMockInitialValues({});
    final store = Store.instance;
    await store.init();
    expect(store.onboardingDone, isFalse);
    store.onboardingDone = true;
    expect(store.onboardingDone, isTrue);
  });

  test('milestone settings default and save', () async {
    SharedPreferences.setMockInitialValues({});
    final store = Store.instance;
    await store.init();
    expect(store.milestoneMessages, isTrue);
    expect(store.speakMessages, isFalse);
    expect(store.voiceSpeed, 'normal');
    expect(store.milestoneStyle, 'calm');
    expect(store.quietHours, isTrue);
    expect(store.quietStart, '22:00');
    expect(store.quietEnd, '07:00');
    expect(store.language, 'auto');
    expect(store.eveningReflection, isTrue);
    expect(store.reflectionTime, '20:30');

    store.language = 'sk';
    store.speakMessages = true;
    store.voiceSpeed = 'slow';
    store.milestoneStyle = 'cheerful';
    store.quietHours = false;
    store.quietStart = '21:30';
    store.quietEnd = '06:45';
    store.milestoneMessages = false;
    store.eveningReflection = false;
    store.reflectionTime = '21:15';

    expect(store.language, 'sk');
    expect(store.speakMessages, isTrue);
    expect(store.voiceSpeed, 'slow');
    expect(store.milestoneStyle, 'cheerful');
    expect(store.quietHours, isFalse);
    expect(store.quietStart, '21:30');
    expect(store.quietEnd, '06:45');
    expect(store.milestoneMessages, isFalse);
    expect(store.eveningReflection, isFalse);
    expect(store.reflectionTime, '21:15');
  });

  test('big and simple defaults off and saves', () async {
    SharedPreferences.setMockInitialValues({});
    final store = Store.instance;
    await store.init();
    expect(store.bigSimple, isFalse);
    store.bigSimple = true;
    expect(store.bigSimple, isTrue);
  });
}
