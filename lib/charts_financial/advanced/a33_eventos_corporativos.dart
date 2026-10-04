// Avanzada 33 · Eventos corporativos sobre el precio
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';
import '../panels.dart';

Widget a33EventosCorporativos() => FcView(build: (d) {
      final markers = <GOverlayMarker>[];
      final axisMarks = <GPointAxisMarker>[];
      var quarter = 1;
      // Un evento cada ~32 barras: se alternan resultados y dividendos.
      for (var i = d.last - 6; i > 20; i -= 32) {
        final earnings = quarter.isOdd;
        final color = earnings ? fcIndigo : fcTeal;
        final move = 100 * (d.c[i] / d.c[i - 1] - 1);
        final text = earnings
            ? 'Resultados\n${move >= 0 ? '+' : ''}${move.toStringAsFixed(1)} %'
            : 'Dividendo\n\$${(d.c[i] * 0.004).toStringAsFixed(2)}';
        markers
          ..add(fcVLine(i, color, dash: const [3, 4]))
          ..add(fcShape(at(i, d.h[i]), color, r: 5, align: Alignment.topCenter))
          ..add(fcCallout(text, at(i, d.h[i]), align: Alignment.topCenter, color: color));
        axisMarks.add(GPointAxisMarker.label(point: i));
        quarter++;
      }
      return fcChart(d, [
        fcPricePanel(d, weight: 0.74, markers: markers),
        fcPanel(
          weight: 0.26,
          scale: [kV],
          min: 0,
          marginBottom: 0,
          precision: 0,
          timeMarkers: axisMarks,
          graphs: [
            fcBars(kV, up: fcGrey.withValues(alpha: 0.6), markers: [fcPanelTitle('Volumen')]),
          ],
        ),
      ], endSpace: 6);
    });
