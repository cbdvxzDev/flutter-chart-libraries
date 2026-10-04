// Datos faltantes - Hueco vs. promedio
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget datosFaltantes() => c(lg: true, [
        LineSeries<Pt, String>(dataSource: s1, xValueMapper: x, yValueMapper: gap, name: 'Hueco', width: 3, emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.gap), markerSettings: MarkerSettings(isVisible: true)),
        LineSeries<Pt, String>(dataSource: s3, xValueMapper: x, yValueMapper: gap, name: 'Promedio', width: 3, emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.average), markerSettings: MarkerSettings(isVisible: true)),
      ]);
