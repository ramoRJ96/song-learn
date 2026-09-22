import 'package:flutter/material.dart';

import '../../domain/entities/drum_voice.dart';

extension DrumVoiceStyle on DrumVoice {
  Color get accent => switch (this) {
    DrumVoice.kick => const Color(0xFFE8A23C),
    DrumVoice.snare => const Color(0xFF4CC3D9),
    DrumVoice.hat => const Color(0xFFB8C0CC),
    DrumVoice.tomHigh => const Color(0xFF7C6CFF),
    DrumVoice.tomLow => const Color(0xFF3D8BFF),
    DrumVoice.crash => const Color(0xFFFF6B6B),
  };
}
