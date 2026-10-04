// 8. Ventana de fechas - Eje temporal con rango inicial
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget ventanaDeFechas() => c(x: dx(min: DateTime(2026, 2, 10), max: DateTime(2026, 3, 22)), zp: ZoomPanBehavior(enablePanning: true, zoomMode: ZoomMode.x), [SplineSeries<Tm, DateTime>(dataSource: tm, xValueMapper: tx, yValueMapper: ty, color: pal[1], width: 3)]);
