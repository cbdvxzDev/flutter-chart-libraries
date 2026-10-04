// Básica 24 · RSI con zonas
import 'package:flutter/material.dart';

import '../common.dart';

Widget b24Rsi() => FcView(build: (d) {
      d.add('rsi', rsi(d.c), label: 'RSI 14');
      return fcChart(d, [
        fcPanel(
          scale: ['rsi'],
          min: 0,
          max: 100,
          graphs: [
            fcLine(
              'rsi',
              fcPurple,
              w: 1.8,
              markers: [
                // Zona de sobrecompra (arriba) y de sobreventa (abajo).
                fcHBand(70, 100, fcDown),
                fcHBand(0, 30, fcUp),
                fcHLine(70, fcDown, dash: const [5, 4]),
                fcHLine(30, fcUp, dash: const [5, 4]),
                fcHLine(50, fcGrey, dash: const [2, 4]),
                fcLabel('Sobrecompra', atValue(0.01, 85), align: Alignment.centerRight, color: fcDown),
                fcLabel('Sobreventa', atValue(0.01, 15), align: Alignment.centerRight, color: fcUp),
              ],
            ),
          ],
          tooltip: fcTip(['rsi']),
        ),
      ]);
    });
