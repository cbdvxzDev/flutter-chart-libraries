// 12. Barras con pista - Color por barra
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget barrasConPista() => c([BarSeries<Pt, String>(dataSource: cats, xValueMapper: x, yValueMapper: y, pointColorMapper: (d, i) => pal[i % 8], isTrackVisible: true, trackColor: track, dataLabelSettings: dls, borderRadius: BorderRadius.circular(8))]);
