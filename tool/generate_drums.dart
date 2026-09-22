import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

const rate = 44100;

void main() {
  final out = Directory('assets/drums')..createSync(recursive: true);
  final rng = Random(7);
  writeWav(File('${out.path}/kick.wav'), kick());
  writeWav(File('${out.path}/snare.wav'), snare(rng));
  writeWav(File('${out.path}/hat.wav'), hat(rng));
  writeWav(File('${out.path}/tom_high.wav'), tom(196, 130, 0.38));
  writeWav(File('${out.path}/tom_low.wav'), tom(118, 72, 0.5));
  writeWav(File('${out.path}/crash.wav'), crash(rng));
  stdout.writeln('WAV écrits dans ${out.path}');
}

void writeWav(File file, List<double> samples) {
  final bytes = BytesBuilder();
  final dataSize = samples.length * 2;
  bytes.add('RIFF'.codeUnits);
  bytes.add(_le32(36 + dataSize));
  bytes.add('WAVE'.codeUnits);
  bytes.add('fmt '.codeUnits);
  bytes.add(_le32(16));
  bytes.add(_le16(1));
  bytes.add(_le16(1));
  bytes.add(_le32(rate));
  bytes.add(_le32(rate * 2));
  bytes.add(_le16(2));
  bytes.add(_le16(16));
  bytes.add('data'.codeUnits);
  bytes.add(_le32(dataSize));
  for (final sample in samples) {
    final clamped = sample.clamp(-1.0, 1.0);
    bytes.add(_le16((clamped * 32767).round()));
  }
  file.writeAsBytesSync(bytes.takeBytes());
}

List<int> _le16(int value) => [value & 0xff, (value >> 8) & 0xff];

List<int> _le32(int value) => [
  value & 0xff,
  (value >> 8) & 0xff,
  (value >> 16) & 0xff,
  (value >> 24) & 0xff,
];

double expDecay(int i, int n, double tau) => exp(-i / (tau * n));

double sine(int i, double freq) => sin(2 * pi * freq * i / rate);

List<double> kick() {
  final n = (rate * 0.42).round();
  return [
    for (var i = 0; i < n; i++)
      (sine(i, 148 - 108 * i / n) * expDecay(i, n, 0.22) +
          sine(i, 1800) * expDecay(i, n, 0.018) * 0.35) *
      0.95,
  ];
}

List<double> snare(Random rng) {
  final n = (rate * 0.28).round();
  return [
    for (var i = 0; i < n; i++)
      sine(i, 196) * expDecay(i, n, 0.16) * 0.45 +
          (rng.nextDouble() * 2 - 1) * expDecay(i, n, 0.12) * 0.7,
  ];
}

List<double> hat(Random rng) {
  final n = (rate * 0.09).round();
  var prev = 0.0;
  return [
    for (var i = 0; i < n; i++)
      () {
        final white = rng.nextDouble() * 2 - 1;
        final hp = white - prev;
        prev = white;
        return hp * expDecay(i, n, 0.14) * 0.55;
      }(),
  ];
}

List<double> tom(double startHz, double endHz, double seconds) {
  final n = (rate * seconds).round();
  return [
    for (var i = 0; i < n; i++)
      sine(i, startHz + (endHz - startHz) * i / n) * expDecay(i, n, 0.28) * 0.85,
  ];
}

List<double> crash(Random rng) {
  final n = (rate * 1.15).round();
  var prev = 0.0;
  return [
    for (var i = 0; i < n; i++)
      () {
        final white = rng.nextDouble() * 2 - 1;
        final hp = white - 0.65 * prev;
        prev = white;
        final metal = sine(i, 740) * 0.08 + sine(i, 1180) * 0.06;
        return (hp * 0.7 + metal) * expDecay(i, n, 0.38) * 0.5;
      }(),
  ];
}
