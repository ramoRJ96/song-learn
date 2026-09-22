import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/drum_voice.dart';
import '../../domain/entities/groove.dart';
import '../../domain/usecases/run_groove.dart';
import 'kit_providers.dart';
import 'kit_state.dart';

class KitController extends Notifier<KitState> {
  late final Groove _groove;
  late final RunGroove _runGroove;

  @override
  KitState build() {
    _groove = ref.read(demoGrooveProvider);
    _runGroove = RunGroove(
      sounds: ref.read(drumSoundRepositoryProvider),
      scheduler: ref.read(taskSchedulerProvider),
      onLitChanged: (lit) => state = state.copyWith(grooveLit: lit),
    );
    ref.onDispose(_runGroove.stop);
    Future.microtask(prepare);
    return KitState.initial(bpm: _groove.bpm, grooveTitle: _groove.title);
  }

  Future<void> prepare() async {
    try {
      await ref.read(prepareDrumKitProvider)();
    } catch (_) {
      // Les tests et le premier hit recréent les lecteurs si besoin.
    }
    state = state.copyWith(ready: true);
  }

  Future<void> hit(DrumVoice voice) async {
    state = state.copyWith(manualLit: {...state.manualLit, voice});
    await ref.read(playDrumHitProvider)(voice);
    ref.read(taskSchedulerProvider).schedule(const Duration(milliseconds: 120), () {
      state = state.copyWith(manualLit: {...state.manualLit}..remove(voice));
    });
  }

  void toggleGroove() {
    if (state.playing) {
      _runGroove.stop();
      state = state.copyWith(playing: false, grooveLit: const {});
      return;
    }
    _runGroove.start(_groove, state.bpm);
    state = state.copyWith(playing: true);
  }

  void setBpm(int value) {
    final bpm = _groove.clampBpm(value);
    state = state.copyWith(bpm: bpm);
    _runGroove.restartIfPlaying(bpm);
  }
}
