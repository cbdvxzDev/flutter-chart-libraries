// 3. Crosshair - Líneas guía al tocar
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget crosshair() => c(tt: false, ch: CrosshairBehavior(enable: true, activationMode: ActivationMode.singleTap, lineType: CrosshairLineType.both), [LineSeries<Pt, String>(dataSource: s1, xValueMapper: x, yValueMapper: y, color: pal[5], width: 3, markerSettings: MarkerSettings(isVisible: true))]);
