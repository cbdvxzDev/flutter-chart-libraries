// 16. Step Area - Inventario
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget stepArea() => c([StepAreaSeries<Pt, String>(dataSource: s3, xValueMapper: x, yValueMapper: y, color: pal[6], opacity: .6, borderColor: pal[6], borderWidth: 2)]);
