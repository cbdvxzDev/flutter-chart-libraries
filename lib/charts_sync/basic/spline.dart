// 3. Spline - Curva suavizada
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget spline() => c([SplineSeries<Pt, String>(dataSource: s1, xValueMapper: x, yValueMapper: y, color: pal[4], width: 3)]);
