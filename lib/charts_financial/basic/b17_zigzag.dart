// Básica 17 · ZigZag de máximos y mínimos
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget b17Zigzag() => FcView(build: (d) {
      // Solo quedan los giros de al menos un 6 %: el ruido desaparece.
      final pivots = zigzag(d.h, d.l);
      final markers = <GOverlayMarker>[
        if (pivots.length >= 2) fcPath([for (final p in pivots) at(p.i, p.v)], fcBlue, w: 2),
        for (final p in pivots)
          fcLabel(
            p.v.toStringAsFixed(1),
            at(p.i, p.v),
            align: p.high ? Alignment.topCenter : Alignment.bottomCenter,
            color: p.high ? fcDown : fcUp,
            size: 10,
            weight: FontWeight.w700,
          ),
      ];
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL],
          marginTop: 0.12,
          marginBottom: 0.12,
          graphs: [fcCandles(up: fcGrey, down: fcGrey, ratio: 0.5, markers: markers)],
        ),
      ]);
    });
