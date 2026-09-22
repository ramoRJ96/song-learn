import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_theme.dart';
import '../kit_providers.dart';
import 'kit_toolbar.dart';
import 'kit_view.dart';

class KitPage extends ConsumerWidget {
  const KitPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(kitControllerProvider);
    final controller = ref.read(kitControllerProvider.notifier);

    return Scaffold(
      backgroundColor: StitchColors.bg,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: KitToolbar(
              state: state,
              onToggleGroove: controller.toggleGroove,
              onBpmChanged: controller.setBpm,
            ),
          ),
          Expanded(
            child: KitView(
              lit: state.lit,
              onHit: controller.hit,
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 18),
            child: _SoonChip(),
          ),
        ],
      ),
    );
  }
}

class _SoonChip extends StatelessWidget {
  const _SoonChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      decoration: BoxDecoration(
        color: StitchColors.pill,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x33E8A23C)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_circle_fill_rounded, size: 16, color: StitchColors.amber),
          SizedBox(width: 8),
          Text(
            'Prêt à jouer ?  Apprendre une vraie chanson',
            style: TextStyle(
              color: StitchColors.amber,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 6),
          Icon(Icons.arrow_forward_rounded, size: 14, color: StitchColors.amber),
        ],
      ),
    );
  }
}
