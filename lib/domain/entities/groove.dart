import 'drum_voice.dart';

class Hit {
  const Hit({required this.beat, required this.voice});

  /// Position en noires (0 = premier temps).
  final double beat;
  final DrumVoice voice;
}

class Groove {
  const Groove({
    required this.title,
    required this.bpm,
    required this.bars,
    required this.hits,
  });

  final String title;
  final int bpm;
  final int bars;
  final List<Hit> hits;

  static const int minBpm = 60;
  static const int maxBpm = 160;

  Duration get barDuration => Duration(milliseconds: (4 * 60000 / bpm).round());

  Duration get loopDuration => barDuration * bars;

  int clampBpm(int value) => value.clamp(minBpm, maxBpm);

  Duration delayForBeat(double beat, int playbackBpm) {
    return Duration(milliseconds: (beat * 60000 / playbackBpm).round());
  }

  Duration loopLength(int playbackBpm) {
    return Duration(milliseconds: (bars * 4 * 60000 / playbackBpm).round());
  }
}
