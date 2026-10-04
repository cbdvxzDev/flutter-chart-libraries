// 10. Columnas con degradado - Pista y etiquetas
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget columnasConDegradado() => c([ColumnSeries<Pt, String>(dataSource: s2, xValueMapper: x, yValueMapper: y, gradient: gr(pal[5], pal[0]), width: .55, isTrackVisible: true, trackColor: track, dataLabelSettings: dls, borderRadius: BorderRadius.circular(10))]);
