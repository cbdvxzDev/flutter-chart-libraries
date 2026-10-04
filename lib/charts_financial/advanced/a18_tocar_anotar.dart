// Avanzada 18 · Tocar para anotar
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget a18TocarAnotar() => const _A18();

class _A18 extends StatefulWidget {
  const _A18();

  @override
  State<_A18> createState() => _A18State();
}

class _A18State extends FcState<_A18> {
  int notas = 0;

  @override
  GChart buildChart() {
    return fcChart(d, [
      fcPanel(scale: [kH, kL], graphs: [fcCandles(id: 'velas')], onTap: _onTap),
    ], barWidth: 10);
  }

  void _onTap(Offset position) {
    final panel = chart.panels[0];
    // Convierte el píxel tocado en "número de barra" y "precio".
    final coord = panel.positionToViewPortCoord(
      position: position,
      pointViewPort: chart.pointViewPort,
    );
    final graph = panel.findGraphById('velas');
    if (coord == null || graph == null) return;
    final bar = coord.point.round();
    graph.addMarker(fcShape(at(bar, coord.value), fcBlue, r: 4));
    graph.addMarker(
      fcCallout(
        'Nota ${notas + 1}\n${coord.value.toStringAsFixed(2)}',
        at(bar, coord.value),
        align: Alignment.topCenter,
        color: fcBlue,
      ),
    );
    notas++;
    repaint();
  }

  @override
  List<Widget> controls(BuildContext context) => [
        Row(
          children: [
            Expanded(child: fcHint('Toca cualquier punto de la gráfica para dejar una nota. Notas: $notas')),
            TextButton.icon(
              onPressed: notas == 0
                  ? null
                  : () {
                      chart.panels[0].findGraphById('velas')?.clearMarkers();
                      notas = 0;
                      repaint();
                    },
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Borrar'),
            ),
          ],
        ),
      ];
}
