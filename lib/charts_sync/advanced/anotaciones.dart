// Anotaciones - Widgets sobre el punto máximo
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget anotaciones() {
    final k = s1.indexOf(s1.reduce((a, b) => a.y > b.y ? a : b));
    return c(an: [CartesianChartAnnotation(widget: badge('Pico ${s1[k].y.toInt()}', pal[2]), coordinateUnit: CoordinateUnit.point, region: AnnotationRegion.chart, x: k.toDouble(), y: s1[k].y + 10)],
        [AreaSeries<Pt, String>(dataSource: s1, xValueMapper: x, yValueMapper: y, gradient: gr(pal[4].withAlpha(210)), borderColor: pal[4], borderWidth: 2.5, borderDrawMode: BorderDrawMode.top)]);
  }
