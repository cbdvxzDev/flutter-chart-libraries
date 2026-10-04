// 15. Pastel agrupado - Valores < 25 → "Otros"
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget pastelAgrupado() => p([PieSeries<Pt, String>(dataSource: cats, xValueMapper: x, yValueMapper: y, radius: '85%', groupMode: CircularChartGroupMode.value, groupTo: 25, selectionBehavior: SelectionBehavior(enable: true), dataLabelSettings: dl())]);
