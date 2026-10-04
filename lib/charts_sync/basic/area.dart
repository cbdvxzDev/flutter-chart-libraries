// 13. Área - Visitas al local
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget area() => c([AreaSeries<Pt, String>(dataSource: s1, xValueMapper: x, yValueMapper: y, color: pal[0], opacity: .5, borderColor: pal[0], borderWidth: 2, borderDrawMode: BorderDrawMode.top)]);
