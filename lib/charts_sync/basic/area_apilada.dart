// 22. Área apilada - Acumulado
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget areaApilada() => c(lg: true, m3((d, n, c) => StackedAreaSeries<Pt, String>(dataSource: d, xValueMapper: x, yValueMapper: y, name: n, color: c, opacity: .7)));
