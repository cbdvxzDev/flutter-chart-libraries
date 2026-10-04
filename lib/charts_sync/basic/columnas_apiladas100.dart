// 24. Columnas apiladas 100% - Participación
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget columnasApiladas100() => c(lg: true, y: nv(fmt: '{value}%'), m3((d, n, c) => StackedColumn100Series<Pt, String>(dataSource: d, xValueMapper: x, yValueMapper: y, name: n, color: c)));
