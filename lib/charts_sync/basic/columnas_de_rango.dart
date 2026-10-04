// 28. Columnas de rango - Mín–máx de temperatura
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget columnasDeRango() => c([RangeColumnSeries<Pt, String>(dataSource: rng, xValueMapper: x, highValueMapper: y, lowValueMapper: y2, color: pal[4], borderRadius: BorderRadius.circular(6))]);
