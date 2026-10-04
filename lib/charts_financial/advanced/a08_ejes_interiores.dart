// Avanzada 08 · Ejes interiores, dobles y con formato propio
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget a08EjesInteriores() => FcView(build: (d) {
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL],
          // Eje de precios dibujado dentro de la gráfica, con formato de dinero.
          valueAxisPosition: GAxisPosition.endInside,
          valueFormatter: fcMoney,
          // Eje de tiempo abajo con fechas cortas en español...
          timeFormatter: fcFecha,
          // ...y otro arriba con la fecha completa.
          extraTimeAxes: [GPointAxis(position: GAxisPosition.start)],
          // Segundo eje de precios, fuera y a la izquierda.
          extraAxes: [GValueAxis(position: GAxisPosition.start, size: 50)],
          graphs: [fcCandles()],
          tooltip: fcTip(fcOhlc, follow: kC),
        ),
      ], barWidth: 10);
    });
