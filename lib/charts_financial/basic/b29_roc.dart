// Básica 29 · ROC (tasa de cambio)
import 'package:flutter/material.dart';

import '../common.dart';

Widget b29Roc() => FcView(build: (d) {
      d.add('roc', roc(d.c), label: 'ROC 12 (%)');
      return fcChart(d, [
        fcPanel(
          scale: ['roc'],
          valueFormatter: (v, p) => '${v.toStringAsFixed(1)} %',
          graphs: [
            // Cuánto subió o bajó el precio frente a 12 barras atrás.
            fcArea('roc', fcUp, base: 0, below: fcDown, w: 1.8, markers: [fcHLine(0, fcGrey)]),
          ],
          tooltip: fcTip(['roc']),
        ),
      ]);
    });
