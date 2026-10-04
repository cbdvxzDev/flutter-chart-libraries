// Avanzada 05 · Bollinger con %B y ancho de banda
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';
import '../panels.dart';

Widget a05BollingerBAncho() => FcView(build: (d) {
      final bb = bollinger(d.c);
      d.add('bbM', bb.mid, label: 'Media 20');
      d.add('bbU', bb.up, label: 'Banda superior');
      d.add('bbL', bb.lo, label: 'Banda inferior');
      // %B: posición del cierre dentro de la banda (0 = abajo, 1 = arriba).
      d.add(
        'pctB',
        [for (var i = 0; i < d.n; i++) (d.c[i] - bb.lo[i]) / (bb.up[i] - bb.lo[i])],
        label: '%B',
      );
      // Ancho: distancia entre bandas como porcentaje de la media.
      d.add(
        'ancho',
        [for (var i = 0; i < d.n; i++) 100 * (bb.up[i] - bb.lo[i]) / bb.mid[i]],
        label: 'Ancho (%)',
      );
      return fcChart(d, [
        fcPricePanel(
          d,
          weight: 0.5,
          scale: const ['bbU', 'bbL'],
          under: [
            fcArea('bbU', fcBlue, baseKey: 'bbL', alpha: 0.10, w: 1),
            fcLine('bbM', fcBlue, w: 1),
          ],
          tip: const ['bbU', 'bbL'],
        ),
        fcPanel(
          weight: 0.25,
          timeAxis: false,
          scale: ['pctB'],
          graphs: [
            fcArea(
              'pctB',
              fcUp,
              base: 0.5,
              below: fcDown,
              w: 1.4,
              markers: [
                fcHLine(1, fcDown, dash: const [5, 4]),
                fcHLine(0, fcUp, dash: const [5, 4]),
                fcPanelTitle('%B'),
              ],
            ),
          ],
          tooltip: fcTip(['pctB'], position: GTooltipPosition.topLeft),
        ),
        fcPanel(
          weight: 0.25,
          scale: ['ancho'],
          min: 0,
          marginBottom: 0,
          graphs: [
            fcArea('ancho', fcPurple, alpha: 0.18, w: 1.6, markers: [fcPanelTitle('Ancho de banda (%)')]),
          ],
          tooltip: fcTip(['ancho'], position: GTooltipPosition.topLeft),
        ),
      ]);
    });
