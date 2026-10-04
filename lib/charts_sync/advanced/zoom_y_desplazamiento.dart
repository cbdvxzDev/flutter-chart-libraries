// 1. Zoom y desplazamiento - Pellizca, arrastra o rueda del mouse
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget zoomYDesplazamiento() => c(x: dx(), zp: ZoomPanBehavior(enablePinching: true, enablePanning: true, enableMouseWheelZooming: true, enableDoubleTapZooming: true, zoomMode: ZoomMode.x), [AreaSeries<Tm, DateTime>(dataSource: tm, xValueMapper: tx, yValueMapper: ty, gradient: gr(pal[0].withAlpha(210)), borderColor: pal[0], borderWidth: 2, borderDrawMode: BorderDrawMode.top)]);
