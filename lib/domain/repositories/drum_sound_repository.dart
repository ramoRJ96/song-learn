import '../entities/drum_voice.dart';

abstract class DrumSoundRepository {
  Future<void> prepare();

  Future<void> play(DrumVoice voice);

  Future<void> dispose();
}
