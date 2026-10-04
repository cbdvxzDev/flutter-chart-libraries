// Avanzada 13 · Segmentador de periodo
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget a13SelectorPeriodo() => const _A13();

class _A13 extends StatefulWidget {
  const _A13();

  @override
  State<_A13> createState() => _A13State();
}

class _A13State extends FcState<_A13> {
  // Barras que se ven con cada opción (un mes tiene unos 21 días hábiles).
  static const bars = {'1M': 21, '3M': 63, '6M': 126, '1A': 252, 'Todo': 520};
  String periodo = '3M';

  @override
  FcData createData() => FcData(n: 520);

  @override
  GChart buildChart() {
    return fcChart(
      d,
      [
        fcPanel(
          scale: [kH, kL],
          timeFormatter: fcFecha,
          graphs: [fcCandles()],
          tooltip: fcTip(fcOhlc, follow: kC),
        ),
      ],
      // El rango inicial se fija a mano en lugar de dejarlo en automático.
      pointViewPort: GPointViewPort(
        initialStartPoint: d.last - bars[periodo]! + 0.5,
        initialEndPoint: d.last + 1.5,
        resizeMode: GViewPortResizeMode.keepRange,
        minPointWidth: 0.5,
        defaultPointWidth: 8,
      ),
    );
  }

  @override
  List<Widget> controls(BuildContext context) => [
        fcSeg<String>(
          options: {for (final k in bars.keys) k: k},
          value: periodo,
          onChanged: (v) {
            // Aquí no hace falta rearmar la gráfica: basta con mover la ventana.
            setState(() => periodo = v);
            chart.pointViewPort.setRange(
              startPoint: d.last - bars[v]! + 0.5,
              endPoint: d.last + 1.5,
              finished: true,
            );
          },
        ),
      ];
}
