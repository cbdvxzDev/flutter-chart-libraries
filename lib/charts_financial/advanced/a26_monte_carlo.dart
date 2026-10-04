// Avanzada 26 · Simulación Monte Carlo
import 'package:flutter/material.dart';

import '../common.dart';

Widget a26MonteCarlo() => FcView(
      n: 200,
      build: (d) {
        const paths = 30;
        final today = d.n - 61; // las últimas 60 barras son "futuro"
        // El historial real se corta hoy; de ahí en adelante todo es simulado.
        d.add('hist', [for (var i = 0; i < d.n; i++) i <= today ? d.c[i] : double.nan], label: 'Historial');
        for (var k = 0; k < paths; k++) {
          d.add('p$k', d.simulate(today), label: 'Trayectoria ${k + 1}');
        }
        // Para cada día futuro se ordenan los 30 valores y se toman percentiles.
        List<double> percentile(double q) => [
              for (var i = 0; i < d.n; i++)
                if (i < today)
                  double.nan
                else
                  ([for (var k = 0; k < paths; k++) d['p$k'][i]]..sort())[((paths - 1) * q).round()],
            ];
        d.add('q05', percentile(0.05), label: 'Percentil 5');
        d.add('q50', percentile(0.50), label: 'Mediana');
        d.add('q95', percentile(0.95), label: 'Percentil 95');
        return fcChart(
          d,
          [
            fcPanel(
              scale: ['hist', for (var k = 0; k < paths; k++) 'p$k'],
              graphs: [
                fcArea('q95', fcBlue, baseKey: 'q05', alpha: 0.12, border: false),
                for (var k = 0; k < paths; k++) fcLine('p$k', fcBlue.withValues(alpha: 0.28), w: 1),
                fcLine('q50', fcOrange, w: 2.4),
                fcLine(
                  'hist',
                  fcInk,
                  w: 2,
                  markers: [
                    fcVLine(today, fcGrey, dash: const [5, 4]),
                    fcLabel('Hoy', atPoint(today, 0.03), align: Alignment.centerLeft, color: fcGrey),
                    ...fcLegend(const {
                      'Historial': fcInk,
                      '30 futuros posibles': fcBlue,
                      'Mediana': fcOrange,
                    }),
                  ],
                ),
              ],
              tooltip: fcTip(['q95', 'q50', 'q05']),
            ),
          ],
          barWidth: 5,
          endSpace: 2,
        );
      },
    );
