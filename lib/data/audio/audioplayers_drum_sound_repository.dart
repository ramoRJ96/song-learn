import 'package:audioplayers/audioplayers.dart';

import '../../domain/entities/drum_voice.dart';
import '../../domain/repositories/drum_sound_repository.dart';
import 'drum_asset_map.dart';

class AudioplayersDrumSoundRepository implements DrumSoundRepository {
  final Map<DrumVoice, List<AudioPlayer>> _pools = {
    for (final voice in DrumVoice.values) voice: [],
  };

  static const _voicesPerPad = 3;

  @override
  Future<void> prepare() async {
    for (final voice in DrumVoice.values) {
      final pool = _pools[voice]!;
      if (pool.isNotEmpty) continue;
      for (var i = 0; i < _voicesPerPad; i++) {
        final player = AudioPlayer();
        await player.setPlayerMode(PlayerMode.lowLatency);
        await player.setReleaseMode(ReleaseMode.stop);
        await player.setSource(AssetSource(drumAssetPath(voice)));
        pool.add(player);
      }
    }
  }

  @override
  Future<void> play(DrumVoice voice) async {
    final pool = _pools[voice]!;
    if (pool.isEmpty) {
      await prepare();
    }
    AudioPlayer? idle;
    for (final player in pool) {
      if (player.state != PlayerState.playing) {
        idle = player;
        break;
      }
    }
    final player = idle ?? pool.first;
    await player.stop();
    await player.play(AssetSource(drumAssetPath(voice)));
  }

  @override
  Future<void> dispose() async {
    for (final pool in _pools.values) {
      for (final player in pool) {
        await player.dispose();
      }
      pool.clear();
    }
  }
}
