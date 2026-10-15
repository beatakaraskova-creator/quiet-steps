import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiet_steps/models/look_pack.dart';

Future<void> _loadFonts() async {
  final root = Platform.environment['FLUTTER_ROOT'] ??
      r'C:\Users\tomas\Downloads\flutter';
  final dir =
      '$root${Platform.pathSeparator}bin${Platform.pathSeparator}cache${Platform.pathSeparator}artifacts${Platform.pathSeparator}material_fonts';
  final loader = FontLoader('Roboto');
  for (final name in [
    'Roboto-Regular.ttf',
    'Roboto-Medium.ttf',
    'Roboto-Bold.ttf',
  ]) {
    final bytes = File('$dir${Platform.pathSeparator}$name').readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

const _smallSize = Size(380, 260);
const _mediumSize = Size(800, 400);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('widget picker previews have the right shape', (tester) async {
    await tester.runAsync(_loadFonts);

    Future<void> capture({
      required Size size,
      required Widget child,
      required String name,
    }) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            fontFamily: 'Roboto',
            useMaterial3: true,
            textTheme: const TextTheme(
              bodyMedium: TextStyle(fontFamily: 'Roboto'),
            ),
          ),
          home: DefaultTextStyle(
            style: const TextStyle(fontFamily: 'Roboto', color: Color(0xFFF3EFE6)),
            child: ColoredBox(
            color: const Color(0x00000000),
            child: Center(
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: RepaintBoundary(key: key, child: child),
              ),
            ),
          ),
          ),
        ),
      );
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
        expect(image.width, size.width.round());
        expect(image.height, size.height.round());
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        expect(bytes, isNotNull);
        if (Platform.environment['WRITE_WIDGET_PREVIEWS'] == '1') {
          final out = File('android/app/src/main/res/drawable/$name.png');
          await out.writeAsBytes(bytes!.buffer.asUint8List(), flush: true);
        }
      });
    }

    await capture(
      size: _smallSize,
      name: 'widget_preview_small',
      child: const _SmallPreview(),
    );
    await capture(
      size: _mediumSize,
      name: 'widget_preview_medium',
      child: const _MediumPreview(),
    );

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final small =
        File('android/app/src/main/res/drawable/widget_preview_small.png');
    final medium =
        File('android/app/src/main/res/drawable/widget_preview_medium.png');
    expect(small.existsSync(), isTrue);
    expect(medium.existsSync(), isTrue);

    await tester.runAsync(() async {
      Future<ui.Image> decode(File f) async {
        final codec = await ui.instantiateImageCodec(f.readAsBytesSync());
        final frame = await codec.getNextFrame();
        return frame.image;
      }

      final s = await decode(small);
      final m = await decode(medium);
      expect(s.width / s.height, closeTo(1.46, 0.12));
      expect(m.width / m.height, closeTo(2.0, 0.08));
    });
  });
}

class _SmallPreview extends StatelessWidget {
  const _SmallPreview();

  @override
  Widget build(BuildContext context) {
    const pack = LookPack.quietGold;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: pack.card,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icon/icon_foreground.png',
                  width: 56,
                  height: 56,
                  filterQuality: FilterQuality.medium,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '4,218',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: pack.ink,
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            const _Bar(progress: 4218 / 8000),
          ],
        ),
      ),
    );
  }
}

class _MediumPreview extends StatelessWidget {
  const _MediumPreview();

  @override
  Widget build(BuildContext context) {
    const pack = LookPack.quietGold;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: pack.card,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icon/icon_foreground.png',
                  width: 72,
                  height: 72,
                  filterQuality: FilterQuality.medium,
                ),
                const SizedBox(width: 16),
                Text(
                  '4,218',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: pack.ink,
                    fontSize: 52,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '3 good days',
              style: TextStyle(
                fontFamily: 'Roboto',
                color: pack.muted,
                fontSize: 26,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '3,782 steps to go',
              style: TextStyle(
                fontFamily: 'Roboto',
                color: pack.ink,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            const _Bar(progress: 4218 / 8000),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: 12,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: Color(0xFF2C2C28)),
            Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                heightFactor: 1,
                child: const ColoredBox(color: Color(0xFFC4A574)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
