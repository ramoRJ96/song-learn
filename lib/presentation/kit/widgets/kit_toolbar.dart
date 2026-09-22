import 'package:flutter/material.dart';

import '../../../domain/entities/groove.dart';
import '../../theme/app_theme.dart';
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
    return ColoredBox(
      color: StitchColors.bg,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 1100;
          final showNav = constraints.maxWidth >= 900;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 16, 6),
                child: SizedBox(
                  height: 44,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        children: [
                          _Wordmark(showSubtitle: wide),
                          const Spacer(),
                          if (wide) const _IoStatus(),
                          if (wide) const SizedBox(width: 12),
                          const _Avatar(),
                        ],
                      ),
                      if (showNav) const _NavPills(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 16, 10),
                child: Row(
                  children: [
                    _GrooveButton(
                      ready: state.ready,
                      playing: state.playing,
                      onPressed: onToggleGroove,
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      'TEMPO',
                      style: TextStyle(
                        color: StitchColors.muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Flexible(
                      child: Slider(
                        value: state.bpm.toDouble(),
                        min: Groove.minBpm.toDouble(),
                        max: Groove.maxBpm.toDouble(),
                        divisions: 20,
                        activeColor: StitchColors.amber,
                        inactiveColor: const Color(0xFF2A3140),
                        onChanged: state.ready ? (value) => onBpmChanged(value.round()) : null,
                      ),
                    ),
                    _BpmChip(bpm: state.bpm),
                    if (wide) ...[
                      const SizedBox(width: 16),
                      Flexible(
                        flex: 2,
                        child: Text(
                          state.ready
                              ? 'Touche un fût ou une cymbale. Le groove allume les pièces.'
                              : 'Préparation du kit…',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: StitchColors.muted, fontSize: 13),
                        ),
                      ),
                      const _ReadyBadge(),
                      const SizedBox(width: 10),
                      const Text(
                        'Studio Birch Master',
                        style: TextStyle(
                          color: StitchColors.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Divider(height: 1, color: StitchColors.line),
            ],
          );
        },
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.showSubtitle});

  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Song Learn',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontStyle: FontStyle.italic,
            letterSpacing: -0.3,
          ),
        ),
        if (showSubtitle) ...[
          const SizedBox(width: 10),
          const Text(
            'MOTEUR ACOUSTIQUE INITÉ',
            style: TextStyle(
              color: StitchColors.muted,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ],
    );
  }
}

class _NavPills extends StatelessWidget {
  const _NavPills();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: StitchColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: StitchColors.line),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _NavChip(label: 'Kit de Pratique', active: true),
          _NavChip(label: 'Pratique sur Morceau'),
          _NavChip(label: 'Importer'),
        ],
      ),
    );
  }
}

class _NavChip extends StatelessWidget {
  const _NavChip({required this.label, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? StitchColors.chip : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          color: active ? StitchColors.white : StitchColors.muted,
        ),
      ),
    );
  }
}

class _GrooveButton extends StatelessWidget {
  const _GrooveButton({
    required this.ready,
    required this.playing,
    required this.onPressed,
  });

  final bool ready;
  final bool playing;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: ready ? onPressed : null,
      style: FilledButton.styleFrom(
        backgroundColor: StitchColors.amber,
        foregroundColor: StitchColors.amberOn,
        disabledBackgroundColor: StitchColors.amber.withValues(alpha: 0.35),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: const StadiumBorder(),
        visualDensity: VisualDensity.compact,
      ),
      icon: Icon(playing ? Icons.stop_rounded : Icons.play_arrow_rounded, size: 18),
      label: Text(
        playing ? 'Stop' : 'Groove Rock',
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      ),
    );
  }
}

class _BpmChip extends StatelessWidget {
  const _BpmChip({required this.bpm});

  final int bpm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: StitchColors.pill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: StitchColors.line),
      ),
      child: Text(
        '$bpm BPM',
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}

class _IoStatus extends StatelessWidget {
  const _IoStatus();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StatusDot(label: 'MIDI IN'),
        SizedBox(width: 10),
        _StatusDot(label: 'USB Audio In'),
      ],
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(color: StitchColors.amber, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: StitchColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: StitchColors.amber, width: 1.4),
        color: const Color(0xFF2A2418),
      ),
      child: const Icon(Icons.person_rounded, size: 18, color: StitchColors.amber),
    );
  }
}

class _ReadyBadge extends StatelessWidget {
  const _ReadyBadge();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.sensors, size: 14, color: StitchColors.amber),
        SizedBox(width: 6),
        Text(
          'Capteurs connectés (3 ms)',
          style: TextStyle(color: StitchColors.muted, fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
