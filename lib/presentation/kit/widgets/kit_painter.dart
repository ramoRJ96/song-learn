import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../domain/entities/drum_voice.dart';
import '../../../domain/entities/kit_layout.dart';
import '../../../domain/entities/kit_piece.dart';
import '../drum_voice_style.dart';

class KitPainter extends CustomPainter {
  KitPainter({required this.layout, required this.lit});

  final KitLayout layout;
  final Set<DrumVoice> lit;

  static const _chrome = Color(0xFFD5DCE4);
  static const _chromeDark = Color(0xFF5C6570);
  static const _shell = Color(0xFF2A1C14);
  static const _shellLight = Color(0xFF4A3426);
  static const _head = Color(0xFFEDE6DA);
  static const _brass = Color(0xFFD4A24A);
  static const _brassDeep = Color(0xFF7A4E14);

  List<KitPiece> get pieces => layout.pieces;

  KitPiece of(DrumVoice voice) => pieces.firstWhere((p) => p.voice == voice);

  @override
  void paint(Canvas canvas, Size size) {
    _paintStage(canvas, size);
    _paintHardware(canvas);

    for (final piece in pieces) {
      final isLit = lit.contains(piece.voice);
      switch (piece.kind) {
        case PieceKind.cymbal:
          _paintCymbal(canvas, piece, isLit);
        case PieceKind.drum:
          _paintTom(canvas, piece, isLit);
        case PieceKind.kick:
          _paintKick(canvas, piece, isLit);
      }
    }
  }

