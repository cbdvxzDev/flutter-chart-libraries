// 16. Pirámide con superficie - Modo surface y etiquetas
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget piramideConSuperficie() => SfPyramidChart(margin: const EdgeInsets.all(10), palette: pal, tooltipBehavior: TooltipBehavior(enable: true), series: PyramidSeries<Pt, String>(dataSource: fun, xValueMapper: x, yValueMapper: y, pyramidMode: PyramidMode.surface, explode: true, gapRatio: .03, dataLabelSettings: DataLabelSettings(isVisible: true, labelPosition: ChartDataLabelPosition.outside, textStyle: const TextStyle(fontSize: 10))));
