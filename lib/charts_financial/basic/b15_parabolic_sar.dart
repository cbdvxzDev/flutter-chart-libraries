// Básica 15 · Parabolic SAR
import 'package:flutter/material.dart';

import '../common.dart';

Widget b15ParabolicSar() => FcView(build: (d) {
      d.add('sar', psar(d.h, d.l), label: 'SAR');
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL, 'sar'],
          graphs: [
            fcCandles(),
            // Solo puntos, sin línea: cuando saltan al otro lado del precio,
            // la tendencia cambió.
            fcLine('sar', fcIndigo, stroke: false, dot: 2.2),
          ],
          tooltip: fcTip([kC, 'sar'], follow: kC),
        ),
      ], barWidth: 10);
    });
