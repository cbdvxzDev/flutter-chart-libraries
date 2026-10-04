// Avanzada 11 · Segmentador de oscilador en el panel inferior
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';
import '../panels.dart';

Widget a11SelectorOscilador() => const _A11();

class _A11 extends StatefulWidget {
  const _A11();

  @override
  State<_A11> createState() => _A11State();
}

class _A11State extends FcState<_A11> {
  String osc = 'rsi';

  @override
  GChart buildChart() {
    // El panel de precio no cambia; el de abajo se reemplaza según la opción.
    final GPanel lower = switch (osc) {
      'macd' => fcMacdPanel(d, weight: 0.35, timeAxis: true),
      'estoc' => fcStochPanel(d, weight: 0.35, timeAxis: true),
      'cci' => fcCciPanel(d, weight: 0.35, timeAxis: true),
      'wr' => fcWilliamsPanel(d, weight: 0.35, timeAxis: true),
      'adx' => fcAdxPanel(d, weight: 0.35, timeAxis: true),
      _ => fcRsiPanel(d, weight: 0.35, timeAxis: true),
    };
    return fcChart(d, [fcPricePanel(d, weight: 0.65), lower]);
  }

  @override
  List<Widget> controls(BuildContext context) => [
        fcSeg<String>(
          options: const {
            'rsi': 'RSI',
            'macd': 'MACD',
            'estoc': 'Estocástico',
            'cci': 'CCI',
            'wr': 'Williams %R',
            'adx': 'ADX',
          },
          value: osc,
          onChanged: (v) {
            osc = v;
            rebuildChart();
          },
        ),
      ];
}
