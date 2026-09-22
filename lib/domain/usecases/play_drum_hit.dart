import '../entities/drum_voice.dart';
import '../repositories/drum_sound_repository.dart';

class PlayDrumHit {
  const PlayDrumHit(this._sounds);

  final DrumSoundRepository _sounds;

  Future<void> call(DrumVoice voice) => _sounds.play(voice);
}
