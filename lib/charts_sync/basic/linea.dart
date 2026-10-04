// 1. Línea - Ventas mensuales
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget linea() => c([LineSeries<Pt, String>(dataSource: s1, xValueMapper: x, yValueMapper: y, color: pal[0], width: 3)]);
