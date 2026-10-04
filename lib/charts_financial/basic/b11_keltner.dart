// Básica 11 · Canal de Keltner
import 'package:flutter/material.dart';

import '../common.dart';

Widget b11Keltner() => FcView(build: (d) {
      final k = keltner(d.h, d.l, d.c);
      d.add('kM', k.mid, label: 'EMA 20');
      d.add('kU', k.up, label: 'EMA + 2 ATR');
      d.add('kL', k.lo, label: 'EMA − 2 ATR');
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL, 'kU', 'kL'],
          graphs: [
            fcCandles(candle: false),
            fcLine('kU', fcPurple, w: 1.6),
            fcLine('kL', fcPurple, w: 1.6),
            fcLine(
              'kM',
              fcAmber,
              w: 1.6,
              markers: fcLegend(const {'EMA 20': fcAmber, 'EMA ± 2 ATR': fcPurple}),
            ),
          ],
          tooltip: fcTip([kC, 'kU', 'kM', 'kL'], follow: kC),
        ),
      ]);
    });
