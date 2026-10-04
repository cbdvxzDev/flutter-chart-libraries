// Básica 38 · Retroceso de Fibonacci
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget b38FibonacciRetroceso() => FcView(build: (d) {
      // Se mide el último gran movimiento: del mínimo al máximo de las últimas
      // 90 barras (en el orden en que ocurrieron).
      final from = d.last - 90;
      final lo = d.lowestIndex(from);
      final hi = d.highestIndex(from);
      final first = lo < hi ? at(lo, d.l[lo]) : at(hi, d.h[hi]);
      final second = lo < hi ? at(hi, d.h[hi]) : at(lo, d.l[lo]);
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL],
          graphs: [
            fcCandles(
              ratio: 0.6,
              markers: [
                GFibRetracementMarker(
                  startCoord: first,
                  endCoord: second,
                  endRay: true,
                  fibLevels: const [0.0, 0.236, 0.382, 0.5, 0.618, 0.786, 1.0],
                  theme: fcMk(stroke: fcOrange, w: 1, text: fcOrange, size: 10),
                ),
                fcArrow(first, second, fcIndigo),
              ],
            ),
          ],
        ),
      ], barWidth: 6, endSpace: 10);
    });
