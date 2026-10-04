// Avanzada 12 · Constructor de paneles
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';
import '../panels.dart';

Widget a12ConstructorPaneles() => const _A12();

class _A12 extends StatefulWidget {
  const _A12();

  @override
  State<_A12> createState() => _A12State();
}

class _A12State extends FcState<_A12> {
  // Los paneles se apilan en el orden en que se van encendiendo.
  final List<String> order = ['vol', 'rsi'];

  @override
  GChart buildChart() {
    final panels = <GPanel>[];
    for (var i = 0; i < order.length; i++) {
      final lastOne = i == order.length - 1;
      panels.add(switch (order[i]) {
        'vol' => fcVolumePanel(d, weight: 0.22, timeAxis: lastOne),
        'macd' => fcMacdPanel(d, weight: 0.22, timeAxis: lastOne),
        'atr' => fcAtrPanel(d, weight: 0.22, timeAxis: lastOne),
        'adx' => fcAdxPanel(d, weight: 0.22, timeAxis: lastOne),
        _ => fcRsiPanel(d, weight: 0.22, timeAxis: lastOne),
      });
    }
    return fcChart(d, [fcPricePanel(d, weight: 0.5, timeAxis: order.isEmpty), ...panels]);
  }

  @override
  List<Widget> controls(BuildContext context) => [
        fcChips(
          options: const {
            'vol': 'Volumen',
            'rsi': 'RSI',
            'macd': 'MACD',
            'atr': 'ATR',
            'adx': 'ADX',
          },
          selected: order.toSet(),
          onChanged: (key, value) {
            if (value) {
              order.add(key);
            } else {
              order.remove(key);
            }
            rebuildChart();
          },
        ),
        fcHint(
          order.isEmpty
              ? 'Solo el precio. Enciende paneles para apilarlos debajo.'
              : 'Orden actual: precio → ${order.join(' → ')}',
        ),
      ];
}
