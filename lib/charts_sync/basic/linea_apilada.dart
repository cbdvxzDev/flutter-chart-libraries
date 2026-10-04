// 23. Línea apilada - Acumulado
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget lineaApilada() => c(lg: true, m3((d, n, c) => StackedLineSeries<Pt, String>(dataSource: d, xValueMapper: x, yValueMapper: y, name: n, color: c, width: 2.5)));
