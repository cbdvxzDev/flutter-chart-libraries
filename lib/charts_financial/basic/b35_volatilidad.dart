// Básica 35 · Volatilidad histórica
import 'package:flutter/material.dart';

import '../common.dart';

Widget b35Volatilidad() => FcView(
      n: 320,
      build: (d) {
        d.add('hv20', histVol(d.c, 20), label: 'Volatilidad 20 d');
        d.add('hv60', histVol(d.c, 60), label: 'Volatilidad 60 d');
        return fcChart(d, [
          fcPanel(
            scale: ['hv20', 'hv60'],
            min: 0,
            marginBottom: 0,
            valueFormatter: (v, p) => '${v.toStringAsFixed(0)} %',
            graphs: [
              // Desviación estándar de los retornos diarios, llevada a un año.
              fcArea('hv20', fcPink, alpha: 0.14, w: 1.6),
              fcLine(
                'hv60',
                fcIndigo,
                w: 2.2,
                markers: fcLegend(const {'20 días': fcPink, '60 días': fcIndigo}),
              ),
            ],
            tooltip: fcTip(['hv20', 'hv60']),
          ),
        ]);
      },
    );
