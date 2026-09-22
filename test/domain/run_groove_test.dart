import 'package:flutter_test/flutter_test.dart';
import 'package:song_learn/domain/entities/drum_voice.dart';
import 'package:song_learn/domain/entities/groove.dart';
import 'package:song_learn/domain/usecases/run_groove.dart';

import '../support/fake_drum_sound_repository.dart';
import '../support/fake_task_scheduler.dart';

void main() {
  const groove = Groove(
    title: 'Mini',
    bpm: 120,
    bars: 1,
    hits: [
      Hit(beat: 0, voice: DrumVoice.kick),
      Hit(beat: 1, voice: DrumVoice.snare),
    ],
  );

  test('joue les hits puis éteint les pièces', () {
    final sounds = FakeDrumSoundRepository();
    final scheduler = FakeTaskScheduler();
    final litHistory = <Set<DrumVoice>>[];
    final run = RunGroove(
      sounds: sounds,
      scheduler: scheduler,
      onLitChanged: litHistory.add,
    );

    run.start(groove, 120);
    expect(run.isPlaying, isTrue);

    scheduler.flushOnce();
    expect(sounds.played, [DrumVoice.kick]);
    expect(litHistory.last, {DrumVoice.kick});

    scheduler.flushOnce();
    expect(sounds.played, [DrumVoice.kick, DrumVoice.snare]);

    run.stop();
    expect(run.isPlaying, isFalse);
    expect(run.lit, isEmpty);
  });

  test('stop annule les callbacks restants', () {
    final sounds = FakeDrumSoundRepository();
    final scheduler = FakeTaskScheduler();
    final run = RunGroove(
      sounds: sounds,
      scheduler: scheduler,
      onLitChanged: (_) {},
    );

    run.start(groove, 120);
    run.stop();
    scheduler.flush();
    expect(sounds.played, isEmpty);
  });
}
