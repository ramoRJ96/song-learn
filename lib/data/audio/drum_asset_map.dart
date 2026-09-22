import '../../domain/entities/drum_voice.dart';

String drumAssetPath(DrumVoice voice) {
  return switch (voice) {
    DrumVoice.kick => 'drums/kick.wav',
    DrumVoice.snare => 'drums/snare.wav',
    DrumVoice.hat => 'drums/hat.wav',
    DrumVoice.tomHigh => 'drums/tom_high.wav',
    DrumVoice.tomLow => 'drums/tom_low.wav',
    DrumVoice.crash => 'drums/crash.wav',
  };
}
