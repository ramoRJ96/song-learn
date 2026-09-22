import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:song_learn/presentation/app.dart';
import 'package:song_learn/presentation/kit/kit_providers.dart';

import 'support/fake_drum_sound_repository.dart';
import 'support/fake_task_scheduler.dart';

void main() {
  testWidgets('affiche le kit batterie', (tester) async {
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          drumSoundRepositoryProvider.overrideWithValue(FakeDrumSoundRepository()),
          taskSchedulerProvider.overrideWithValue(FakeTaskScheduler()),
        ],
        child: const SongLearnApp(),
      ),
    );
    await tester.pump();
    expect(find.text('Song Learn'), findsOneWidget);
    expect(find.text('Kit de Pratique'), findsOneWidget);
    expect(find.text('Groove Rock'), findsOneWidget);
    expect(find.bySemanticsLabel('Kick'), findsWidgets);
    expect(find.bySemanticsLabel('Snare'), findsWidgets);
  });
}
