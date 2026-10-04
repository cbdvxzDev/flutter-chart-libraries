// 11. Línea por segmentos - Color según umbral
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget lineaPorSegmentos() => c([LineSeries<Pt, String>(dataSource: s1, xValueMapper: x, yValueMapper: y, width: 4, pointColorMapper: (d, i) => d.y > 70 ? pal[1] : (d.y > 55 ? pal[3] : pal[2]), markerSettings: MarkerSettings(isVisible: true))]);
