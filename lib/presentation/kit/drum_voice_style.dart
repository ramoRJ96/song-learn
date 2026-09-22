import 'package:flutter/material.dart';

import '../../domain/entities/drum_voice.dart';
import '../theme/app_theme.dart';

extension DrumVoiceStyle on DrumVoice {
  Color get accent => switch (this) {
    DrumVoice.kick => StitchColors.amber,
    DrumVoice.snare => StitchColors.label,
    DrumVoice.hat => const Color(0xFFE8D48A),
    DrumVoice.tomHigh => const Color(0xFFD8D0C4),
    DrumVoice.tomLow => StitchColors.label,
    DrumVoice.crash => const Color(0xFFE8D48A),
  };

  String get stitchCaption => switch (this) {
    DrumVoice.kick => 'GROSSE CAISSE  22"',
    DrumVoice.snare => 'CAISSE CLAIRE  14"',
    DrumVoice.hat => 'CHARLESTON  14"',
    DrumVoice.tomHigh => 'TOM AIGU  8"',
    DrumVoice.tomLow => 'TOM GRAVE  16"',
    DrumVoice.crash => 'CRASH  18"',
  };
}
