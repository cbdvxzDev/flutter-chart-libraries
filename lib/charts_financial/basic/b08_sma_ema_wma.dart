// Básica 08 · SMA, EMA y WMA con el mismo periodo
import 'package:flutter/material.dart';

import '../common.dart';

Widget b08SmaEmaWma() => FcView(build: (d) {
      // Mismo periodo, tres formas de promediar: se ve cuál reacciona antes.
      d.add('sma', sma(d.c, 30), label: 'SMA 30');
      d.add('ema', ema(d.c, 30), label: 'EMA 30');
      d.add('wma', wma(d.c, 30), label: 'WMA 30');
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL],
          graphs: [
            fcCandles(up: fcGrey, down: fcGrey, hollow: true, ratio: 0.6),
            fcLine('sma', fcBlue, w: 2),
            fcLine('ema', fcPink, w: 2),
            fcLine(
              'wma',
              fcTeal,
              w: 2,
              markers: fcLegend(const {'SMA 30': fcBlue, 'EMA 30': fcPink, 'WMA 30': fcTeal}),
            ),
          ],
          tooltip: fcTip([kC, 'sma', 'ema', 'wma'], follow: kC),
        ),
      ], barWidth: 10);
    });
