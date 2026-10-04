// Avanzada 06 · Precio y volumen con dos escalas en un mismo panel
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget a06DobleEscala() => FcView(build: (d) {
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL],
          // El precio deja libre el 30 % inferior, que ocupa el volumen.
          marginBottom: 0.30,
          extraViewPorts: [
            // Segunda escala vertical, solo para el volumen.
            GValueViewPort(
              id: 'vol',
              valuePrecision: 0,
              autoScaleStrategy: GValueViewPortAutoScaleStrategyMinMax(
                dataKeys: [kV],
                fixedStartValue: 0,
                marginStart: GSize.viewSize(0),
                marginEnd: GSize.viewHeightRatio(0.72),
              ),
            ),
          ],
          extraAxes: [
            GValueAxis(viewPortId: 'vol', position: GAxisPosition.start, scaleMode: GAxisScaleMode.none),
          ],
          graphs: [
            fcBars(kV, up: fcIndigo.withValues(alpha: 0.35), vp: 'vol'),
            fcCandles(),
          ],
          tooltip: fcTip([...fcOhlc, kV], follow: kC),
        ),
      ]);
    });
