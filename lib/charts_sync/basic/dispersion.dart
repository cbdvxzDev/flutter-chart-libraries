// 18. Dispersión - Temperatura vs. ventas
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget dispersion() => c(x: nv(g: false), [ScatterSeries<Nm, double>(dataSource: sc, xValueMapper: nx, yValueMapper: ny, color: pal[0], opacity: .75, markerSettings: MarkerSettings(isVisible: true, height: 10, width: 10))]);
