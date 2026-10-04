// Columnas solapadas - Real, meta y mínimo
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget columnasSolapadas() => c(lg: true, sbs: false, [
        ColumnSeries<Pt, String>(dataSource: s1, xValueMapper: x, yValueMapper: y, name: 'Meta', width: .85, opacity: .45),
        ColumnSeries<Pt, String>(dataSource: s2, xValueMapper: x, yValueMapper: y, name: 'Real', width: .55),
        ColumnSeries<Pt, String>(dataSource: s3, xValueMapper: x, yValueMapper: y, name: 'Mínimo', width: .25),
      ]);
