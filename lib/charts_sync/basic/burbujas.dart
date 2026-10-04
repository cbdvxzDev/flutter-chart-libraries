// 19. Burbujas - Tamaño = margen
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget burbujas() => c(x: nv(g: false), [BubbleSeries<Nm, double>(dataSource: bub, xValueMapper: nx, yValueMapper: ny, sizeValueMapper: ns, minimumRadius: 5, maximumRadius: 20, opacity: .7, color: pal[1])]);
