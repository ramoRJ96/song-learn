import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../domain/entities/drum_voice.dart';
import '../../../domain/entities/kit_layout.dart';
import 'kit_painter.dart';

class KitView extends StatelessWidget {
  const KitView({
    super.key,
    required this.lit,
    required this.onHit,
  });

  final Set<DrumVoice> lit;
  final ValueChanged<DrumVoice> onHit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final layout = buildKitLayout(size);
        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (event) {
            final voice = hitTestKit(layout.pieces, event.localPosition);
            if (voice == null) return;
            HapticFeedback.mediumImpact();
            onHit(voice);
          },
          child: Stack(
            children: [
              CustomPaint(
                size: size,
                painter: KitPainter(layout: layout, lit: lit),
              ),
              for (final piece in layout.pieces)
                Positioned.fromRect(
                  rect: piece.bounds,
                  child: Semantics(
                    button: true,
                    label: piece.voice.shortLabel,
                    child: const SizedBox.expand(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
