// 4. Spline múltiple - Tres orígenes
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget splineMultiple() => c(lg: true, m3((d, n, c) => SplineSeries<Pt, String>(dataSource: d, xValueMapper: x, yValueMapper: y, name: n, color: c, width: 2.5)));
