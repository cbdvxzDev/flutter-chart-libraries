// 7. Media móvil - Periodo de 3 meses
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget mediaMovil() => c([LineSeries<Pt, String>(dataSource: s2, xValueMapper: x, yValueMapper: y, color: pal[0], width: 2, markerSettings: MarkerSettings(isVisible: true), trendlines: <Trendline>[Trendline(type: TrendlineType.movingAverage, period: 3, color: pal[2], width: 3)])]);
