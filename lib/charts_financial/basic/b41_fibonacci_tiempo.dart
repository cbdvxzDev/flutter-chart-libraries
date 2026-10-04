// Básica 41 · Zonas temporales de Fibonacci
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget b41FibonacciTiempo() => FcView(build: (d) {
      // Líneas verticales a 1, 2, 3, 5, 8, 13, 21... unidades del punto de
      // partida. La unidad aquí son 3 barras.
      final start = d.lowestIndex(d.last - 100, d.last - 60);
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL],
          graphs: [
            fcCandles(
              ratio: 0.6,
              markers: [
                GFibTimeZoneMarker(
                  startCoord: at(start, d.l[start]),
                  endCoord: at(start + 3, d.l[start]),
                  labelPosition: 0.04,
                  theme: fcMk(stroke: fcIndigo, w: 1, text: fcIndigo, size: 10, dash: const [4, 3]),
                ),
                fcShape(at(start, d.l[start]), fcIndigo, r: 5),
              ],
            ),
          ],
        ),
      ], barWidth: 6);
    });
