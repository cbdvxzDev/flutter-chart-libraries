// Avanzada 31 · Comparación de dos activos y su diferencia
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';
import '../panels.dart';

Widget a31ComparacionSpread() => FcView(build: (d) {
      final a = base100(d.c);
      final b = base100(d.walk(vol: 0.016, drift: 0.0003));
      d.add('a', a, label: 'Activo A');
      d.add('b', b, label: 'Activo B');
      d.add('dif', zip(a, b, (x, y) => x - y), label: 'A − B');
      return fcChart(d, [
        fcPanel(
          weight: 0.62,
          timeAxis: false,
          scale: ['a', 'b'],
          graphs: [
            fcLine('b', fcPurple, w: 1.8),
            fcLine(
              'a',
              fcBlue,
              w: 1.8,
              markers: [
                fcHLine(100, fcGrey, dash: const [2, 4]),
                ...fcLegend(const {'Activo A (base 100)': fcBlue, 'Activo B (base 100)': fcPurple}),
              ],
            ),
          ],
          tooltip: fcTip(['a', 'b'], follow: 'a'),
        ),
        fcPanel(
          weight: 0.38,
          scale: ['dif'],
          graphs: [
            // El panel de abajo es la resta de las dos líneas de arriba.
            fcArea(
              'dif',
              fcUp,
              base: 0,
              below: fcDown,
              w: 1.6,
              markers: [fcHLine(0, fcGrey), fcPanelTitle('Diferencia A − B (puntos)')],
            ),
          ],
          tooltip: fcTip(['dif'], position: GTooltipPosition.bottomLeft),
        ),
      ]);
    });
