// Avanzada 24 · Dos activos con el desplazamiento sincronizado
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';
import '../panels.dart';

Widget a24GraficosSincronizados() => const _A24();

class _A24 extends StatefulWidget {
  const _A24();

  @override
  State<_A24> createState() => _A24State();
}

class _A24State extends State<_A24> with TickerProviderStateMixin {
  late final GChart _a;
  late final GChart _b;

  @override
  void initState() {
    super.initState();
    _a = _build('Activo A', fcBlue, FcData(n: 320));
    _b = _build('Activo B', fcPurple, FcData(n: 320, vol: 0.026));
    // Cuando una se mueve o hace zoom, la otra copia su ventana de tiempo.
    _a.pointViewPort.addListener(() => _sync(_a, _b));
    _b.pointViewPort.addListener(() => _sync(_b, _a));
  }

  GChart _build(String name, Color color, FcData d) {
    return fcChart(d, [
      fcPanel(
        scale: [kH, kL],
        graphs: [
          fcCandles(up: color, down: fcGrey, markers: [fcPanelTitle(name, color: color)]),
        ],
        tooltip: fcTip(fcOhlc, follow: kC),
      ),
    ]);
  }

  void _sync(GChart from, GChart to) {
    if (!from.pointViewPort.isValid) return;
    to.pointViewPort.setRange(
      startPoint: from.pointViewPort.startPoint,
      endPoint: from.pointViewPort.endPoint,
      finished: true,
    );
    to.autoScaleViewports(resetPointViewPort: false, resetValueViewPort: true, animation: false);
  }

  @override
  void dispose() {
    _a.dispose();
    _b.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: GChartWidget(chart: _a, tickerProvider: this)),
        const SizedBox(height: 8),
        Expanded(child: GChartWidget(chart: _b, tickerProvider: this)),
      ],
    );
  }
}
