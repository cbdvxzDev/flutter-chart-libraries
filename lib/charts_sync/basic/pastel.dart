// 37. Pastel - Mezcla de ventas
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget pastel() => p([PieSeries<Pt, String>(dataSource: cats, xValueMapper: x, yValueMapper: y, radius: '88%', dataLabelSettings: dl())]);
