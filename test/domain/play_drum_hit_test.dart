import 'package:flutter_test/flutter_test.dart';
import 'package:song_learn/domain/entities/drum_voice.dart';
import 'package:song_learn/domain/usecases/play_drum_hit.dart';
import 'package:song_learn/domain/usecases/prepare_drum_kit.dart';

import '../support/fake_drum_sound_repository.dart';

void main() {
  test('PlayDrumHit délègue au repository', () async {
    final sounds = FakeDrumSoundRepository();
    await PlayDrumHit(sounds)(DrumVoice.snare);
    expect(sounds.played, [DrumVoice.snare]);
  });

  test('PrepareDrumKit prépare le repository', () async {
    final sounds = FakeDrumSoundRepository();
    await PrepareDrumKit(sounds)();
    expect(sounds.prepareCount, 1);
  });
}
