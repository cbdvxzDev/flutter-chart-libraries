// 18. Sparkline de línea - Máx/mín resaltados
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../common.dart';

Widget sparklineDeLinea() => kpiBox('47.2K', 'Ventas · últimos 12 meses', SfSparkLineChart(data: sp, color: pal[0], axisLineWidth: 0, highPointColor: pal[1], lowPointColor: pal[2], marker: SparkChartMarker(displayMode: SparkChartMarkerDisplayMode.all), trackball: SparkChartTrackball(activationMode: SparkChartActivationMode.tap)));
