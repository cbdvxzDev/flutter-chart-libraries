// Básica 18 · Puntos pivote
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget b18PuntosPivote() => FcView(build: (d) {
      // Los niveles salen del máximo, mínimo y cierre del periodo anterior
      // (aquí, las 40 barras previas a las últimas 40).
      final to = d.last - 40;
      final from = to - 40;
      final hi = d.h[d.highestIndex(from, to)];
      final lo = d.l[d.lowestIndex(from, to)];
      final p = (hi + lo + d.c[to]) / 3;
      final levels = <String, (double, Color)>{
        'R2': (p + (hi - lo), fcDown),
        'R1': (2 * p - lo, fcDown),
        'P': (p, fcInk),
        'S1': (2 * p - hi, fcUp),
        'S2': (p - (hi - lo), fcUp),
      };
      // Dos series constantes para que la escala siempre incluya R2 y S2.
      d.add('r2', List<double>.filled(d.n, levels['R2']!.$1));
      d.add('s2', List<double>.filled(d.n, levels['S2']!.$1));
      final markers = <GOverlayMarker>[
        fcVBand(from, to, fcGrey, alpha: 0.10),
        for (final e in levels.entries) ...[
          fcHLine(e.value.$1, e.value.$2, dash: e.key == 'P' ? null : const [6, 4]),
          fcLabel(
            '${e.key}  ${e.value.$1.toStringAsFixed(2)}',
            atValue(0.01, e.value.$1),
            align: Alignment.topRight,
            color: e.value.$2,
            weight: FontWeight.w700,
          ),
        ],
      ];
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL, 'r2', 's2'],
          graphs: [fcCandles(markers: markers)],
        ),
      ], barWidth: 6);
    });
