// Básica 39 · Abanico de Fibonacci
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget b39FibonacciAbanico() => FcView(build: (d) {
      final from = d.last - 100;
      final lo = d.lowestIndex(from, d.last - 40);
      final hi = d.highestIndex(lo);
      // Si el máximo coincide con el mínimo no hay movimiento que medir.
      final end = hi > lo ? hi : d.last;
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL],
          graphs: [
            fcCandles(
              ratio: 0.6,
              markers: [
                // Rayos que salen del mínimo y cortan el movimiento en las
                // proporciones de Fibonacci.
                GFibResistanceFanMarker(
                  startCoord: at(lo, d.l[lo]),
                  endCoord: at(end, d.h[end]),
                  showPointLevelLines: false,
                  showPointLevelStartLabels: false,
                  showPointLevelEndLabels: false,
                  theme: fcMk(stroke: fcPurple, w: 1, text: fcPurple, size: 10),
                ),
              ],
            ),
          ],
        ),
      ], barWidth: 6, endSpace: 12);
    });
