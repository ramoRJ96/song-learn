import '../repositories/drum_sound_repository.dart';

class PrepareDrumKit {
  const PrepareDrumKit(this._sounds);

  final DrumSoundRepository _sounds;

  Future<void> call() => _sounds.prepare();
}
