// Avanzada 02 · Velas, RSI y MACD en tres paneles
import 'package:flutter/material.dart';

import '../common.dart';
import '../panels.dart';

Widget a02VelasRsiMacd() => FcView(build: (d) {
      d.add('s20', sma(d.c, 20), label: 'SMA 20');
      return fcChart(d, [
        fcPricePanel(d, weight: 0.5, over: [fcLine('s20', fcOrange, w: 1.6)], tip: const ['s20']),
        fcRsiPanel(d, weight: 0.25, markers: [fcPanelTitle('RSI 14')]),
        fcMacdPanel(d, weight: 0.25, timeAxis: true),
      ]);
    });
