// 6. Línea rápida - 2.000 puntos de sensor
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget lineaRapida() => c(x: nv(g: false), [FastLineSeries<Nm, double>(dataSource: fast, xValueMapper: nx, yValueMapper: ny, color: pal[6], width: 1.5)]);
