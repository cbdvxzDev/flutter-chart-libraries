// Avanzada 35 · Perfil de volumen por precio
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget a35PerfilVolumen() => FcView(build: (d) {
      // Se reparte el volumen de las últimas 120 barras en 24 franjas de
      // precio: cada barra horizontal dice cuánto se negoció a ese nivel.
      const bins = 24;
      final from = d.last - 120;
      final hi = d.h[d.highestIndex(from)];
      final lo = d.l[d.lowestIndex(from)];
      final step = (hi - lo) / bins;
      final volume = List<double>.filled(bins, 0.0);
      for (var i = from; i <= d.last; i++) {
        final typicalPrice = (d.h[i] + d.l[i] + d.c[i]) / 3;
        final raw = ((typicalPrice - lo) / step).floor();
        final bin = raw < 0 ? 0 : (raw >= bins ? bins - 1 : raw);
        volume[bin] += d.v[i];
      }
      var poc = 0; // franja con más volumen ("punto de control")
      for (var b = 0; b < bins; b++) {
        if (volume[b] > volume[poc]) poc = b;
      }
      final markers = <GOverlayMarker>[
        for (var b = 0; b < bins; b++)
          GRectMarker(
            // x va en fracción del ancho: las barras nacen en el borde derecho.
            startCoord: atValue(1 - 0.32 * volume[b] / volume[poc], lo + step * b + step * 0.08),
            endCoord: atValue(1, lo + step * (b + 1) - step * 0.08),
            theme: fcMk(fill: (b == poc ? fcOrange : fcIndigo).withValues(alpha: b == poc ? 0.75 : 0.30)),
          ),
        fcHLine(lo + step * (poc + 0.5), fcOrange, dash: const [5, 4]),
        fcLabel(
          'Punto de control ${(lo + step * (poc + 0.5)).toStringAsFixed(2)}',
          atValue(0.01, lo + step * (poc + 0.5)),
          align: Alignment.topRight,
          color: fcOrange,
          weight: FontWeight.w700,
        ),
      ];
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL],
          graphs: [fcCandles(ratio: 0.6, markers: markers)],
          tooltip: fcTip(fcOhlc, follow: kC),
        ),
      ], barWidth: 6);
    });
