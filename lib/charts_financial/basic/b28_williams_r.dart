// Básica 28 · Williams %R
import 'package:flutter/material.dart';

import '../common.dart';

Widget b28WilliamsR() => FcView(build: (d) {
      d.add('wr', williamsR(d.h, d.l, d.c), label: '%R 14');
      return fcChart(d, [
        fcPanel(
          scale: ['wr'],
          min: -100,
          max: 0,
          precision: 0,
          graphs: [
            fcLine(
              'wr',
              fcIndigo,
              w: 1.8,
              markers: [
                // Escala invertida respecto al RSI: va de -100 a 0.
                fcHBand(-20, 0, fcDown),
                fcHBand(-100, -80, fcUp),
                fcHLine(-20, fcDown, dash: const [5, 4]),
                fcHLine(-80, fcUp, dash: const [5, 4]),
              ],
            ),
          ],
          tooltip: fcTip(['wr']),
        ),
      ]);
    });
