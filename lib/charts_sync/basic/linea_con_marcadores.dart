// 2. Línea con marcadores - Ventas por origen
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget lineaConMarcadores() => c(lg: true, m3((d, n, c) => LineSeries<Pt, String>(dataSource: d, xValueMapper: x, yValueMapper: y, name: n, color: c, width: 2.5, markerSettings: MarkerSettings(isVisible: true))));
