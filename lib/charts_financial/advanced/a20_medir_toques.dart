// Avanzada 20 · Medir entre dos toques
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget a20MedirToques() => const _A20();

class _A20 extends StatefulWidget {
  const _A20();

  @override
  State<_A20> createState() => _A20State();
}

class _A20State extends FcState<_A20> {
  GViewPortCoord? first; // primer toque, a la espera del segundo

  @override
  GChart buildChart() {
    return fcChart(d, [
      fcPanel(
        scale: [kH, kL],
        marginTop: 0.15,
        graphs: [fcCandles(id: 'velas', ratio: 0.6)],
        onTap: _onTap,
      ),
    ]);
  }

  void _onTap(Offset position) {
    final panel = chart.panels[0];
    final coord = panel.positionToViewPortCoord(
      position: position,
      pointViewPort: chart.pointViewPort,
    );
    final graph = panel.findGraphById('velas');
    if (coord == null || graph == null) return;
    final start = first;
    if (start == null) {
      // Primer toque: se limpia la medición anterior y se marca el origen.
      graph.clearMarkers();
      graph.addMarker(fcShape(coord, fcBlue, r: 5));
      first = coord;
    } else {
      // Segundo toque: la regla calcula sola precio, barras y ángulo.
      graph.clearMarkers();
      graph.addMarker(
        GStatsLineMarker(
          startCoord: start,
          endCoord: coord,
          statsBoxPosition: 1,
          fillStyle: GStatsLineFillStyle.rectangle,
          theme: fcMk(
            stroke: fcBlue,
            fill: fcBlue.withValues(alpha: 0.10),
            w: 1.6,
            labelBg: Colors.white,
            labelBorder: fcBlue,
          ),
        ),
      );
      first = null;
    }
    repaint();
  }

  @override
  List<Widget> controls(BuildContext context) => [
        fcHint(
          first == null
              ? 'Toca un punto de partida y luego uno de llegada para medir el movimiento.'
              : 'Origen marcado. Ahora toca el punto de llegada.',
        ),
      ];
}
