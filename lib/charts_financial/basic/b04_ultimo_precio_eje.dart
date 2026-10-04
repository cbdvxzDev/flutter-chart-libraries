// Básica 04 · Último precio marcado en los ejes
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget b04UltimoPrecioEje() => FcView(build: (d) {
      final last = d.c[d.last];
      // Rango de las últimas 20 barras, para sombrearlo en los dos ejes.
      final from = d.last - 20;
      final hi = d.h[d.highestIndex(from)];
      final lo = d.l[d.lowestIndex(from)];
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL],
          valueMarkers: [
            GValueAxisMarker.range(startValue: lo, endValue: hi),
            GValueAxisMarker.label(labelValue: last),
          ],
          timeMarkers: [
            GPointAxisMarker.range(startPoint: from.toDouble(), endPoint: d.last.toDouble()),
            GPointAxisMarker.label(point: d.last),
          ],
          graphs: [
            fcCandles(
              markers: [
                fcHLine(last, fcBlue, dash: const [4, 4]),
                fcLabel('Último', atValue(0.01, last), align: Alignment.topRight, color: fcBlue),
              ],
            ),
          ],
        ),
      ], endSpace: 8);
    });
