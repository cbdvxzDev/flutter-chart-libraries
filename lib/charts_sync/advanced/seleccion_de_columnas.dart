// 4. Selección de columnas - Toca una barra
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget seleccionDeColumnas() => c([ColumnSeries<Pt, String>(dataSource: s1, xValueMapper: x, yValueMapper: y, color: pal[4], borderRadius: const BorderRadius.vertical(top: Radius.circular(8)), selectionBehavior: SelectionBehavior(enable: true, selectedColor: pal[0], unselectedOpacity: .3))]);
