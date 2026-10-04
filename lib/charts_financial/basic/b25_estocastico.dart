// Básica 25 · Oscilador estocástico
import 'package:flutter/material.dart';

import '../common.dart';

Widget b25Estocastico() => FcView(build: (d) {
      final st = stochastic(d.h, d.l, d.c);
      d.add('k', st.k, label: '%K');
      d.add('dd', st.d, label: '%D');
      return fcChart(d, [
        fcPanel(
          scale: ['k', 'dd'],
          min: 0,
          max: 100,
          graphs: [
            fcLine('dd', fcOrange, w: 1.6),
            fcLine(
              'k',
              fcBlue,
              w: 1.6,
              markers: [
                fcHBand(80, 100, fcDown, alpha: 0.10),
                fcHBand(0, 20, fcUp, alpha: 0.10),
                fcHLine(80, fcDown, dash: const [5, 4]),
                fcHLine(20, fcUp, dash: const [5, 4]),
                ...fcLegend(const {'%K (rápida)': fcBlue, '%D (señal)': fcOrange}),
              ],
            ),
          ],
          tooltip: fcTip(['k', 'dd']),
        ),
      ]);
    });
