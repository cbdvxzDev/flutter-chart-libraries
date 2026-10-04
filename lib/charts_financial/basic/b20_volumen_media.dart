// Básica 20 · Volumen con media y picos
import 'package:flutter/material.dart';

import '../common.dart';

Widget b20VolumenMedia() => FcView(build: (d) {
      final avg = sma(d.v, 20);
      d.add('vAvg', avg, label: 'Media 20', precision: 0);
      // Pico: volumen al menos 1,5 veces su media.
      d.add(
        'vPico',
        [for (var i = 0; i < d.n; i++) (!avg[i].isNaN && d.v[i] > 1.5 * avg[i]) ? d.v[i] : 0.0],
        label: 'Pico',
        precision: 0,
      );
      return fcChart(d, [
        fcPanel(
          scale: [kV],
          min: 0,
          marginBottom: 0,
          precision: 0,
          graphs: [
            fcBars(kV, up: fcGrey.withValues(alpha: 0.55)),
            fcBars('vPico', up: fcOrange),
            fcLine(
              'vAvg',
              fcIndigo,
              w: 2,
              markers: fcLegend(const {'Media de 20 barras': fcIndigo, 'Pico (> 1,5 × media)': fcOrange}),
            ),
          ],
          tooltip: fcTip([kV, 'vAvg']),
        ),
      ], barWidth: 10);
    });
