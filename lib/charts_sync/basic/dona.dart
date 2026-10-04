// 38. Dona - Mezcla de ventas
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget dona() => p([DoughnutSeries<Pt, String>(dataSource: cats, xValueMapper: x, yValueMapper: y, radius: '90%', innerRadius: '55%', dataLabelSettings: dl())]);
