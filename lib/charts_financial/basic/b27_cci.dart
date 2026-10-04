// Básica 27 · CCI (Commodity Channel Index)
import 'package:flutter/material.dart';

import '../common.dart';

Widget b27Cci() => FcView(build: (d) {
      d.add('cci', cci(d.h, d.l, d.c), label: 'CCI 20');
      return fcChart(d, [
        fcPanel(
          scale: ['cci'],
          precision: 0,
          graphs: [
            fcArea(
              'cci',
              fcUp,
              base: 0,
              below: fcDown,
              alpha: 0.16,
              w: 1.6,
              markers: [
                // Fuera de ±100 el precio se alejó mucho de su media.
                fcHLine(100, fcDown, dash: const [5, 4]),
                fcHLine(-100, fcUp, dash: const [5, 4]),
                fcHLine(0, fcGrey),
                fcLabel('+100', atValue(0.01, 100), align: Alignment.topRight, color: fcDown),
                fcLabel('−100', atValue(0.01, -100), align: Alignment.bottomRight, color: fcUp),
              ],
            ),
          ],
          tooltip: fcTip(['cci']),
        ),
      ]);
    });
