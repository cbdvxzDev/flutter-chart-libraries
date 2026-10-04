// 34. Cascada - Del ingreso a la utilidad
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget cascada() => c([WaterfallSeries<Pt, String>(dataSource: wf, xValueMapper: x, yValueMapper: y, intermediateSumPredicate: (d, _) => d.x == 'Subtotal', totalSumPredicate: (d, _) => d.x == 'Total', pointColorMapper: (d, i) => (d.x == 'Subtotal' || d.x == 'Total') ? pal[0] : (d.y < 0 ? pal[2] : pal[1]), borderRadius: BorderRadius.circular(5), dataLabelSettings: dls)]);
