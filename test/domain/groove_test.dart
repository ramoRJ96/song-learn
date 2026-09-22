import 'package:flutter_test/flutter_test.dart';
import 'package:song_learn/domain/entities/drum_voice.dart';
import 'package:song_learn/domain/entities/groove.dart';

void main() {
  const groove = Groove(
    title: 'Test',
    bpm: 120,
    bars: 1,
    hits: [Hit(beat: 0, voice: DrumVoice.kick), Hit(beat: 1, voice: DrumVoice.snare)],
  );

  test('borne le tempo', () {
    expect(groove.clampBpm(10), Groove.minBpm);
    expect(groove.clampBpm(300), Groove.maxBpm);
    expect(groove.clampBpm(100), 100);
  });

  test('calcule le délai d’une noire à 120 BPM', () {
    expect(groove.delayForBeat(1, 120), const Duration(milliseconds: 500));
  });

  test('calcule la durée d’une mesure 4/4', () {
    expect(groove.barDuration, const Duration(milliseconds: 2000));
    expect(groove.loopDuration, const Duration(milliseconds: 2000));
  });
}
