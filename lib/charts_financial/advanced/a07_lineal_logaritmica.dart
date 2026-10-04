// Avanzada 07 · Escala lineal frente a logarítmica
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';
import '../panels.dart';

Widget a07LinealLogaritmica() => FcView(
      n: 420,
      drift: 0.004,
      vol: 0.022,
      build: (d) {
        // Un activo que crece muy rápido: en la escala lineal el principio
        // queda aplastado; en la logarítmica cada +100 % mide lo mismo.
        return fcChart(
          d,
          [
            fcPanel(
              timeAxis: false,
              scale: [kC],
              graphs: [
                fcArea(kC, fcBlue, alpha: 0.15, w: 1.8, markers: [fcPanelTitle('Lineal', color: fcBlue)]),
              ],
              tooltip: fcTip([kC], position: GTooltipPosition.topLeft),
            ),
            fcPanel(
              scale: [kC],
              marginBottom: 0.02,
              scaleType: GValueViewPortScaleType.logarithmic,
              graphs: [
                fcLine(
                  kC,
                  fcPurple,
                  w: 1.8,
                  markers: [fcPanelTitle('Logarítmica', color: fcPurple)],
                ),
              ],
              tooltip: fcTip([kC], position: GTooltipPosition.topLeft),
            ),
          ],
          barWidth: 3,
        );
      },
    );
