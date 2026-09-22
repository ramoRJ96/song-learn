import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:song_learn/domain/entities/drum_voice.dart';
import 'package:song_learn/domain/entities/kit_layout.dart';

void main() {
  const landscape = Size(800, 450);

  test('place les 6 pièces du kit', () {
    expect(layoutKit(landscape), hasLength(6));
  });

  test('le snare est à gauche de la grosse caisse', () {
    final pieces = layoutKit(landscape);
    final snare = pieces.firstWhere((p) => p.voice == DrumVoice.snare);
    final kick = pieces.firstWhere((p) => p.voice == DrumVoice.kick);
    expect(snare.center.dx, lessThan(kick.center.dx));
    expect(hitTestKit(pieces, snare.center), DrumVoice.snare);
  });

  test('le charleston est à gauche, le floor tom à droite', () {
    final pieces = layoutKit(landscape);
    final hats = pieces.firstWhere((p) => p.voice == DrumVoice.hat);
    final floorTom = pieces.firstWhere((p) => p.voice == DrumVoice.tomLow);
    final kick = pieces.firstWhere((p) => p.voice == DrumVoice.kick);
    expect(hats.center.dx, lessThan(kick.center.dx));
    expect(floorTom.center.dx, greaterThan(kick.center.dx));
  });

  test('le crash est au-dessus de la grosse caisse', () {
    final pieces = layoutKit(landscape);
    final crash = pieces.firstWhere((p) => p.voice == DrumVoice.crash);
    final kick = pieces.firstWhere((p) => p.voice == DrumVoice.kick);
    expect(crash.center.dy, lessThan(kick.center.dy));
  });

  test('le centre du kick vise la grosse caisse', () {
    final pieces = layoutKit(landscape);
    final kick = pieces.firstWhere((p) => p.voice == DrumVoice.kick);
    expect(hitTestKit(pieces, kick.center), DrumVoice.kick);
  });

  test('un coin vide ne déclenche rien', () {
    expect(hitTestKit(layoutKit(landscape), Offset.zero), isNull);
  });
}
