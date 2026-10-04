// Básica 43 · Soportes y resistencias
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget b43SoportesResistencias() => FcView(build: (d) {
      // Los últimos giros del ZigZag marcan las zonas: los máximos son
      // resistencias y los mínimos, soportes.
      final pivots = zigzag(d.h, d.l, pct: 0.05);
      final recent = pivots.length > 6 ? pivots.sublist(pivots.length - 6) : pivots;
      final markers = <GOverlayMarker>[];
      for (final p in recent) {
        final color = p.high ? fcDown : fcUp;
        final half = p.v * 0.006; // la zona abarca ±0,6 % del nivel
        markers
          ..add(fcHBand(p.v - half, p.v + half, color, alpha: 0.16))
          ..add(fcShape(at(p.i, p.v), color, r: 4))
          ..add(
            fcLabel(
              '${p.high ? 'Resistencia' : 'Soporte'} ${p.v.toStringAsFixed(1)}',
              atValue(0.01, p.v),
              align: Alignment.centerRight,
              color: color,
              size: 10,
              weight: FontWeight.w700,
            ),
          );
      }
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL],
          graphs: [fcCandles(up: fcGrey, down: fcGrey, ratio: 0.55, markers: markers)],
        ),
      ]);
    });
