// Calm milestone pop-up that replaced the always-visible Home card of 1.0.1+2.
// Shows the warm line for 30 s, then fades away. Tap anywhere or Close.
// Sound (tune, then voice) is started by the caller; see milestone_sound.dart.
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../l10n/popup_text.dart';
import '../models/look_pack.dart';
import '../services/format.dart';
import '../services/look.dart';

const milestonePopupDuration = Duration(seconds: 30);

/// Bundled serif for the warm line (Noto Serif, SIL OFL 1.1, Latin subset).
const milestoneSerif = 'NotoSerif';

/// "5,000 steps" / "5 000 krokov" / "Daily goal" for a fired milestone id.
String milestonePopupLabel(String language, String milestoneKey) =>
    popupMilestoneLabel(language, milestoneKey, (n) => formatCount(n, language));

/// Show the pop-up over whatever is on screen. Returns when it closes.
Future<void> showMilestonePopup(
  BuildContext context, {
  required String language,
  required String label,
  required String line,
  Duration duration = milestonePopupDuration,
  Listenable? closeSignal,
}) async {
  await showGeneralDialog<void>(
    context: context,
    barrierDismissible: false, // our own full-screen tap target handles it
    barrierColor: Colors.transparent,
    barrierLabel: label,
    transitionDuration: const Duration(milliseconds: 450),
    pageBuilder: (ctx, a1, a2) => MilestonePopup(
      language: language,
      label: label,
      line: line,
      duration: duration,
      closeSignal: closeSignal,
    ),
    transitionBuilder: (ctx, anim, _, child) {
      final c = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(opacity: c, child: child);
    },
  );
}

class MilestonePopup extends StatefulWidget {
  const MilestonePopup({
    super.key,
    required this.language,
    required this.label,
    required this.line,
    this.duration = milestonePopupDuration,
    this.closeSignal,
  });

  final String language;
  final String label;
  final String line;
  final Duration duration;

  /// Fires to close the pop-up from outside (for example the app was left).
  final Listenable? closeSignal;

  @override
  State<MilestonePopup> createState() => _MilestonePopupState();
}

class _MilestonePopupState extends State<MilestonePopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _life =
      AnimationController(vsync: this, duration: widget.duration)
        ..addStatusListener((s) {
          if (s == AnimationStatus.completed) _dismiss();
        })
        ..forward();
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    widget.closeSignal?.addListener(_dismiss);
  }

  void _dismiss() {
    if (_closing || !mounted) return;
    _closing = true;
    Navigator.of(context).maybePop();
  }

  @override
  void dispose() {
    widget.closeSignal?.removeListener(_dismiss);
    _life.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pack = Look.instance.pack;
    final scale = Look.instance.fontScale;
    final big = Look.instance.bigSimple;
    final media = MediaQuery.of(context);
    final cardW = (media.size.width - (big ? 32 : 56)).clamp(0.0, 360.0);
    final scrim = pack.light
        ? Colors.black.withValues(alpha: 0.22)
        : Colors.black.withValues(alpha: 0.48);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _dismiss,
      child: Stack(
        children: [
          Positioned.fill(
            key: const ValueKey('popup-scrim'),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 9, sigmaY: 9),
              child: ColoredBox(color: scrim),
            ),
          ),
          Center(
            child: Semantics(
              liveRegion: true,
              label: '${widget.label}. ${widget.line}',
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  width: cardW,
                  padding: EdgeInsets.fromLTRB(
                      big ? 24 : 28, big ? 30 : 28, big ? 24 : 28, 10),
                  decoration: BoxDecoration(
                    color: pack.card,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: pack.line, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: pack.light ? 0.08 : 0.30),
                        blurRadius: 32,
                        spreadRadius: -6,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomPaint(
                        size: Size.square(big ? 38 : 32),
                        painter: FootprintsPainter(pack.accent),
                      ),
                      SizedBox(height: big ? 14 : 12),
                      Text(
                        widget.label,
                        key: const ValueKey('popup-label'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: pack.accent,
                          fontSize: (big ? 16 : 13.5) * scale,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6,
                        ),
                      ),
                      SizedBox(height: big ? 14 : 12),
                      Text(
                        widget.line,
                        key: const ValueKey('popup-line'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: milestoneSerif,
                          color: pack.ink,
                          fontSize: (big ? 24 : 21) * scale,
                          height: 1.42,
                        ),
                      ),
                      SizedBox(height: big ? 24 : 22),
                      _LifeLine(life: _life, pack: pack),
                      SizedBox(height: big ? 10 : 6),
                      TextButton(
                        onPressed: _dismiss,
                        style: TextButton.styleFrom(
                          foregroundColor: pack.muted,
                          minimumSize: Size(120, big ? 56 : 48),
                          textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: (big ? 18 : 15) * scale,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        child: Text(popupLine(widget.language, 'close'), key: const ValueKey('popup-close')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Thin line that shrinks toward its centre over the 30 seconds.
class _LifeLine extends StatelessWidget {
  const _LifeLine({required this.life, required this.pack});
  final Animation<double> life;
  final LookPack pack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 2,
      child: AnimatedBuilder(
        animation: life,
        builder: (_, _) => Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: pack.line,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: (1 - life.value).clamp(0.0, 1.0),
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: pack.accent.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Two small soft footprints, drawn (no icon font has one).
class FootprintsPainter extends CustomPainter {
  FootprintsPainter(this.color);
  final Color color;

  void _foot(Canvas c, Offset o, double s, Paint p, {bool mirror = false}) {
    c.save();
    c.translate(o.dx, o.dy);
    if (mirror) c.scale(-1, 1);
    c.rotate(mirror ? 0.18 : -0.18);
    // sole
    c.drawOval(Rect.fromCenter(center: Offset(0, s * 0.10), width: s * 0.36, height: s * 0.52), p);
    // heel
    c.drawOval(Rect.fromCenter(center: Offset(0, s * 0.46), width: s * 0.26, height: s * 0.20), p);
    // toes
    for (var i = 0; i < 4; i++) {
      final r = s * (0.065 - i * 0.008);
      c.drawCircle(Offset(-s * 0.12 + i * s * 0.08, -s * 0.24 + i * s * 0.025), r, p);
    }
    c.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.height * 0.62;
    final p = Paint()..color = color.withValues(alpha: 0.9);
    _foot(canvas, Offset(size.width * 0.32, size.height * 0.58), s, p);
    _foot(canvas, Offset(size.width * 0.70, size.height * 0.34), s, p, mirror: true);
  }

  @override
  bool shouldRepaint(FootprintsPainter old) => old.color != color;
}
