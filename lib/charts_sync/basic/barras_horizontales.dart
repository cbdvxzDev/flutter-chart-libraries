// 11. Barras horizontales - Ranking de bebidas
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget barrasHorizontales() => c([BarSeries<Pt, String>(dataSource: cats, xValueMapper: x, yValueMapper: y, color: pal[5], borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)))]);
