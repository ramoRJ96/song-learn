import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      backgroundColor: const Color(0xFF101418),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                state.ready
                    ? 'Touche un fût ou une cymbale. Le groove allume les pièces.'
                    : 'Préparation du kit…',
                style: const TextStyle(color: Color(0xFF8B95A5), fontSize: 13),
              ),
            ),
          ),
          Expanded(
            child: KitView(
              lit: state.lit,
              onHit: controller.hit,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 14),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2430),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Text(
        'Prêt à jouer ?  Apprendre une vraie chanson',
        style: TextStyle(color: Color(0xFFE8A23C), fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
