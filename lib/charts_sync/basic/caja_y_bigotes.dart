// 36. Caja y bigotes - Pedidos por día
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget cajaYBigotes() => c([BoxAndWhiskerSeries<Bx, String>(dataSource: box, xValueMapper: (d, _) => d.x, yValueMapper: (d, _) => d.v, boxPlotMode: BoxPlotMode.normal, showMean: true, spacing: .3, color: pal[4])]);
