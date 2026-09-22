import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/audio/audioplayers_drum_sound_repository.dart';
import '../../data/grooves/static_groove_repository.dart';
import '../../data/scheduling/dart_task_scheduler.dart';
import '../../domain/entities/groove.dart';
import '../../domain/repositories/drum_sound_repository.dart';
import '../../domain/repositories/groove_repository.dart';
import '../../domain/services/task_scheduler.dart';
import '../../domain/usecases/play_drum_hit.dart';
import '../../domain/usecases/prepare_drum_kit.dart';
import 'kit_controller.dart';
import 'kit_state.dart';

final drumSoundRepositoryProvider = Provider<DrumSoundRepository>((ref) {
  final repository = AudioplayersDrumSoundRepository();
  ref.onDispose(repository.dispose);
  return repository;
});

final grooveRepositoryProvider = Provider<GrooveRepository>(
  (ref) => const StaticGrooveRepository(),
);

final taskSchedulerProvider = Provider<TaskScheduler>(
  (ref) => DartTaskScheduler(),
);

final playDrumHitProvider = Provider<PlayDrumHit>(
  (ref) => PlayDrumHit(ref.watch(drumSoundRepositoryProvider)),
);

final prepareDrumKitProvider = Provider<PrepareDrumKit>(
  (ref) => PrepareDrumKit(ref.watch(drumSoundRepositoryProvider)),
);

final demoGrooveProvider = Provider<Groove>(
  (ref) => ref.watch(grooveRepositoryProvider).demoGroove(),
);

final kitControllerProvider = NotifierProvider<KitController, KitState>(
  KitController.new,
);
