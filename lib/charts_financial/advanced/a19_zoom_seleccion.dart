// Avanzada 19 · Zoom por selección en el eje y reinicio con doble toque
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget a19ZoomSeleccion() => const _A19();

class _A19 extends StatefulWidget {
  const _A19();

  @override
  State<_A19> createState() => _A19State();
}

class _A19State extends FcState<_A19> {
  @override
  FcData createData() => FcData(n: 400);

  @override
  GChart buildChart() {
    return fcChart(d, [
      fcPanel(
        scale: [kH, kL],
        // Modo "select": arrastrar sobre el eje de tiempo marca un tramo y la
        // gráfica se acerca a él.
        timeAxisMode: GAxisScaleMode.select,
        graphs: [fcCandles()],
        tooltip: fcTip(fcOhlc, follow: kC),
        onDoubleTap: (_) => fcResetZoom(chart),
      ),
    ], barWidth: 4);
  }

  @override
  List<Widget> controls(BuildContext context) => [
        Row(
          children: [
            Expanded(
              child: fcHint('Arrastra sobre el eje de fechas para elegir un tramo. Doble toque para volver.'),
            ),
            TextButton.icon(
              onPressed: () => fcResetZoom(chart),
              icon: const Icon(Icons.zoom_out_map, size: 18),
              label: const Text('Restablecer'),
            ),
          ],
        ),
      ];
}
