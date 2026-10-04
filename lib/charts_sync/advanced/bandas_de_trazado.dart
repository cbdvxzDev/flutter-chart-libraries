// Bandas de trazado - Zona objetivo y meta
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget bandasDeTrazado() => c(y: nv(min: 0, max: 120, bands: [
        PlotBand(isVisible: true, start: 50, end: 75, color: pal[1], opacity: .15, text: 'Zona objetivo', textStyle: TextStyle(fontSize: 10, color: pal[1])),
        PlotBand(isVisible: true, start: 95, end: 95, borderWidth: 2, borderColor: pal[2], dashArray: const <double>[6, 4], text: 'Meta 95', textStyle: TextStyle(fontSize: 10, color: pal[2])),
      ]), [ColumnSeries<Pt, String>(dataSource: s1, xValueMapper: x, yValueMapper: y, color: pal[0], borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))]);
