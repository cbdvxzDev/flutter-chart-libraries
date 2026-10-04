// Avanzada 32 · Trading de pares: ratio y puntuación Z
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';
import '../panels.dart';

Widget a32ParesZscore() => FcView(
      n: 340,
      build: (d) {
        // Segundo activo: sigue al primero pero con ruido propio.
        final noise = d.walk(start: 1, vol: 0.006, drift: 0);
        final other = [for (var i = 0; i < d.n; i++) d.c[i] * 0.8 * noise[i]];
        final ratio = zip(d.c, other, (a, b) => a / b);
        final mean = sma(ratio, 40);
        final sd = stdev(ratio, 40);
        // Z: a cuántas desviaciones está el ratio de su media.
        final z = [for (var i = 0; i < d.n; i++) sd[i] == 0 ? double.nan : (ratio[i] - mean[i]) / sd[i]];
        d.add('ratio', ratio, label: 'Ratio A/B', precision: 3);
        d.add('mean', mean, label: 'Media 40', precision: 3);
        d.add('z', z, label: 'Z');
        // Señal cada vez que Z sale de la banda de ±2.
        final signals = <GOverlayMarker>[];
        for (var i = 1; i < d.n; i++) {
          if (z[i].isNaN || z[i - 1].isNaN) continue;
          if (z[i - 1] <= 2 && z[i] > 2) signals.add(fcSell(i, z[i]));
          if (z[i - 1] >= -2 && z[i] < -2) signals.add(fcBuy(i, z[i]));
        }
        return fcChart(d, [
          fcPanel(
            weight: 0.5,
            timeAxis: false,
            precision: 3,
            scale: ['ratio'],
            graphs: [
              fcLine('mean', fcOrange, w: 1.4),
              fcLine('ratio', fcBlue, w: 1.8, markers: [fcPanelTitle('Ratio de precios A / B', color: fcBlue)]),
            ],
            tooltip: fcTip(['ratio', 'mean'], follow: 'ratio'),
          ),
          fcPanel(
            weight: 0.5,
            scale: ['z'],
            min: -3.5,
            max: 3.5,
            graphs: [
              fcArea(
                'z',
                fcDown,
                base: 0,
                below: fcUp,
                alpha: 0.14,
                w: 1.6,
                markers: [
                  fcHBand(2, 3.5, fcDown, alpha: 0.10),
                  fcHBand(-3.5, -2, fcUp, alpha: 0.10),
                  fcHLine(2, fcDown, dash: const [5, 4]),
                  fcHLine(-2, fcUp, dash: const [5, 4]),
                  fcHLine(0, fcGrey),
                  fcPanelTitle('Puntuación Z · ▼ vender A / comprar B · ▲ lo contrario'),
                  ...signals,
                ],
              ),
            ],
            tooltip: fcTip(['z'], position: GTooltipPosition.bottomLeft),
          ),
        ]);
      },
    );
