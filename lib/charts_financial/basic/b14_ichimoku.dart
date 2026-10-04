// Básica 14 · Nube de Ichimoku
import 'package:flutter/material.dart';

import '../common.dart';

Widget b14Ichimoku() => FcView(
      n: 320,
      build: (d) {
        final ich = ichimoku(d.h, d.l);
        d.add('conv', ich.conv, label: 'Conversión (9)');
        d.add('base', ich.base, label: 'Base (26)');
        d.add('spanA', ich.spanA, label: 'Span A');
        d.add('spanB', ich.spanB, label: 'Span B');
        return fcChart(d, [
          fcPanel(
            scale: [kH, kL, 'spanA', 'spanB'],
            graphs: [
              // La nube es el espacio entre los dos spans: verde cuando A va
              // por encima de B (tendencia alcista) y roja al revés.
              fcArea('spanA', fcUp, baseKey: 'spanB', below: fcDown, alpha: 0.18, w: 1),
              fcLine('base', fcDown, w: 1.4),
              fcLine('conv', fcBlue, w: 1.4),
              fcCandles(
                ratio: 0.6,
                markers: fcLegend(const {'Conversión': fcBlue, 'Base': fcDown, 'Nube': fcUp}),
              ),
            ],
            tooltip: fcTip([kC, 'conv', 'base', 'spanA', 'spanB'], follow: kC),
          ),
        ]);
      },
    );
