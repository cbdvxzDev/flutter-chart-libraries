// 40. Pirámide - Fidelización
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget piramide() => SfPyramidChart(margin: const EdgeInsets.all(8), palette: pal, tooltipBehavior: TooltipBehavior(enable: true), legend: Legend(isVisible: true, position: LegendPosition.bottom, overflowMode: LegendItemOverflowMode.wrap), series: PyramidSeries<Pt, String>(dataSource: fun, xValueMapper: x, yValueMapper: y, gapRatio: .04, dataLabelSettings: dl()));
