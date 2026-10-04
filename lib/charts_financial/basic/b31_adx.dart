// Básica 31 · ADX con líneas direccionales
import 'package:flutter/material.dart';

import '../common.dart';

Widget b31Adx() => FcView(build: (d) {
      final a = adx(d.h, d.l, d.c);
      d.add('adx', a.adx, label: 'ADX');
      d.add('pdi', a.plus, label: '+DI');
      d.add('mdi', a.minus, label: '−DI');
      return fcChart(d, [
        fcPanel(
          scale: ['adx', 'pdi', 'mdi'],
          min: 0,
          marginBottom: 0,
          graphs: [
            fcLine('pdi', fcUp, w: 1.4),
            fcLine('mdi', fcDown, w: 1.4),
            fcLine(
              'adx',
              fcInk,
              w: 2.4,
              markers: [
                // Por encima de 25 se considera que hay tendencia.
                fcHLine(25, fcGrey, dash: const [5, 4]),
                fcLabel('Tendencia fuerte > 25', atValue(0.99, 25), align: Alignment.topLeft, color: fcGrey),
                ...fcLegend(const {'ADX (fuerza)': fcInk, '+DI (alcista)': fcUp, '−DI (bajista)': fcDown}),
              ],
            ),
          ],
          tooltip: fcTip(['adx', 'pdi', 'mdi']),
        ),
      ]);
    });
