// Eje secundario - Ventas (col.) y satisfacción (línea)
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget ejeSecundario() => c(lg: true, axes: [nv(name: 'y2', opp: true, g: false)], [
        ColumnSeries<Pt, String>(dataSource: s1, xValueMapper: x, yValueMapper: y, name: 'Ventas', borderRadius: const BorderRadius.vertical(top: Radius.circular(6))),
        SplineSeries<Pt, String>(dataSource: s3, xValueMapper: x, yValueMapper: y, name: 'Satisfacción', yAxisName: 'y2', width: 3, markerSettings: MarkerSettings(isVisible: true)),
      ]);
