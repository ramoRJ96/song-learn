import 'package:flutter/material.dart';

import '../../../domain/entities/groove.dart';
import '../kit_state.dart';

class KitHeader extends StatelessWidget {
  const KitHeader({
    super.key,
    required this.state,
    required this.onToggleGroove,
    required this.onBpmChanged,
  });

  final KitState state;
  final VoidCallback onToggleGroove;
  final ValueChanged<int> onBpmChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Song Learn',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          state.ready
              ? 'Touche un fût ou une cymbale. Le groove allume les pièces.'
              : 'Préparation du kit…',
          style: const TextStyle(color: Color(0xFF8B95A5), fontSize: 13),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            FilledButton.icon(
              onPressed: state.ready ? onToggleGroove : null,
              icon: Icon(state.playing ? Icons.stop_rounded : Icons.play_arrow_rounded),
              label: Text(state.playing ? 'Stop' : 'Groove rock'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                children: [
                  const Text('Tempo', style: TextStyle(color: Color(0xFF8B95A5))),
                  Expanded(
                    child: Slider(
                      value: state.bpm.toDouble(),
                      min: Groove.minBpm.toDouble(),
                      max: Groove.maxBpm.toDouble(),
                      divisions: 20,
                      label: '${state.bpm} BPM',
                      onChanged: state.ready ? (value) => onBpmChanged(value.round()) : null,
                    ),
                  ),
                  SizedBox(
                    width: 56,
                    child: Text(
                      '${state.bpm}',
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
