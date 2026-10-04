// Avanzada 28 · Divergencia entre precio y RSI
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';
import '../panels.dart';

Widget a28DivergenciaRsi() => FcView(
      n: 300,
      build: (d) {
        final r = rsi(d.c);
        // Se toman los dos últimos mínimos relevantes del precio...
        final lows = [
          for (final p in zigzag(d.h, d.l, pct: 0.05))
            if (!p.high && !r[p.i].isNaN) p,
        ];
        final priceMarks = <GOverlayMarker>[];
        final rsiMarks = <GOverlayMarker>[];
        if (lows.length >= 2) {
          final a = lows[lows.length - 2];
          final b = lows.last;
          // ...y se compara qué hizo el RSI en esas mismas dos barras.
          final lowerLow = b.v < a.v;
          final rsiHigherLow = r[b.i] > r[a.i];
          final divergence = lowerLow && rsiHigherLow;
          final color = divergence ? fcUp : fcGrey;
          final text = divergence
              ? 'Divergencia alcista: el precio marca un mínimo más bajo y el RSI no'
              : 'Sin divergencia: precio y RSI se mueven en el mismo sentido';
          priceMarks
            ..add(fcArrow(at(a.i, a.v), at(b.i, b.v), color, w: 2))
            ..add(fcShape(at(a.i, a.v), color, r: 4))
            ..add(fcLabel(text, GPositionCoord.absolute(x: 8, y: 6), align: Alignment.bottomRight, color: color, weight: FontWeight.w700));
          rsiMarks
            ..add(fcArrow(at(a.i, r[a.i]), at(b.i, r[b.i]), color, w: 2))
            ..add(fcShape(at(a.i, r[a.i]), color, r: 4))
            ..add(fcVLine(a.i, fcGrey, dash: const [3, 4]))
            ..add(fcVLine(b.i, fcGrey, dash: const [3, 4]));
          priceMarks
            ..add(fcVLine(a.i, fcGrey, dash: const [3, 4]))
            ..add(fcVLine(b.i, fcGrey, dash: const [3, 4]));
        }
        return fcChart(d, [
          fcPricePanel(d, weight: 0.6, markers: priceMarks),
          fcRsiPanel(d, weight: 0.4, timeAxis: true, markers: rsiMarks),
        ]);
      },
    );
