// Avanzada 36 · Panel de riesgo
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';
import '../panels.dart';

Widget a36PanelRiesgo() => FcView(
      n: 340,
      build: (d) {
        final dd = drawdown(d.c);
        final hv = histVol(d.c, 20);
        d.add('dd', dd, label: 'Caída desde el máximo (%)');
        d.add('hv', hv, label: 'Volatilidad 20 d (%)');
        // Máximo alcanzado hasta cada barra.
        final peak = <double>[];
        var top = d.c[0];
        for (final price in d.c) {
          if (price > top) top = price;
          peak.add(top);
        }
        d.add('peak', peak, label: 'Máximo histórico');
        var worst = 0;
        for (var i = 0; i < d.n; i++) {
          if (dd[i] < dd[worst]) worst = i;
        }
        // Tres lecturas del mismo riesgo: distancia al máximo, caída en
        // porcentaje y volatilidad.
        return fcChart(d, [
          fcPanel(
            weight: 0.46,
            timeAxis: false,
            scale: [kC, 'peak'],
            graphs: [
              fcArea('peak', fcDown, baseKey: kC, alpha: 0.16, border: false),
              fcLine('peak', fcGrey, w: 1.2),
              fcLine(
                kC,
                fcBlue,
                w: 1.8,
                markers: [
                  fcVLine(worst, fcDown, dash: const [3, 4]),
                  ...fcLegend(const {'Cierre': fcBlue, 'Máximo alcanzado': fcGrey}),
                ],
              ),
            ],
            tooltip: fcTip([kC, 'peak'], follow: kC),
          ),
          fcPanel(
            weight: 0.27,
            timeAxis: false,
            scale: ['dd'],
            max: 0,
            marginTop: 0,
            graphs: [
              fcArea(
                'dd',
                fcDown,
                base: 0,
                alpha: 0.30,
                w: 1.4,
                markers: [
                  fcVLine(worst, fcDown, dash: const [3, 4]),
                  fcPanelTitle('Drawdown · peor: ${dd[worst].toStringAsFixed(1)} %', color: fcDown),
                ],
              ),
            ],
            tooltip: fcTip(['dd'], position: GTooltipPosition.bottomLeft),
          ),
          fcPanel(
            weight: 0.27,
            scale: ['hv'],
            min: 0,
            marginBottom: 0,
            graphs: [
              fcArea('hv', fcPurple, alpha: 0.18, w: 1.4, markers: [fcPanelTitle('Volatilidad anualizada (%)', color: fcPurple)]),
            ],
            tooltip: fcTip(['hv'], position: GTooltipPosition.bottomLeft),
          ),
        ]);
      },
    );
