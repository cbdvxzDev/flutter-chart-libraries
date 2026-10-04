// Básica 42 · Línea de tendencia con estadísticas
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget b42TendenciaEstadisticas() => FcView(build: (d) {
      final a = d.lowestIndex(d.last - 80, d.last - 40);
      final b = d.last - 8;
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL],
          marginTop: 0.15,
          graphs: [
            fcCandles(
              ratio: 0.6,
              markers: [
                // La librería calcula sola el ángulo, el cambio de precio y
                // cuántas barras abarca la línea.
                GStatsLineMarker(
                  startCoord: at(a, d.l[a]),
                  endCoord: at(b, d.c[b]),
                  endRay: true,
                  // Dónde va el recuadro de cifras (0 = inicio, 1 = final).
                  statsBoxPosition: 0.5,
                  fillStyle: GStatsLineFillStyle.triangle,
                  theme: fcMk(
                    stroke: fcBlue,
                    fill: fcBlue.withValues(alpha: 0.10),
                    w: 1.6,
                    text: fcInk,
                    labelBg: Colors.white,
                    labelBorder: fcBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ], barWidth: 6, endSpace: 14);
    });
