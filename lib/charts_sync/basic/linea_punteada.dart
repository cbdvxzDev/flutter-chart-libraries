// Línea punteada - Meta vs. real
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget lineaPunteada() => c(lg: true, [
        LineSeries<Pt, String>(dataSource: s1, xValueMapper: x, yValueMapper: y, name: 'Real', width: 3),
        LineSeries<Pt, String>(dataSource: s2, xValueMapper: x, yValueMapper: y, name: 'Meta', width: 2, dashArray: const <double>[6, 4]),
      ]);
