// Básica 34 · Awesome Oscillator
import 'package:flutter/material.dart';

import '../common.dart';

Widget b34Awesome() => FcView(build: (d) {
      final ao = nz(awesome(d.h, d.l));
      // Verde si la barra es mayor que la anterior, roja si es menor: el color
      // indica aceleración, no si está por encima o por debajo de cero.
      d.add('aoUp', [for (var i = 0; i < d.n; i++) (i > 0 && ao[i] >= ao[i - 1]) ? ao[i] : 0.0],
          label: 'AO acelerando');
      d.add('aoDn', [for (var i = 0; i < d.n; i++) (i > 0 && ao[i] < ao[i - 1]) ? ao[i] : 0.0],
          label: 'AO frenando');
      return fcChart(d, [
        fcPanel(
          scale: ['aoUp', 'aoDn'],
          graphs: [
            fcBars('aoUp', up: fcUp, down: fcUp, base: 0, ratio: 0.8),
            fcBars('aoDn', up: fcDown, down: fcDown, base: 0, ratio: 0.8, markers: [fcHLine(0, fcGrey)]),
          ],
          tooltip: fcTip(['aoUp', 'aoDn']),
        ),
      ], barWidth: 10);
    });
