// 32. OHLC - Apertura/Máx/Mín/Cierre
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget ohlcChart() => c(x: dx(), [HiloOpenCloseSeries<Oh, DateTime>(dataSource: ohlc, xValueMapper: (d, _) => d.d, lowValueMapper: (d, _) => d.l, highValueMapper: (d, _) => d.h, openValueMapper: (d, _) => d.o, closeValueMapper: (d, _) => d.c, bullColor: pal[1], bearColor: pal[2])]);
