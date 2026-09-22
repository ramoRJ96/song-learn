import 'package:flutter_test/flutter_test.dart';
import 'package:song_learn/domain/entities/drum_voice.dart';

void main() {
  test('mappe les notes GM principales', () {
    expect(voiceFromGmNote(36), DrumVoice.kick);
    expect(voiceFromGmNote(38), DrumVoice.snare);
    expect(voiceFromGmNote(42), DrumVoice.hat);
    expect(voiceFromGmNote(49), DrumVoice.crash);
  });

  test('mappe les alias GM courants', () {
    expect(voiceFromGmNote(35), DrumVoice.kick);
    expect(voiceFromGmNote(46), DrumVoice.hat);
    expect(voiceFromGmNote(57), DrumVoice.crash);
  });

  test('ignore une note inconnue', () {
    expect(voiceFromGmNote(12), isNull);
  });
}
