import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:song_learn/domain/entities/drum_voice.dart';
import 'package:song_learn/domain/entities/groove.dart';
import 'package:song_learn/domain/repositories/groove_repository.dart';
import 'package:song_learn/presentation/kit/kit_providers.dart';

import '../support/fake_drum_sound_repository.dart';
import '../support/fake_task_scheduler.dart';

class _FakeGrooveRepository implements GrooveRepository {
  @override
  Groove demoGroove() {
    return const Groove(
      title: 'Test groove',
      bpm: 100,
      bars: 1,
      hits: [Hit(beat: 0, voice: DrumVoice.kick)],
    );
  }
}

void main() {
  late FakeDrumSoundRepository sounds;
  late FakeTaskScheduler scheduler;
  late ProviderContainer container;

  setUp(() {
    sounds = FakeDrumSoundRepository();
    scheduler = FakeTaskScheduler();
    container = ProviderContainer(
      overrides: [
        drumSoundRepositoryProvider.overrideWithValue(sounds),
        taskSchedulerProvider.overrideWithValue(scheduler),
        grooveRepositoryProvider.overrideWithValue(_FakeGrooveRepository()),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('prepare marque le kit prêt', () async {
    final controller = container.read(kitControllerProvider.notifier);
    await controller.prepare();
    expect(container.read(kitControllerProvider).ready, isTrue);
    expect(sounds.prepareCount, greaterThan(0));
  });

  test('hit joue et allume puis éteint', () async {
    final controller = container.read(kitControllerProvider.notifier);
    await controller.hit(DrumVoice.snare);
    expect(sounds.played, [DrumVoice.snare]);
    expect(container.read(kitControllerProvider).isLit(DrumVoice.snare), isTrue);

    scheduler.flush();
    expect(container.read(kitControllerProvider).isLit(DrumVoice.snare), isFalse);
  });

  test('toggleGroove démarre puis arrête', () {
    final controller = container.read(kitControllerProvider.notifier);
    controller.toggleGroove();
    expect(container.read(kitControllerProvider).playing, isTrue);

    scheduler.flushOnce();
    expect(sounds.played, contains(DrumVoice.kick));

    controller.toggleGroove();
    expect(container.read(kitControllerProvider).playing, isFalse);
    expect(container.read(kitControllerProvider).grooveLit, isEmpty);
  });

  test('setBpm borne le tempo', () {
    final controller = container.read(kitControllerProvider.notifier);
    controller.setBpm(10);
    expect(container.read(kitControllerProvider).bpm, Groove.minBpm);
    controller.setBpm(200);
    expect(container.read(kitControllerProvider).bpm, Groove.maxBpm);
  });
}
