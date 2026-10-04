// 5. Tendencia lineal - Regresión sobre dispersión
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget tendenciaLineal() => c(x: nv(g: false), [ScatterSeries<Nm, double>(dataSource: sc, xValueMapper: nx, yValueMapper: ny, color: pal[4], opacity: .7, markerSettings: MarkerSettings(isVisible: true, height: 9, width: 9), trendlines: <Trendline>[Trendline(type: TrendlineType.linear, color: pal[2], width: 3, dashArray: const <double>[6, 4])])]);
