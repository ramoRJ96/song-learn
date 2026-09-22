import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../domain/entities/drum_voice.dart';
import '../../../domain/entities/kit_layout.dart';
import '../../../domain/entities/kit_piece.dart';
import '../../theme/app_theme.dart';
import '../drum_voice_style.dart';

class KitPainter extends CustomPainter {
  KitPainter({required this.layout, required this.lit});

  final KitLayout layout;
  final Set<DrumVoice> lit;

  static const _head = Color(0xFFF3EDE3);
  static const _headEdge = Color(0xFFC9BFB2);
  static const _hoop = Color(0xFF1A1512);
  static const _hoopWood = Color(0xFF3A2C22);
  static const _chrome = Color(0xFFD5DCE4);
  static const _goldHi = Color(0xFFF6E08A);
  static const _gold = Color(0xFFD4A24A);
  static const _goldDeep = Color(0xFF8A5A12);

  List<KitPiece> get pieces => layout.pieces;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = StitchColors.bg);

    for (final piece in pieces) {
      final isLit = lit.contains(piece.voice);
      if (isLit) _paintGlow(canvas, piece);
      switch (piece.kind) {
        case PieceKind.cymbal:
          _paintCymbal(canvas, piece, isLit);
        case PieceKind.drum:
        case PieceKind.kick:
          _paintDrum(canvas, piece, isLit);
      }
      _caption(canvas, piece, isLit);
    }
  }

  void _paintGlow(Canvas canvas, KitPiece piece) {
    canvas.drawOval(
      piece.bounds.inflate(18),
      Paint()
        ..shader = ui.Gradient.radial(piece.center, piece.rx + 18, [
          piece.voice.accent.withValues(alpha: 0.38),
          piece.voice.accent.withValues(alpha: 0),
        ]),
    );
  }

  void _paintCymbal(Canvas canvas, KitPiece piece, bool isLit) {
    final bounds = piece.bounds;
    canvas.drawOval(
      bounds.translate(0, 7),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    canvas.drawOval(bounds.translate(0, 5), Paint()..color = _goldDeep.withValues(alpha: 0.9));

    canvas.drawOval(
      bounds,
      Paint()
        ..shader = ui.Gradient.linear(
          bounds.topLeft,
          bounds.bottomRight,
          isLit ? const [Color(0xFFFFF0B8), _goldHi, _gold, _goldDeep] : const [_goldHi, _gold, Color(0xFFB07A20), _goldDeep],
          const [0, 0.28, 0.62, 1],
        ),
    );

    for (final t in [0.22, 0.38, 0.55, 0.72, 0.88]) {
      canvas.drawOval(
        Rect.fromCenter(center: piece.center, width: piece.rx * 2 * t, height: piece.ry * 2 * t),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.9
          ..color = const Color(0x55F8E7A8),
      );
    }

    canvas.drawOval(
      bounds,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xCCF6E2A8),
    );

    final bell = Rect.fromCenter(center: piece.center, width: piece.rx * 0.28, height: piece.ry * 0.28);
    canvas.drawOval(
      bell,
      Paint()
        ..shader = ui.Gradient.radial(piece.center + Offset(-piece.rx * 0.04, -piece.ry * 0.04), piece.rx * 0.16, [
          const Color(0xFFFFF3C0),
          _gold,
          _goldDeep,
        ], const [0, 0.45, 1]),
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: piece.center + Offset(-piece.rx * 0.22, -piece.ry * 0.28),
        width: piece.rx * 0.7,
        height: piece.ry * 0.28,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.14),
    );
  }

  void _paintDrum(Canvas canvas, KitPiece piece, bool isLit) {
    final hoop = piece.bounds.inflate(piece.rx * 0.08);
    canvas.drawOval(
      hoop.translate(0, 8),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawOval(hoop, Paint()..color = _hoop);
    canvas.drawOval(
      hoop.deflate(piece.rx * 0.035),
      Paint()
        ..shader = ui.Gradient.linear(
          hoop.topLeft,
          hoop.bottomRight,
          const [Color(0xFF5A4332), _hoopWood, Color(0xFF1C1410)],
          const [0, 0.45, 1],
        ),
    );

    canvas.drawOval(
      piece.bounds,
      Paint()
        ..shader = ui.Gradient.radial(
          piece.center + Offset(-piece.rx * 0.22, -piece.ry * 0.28),
          piece.rx * 1.2,
          [
            if (isLit) Color.lerp(_head, piece.voice.accent, 0.22)! else const Color(0xFFFAF6F0),
            if (isLit) Color.lerp(_head, piece.voice.accent, 0.08)! else _head,
            _headEdge,
          ],
          const [0, 0.48, 1],
        ),
    );

    canvas.drawOval(
      piece.bounds.deflate(2.8),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..color = _chrome.withValues(alpha: 0.85),
    );

    final lugPaint = Paint()..color = _chrome;
    final lugCount = piece.voice == DrumVoice.kick ? 10 : 8;
    for (var i = 0; i < lugCount; i++) {
      final angle = (math.pi * 2 / lugCount) * i - math.pi / 2;
      final lug = Offset(
        piece.center.dx + math.cos(angle) * piece.rx * 0.93,
        piece.center.dy + math.sin(angle) * piece.ry * 0.93,
      );
      canvas.drawCircle(lug, math.max(2.2, piece.rx * 0.035), lugPaint);
    }

    canvas.drawOval(
      Rect.fromCenter(
        center: piece.center + Offset(-piece.rx * 0.2, -piece.ry * 0.26),
        width: piece.rx * 0.62,
        height: piece.ry * 0.32,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.16),
    );

    if (piece.voice == DrumVoice.kick) {
      _kickBadge(canvas, piece);
    } else if (piece.voice == DrumVoice.tomHigh) {
      _innerLabel(canvas, piece, '8" COATED');
    } else if (piece.voice == DrumVoice.tomLow) {
      _innerLabel(canvas, piece, 'FLOOR 16"');
    } else if (piece.voice == DrumVoice.snare) {
      _innerLabel(canvas, piece, 'COATED 14"');
    }
  }

  void _kickBadge(Canvas canvas, KitPiece piece) {
    final title = TextPainter(
      text: const TextSpan(
        text: 'SONG LEARN',
        style: TextStyle(
          color: Color(0xFF3A322C),
          fontWeight: FontWeight.w800,
          fontSize: 11,
          letterSpacing: 1.4,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final subtitle = TextPainter(
      text: const TextSpan(
        text: 'ACOUSTIC MASTER  22"',
        style: TextStyle(
          color: Color(0xFF6A625A),
          fontWeight: FontWeight.w600,
          fontSize: 8,
          letterSpacing: 0.8,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    title.paint(canvas, Offset(piece.center.dx - title.width / 2, piece.center.dy - 10));
    subtitle.paint(canvas, Offset(piece.center.dx - subtitle.width / 2, piece.center.dy + 4));
  }

  void _innerLabel(Canvas canvas, KitPiece piece, String text) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFF8A8278),
          fontWeight: FontWeight.w700,
          fontSize: 8,
          letterSpacing: 0.8,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, Offset(piece.center.dx - painter.width / 2, piece.center.dy - painter.height / 2));
  }

  void _caption(Canvas canvas, KitPiece piece, bool isLit) {
    final painter = TextPainter(
      text: TextSpan(
        text: piece.voice.stitchCaption,
        style: TextStyle(
          color: isLit ? piece.voice.accent : StitchColors.label,
          fontWeight: FontWeight.w700,
          fontSize: 10,
          letterSpacing: 0.8,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      Offset(piece.center.dx - painter.width / 2, piece.bounds.bottom + piece.rx * 0.14),
    );
  }

  @override
  bool shouldRepaint(KitPainter oldDelegate) {
    return oldDelegate.lit != lit || oldDelegate.layout.stage != layout.stage;
  }
}
