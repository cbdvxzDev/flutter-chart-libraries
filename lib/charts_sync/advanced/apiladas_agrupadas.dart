// Apiladas agrupadas - Dos tiendas, dos pilas
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget apiladasAgrupadas() => c(lg: true, [
        StackedColumnSeries<Pt, String>(dataSource: s1, xValueMapper: x, yValueMapper: y, groupName: 'A', name: 'A · Arábica'),
        StackedColumnSeries<Pt, String>(dataSource: s2, xValueMapper: x, yValueMapper: y, groupName: 'A', name: 'A · Robusta'),
        StackedColumnSeries<Pt, String>(dataSource: s3, xValueMapper: x, yValueMapper: y, groupName: 'B', name: 'B · Geisha'),
        StackedColumnSeries<Pt, String>(dataSource: s2, xValueMapper: x, yValueMapper: y, groupName: 'B', name: 'B · Robusta'),
      ]);
