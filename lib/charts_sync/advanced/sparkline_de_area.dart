// 19. Sparkline de área - Tendencia compacta
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../common.dart';

Widget sparklineDeArea() => kpiBox('1.284', 'Pedidos · últimos 12 meses', SfSparkAreaChart(data: sp, color: pal[4].withAlpha(90), borderColor: pal[4], borderWidth: 2, axisLineWidth: 0, trackball: SparkChartTrackball(activationMode: SparkChartActivationMode.tap)));
