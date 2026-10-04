// Básica 36 · Drawdown (curva bajo el agua)
import 'package:flutter/material.dart';

import '../common.dart';

Widget b36Drawdown() => FcView(build: (d) {
      final dd = drawdown(d.c);
      d.add('dd', dd, label: 'Caída desde el máximo (%)');
      // La peor caída del periodo.
      var worst = 0;
      for (var i = 0; i < d.n; i++) {
        if (dd[i] < dd[worst]) worst = i;
      }
      return fcChart(d, [
        fcPanel(
          scale: ['dd'],
          max: 0,
          marginTop: 0,
          marginBottom: 0.15,
          valueFormatter: (v, p) => '${v.toStringAsFixed(0)} %',
          graphs: [
            fcArea(
              'dd',
              fcDown,
              base: 0,
              alpha: 0.30,
              w: 1.6,
              markers: [
                fcShape(at(worst, dd[worst]), fcDown, r: 4),
                fcCallout(
                  'Peor caída: ${dd[worst].toStringAsFixed(1)} %',
                  at(worst, dd[worst]),
                  align: Alignment.bottomCenter,
                  color: fcDown,
                ),
              ],
            ),
          ],
          tooltip: fcTip(['dd'], follow: 'dd'),
        ),
      ]);
    });
