// 2. Trackball agrupado - Toca para comparar series
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget trackballAgrupado() => c(lg: true, tt: false, tb: TrackballBehavior(enable: true, activationMode: ActivationMode.singleTap, tooltipDisplayMode: TrackballDisplayMode.groupAllPoints), m3((d, n, c) => SplineSeries<Pt, String>(dataSource: d, xValueMapper: x, yValueMapper: y, name: n, color: c, width: 2.5)));
