// 9. Columnas con etiquetas - Valores visibles
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget columnasConEtiquetas() => c([ColumnSeries<Pt, String>(dataSource: cats, xValueMapper: x, yValueMapper: y, color: pal[4], dataLabelSettings: dls, borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))]);
