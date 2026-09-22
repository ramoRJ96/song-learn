import 'dart:ui';

import 'drum_voice.dart';
import 'kit_piece.dart';

class KitLayout {
  const KitLayout({required this.stage, required this.pieces});

  final Rect stage;
  final List<KitPiece> pieces;
}

/// Vue batteur paysage : cymbales en hauteur, fûts au sol, kick au centre.
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

  final pieces = [
    KitPiece(
      voice: DrumVoice.crash,
      kind: PieceKind.cymbal,
      center: p(0.20, 0.20),
      rx: stage.width * 0.105,
      ry: stage.height * 0.040,
    ),
    KitPiece(
      voice: DrumVoice.hat,
      kind: PieceKind.cymbal,
      center: p(0.13, 0.46),
      rx: stage.width * 0.078,
      ry: stage.height * 0.030,
    ),
    KitPiece(
      voice: DrumVoice.tomHigh,
      kind: PieceKind.drum,
      center: p(0.40, 0.30),
      rx: stage.width * 0.070,
      ry: stage.height * 0.072,
    ),
    KitPiece(
      voice: DrumVoice.tomLow,
      kind: PieceKind.drum,
      center: p(0.78, 0.50),
      rx: stage.width * 0.092,
      ry: stage.height * 0.098,
    ),
    KitPiece(
      voice: DrumVoice.kick,
      kind: PieceKind.kick,
      center: p(0.52, 0.56),
      rx: stage.width * 0.148,
      ry: stage.height * 0.205,
    ),
    KitPiece(
      voice: DrumVoice.snare,
      kind: PieceKind.drum,
      center: p(0.30, 0.64),
      rx: stage.width * 0.076,
      ry: stage.height * 0.080,
    ),
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
