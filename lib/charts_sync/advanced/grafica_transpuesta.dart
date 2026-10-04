// Gráfica transpuesta - Ejes intercambiados
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget graficaTranspuesta() => c(lg: true, tr: true, [
        SplineAreaSeries<Pt, String>(dataSource: s1, xValueMapper: x, yValueMapper: y, name: 'Año actual', opacity: .6),
        SplineAreaSeries<Pt, String>(dataSource: s3, xValueMapper: x, yValueMapper: y, name: 'Año previo', opacity: .6),
      ]);
