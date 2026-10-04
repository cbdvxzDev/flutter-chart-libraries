// Avanzada 15 · Matriz de combinaciones
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';
import '../panels.dart';

Widget a15MatrizCombinaciones() => const _A15();

class _A15 extends StatefulWidget {
  const _A15();

  @override
  State<_A15> createState() => _A15State();
}

class _A15State extends FcState<_A15> {
  static const precios = {'velas': 'Velas', 'ha': 'Heikin-Ashi', 'linea': 'Línea'};
  static const capas = {'no': 'Sin capa', 'bb': 'Bollinger', 'ichi': 'Ichimoku', 'st': 'SuperTrend'};
  static const paneles = {'no': 'Sin panel', 'vol': 'Volumen', 'rsi': 'RSI', 'macd': 'MACD'};

  String precio = 'velas';
  String capa = 'bb';
  String panel = 'vol';

  @override
  FcData createData() => FcData(n: 320);

  @override
  GChart buildChart() {
    final ha = heikinAshi(d.o, d.h, d.l, d.c);
    final bb = bollinger(d.c);
    final ich = ichimoku(d.h, d.l);
    d.add('haO', ha.o, label: 'HA apertura');
    d.add('haH', ha.h, label: 'HA máximo');
    d.add('haL', ha.l, label: 'HA mínimo');
    d.add('haC', ha.c, label: 'HA cierre');
    d.add('bbU', bb.up, label: 'Banda superior');
    d.add('bbL', bb.lo, label: 'Banda inferior');
    d.add('spanA', ich.spanA, label: 'Span A');
    d.add('spanB', ich.spanB, label: 'Span B');
    d.add('st', supertrend(d.h, d.l, d.c).line, label: 'SuperTrend');

    // 1) Cómo se dibuja el precio.
    final GGraph price = switch (precio) {
      'ha' => fcCandles(keys: const ['haO', 'haH', 'haL', 'haC'], ratio: 0.6),
      'linea' => fcLine(kC, fcInk, w: 1.8),
      _ => fcCandles(ratio: 0.6),
    };
    // 2) Qué capa va por debajo del precio.
    final under = <GGraph>[
      if (capa == 'bb') fcArea('bbU', fcBlue, baseKey: 'bbL', alpha: 0.10, w: 1),
      if (capa == 'ichi') fcArea('spanA', fcUp, baseKey: 'spanB', below: fcDown, alpha: 0.16, w: 1),
      if (capa == 'st') fcArea(kC, fcUp, baseKey: 'st', below: fcDown, alpha: 0.18, border: false),
    ];
    final scale = <String>[
      if (capa == 'bb') ...['bbU', 'bbL'],
      if (capa == 'ichi') ...['spanA', 'spanB'],
      if (capa == 'st') 'st',
    ];
    // 3) Qué panel va debajo.
    final lower = <GPanel>[
      if (panel == 'vol') fcVolumePanel(d, weight: 0.3, timeAxis: true),
      if (panel == 'rsi') fcRsiPanel(d, weight: 0.3, timeAxis: true),
      if (panel == 'macd') fcMacdPanel(d, weight: 0.3, timeAxis: true),
    ];
    return fcChart(d, [
      fcPricePanel(d, weight: 0.7, timeAxis: lower.isEmpty, price: price, under: under, scale: scale),
      ...lower,
    ]);
  }

  @override
  List<Widget> controls(BuildContext context) {
    final total = precios.length * capas.length * paneles.length;
    final index = precios.keys.toList().indexOf(precio) * capas.length * paneles.length +
        capas.keys.toList().indexOf(capa) * paneles.length +
        paneles.keys.toList().indexOf(panel) +
        1;
    void pick(void Function() change) {
      change();
      rebuildChart();
    }

    return [
      fcSeg<String>(options: precios, value: precio, onChanged: (v) => pick(() => precio = v)),
      fcSeg<String>(options: capas, value: capa, onChanged: (v) => pick(() => capa = v)),
      fcSeg<String>(options: paneles, value: panel, onChanged: (v) => pick(() => panel = v)),
      fcHint('Combinación $index de $total  ·  ${precios[precio]} + ${capas[capa]} + ${paneles[panel]}'),
    ];
  }
}
