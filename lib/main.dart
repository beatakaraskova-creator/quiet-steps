import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/look.dart';
import 'services/step_engine.dart';
import 'services/store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await StepEngine.instance.init();
  await Look.instance.load();
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
