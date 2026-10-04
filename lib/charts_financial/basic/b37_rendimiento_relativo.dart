// Básica 37 · Rendimiento relativo frente a un índice
import 'package:flutter/material.dart';

import '../common.dart';

Widget b37RendimientoRelativo() => FcView(build: (d) {
      // Los dos arrancan en 100 para poder compararlos.
      d.add('act', base100(d.c), label: 'Activo');
      d.add('idx', base100(d.walk(vol: 0.009)), label: 'Índice');
      return fcChart(d, [
        fcPanel(
          scale: ['act', 'idx'],
          graphs: [
            // Verde cuando el activo le gana al índice, rojo cuando pierde.
            fcArea('act', fcUp, baseKey: 'idx', below: fcDown, alpha: 0.22, border: false),
            fcLine('idx', fcGrey, w: 1.6),
            fcLine(
              'act',
              fcBlue,
              w: 2,
              markers: [
                fcHLine(100, fcGrey, dash: const [2, 4]),
                ...fcLegend(const {'Activo': fcBlue, 'Índice de referencia': fcGrey}),
              ],
            ),
          ],
          tooltip: fcTip(['act', 'idx'], follow: 'act'),
        ),
      ]);
    });
