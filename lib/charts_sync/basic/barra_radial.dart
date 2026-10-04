// 39. Barra radial - Cumplimiento de metas
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget barraRadial() => p([RadialBarSeries<Pt, String>(dataSource: kpi, xValueMapper: x, yValueMapper: y, maximumValue: 100, radius: '95%', innerRadius: '30%', gap: '5%', trackColor: const Color(0xFF808080), trackOpacity: .15, dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: const TextStyle(fontSize: 10)))]);
