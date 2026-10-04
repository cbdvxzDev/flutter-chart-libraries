// 20. Sparkline de barras - Barras mínimas
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../common.dart';

Widget sparklineDeBarras() => kpiBox('4.8 ★', 'Reseñas · por mes', SfSparkBarChart(data: sp, color: pal[5], highPointColor: pal[1], lowPointColor: pal[2], axisLineWidth: 0, trackball: SparkChartTrackball(activationMode: SparkChartActivationMode.tap)));
