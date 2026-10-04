// 20. Columnas apiladas - Total por mes
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget columnasApiladas() => c(lg: true, m3((d, n, c) => StackedColumnSeries<Pt, String>(dataSource: d, xValueMapper: x, yValueMapper: y, name: n, color: c)));
