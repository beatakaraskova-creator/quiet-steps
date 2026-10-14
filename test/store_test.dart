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
}
