import '../entities/drum_voice.dart';
import '../entities/groove.dart';
import '../repositories/drum_sound_repository.dart';
import '../services/task_scheduler.dart';

class RunGroove {
  RunGroove({
    required this.sounds,
    required this.scheduler,
    required this.onLitChanged,
  });

  final DrumSoundRepository sounds;
  final TaskScheduler scheduler;
  final void Function(Set<DrumVoice> lit) onLitChanged;

  final Set<DrumVoice> _lit = {};
  bool _playing = false;
  Groove? _groove;
  int _bpm = Groove.minBpm;

  bool get isPlaying => _playing;

  Set<DrumVoice> get lit => Set.unmodifiable(_lit);

  void start(Groove groove, int bpm) {
    stop();
    _groove = groove;
    _bpm = groove.clampBpm(bpm);
    _playing = true;
    _armLoop();
  }

  void stop() {
    scheduler.cancelAll();
    _playing = false;
    _lit.clear();
    onLitChanged(const {});
  }

  void restartIfPlaying(int bpm) {
    final groove = _groove;
    if (!_playing || groove == null) return;
    start(groove, bpm);
  }

  void _armLoop() {
    final groove = _groove;
    if (groove == null) return;

    for (final hit in groove.hits) {
      scheduler.schedule(groove.delayForBeat(hit.beat, _bpm), () {
        if (!_playing) return;
        sounds.play(hit.voice);
        _flash(hit.voice);
      });
    }

    scheduler.schedule(groove.loopLength(_bpm), () {
      if (!_playing) return;
      scheduler.cancelAll();
      _armLoop();
    });
  }

  void _flash(DrumVoice voice) {
    _lit.add(voice);
    onLitChanged(Set.of(_lit));
    scheduler.schedule(const Duration(milliseconds: 110), () {
      _lit.remove(voice);
      onLitChanged(Set.of(_lit));
    });
  }
}
