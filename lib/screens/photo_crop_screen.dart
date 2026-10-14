import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../services/look.dart';

/// Full-screen crop. Starts with the whole photo visible and centred.
/// Pinch to fill the phone, drag to choose the part you want, then Use.
class PhotoCropScreen extends StatefulWidget {
  const PhotoCropScreen({super.key, required this.file});

  final File file;

  @override
  State<PhotoCropScreen> createState() => _PhotoCropScreenState();
}

class _PhotoCropScreenState extends State<PhotoCropScreen> {
  final _boundaryKey = GlobalKey();

  double _imgW = 0;
  double _imgH = 0;
  double _scale = 1;
  double _minScale = 1;
  double _maxScale = 4;
  Offset _offset = Offset.zero;

  double _startScale = 1;
  Offset _startOffset = Offset.zero;
  Offset _startFocal = Offset.zero;

  bool _ready = false;
  bool _busy = false;
  Size? _view;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bytes = await widget.file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final w = frame.image.width.toDouble();
    final h = frame.image.height.toDouble();
    frame.image.dispose();
    if (!mounted) return;
    setState(() {
      _imgW = w;
      _imgH = h;
      _ready = true;
    });
  }

  void _fitToView(Size view) {
    if (_imgW <= 0 || _imgH <= 0) return;
    if (_view == view) return;
    _view = view;
    _minScale = math.min(view.width / _imgW, view.height / _imgH);
    final cover = math.max(view.width / _imgW, view.height / _imgH);
    _maxScale = cover * 5;
    // Whole photo on screen, centred — user pinches to fill.
    _scale = _minScale;
    _offset = _clamp(Offset(
      (view.width - _imgW * _scale) / 2,
      (view.height - _imgH * _scale) / 2,
    ));
  }

  Offset _clamp(Offset offset) {
    final view = _view;
    if (view == null) return offset;
    final w = _imgW * _scale;
    final h = _imgH * _scale;
    double dx = offset.dx;
    double dy = offset.dy;
    if (w <= view.width) {
      dx = (view.width - w) / 2;
    } else {
      dx = dx.clamp(view.width - w, 0);
    }
    if (h <= view.height) {
      dy = (view.height - h) / 2;
    } else {
      dy = dy.clamp(view.height - h, 0);
    }
    return Offset(dx, dy);
  }

  void _onScaleStart(ScaleStartDetails d) {
    _startScale = _scale;
    _startOffset = _offset;
    _startFocal = d.localFocalPoint;
  }

  void _onScaleUpdate(ScaleUpdateDetails d) {
    final nextScale = (_startScale * d.scale).clamp(_minScale, _maxScale);
    final normalized = (_startFocal - _startOffset) / _startScale;
    setState(() {
      _scale = nextScale;
      _offset = _clamp(d.localFocalPoint - normalized * nextScale);
    });
  }

  void _fillScreen() {
    final view = _view;
    if (view == null || _imgW <= 0) return;
    final cover = math.max(view.width / _imgW, view.height / _imgH);
    setState(() {
      _scale = cover;
      _offset = _clamp(Offset(
        (view.width - _imgW * _scale) / 2,
        (view.height - _imgH * _scale) / 2,
      ));
    });
  }

  Future<void> _use() async {
    if (_busy || !_ready) return;
    setState(() => _busy = true);
    try {
      final boundary = _boundaryKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (bytes == null) return;
      await Look.instance.saveCroppedPhoto(bytes.buffer.asUint8List());
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          RepaintBoundary(
            key: _boundaryKey,
            child: ColoredBox(
              color: Colors.black,
              child: !_ready
                  ? const Center(child: CircularProgressIndicator())
                  : LayoutBuilder(
                      builder: (context, box) {
                        final view = box.biggest;
                        if (view.width > 0 && view.height > 0) {
                          _fitToView(view);
                        }
                        return ClipRect(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onScaleStart: _onScaleStart,
                            onScaleUpdate: _onScaleUpdate,
                            onDoubleTap: _fillScreen,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Positioned(
                                  left: _offset.dx,
                                  top: _offset.dy,
                                  width: _imgW * _scale,
                                  height: _imgH * _scale,
                                  child: Image.file(
                                    widget.file,
                                    fit: BoxFit.fill,
                                    filterQuality: FilterQuality.high,
                                    width: _imgW * _scale,
                                    height: _imgH * _scale,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0),
                    Colors.black.withValues(alpha: 0.72),
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                          label: 'Cancel',
                          onPressed: _busy
                              ? null
                              : () => Navigator.pop(context, false),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _actionButton(
                          label: 'Fill',
                          onPressed: _busy ? null : _fillScreen,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _actionButton(
                          label: 'Use',
                          onPressed: (_busy || !_ready) ? null : _use,
                          busy: _busy,
                        ),
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

  Widget _actionButton({
    required String label,
    required VoidCallback? onPressed,
    bool busy = false,
  }) {
    final p = Look.instance.pack;
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: p.accent,
        foregroundColor: p.onAccent,
        disabledBackgroundColor: p.accent.withValues(alpha: 0.5),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: busy
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: p.onAccent,
              ),
            )
          : Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
    );
  }
}
