// Avanzada 09 · Segmentador de tipo de precio
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget a09SelectorTipoPrecio() => const _A09();

class _A09 extends StatefulWidget {
  const _A09();

  @override
  State<_A09> createState() => _A09State();
}

class _A09State extends FcState<_A09> {
  String tipo = 'velas';

  @override
  GChart buildChart() {
    final ha = heikinAshi(d.o, d.h, d.l, d.c);
    d.add('haO', ha.o, label: 'HA apertura');
    d.add('haH', ha.h, label: 'HA máximo');
    d.add('haL', ha.l, label: 'HA mínimo');
    d.add('haC', ha.c, label: 'HA cierre');
    // Los mismos datos, dibujados de seis maneras.
    final GGraph graph = switch (tipo) {
      'huecas' => fcCandles(hollow: true),
      'ohlc' => fcCandles(candle: false),
      'ha' => fcCandles(keys: const ['haO', 'haH', 'haL', 'haC']),
      'linea' => fcLine(kC, fcBlue, w: 2),
      'montana' => fcArea(kC, fcBlue, alpha: 0.20, w: 1.8),
      _ => fcCandles(),
    };
    return fcChart(d, [
      fcPanel(scale: [kH, kL], graphs: [graph], tooltip: fcTip(fcOhlc, follow: kC)),
    ]);
  }

  @override
  List<Widget> controls(BuildContext context) => [
        fcSeg<String>(
          options: const {
            'velas': 'Velas',
            'huecas': 'Huecas',
            'ohlc': 'OHLC',
            'ha': 'Heikin-Ashi',
            'linea': 'Línea',
            'montana': 'Montaña',
          },
          value: tipo,
          onChanged: (v) {
            tipo = v;
            rebuildChart();
          },
        ),
      ];
}
