// Básica 33 · MFI (Money Flow Index)
import 'package:flutter/material.dart';

import '../common.dart';

Widget b33Mfi() => FcView(build: (d) {
      d.add('mfi', mfi(d.h, d.l, d.c, d.v), label: 'MFI 14');
      return fcChart(d, [
        fcPanel(
          scale: ['mfi'],
          min: 0,
          max: 100,
          precision: 0,
          graphs: [
            fcArea(
              'mfi',
              fcTeal,
              base: 50,
              below: fcPink,
              alpha: 0.14,
              w: 1.8,
              markers: [
                // Como un RSI, pero cada movimiento pesa según su volumen.
                fcHBand(80, 100, fcDown, alpha: 0.10),
                fcHBand(0, 20, fcUp, alpha: 0.10),
                fcHLine(80, fcDown, dash: const [5, 4]),
                fcHLine(20, fcUp, dash: const [5, 4]),
              ],
            ),
          ],
          tooltip: fcTip(['mfi']),
        ),
      ]);
    });
