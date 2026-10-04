// 21. Barras apiladas - Total por mes
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget barrasApiladas() => c(lg: true, m3((d, n, c) => StackedBarSeries<Pt, String>(dataSource: d, xValueMapper: x, yValueMapper: y, name: n, color: c)));
