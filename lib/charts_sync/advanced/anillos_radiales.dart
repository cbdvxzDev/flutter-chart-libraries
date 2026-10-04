// 14. Anillos radiales - Esquinas redondeadas
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget anillosRadiales() => p([RadialBarSeries<Pt, String>(dataSource: kpi, xValueMapper: x, yValueMapper: y, maximumValue: 100, radius: '100%', innerRadius: '25%', gap: '8%', cornerStyle: CornerStyle.bothCurve, trackColor: const Color(0xFF808080), trackOpacity: .15, dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: const TextStyle(fontSize: 10)))]);
