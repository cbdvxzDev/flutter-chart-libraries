// Básica 23 · Chaikin Money Flow
import 'package:flutter/material.dart';

import '../common.dart';

Widget b23Chaikin() => FcView(build: (d) {
      // Las barras no aceptan NaN, por eso se rellenan con cero (nz).
      d.add('cmf', nz(cmf(d.h, d.l, d.c, d.v)), label: 'CMF 20', precision: 3);
      return fcChart(d, [
        fcPanel(
          scale: ['cmf'],
          precision: 2,
          graphs: [
            fcBars(
              'cmf',
              up: fcUp,
              down: fcDown,
              base: 0,
              ratio: 0.8,
              markers: [
                fcHLine(0.05, fcUp, dash: const [4, 4]),
                fcHLine(-0.05, fcDown, dash: const [4, 4]),
              ],
            ),
          ],
          tooltip: fcTip(['cmf']),
        ),
      ], barWidth: 10);
    });
