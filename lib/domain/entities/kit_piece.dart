import 'dart:ui';

import 'drum_voice.dart';

enum PieceKind { kick, drum, cymbal }

class KitPiece {
  const KitPiece({
    required this.voice,
    required this.kind,
    required this.center,
    required this.rx,
    required this.ry,
  });

  final DrumVoice voice;
  final PieceKind kind;
  final Offset center;
  final double rx;
  final double ry;

  Rect get bounds => Rect.fromCenter(center: center, width: rx * 2, height: ry * 2);

  bool contains(Offset point) {
    final dx = (point.dx - center.dx) / rx;
    final dy = (point.dy - center.dy) / ry;
    return dx * dx + dy * dy <= 1.05;
  }
}
