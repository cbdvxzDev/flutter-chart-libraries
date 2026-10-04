// 7. Columnas - Tazas vendidas
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget columnas() => c([ColumnSeries<Pt, String>(dataSource: s1, xValueMapper: x, yValueMapper: y, color: pal[0])]);
