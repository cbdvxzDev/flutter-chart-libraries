// 5. Línea escalonada - Precio por kilo
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget lineaEscalonada() => c([StepLineSeries<Pt, String>(dataSource: s2, xValueMapper: x, yValueMapper: y, color: pal[5], width: 3)]);
