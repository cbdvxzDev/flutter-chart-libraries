// Básica 40 · Arcos de Fibonacci
import 'dart:math' as math;

import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget b40FibonacciArcos() => FcView(build: (d) {
      final from = d.last - 90;
      final hi = d.highestIndex(from, d.last - 30);
      final lo = d.lowestIndex(from, hi > from ? hi : d.last);
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL],
          graphs: [
            fcCandles(
              ratio: 0.6,
              markers: [
                // Semicírculos con centro en el máximo; el radio completo llega
                // hasta el mínimo anterior.
                GFibArcMarker(
                  startCoord: at(hi, d.h[hi]),
                  endCoord: at(lo, d.l[lo]),
                  startTheta: 0,
                  endTheta: math.pi,
                  fibLevels: const [0.382, 0.5, 0.618, 1.0],
                  theme: fcMk(stroke: fcTeal, w: 1.2, text: fcTeal, size: 10),
                ),
                fcPath([at(lo, d.l[lo]), at(hi, d.h[hi])], fcGrey, dash: const [4, 4]),
              ],
            ),
          ],
        ),
      ], barWidth: 6, endSpace: 10);
    });
