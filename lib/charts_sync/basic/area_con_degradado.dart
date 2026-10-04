// 14. Área con degradado - Ingresos
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget areaConDegradado() => c([AreaSeries<Pt, String>(dataSource: s2, xValueMapper: x, yValueMapper: y, gradient: gr(pal[4].withAlpha(210)), borderColor: pal[4], borderWidth: 2.5, borderDrawMode: BorderDrawMode.top)]);
