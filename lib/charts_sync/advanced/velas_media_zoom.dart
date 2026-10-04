// Velas + media + zoom - Candle con MA(5) y zoom
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget velasMediaZoom() => c(x: dx(), zp: ZoomPanBehavior(enablePinching: true, enablePanning: true, enableMouseWheelZooming: true, zoomMode: ZoomMode.x), [
        CandleSeries<Oh, DateTime>(dataSource: ohlc, xValueMapper: (d, _) => d.d, lowValueMapper: (d, _) => d.l, highValueMapper: (d, _) => d.h, openValueMapper: (d, _) => d.o, closeValueMapper: (d, _) => d.c, bullColor: pal[1], bearColor: pal[2], enableSolidCandles: true),
        LineSeries<Tm, DateTime>(dataSource: ma, xValueMapper: tx, yValueMapper: ty, color: pal[0], width: 2.5),
      ]);
