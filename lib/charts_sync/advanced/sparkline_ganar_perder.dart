// 21. Sparkline ganar/perder - Días sobre/bajo la meta
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../common.dart';

Widget sparklineGanarPerder() => kpiBox('9 / 15', 'Días sobre meta', SfSparkWinLossChart(data: wl, color: pal[1], negativePointColor: pal[2], tiePointColor: pal[7]));
