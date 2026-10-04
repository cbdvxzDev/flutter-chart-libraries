// 30. Spline de rango - Banda suavizada
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget splineDeRango() => c([SplineRangeAreaSeries<Pt, String>(dataSource: rng, xValueMapper: x, highValueMapper: y, lowValueMapper: y2, color: pal[5], opacity: .5, borderColor: pal[5], borderWidth: 2)]);
