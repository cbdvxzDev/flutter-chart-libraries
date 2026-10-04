// Básica 26 · MACD
import 'package:flutter/material.dart';

import '../common.dart';

Widget b26Macd() => FcView(build: (d) {
      final m = macd(d.c);
      d.add('macd', m.line, label: 'MACD');
      d.add('sig', m.signal, label: 'Señal');
      d.add('hist', nz(m.hist), label: 'Histograma');
      return fcChart(d, [
        fcPanel(
          scale: ['macd', 'sig', 'hist'],
          graphs: [
            // El histograma es la distancia entre el MACD y su señal.
            fcBars('hist', up: fcUp.withValues(alpha: 0.7), down: fcDown.withValues(alpha: 0.7), base: 0),
            fcLine('sig', fcOrange, w: 1.6),
            fcLine(
              'macd',
              fcBlue,
              w: 1.6,
              markers: [
                fcHLine(0, fcGrey),
                ...fcLegend(const {'MACD (12, 26)': fcBlue, 'Señal (9)': fcOrange}),
              ],
            ),
          ],
          tooltip: fcTip(['macd', 'sig', 'hist']),
        ),
      ]);
    });
