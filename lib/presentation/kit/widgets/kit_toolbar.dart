import 'package:flutter/material.dart';

import '../../../domain/entities/groove.dart';
import '../kit_state.dart';

class KitToolbar extends StatelessWidget {
  const KitToolbar({
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
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xE6101418),
        border: Border(bottom: BorderSide(color: Color(0x14FFFFFF))),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showNav = constraints.maxWidth >= 1320;
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 16, 10),
            child: Row(
              children: [
                const Text(
                  'Song Learn',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                if (showNav) ...[
                  const SizedBox(width: 22),
                  const _NavItem(label: 'Kit de Pratique', active: true),
                  const SizedBox(width: 16),
                  const _NavItem(label: 'Pratique sur Morceau'),
                  const SizedBox(width: 16),
                  const _NavItem(label: 'Importer'),
                ],
                const Spacer(),
                FilledButton.icon(
                  onPressed: state.ready ? onToggleGroove : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE8A23C),
                    foregroundColor: const Color(0xFF1A1208),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: const StadiumBorder(),
                  ),
                  icon: Icon(state.playing ? Icons.stop_rounded : Icons.play_arrow_rounded, size: 18),
                  label: Text(state.playing ? 'Stop' : 'Groove Rock'),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showNav)
                        const Text(
                          'TEMPO',
                          style: TextStyle(color: Color(0xFF8B95A5), fontSize: 10, letterSpacing: 1.1),
                        ),
                      Flexible(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                          ),
                          child: Slider(
                            value: state.bpm.toDouble(),
                            min: Groove.minBpm.toDouble(),
                            max: Groove.maxBpm.toDouble(),
                            divisions: 20,
                            activeColor: const Color(0xFFE8A23C),
                            onChanged: state.ready ? (value) => onBpmChanged(value.round()) : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C2430),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${state.bpm} BPM',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.label, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: active ? Colors.white : const Color(0xFF8B95A5),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 2,
          width: active ? 28 : 0,
          decoration: BoxDecoration(
            color: const Color(0xFFE8A23C),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
