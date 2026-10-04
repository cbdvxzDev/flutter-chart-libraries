// Básica 02 · Velas huecas
import 'package:flutter/material.dart';

import '../common.dart';

Widget b02VelasHuecas() => FcView(build: (d) {
      // Las velas alcistas solo llevan borde; las bajistas van rellenas.
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL],
          graphs: [fcCandles(hollow: true, up: fcInk, down: fcInk, ratio: 0.75)],
          tooltip: fcTip(fcOhlc, follow: kC),
        ),
      ], barWidth: 10);
    });
