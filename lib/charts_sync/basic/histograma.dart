// 35. Histograma - Ticket promedio
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget histograma() => c(x: nv(g: false), [HistogramSeries<Nm, double>(dataSource: hist, yValueMapper: ny, binInterval: 10, showNormalDistributionCurve: true, curveColor: pal[2], color: pal[0], width: .98)]);
