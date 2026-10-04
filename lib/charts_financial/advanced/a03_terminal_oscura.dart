// Avanzada 03 · Terminal de trading en tema oscuro
import 'package:flutter/material.dart';

import '../common.dart';
import '../panels.dart';

Widget a03TerminalOscura() => FcView(
      n: 320,
      build: (d) {
        final bb = bollinger(d.c);
        d.add('bbM', bb.mid, label: 'Media 20');
        d.add('bbU', bb.up, label: 'Banda superior');
        d.add('bbL', bb.lo, label: 'Banda inferior');
        // Cuatro paneles apilados que comparten el mismo eje de tiempo.
        return fcChart(
          d,
          [
            fcPricePanel(
              d,
              weight: 0.46,
              scale: const ['bbU', 'bbL'],
              under: [
                fcArea('bbU', fcBlue, baseKey: 'bbL', alpha: 0.12, w: 1),
                fcLine('bbM', fcBlue, w: 1),
              ],
              tip: const ['bbU', 'bbL'],
            ),
            fcVolumePanel(d, weight: 0.16),
            fcRsiPanel(d, weight: 0.18),
            fcMacdPanel(d, weight: 0.20, timeAxis: true),
          ],
          dark: true,
          barWidth: 7,
        );
      },
    );
