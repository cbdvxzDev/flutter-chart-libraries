// Tres ejes Y - Ventas, clima y clientes
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget tresEjesY() => c(lg: true, axes: [nv(name: 'y2', opp: true, g: false), nv(name: 'y3', opp: true, g: false)], [
        ColumnSeries<Pt, String>(dataSource: s1, xValueMapper: x, yValueMapper: y, name: 'Ventas', opacity: .7),
        SplineSeries<Pt, String>(dataSource: s3, xValueMapper: x, yValueMapper: y, name: 'Clima', yAxisName: 'y2', width: 3),
        LineSeries<Pt, String>(dataSource: s2, xValueMapper: x, yValueMapper: y, name: 'Clientes', yAxisName: 'y3', width: 2, dashArray: const <double>[5, 4]),
      ]);
