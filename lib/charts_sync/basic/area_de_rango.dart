// 29. Área de rango - Banda de precios
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget areaDeRango() => c([RangeAreaSeries<Pt, String>(dataSource: rng, xValueMapper: x, highValueMapper: y, lowValueMapper: y2, color: pal[0], opacity: .5, borderColor: pal[0], borderWidth: 2)]);
