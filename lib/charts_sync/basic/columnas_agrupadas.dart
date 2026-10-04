// 10. Columnas agrupadas - Comparativa de orígenes
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget columnasAgrupadas() => c(lg: true, m3((d, n, c) => ColumnSeries<Pt, String>(dataSource: d, xValueMapper: x, yValueMapper: y, name: n, color: c, spacing: .1)));
