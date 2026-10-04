// Básica 05 · Ladrillos Renko
import 'package:flutter/material.dart';

import '../common.dart';

Widget b05Renko() => FcView(build: (d) {
      // Un ladrillo nuevo solo aparece cuando el precio avanza un 2 %: el eje
      // horizontal deja de ser el tiempo y pasa a ser el número de ladrillo.
      final bricks = renko(d.c, d.c[0] * 0.02);
      if (bricks.isEmpty) bricks.add((from: d.c[0], to: d.c[0] * 1.02));
      final r = FcData.raw(List.generate(bricks.length, (i) => i));
      // Cada ladrillo es una barra flotante entre "desde" y "hasta". Los que no
      // son de su color se dejan con altura cero para que no se vean.
      r.add('upLo', [for (final b in bricks) b.from]);
      r.add('upHi', [for (final b in bricks) b.to > b.from ? b.to : b.from]);
      r.add('dnLo', [for (final b in bricks) b.from]);
      r.add('dnHi', [for (final b in bricks) b.to < b.from ? b.to : b.from]);
      return fcChart(r, [
        fcPanel(
          scale: ['upLo', 'upHi', 'dnHi'],
          timeFormatter: (point, value) => '#${point + 1}',
          graphs: [
            fcStack(['upLo', 'upHi'], const [fcUp, fcUp], base: null, ratio: 0.92),
            fcStack(['dnLo', 'dnHi'], const [fcDown, fcDown], base: null, ratio: 0.92),
          ],
        ),
      ], barWidth: 12);
    });
