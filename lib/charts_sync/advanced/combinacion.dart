// Combinación - Área + columna + spline
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget combinacion() => c(lg: true, [
        AreaSeries<Pt, String>(dataSource: s3, xValueMapper: x, yValueMapper: y, name: 'Base', opacity: .3),
        ColumnSeries<Pt, String>(dataSource: s2, xValueMapper: x, yValueMapper: y, name: 'Pedidos', width: .5),
        SplineSeries<Pt, String>(dataSource: s1, xValueMapper: x, yValueMapper: y, name: 'Ingresos', width: 3, markerSettings: MarkerSettings(isVisible: true)),
      ]);
