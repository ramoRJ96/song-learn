enum DrumVoice { kick, snare, hat, tomHigh, tomLow, crash }

extension DrumVoiceInfo on DrumVoice {
  String get label => switch (this) {
    DrumVoice.kick => 'Grosse caisse',
    DrumVoice.snare => 'Caisse claire',
    DrumVoice.hat => 'Charleston',
    DrumVoice.tomHigh => 'Tom aigu',
    DrumVoice.tomLow => 'Tom grave',
    DrumVoice.crash => 'Crash',
  };

  String get shortLabel => switch (this) {
    DrumVoice.kick => 'Kick',
    DrumVoice.snare => 'Snare',
    DrumVoice.hat => 'Hats',
    DrumVoice.tomHigh => 'Tom H',
    DrumVoice.tomLow => 'Tom L',
    DrumVoice.crash => 'Crash',
  };

  int get gmNote => switch (this) {
    DrumVoice.kick => 36,
    DrumVoice.snare => 38,
    DrumVoice.hat => 42,
    DrumVoice.tomHigh => 50,
    DrumVoice.tomLow => 45,
    DrumVoice.crash => 49,
  };
}

DrumVoice? voiceFromGmNote(int note) {
  for (final voice in DrumVoice.values) {
    if (voice.gmNote == note) return voice;
  }
  return switch (note) {
    35 => DrumVoice.kick,
    40 => DrumVoice.snare,
    44 || 46 => DrumVoice.hat,
    48 || 47 => DrumVoice.tomHigh,
    41 || 43 => DrumVoice.tomLow,
    52 || 57 => DrumVoice.crash,
    _ => null,
  };
}
