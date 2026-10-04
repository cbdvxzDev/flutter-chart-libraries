// Avanzada 29 · Juego completo de herramientas de Fibonacci
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget a29FibonacciCompleto() => const _A29();

class _A29 extends StatefulWidget {
  const _A29();

  @override
  State<_A29> createState() => _A29State();
}

class _A29State extends FcState<_A29> {
  // Las herramientas se pueden encender juntas sobre el mismo movimiento.
  final Set<String> on = {'ret', 'circ'};

  @override
  GChart buildChart() {
    final from = d.last - 90;
    final lo = d.lowestIndex(from, d.last - 30);
    final hi0 = d.highestIndex(lo);
    final hi = hi0 > lo ? hi0 : d.last;
    final a = at(lo, d.l[lo]);
    final b = at(hi, d.h[hi]);
    return fcChart(d, [
      fcPanel(
        scale: [kH, kL],
        graphs: [
          fcCandles(
            ratio: 0.6,
            up: fcGrey,
            down: fcGrey,
            markers: [
              if (on.contains('ret'))
                GFibRetracementMarker(
                  startCoord: a,
                  endCoord: b,
                  endRay: true,
                  theme: fcMk(stroke: fcOrange, w: 1, text: fcOrange, size: 10),
                ),
              if (on.contains('fan'))
                GFibResistanceFanMarker(
                  startCoord: a,
                  endCoord: b,
                  showPointLevelLines: false,
                  showPointLevelStartLabels: false,
                  showPointLevelEndLabels: false,
                  theme: fcMk(stroke: fcPurple, w: 1, text: fcPurple, size: 10),
                ),
              if (on.contains('circ'))
                GFibCircleMarker(
                  startCoord: a,
                  endCoord: b,
                  fibLevels: const [0.382, 0.618, 1.0],
                  theme: fcMk(stroke: fcTeal, w: 1, text: fcTeal, size: 10),
                ),
              if (on.contains('time'))
                GFibTimeZoneMarker(
                  startCoord: a,
                  endCoord: at(lo + 3, d.l[lo]),
                  labelPosition: 0.04,
                  theme: fcMk(stroke: fcIndigo, w: 1, text: fcIndigo, size: 10, dash: const [4, 3]),
                ),
              fcArrow(a, b, fcInk, w: 2),
            ],
          ),
        ],
      ),
    ], barWidth: 6, endSpace: 12);
  }

  @override
  List<Widget> controls(BuildContext context) => [
        fcChips(
          options: const {
            'ret': 'Retroceso',
            'fan': 'Abanico',
            'circ': 'Círculos',
            'time': 'Zonas de tiempo',
          },
          selected: on,
          onChanged: (key, value) {
            if (value) {
              on.add(key);
            } else {
              on.remove(key);
            }
            rebuildChart();
          },
        ),
      ];
}
