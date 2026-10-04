// 15. Spline Area - Área curva
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget splineArea() => c([SplineAreaSeries<Pt, String>(dataSource: s1, xValueMapper: x, yValueMapper: y, gradient: gr(pal[5].withAlpha(210)), borderColor: pal[5], borderWidth: 2.5)]);
