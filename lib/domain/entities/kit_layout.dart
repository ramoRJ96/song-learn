import 'dart:ui';

import 'drum_voice.dart';
import 'kit_piece.dart';

class KitLayout {
  const KitLayout({required this.stage, required this.pieces});

  final Rect stage;
  final List<KitPiece> pieces;
}

/// Vue de dessus paysage, calée sur la maquette Stitch tablette.
KitLayout buildKitLayout(Size size) {
  const aspect = 16 / 9;
  var stageW = size.width;
  var stageH = stageW / aspect;
  if (stageH > size.height) {
    stageH = size.height;
    stageW = stageH * aspect;
  }
  final stage = Rect.fromLTWH(
    (size.width - stageW) / 2,
    (size.height - stageH) / 2,
    stageW,
    stageH,
  );

  Offset p(double nx, double ny) => Offset(stage.left + nx * stage.width, stage.top + ny * stage.height);
  double r(double nw) => stage.width * nw;

  KitPiece piece({
    required DrumVoice voice,
    required PieceKind kind,
    required double nx,
    required double ny,
    required double nw,
  }) {
    final radius = r(nw);
    return KitPiece(
      voice: voice,
      kind: kind,
      center: p(nx, ny),
      rx: radius,
      ry: radius,
    );
  }

  final pieces = [
    piece(voice: DrumVoice.crash, kind: PieceKind.cymbal, nx: 0.18, ny: 0.36, nw: 0.092),
    piece(voice: DrumVoice.tomHigh, kind: PieceKind.drum, nx: 0.42, ny: 0.34, nw: 0.050),
    piece(voice: DrumVoice.hat, kind: PieceKind.cymbal, nx: 0.18, ny: 0.70, nw: 0.070),
    piece(voice: DrumVoice.snare, kind: PieceKind.drum, nx: 0.40, ny: 0.70, nw: 0.078),
    piece(voice: DrumVoice.kick, kind: PieceKind.kick, nx: 0.58, ny: 0.68, nw: 0.108),
    piece(voice: DrumVoice.tomLow, kind: PieceKind.drum, nx: 0.80, ny: 0.70, nw: 0.086),
  ];

  return KitLayout(stage: stage, pieces: pieces);
}

List<KitPiece> layoutKit(Size size) => buildKitLayout(size).pieces;

DrumVoice? hitTestKit(List<KitPiece> pieces, Offset point) {
  for (final piece in pieces.reversed) {
    if (piece.contains(point)) return piece.voice;
  }
  return null;
}
