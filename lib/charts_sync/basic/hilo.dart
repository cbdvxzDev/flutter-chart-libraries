// 33. HiLo - Rango diario
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget hilo() => c(x: dx(), [HiloSeries<Oh, DateTime>(dataSource: ohlc, xValueMapper: (d, _) => d.d, lowValueMapper: (d, _) => d.l, highValueMapper: (d, _) => d.h, color: pal[4], borderWidth: 2)]);
