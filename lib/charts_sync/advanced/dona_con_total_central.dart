// 13. Dona con total central - Anotación circular
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget donaConTotalCentral() => p(lg: false, [DoughnutSeries<Pt, String>(dataSource: cats, xValueMapper: x, yValueMapper: y, radius: '92%', innerRadius: '68%', cornerStyle: CornerStyle.bothCurve)]).wrapCenter('1.284', 'pedidos');
