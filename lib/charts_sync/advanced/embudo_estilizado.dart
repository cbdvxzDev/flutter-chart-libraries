// 17. Embudo estilizado - Cuello ajustado
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget embudoEstilizado() => SfFunnelChart(margin: const EdgeInsets.all(10), palette: pal, tooltipBehavior: TooltipBehavior(enable: true), series: FunnelSeries<Pt, String>(dataSource: fun, xValueMapper: x, yValueMapper: y, neckWidth: '15%', neckHeight: '25%', gapRatio: .05, pointColorMapper: (d, i) => pal[i % 8], dataLabelSettings: dl()));
