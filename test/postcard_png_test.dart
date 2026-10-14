import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quiet_steps/models/look_pack.dart';
import 'package:quiet_steps/models/walk_entry.dart';
import 'package:quiet_steps/services/postcard.dart';
import 'package:quiet_steps/services/step_math.dart';
import 'package:quiet_steps/widgets/postcard_face.dart';

Future<void> _loadFonts() async {
  final root = Platform.environment['FLUTTER_ROOT'] ??
      r'C:\Users\tomas\Downloads\flutter';
  final dir =
      '$root${Platform.pathSeparator}bin${Platform.pathSeparator}cache${Platform.pathSeparator}artifacts${Platform.pathSeparator}material_fonts';
  Future<void> load(String family, String name) async {
    final bytes = File('$dir${Platform.pathSeparator}$name').readAsBytesSync();
    await ui.loadFontFromList(bytes, fontFamily: family);
  }

  await load('Roboto', 'Roboto-Regular.ttf');
  await load('Roboto', 'Roboto-Medium.ttf');
  await load('Roboto', 'Roboto-Bold.ttf');
  await load('MaterialIcons', 'MaterialIcons-Regular.otf');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('writes a sample 1080x1350 postcard png', (tester) async {
    await initializeDateFormatting('en');
    await tester.runAsync(_loadFonts);
    tester.view.physicalSize = const Size(1080, 1350);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final now = DateTime(2026, 10, 31);
    final steps = <String, int>{};
    for (var d = 1; d <= 31; d++) {
      final date = DateTime(2026, 10, d);
      if (date.weekday == DateTime.sunday) {
        steps[todayKey(date)] = 900;
      } else if (d == 7 || d == 21) {
        steps[todayKey(date)] = 2400;
      } else if (d == 16) {
        steps[todayKey(date)] = 15420;
      } else {
        steps[todayKey(date)] = 8200 + d * 30;
      }
    }
    final walks = [
      for (final day in [3, 8, 12, 18, 24, 29])
        WalkEntry(
          id: '$day',
          mood: 'move',
          steps: 2000,
          minutes: 30,
          note: '',
          startedAt: '2026-10-${day.toString().padLeft(2, '0')}T10:00:00.000',
          endedAt: '2026-10-${day.toString().padLeft(2, '0')}T10:40:00.000',
        ),
    ];
    final data = buildPostcard(
      year: 2026,
      month: 10,
      stepsByDate: steps,
      goal: 8000,
      now: now,
      walks: walks,
    );

    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        home: ColoredBox(
          color: LookPack.quietGold.bg,
          child: Center(
            child: SizedBox(
              width: PostcardFace.width,
              height: PostcardFace.height,
              child: RepaintBoundary(
                key: key,
                child: PostcardFace(
                  data: data,
                  pack: LookPack.quietGold,
                  language: 'en',
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.runAsync(() async {
      await precacheImage(
        const AssetImage('assets/icon/icon_foreground.png'),
        key.currentContext!,
      );
    });
    await tester.pump();

    await tester.runAsync(() async {
      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 1);
      expect(image.width, 1080);
      expect(image.height, 1350);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      expect(bytes, isNotNull);
      final out = File(
        '${Directory.systemTemp.path}${Platform.pathSeparator}quiet-steps-postcard.png',
      );
      await out.writeAsBytes(bytes!.buffer.asUint8List(), flush: true);
      expect(out.existsSync(), isTrue);
      expect(out.lengthSync(), greaterThan(1000));
    });
  });
}