  void _paintStage(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF0B0E12));

    final floor = Rect.fromCenter(
      center: Offset(layout.stage.center.dx, layout.stage.bottom - layout.stage.height * 0.06),
      width: layout.stage.width * 0.92,
      height: layout.stage.height * 0.22,
    );
    canvas.drawOval(
      floor,
      Paint()
        ..shader = ui.Gradient.radial(
          floor.center,
          floor.width * 0.42,
          const [Color(0xFF2A3140), Color(0x000B0E12)],
        ),
    );
  }

  void _paintHardware(Canvas canvas) {
    final line = Paint()
      ..color = _chrome.withValues(alpha: 0.8)
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;
    final floorY = layout.stage.bottom - 8;

    void tripod(double x, double y) {
      canvas.drawLine(Offset(x, y), Offset(x, floorY), line);
      canvas.drawLine(Offset(x, floorY), Offset(x - 22, floorY + 10), line);
      canvas.drawLine(Offset(x, floorY), Offset(x + 22, floorY + 10), line);
      canvas.drawLine(Offset(x, floorY), Offset(x, floorY + 12), line);
    }

    final crash = of(DrumVoice.crash);
    final boom = Offset(crash.center.dx + 18, floorY - layout.stage.height * 0.18);
    canvas.drawLine(crash.center + Offset(8, crash.ry), boom, line);
    tripod(boom.dx, crash.center.dy + 24);

    final hats = of(DrumVoice.hat);
    tripod(hats.center.dx, hats.center.dy + hats.ry);
    canvas.drawLine(
      Offset(hats.center.dx, floorY),
      Offset(hats.center.dx - 16, floorY + 14),
      line,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(hats.center.dx - 18, floorY + 14), width: 22, height: 6),
        const Radius.circular(3),
      ),
      Paint()..color = _chromeDark,
    );

    final snare = of(DrumVoice.snare);
    tripod(snare.center.dx, snare.center.dy + snare.ry * 1.5);

    final floorTom = of(DrumVoice.tomLow);
    tripod(floorTom.center.dx - 14, floorTom.center.dy + floorTom.ry * 1.4);
    tripod(floorTom.center.dx + 16, floorTom.center.dy + floorTom.ry * 1.4);
  }

  void _paintGlow(Canvas canvas, KitPiece piece, Color color) {
    canvas.drawOval(
      piece.bounds.inflate(14),
      Paint()
        ..shader = ui.Gradient.radial(piece.center, math.max(piece.rx, piece.ry) + 16, [
          color.withValues(alpha: 0.5),
          color.withValues(alpha: 0),
        ]),
    );
  }

  void _paintTom(Canvas canvas, KitPiece piece, bool isLit) {
    if (isLit) _paintGlow(canvas, piece, piece.voice.accent);

    final depth = piece.ry * 1.35;
    final bottom = piece.center + Offset(0, depth);
    final bottomRx = piece.rx * 0.94;
    final bottomRy = piece.ry * 0.94;

    final shell = Path()
      ..moveTo(piece.center.dx - piece.rx, piece.center.dy)
      ..lineTo(bottom.dx - bottomRx, bottom.dy)
      ..arcToPoint(
        Offset(bottom.dx + bottomRx, bottom.dy),
        radius: Radius.elliptical(bottomRx, bottomRy),
        clockwise: false,
      )
      ..lineTo(piece.center.dx + piece.rx, piece.center.dy)
      ..close();

    canvas.drawPath(
      shell,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(piece.center.dx - piece.rx, piece.center.dy),
          Offset(piece.center.dx + piece.rx, piece.center.dy),
          const [Color(0xFF1A120C), _shell, _shellLight, Color(0xFF1A120C)],
          const [0, 0.28, 0.62, 1],
        ),
    );

    canvas.drawOval(
      Rect.fromCenter(center: bottom, width: bottomRx * 2, height: bottomRy * 2),
      Paint()..color = const Color(0xFF140E0A),
    );

    _paintHead(canvas, piece, isLit, lugCount: 8);
    _caption(canvas, piece, isLit);
  }

  void _paintKick(Canvas canvas, KitPiece piece, bool isLit) {
    if (isLit) _paintGlow(canvas, piece, piece.voice.accent);

    final hoop = piece.bounds.inflate(8);
    canvas.drawOval(hoop, Paint()..color = const Color(0xFF1A1410));
    canvas.drawOval(
      hoop,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..color = _chromeDark,
    );
    canvas.drawOval(
      hoop.deflate(5),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = _chrome,
    );

    _paintHead(canvas, piece, isLit, lugCount: 10);

    final port = Rect.fromCenter(
      center: piece.center + Offset(piece.rx * 0.28, piece.ry * 0.08),
      width: piece.rx * 0.42,
      height: piece.ry * 0.38,
    );
    canvas.drawOval(port, Paint()..color = const Color(0xFF0B0E12));
    canvas.drawOval(
      port.deflate(2),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFF3A322C),
    );

    _caption(canvas, piece, isLit);
  }

  void _paintCymbal(Canvas canvas, KitPiece piece, bool isLit) {
    if (isLit) _paintGlow(canvas, piece, piece.voice.accent);

    if (piece.voice == DrumVoice.hat) {
      final lower = piece.bounds.translate(0, 5).inflate(2);
      canvas.drawOval(lower, Paint()..color = _brassDeep);
    }

    canvas.drawOval(piece.bounds.translate(0, 3), Paint()..color = _brassDeep.withValues(alpha: 0.85));

    canvas.drawOval(
      piece.bounds,
      Paint()
        ..shader = ui.Gradient.linear(
          piece.bounds.topLeft,
          piece.bounds.bottomRight,
          isLit
              ? const [Color(0xFFFFE7A3), _brass, _brassDeep]
              : const [Color(0xFFF3D27A), _brass, _brassDeep],
          const [0.0, 0.45, 1.0],
        ),
    );

    for (final t in [0.22, 0.42, 0.62, 0.82]) {
      canvas.drawOval(
        Rect.fromCenter(
          center: piece.center,
          width: piece.rx * 2 * t,
          height: piece.ry * 2 * t,
        ),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8
          ..color = const Color(0x66F6E2A8),
      );
    }

    canvas.drawOval(
      piece.bounds,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..color = const Color(0xFFF6E2A8).withValues(alpha: 0.85),
    );

    canvas.drawOval(
      Rect.fromCenter(center: piece.center, width: piece.rx * 0.22, height: piece.ry * 0.5),
      Paint()..color = const Color(0xFFF3D27A),
    );
    _caption(canvas, piece, isLit);
  }

  void _paintHead(Canvas canvas, KitPiece piece, bool isLit, {required int lugCount}) {
    canvas.drawOval(
      piece.bounds,
      Paint()
        ..shader = ui.Gradient.radial(
          piece.center + Offset(-piece.rx * 0.22, -piece.ry * 0.28),
          math.max(piece.rx, piece.ry) * 1.15,
          [
            if (isLit) Color.lerp(_head, piece.voice.accent, 0.3)! else const Color(0xFFF7F2EA),
            if (isLit) Color.lerp(_head, piece.voice.accent, 0.12)! else _head,
            const Color(0xFFB7AFA4),
          ],
          const [0, 0.45, 1],
        ),
    );

    canvas.drawOval(
      piece.bounds.deflate(3.5),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..color = _chrome.withValues(alpha: 0.9),
    );

    final lugPaint = Paint()..color = _chrome;
    for (var i = 0; i < lugCount; i++) {
      final angle = (math.pi * 2 / lugCount) * i - math.pi / 2;
      final lug = Offset(
        piece.center.dx + math.cos(angle) * piece.rx * 0.92,
        piece.center.dy + math.sin(angle) * piece.ry * 0.92,
      );
      canvas.drawCircle(lug, 2.4, lugPaint);
    }

    canvas.drawOval(
      Rect.fromCenter(
        center: piece.center + Offset(-piece.rx * 0.2, -piece.ry * 0.26),
        width: piece.rx * 0.62,
        height: piece.ry * 0.32,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.16),
    );
  }

  void _caption(Canvas canvas, KitPiece piece, bool isLit) {
    final painter = TextPainter(
      text: TextSpan(
        text: piece.voice.shortLabel.toUpperCase(),
        style: TextStyle(
          color: isLit ? piece.voice.accent : const Color(0xFF8B95A5),
          fontWeight: FontWeight.w700,
          fontSize: 10,
          letterSpacing: 1.1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      Offset(piece.center.dx - painter.width / 2, piece.bounds.bottom + 6),
    );
  }

  @override
  bool shouldRepaint(KitPainter oldDelegate) {
    return oldDelegate.lit != lit || oldDelegate.layout.stage != layout.stage;
  }
}
