import 'package:song_learn/domain/entities/drum_voice.dart';
import 'package:song_learn/domain/repositories/drum_sound_repository.dart';

class FakeDrumSoundRepository implements DrumSoundRepository {
  final List<DrumVoice> played = [];
  int prepareCount = 0;
  bool failPrepare = false;

  @override
  Future<void> prepare() async {
    prepareCount += 1;
    if (failPrepare) throw StateError('prepare failed');
  }

  @override
  Future<void> play(DrumVoice voice) async {
    played.add(voice);
  }

  @override
  Future<void> dispose() async {}
}
