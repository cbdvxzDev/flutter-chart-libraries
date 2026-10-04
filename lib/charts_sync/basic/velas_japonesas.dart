// 31. Velas japonesas - Precio del grano
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget velasJaponesas() => c(x: dx(), [CandleSeries<Oh, DateTime>(dataSource: ohlc, xValueMapper: (d, _) => d.d, lowValueMapper: (d, _) => d.l, highValueMapper: (d, _) => d.h, openValueMapper: (d, _) => d.o, closeValueMapper: (d, _) => d.c, bullColor: pal[1], bearColor: pal[2], enableSolidCandles: true)]);
