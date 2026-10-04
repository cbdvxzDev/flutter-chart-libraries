// Avanzada 10 · Superposiciones combinables
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget a10SelectorSuperposiciones() => const _A10();

class _A10 extends StatefulWidget {
  const _A10();

  @override
  State<_A10> createState() => _A10State();
}

class _A10State extends FcState<_A10> {
  // Cada ficha se enciende por separado: 6 fichas dan 64 combinaciones.
  final Set<String> on = {'sma', 'bb'};

  @override
  FcData createData() => FcData(n: 320);

  @override
  GChart buildChart() {
    final bb = bollinger(d.c);
    final kc = keltner(d.h, d.l, d.c);
    final ich = ichimoku(d.h, d.l);
    d.add('s20', sma(d.c, 20), label: 'SMA 20');
    d.add('s50', sma(d.c, 50), label: 'SMA 50');
    d.add('e21', ema(d.c, 21), label: 'EMA 21');
    d.add('bbU', bb.up, label: 'Bollinger sup.');
    d.add('bbL', bb.lo, label: 'Bollinger inf.');
    d.add('kU', kc.up, label: 'Keltner sup.');
    d.add('kL', kc.lo, label: 'Keltner inf.');
    d.add('spanA', ich.spanA, label: 'Span A');
    d.add('spanB', ich.spanB, label: 'Span B');
    d.add('sar', psar(d.h, d.l), label: 'SAR');
    return fcChart(d, [
      fcPanel(
        scale: [
          kH,
          kL,
          if (on.contains('bb')) ...['bbU', 'bbL'],
          if (on.contains('kc')) ...['kU', 'kL'],
          if (on.contains('ichi')) ...['spanA', 'spanB'],
        ],
        graphs: <GGraph>[
          if (on.contains('ichi'))
            fcArea('spanA', fcUp, baseKey: 'spanB', below: fcDown, alpha: 0.16, w: 1),
          if (on.contains('bb')) fcArea('bbU', fcBlue, baseKey: 'bbL', alpha: 0.10, w: 1),
          if (on.contains('kc')) ...[fcLine('kU', fcPurple, w: 1.4), fcLine('kL', fcPurple, w: 1.4)],
          fcCandles(ratio: 0.6),
          if (on.contains('sma')) ...[fcLine('s20', fcOrange, w: 1.6), fcLine('s50', fcIndigo, w: 1.6)],
          if (on.contains('ema')) fcLine('e21', fcPink, w: 1.6),
          if (on.contains('sar')) fcLine('sar', fcInk, stroke: false, dot: 2),
        ],
        tooltip: fcTip(fcOhlc, follow: kC),
      ),
    ]);
  }

  @override
  List<Widget> controls(BuildContext context) => [
        fcChips(
          options: const {
            'sma': 'SMA 20/50',
            'ema': 'EMA 21',
            'bb': 'Bollinger',
            'kc': 'Keltner',
            'ichi': 'Ichimoku',
            'sar': 'SAR',
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
