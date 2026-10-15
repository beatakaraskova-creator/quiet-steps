import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/walk_entry.dart';
import '../services/app_locale.dart';
import '../services/look.dart';
import '../services/postcard.dart';
import '../services/step_math.dart';
import '../services/store.dart';
import '../widgets/postcard_face.dart';

class PostcardScreen extends StatefulWidget {
  const PostcardScreen({super.key});

  @override
  State<PostcardScreen> createState() => _PostcardScreenState();
}

class _PostcardScreenState extends State<PostcardScreen> {
  final GlobalKey _cardKey = GlobalKey();
  late DateTime _month;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month, 1);
  }

  String get _lang => currentLanguage();

  Map<String, int> _stepsByDate(Store store) {
    final map = <String, int>{
      for (final d in store.history()) d.date: d.steps,
    };
    final key = store.todayDate.isEmpty ? todayKey() : store.todayDate;
    map[key] = store.todaySteps;
    return map;
  }

  DateTime _earliest(Map<String, int> steps, List<WalkEntry> walks) {
    return earliestPostcardMonth(
      dayKeys: steps.keys,
      walkIsos: [
        for (final w in walks)
          if (w.endedAt.isNotEmpty) w.endedAt else w.startedAt,
      ],
      now: DateTime.now(),
    );
  }

  Future<void> _snack(String msg) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<ui.Image?> _raster() async {
    final ctx = _cardKey.currentContext;
    if (ctx == null) return null;
    final boundary = ctx.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    return boundary.toImage(pixelRatio: 1);
  }

  Future<Uint8List?> _pngBytes() async {
    final image = await _raster();
    if (image == null) return null;
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data?.buffer.asUint8List();
  }

  String _fileName() {
    final m = _month.month.toString().padLeft(2, '0');
    return 'quiet-steps-${_month.year}-$m.png';
  }

  Future<void> _save() async {
    if (_busy) return;
    setState(() => _busy = true);
    final lang = _lang;
    try {
      final bytes = await _pngBytes();
      if (bytes == null) {
        await _snack(postcardUiLine(lang, 'saveFailed'));
        return;
      }
      if (!await Gal.hasAccess(toAlbum: true)) {
        final ok = await Gal.requestAccess(toAlbum: true);
        if (!ok) {
          await _snack(postcardUiLine(lang, 'needPermission'));
          return;
        }
      }
      final m = _month.month.toString().padLeft(2, '0');
      await Gal.putImageBytes(
        bytes,
        name: 'quiet-steps-${_month.year}-$m',
        album: 'Quiet Steps',
      );
      await _snack(postcardUiLine(lang, 'saved'));
    } catch (_) {
      await _snack(postcardUiLine(lang, 'saveFailed'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _share() async {
    if (_busy) return;
    setState(() => _busy = true);
    final lang = _lang;
    try {
      final bytes = await _pngBytes();
      if (bytes == null) {
        await _snack(postcardUiLine(lang, 'shareFailed'));
        return;
      }
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${_fileName()}');
      await file.writeAsBytes(bytes, flush: true);
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(file.path, mimeType: 'image/png', name: _fileName()),
          ],
        ),
      );
    } catch (_) {
      await _snack(postcardUiLine(lang, 'shareFailed'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = Store.instance;
    final p = Look.instance.pack;
    final lang = _lang;
    final now = DateTime.now();
    final steps = _stepsByDate(store);
    final walks = store.walks();
    final earliest = _earliest(steps, walks);
    final latest = DateTime(now.year, now.month, 1);
    final data = buildPostcard(
      year: _month.year,
      month: _month.month,
      stepsByDate: steps,
      goal: store.goal,
      now: now,
      walks: walks,
    );
    String heading;
    try {
      heading = DateFormat.yMMMM(lang).format(_month);
    } catch (_) {
      heading = DateFormat.yMMMM('en').format(_month);
    }

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: p.bg,
        foregroundColor: p.ink,
        title: Text(postcardUiLine(lang, 'title')),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: postcardUiLine(lang, 'title'),
                onPressed: canGoPrevMonth(_month, earliest)
                    ? () => setState(() => _month = prevMonth(_month))
                    : null,
                icon: Icon(
                  Icons.chevron_left,
                  color: canGoPrevMonth(_month, earliest) ? p.ink : p.muted,
                ),
              ),
              Expanded(
                child: Text(
                  heading,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: p.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: canGoNextMonth(_month, latest)
                    ? () => setState(() => _month = nextMonth(_month))
                    : null,
                icon: Icon(
                  Icons.chevron_right,
                  color: canGoNextMonth(_month, latest) ? p.ink : p.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AspectRatio(
            aspectRatio: PostcardFace.width / PostcardFace.height,
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: PostcardFace.width,
                height: PostcardFace.height,
                child: RepaintBoundary(
                  key: _cardKey,
                  child: PostcardFace(
                    data: data,
                    pack: p,
                    language: lang,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _busy ? null : _save,
            style: FilledButton.styleFrom(
              backgroundColor: p.accent,
              foregroundColor: p.onAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(postcardUiLine(lang, 'save')),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: _busy ? null : _share,
            style: secondaryOutlineStyle(
              p,
              minimumSize: const Size(double.infinity, 52),
            ),
            child: Text(postcardUiLine(lang, 'share')),
          ),
        ],
      ),
    );
  }
}
