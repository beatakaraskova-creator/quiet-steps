import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/glance.dart';
import 'services/look.dart';
import 'services/milestones.dart';
import 'services/reflection_alerts.dart';
import 'services/step_engine.dart';
import 'services/store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  for (final lang in supportedLanguages) {
    await initializeDateFormatting(lang);
  }
  await StepEngine.instance.init();
  await Look.instance.load();
  await pushQuietStepsWidget(force: true);
  await ReflectionAlerts.instance.init();
  await ReflectionAlerts.instance.syncSchedule(Store.instance);
  await ReflectionAlerts.instance.maybeFire(Store.instance);
  runApp(const QuietStepsApp());
}

class QuietStepsApp extends StatelessWidget {
  const QuietStepsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Look.instance,
      builder: (context, _) {
        final look = Look.instance;
        final light = look.pack.light;
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              light ? Brightness.dark : Brightness.light,
        ));
        return MaterialApp(
          navigatorKey: appNavigatorKey,
          title: 'Quiet Steps',
          debugShowCheckedModeBanner: false,
          theme: look.theme,
          home: Store.instance.onboardingDone
              ? const HomeScreen()
              : const OnboardingScreen(),
        );
      },
    );
  }
}
