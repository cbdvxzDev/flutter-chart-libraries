// 8. Columnas redondeadas - Bordes superiores
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget columnasRedondeadas() => c([ColumnSeries<Pt, String>(dataSource: s2, xValueMapper: x, yValueMapper: y, color: pal[1], width: .6, borderRadius: const BorderRadius.vertical(top: Radius.circular(8)))]);
