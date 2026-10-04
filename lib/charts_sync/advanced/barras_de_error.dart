// Barras de error - Incertidumbre ±6
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget barrasDeError() => c([
        LineSeries<Pt, String>(dataSource: s2, xValueMapper: x, yValueMapper: y, color: pal[0], width: 2.5, markerSettings: MarkerSettings(isVisible: true)),
        ErrorBarSeries<Pt, String>(dataSource: s2, xValueMapper: x, yValueMapper: y, type: ErrorBarType.fixed, verticalErrorValue: 6),
      ]);
