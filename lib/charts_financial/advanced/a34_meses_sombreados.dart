// Avanzada 34 · Meses sombreados y rendimiento de cada uno
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget a34MesesSombreados() => FcView(build: (d) {
      const names = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
      final markers = <GOverlayMarker>[];
      // Se recorre la serie buscando dónde cambia el mes.
      var start = 0;
      for (var i = 1; i <= d.n; i++) {
        final month = DateTime.fromMillisecondsSinceEpoch(d.t[start]).month;
        final ended = i == d.n || DateTime.fromMillisecondsSinceEpoch(d.t[i]).month != month;
        if (!ended) continue;
        final end = i - 1;
        final ret = 100 * (d.c[end] / d.o[start] - 1);
        final color = ret >= 0 ? fcUp : fcDown;
        // Franja del color del resultado del mes, y su cifra arriba.
        markers
          ..add(fcVBand(start - 0.5, end + 0.5, color, alpha: 0.10))
          ..add(
            fcLabel(
              '${names[month - 1]}\n${ret >= 0 ? '+' : ''}${ret.toStringAsFixed(1)} %',
              atPoint((start + end) / 2, 0.02),
              align: Alignment.bottomCenter,
              color: color,
              size: 10,
              weight: FontWeight.w700,
            ),
          );
        start = i;
      }
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL],
          marginTop: 0.20,
          timeFormatter: fcFecha,
          graphs: [fcCandles(ratio: 0.6, markers: markers)],
          tooltip: fcTip(fcOhlc, follow: kC),
        ),
      ], barWidth: 6);
    });
