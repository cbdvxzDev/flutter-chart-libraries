// Eje logarítmico - Crecimiento exponencial
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget ejeLogaritmico() => c(y: LogarithmicAxis(labelStyle: ts, axisLine: AxisLine(width: 0), majorTickLines: MajorTickLines(size: 0), majorGridLines: MajorGridLines(color: grid)), [
        ColumnSeries<Pt, String>(dataSource: exp, xValueMapper: x, yValueMapper: y, color: pal[0], opacity: .5),
        SplineSeries<Pt, String>(dataSource: exp, xValueMapper: x, yValueMapper: y, color: pal[2], width: 3, markerSettings: MarkerSettings(isVisible: true)),
      ]);
