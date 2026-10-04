// 6. Tendencia polinómica - Orden 3
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget tendenciaPolinomica() => c([ColumnSeries<Pt, String>(dataSource: s1, xValueMapper: x, yValueMapper: y, color: pal[6], opacity: .8, trendlines: <Trendline>[Trendline(type: TrendlineType.polynomial, polynomialOrder: 3, color: pal[5], width: 3)])]);
