// Dispersión por formas - Tres segmentos
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget dispersionPorFormas() => c(lg: true, x: nv(g: false), [
        ScatterSeries<Nm, double>(dataSource: sc.sublist(0, 20), xValueMapper: nx, yValueMapper: ny, name: 'Mañana', markerSettings: MarkerSettings(isVisible: true, shape: DataMarkerType.circle, height: 10, width: 10)),
        ScatterSeries<Nm, double>(dataSource: sc.sublist(20, 40), xValueMapper: nx, yValueMapper: ny, name: 'Tarde', markerSettings: MarkerSettings(isVisible: true, shape: DataMarkerType.triangle, height: 11, width: 11)),
        ScatterSeries<Nm, double>(dataSource: sc.sublist(40), xValueMapper: nx, yValueMapper: ny, name: 'Noche', markerSettings: MarkerSettings(isVisible: true, shape: DataMarkerType.diamond, height: 11, width: 11)),
      ]);
