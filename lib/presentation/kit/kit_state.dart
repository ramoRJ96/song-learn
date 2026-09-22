import '../../domain/entities/drum_voice.dart';

class KitState {
  const KitState({
    required this.ready,
    required this.playing,
    required this.bpm,
    required this.manualLit,
    required this.grooveLit,
    required this.grooveTitle,
  });

  factory KitState.initial({required int bpm, required String grooveTitle}) {
    return KitState(
      ready: false,
      playing: false,
      bpm: bpm,
      manualLit: const {},
      grooveLit: const {},
      grooveTitle: grooveTitle,
    );
  }

  final bool ready;
  final bool playing;
  final int bpm;
  final Set<DrumVoice> manualLit;
  final Set<DrumVoice> grooveLit;
  final String grooveTitle;

  Set<DrumVoice> get lit => {...manualLit, ...grooveLit};

  bool isLit(DrumVoice voice) => lit.contains(voice);

  KitState copyWith({
    bool? ready,
    bool? playing,
    int? bpm,
    Set<DrumVoice>? manualLit,
    Set<DrumVoice>? grooveLit,
    String? grooveTitle,
  }) {
    return KitState(
      ready: ready ?? this.ready,
      playing: playing ?? this.playing,
      bpm: bpm ?? this.bpm,
      manualLit: manualLit ?? this.manualLit,
      grooveLit: grooveLit ?? this.grooveLit,
      grooveTitle: grooveTitle ?? this.grooveTitle,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is KitState &&
        other.ready == ready &&
        other.playing == playing &&
        other.bpm == bpm &&
        other.grooveTitle == grooveTitle &&
        other.manualLit.length == manualLit.length &&
        other.manualLit.containsAll(manualLit) &&
        other.grooveLit.length == grooveLit.length &&
        other.grooveLit.containsAll(grooveLit);
  }

  @override
  int get hashCode => Object.hash(
    ready,
    playing,
    bpm,
    grooveTitle,
    Object.hashAll(manualLit),
    Object.hashAll(grooveLit),
  );
}
