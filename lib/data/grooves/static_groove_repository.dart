import '../../domain/entities/drum_voice.dart';
import '../../domain/entities/groove.dart';
import '../../domain/repositories/groove_repository.dart';

class StaticGrooveRepository implements GrooveRepository {
  const StaticGrooveRepository();

  @override
  Groove demoGroove() => rockGroove;
}

const rockGroove = Groove(
  title: 'Rock 4/4',
  bpm: 100,
  bars: 2,
  hits: [
    Hit(beat: 0, voice: DrumVoice.crash),
    Hit(beat: 0, voice: DrumVoice.kick),
    Hit(beat: 0, voice: DrumVoice.hat),
    Hit(beat: 0.5, voice: DrumVoice.hat),
    Hit(beat: 1, voice: DrumVoice.snare),
    Hit(beat: 1, voice: DrumVoice.hat),
    Hit(beat: 1.5, voice: DrumVoice.hat),
    Hit(beat: 2, voice: DrumVoice.kick),
    Hit(beat: 2, voice: DrumVoice.hat),
    Hit(beat: 2.5, voice: DrumVoice.hat),
    Hit(beat: 3, voice: DrumVoice.snare),
    Hit(beat: 3, voice: DrumVoice.hat),
    Hit(beat: 3.5, voice: DrumVoice.hat),
    Hit(beat: 4, voice: DrumVoice.kick),
    Hit(beat: 4, voice: DrumVoice.hat),
    Hit(beat: 4.5, voice: DrumVoice.hat),
    Hit(beat: 5, voice: DrumVoice.snare),
    Hit(beat: 5, voice: DrumVoice.hat),
    Hit(beat: 5.5, voice: DrumVoice.hat),
    Hit(beat: 6, voice: DrumVoice.kick),
    Hit(beat: 6, voice: DrumVoice.hat),
    Hit(beat: 6.5, voice: DrumVoice.hat),
    Hit(beat: 7, voice: DrumVoice.snare),
    Hit(beat: 7, voice: DrumVoice.hat),
    Hit(beat: 7.5, voice: DrumVoice.hat),
  ],
);
