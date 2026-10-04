// 17. Áreas superpuestas - Tres sucursales
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget areasSuperpuestas() => c(lg: true, m3((d, n, c) => AreaSeries<Pt, String>(dataSource: d, xValueMapper: x, yValueMapper: y, name: n, color: c, opacity: .55)));
