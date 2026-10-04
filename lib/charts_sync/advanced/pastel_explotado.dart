// 12. Pastel explotado - Etiquetas externas con conector
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget pastelExplotado() => p(lg: false, [PieSeries<Pt, String>(dataSource: cats, xValueMapper: x, yValueMapper: y, radius: '70%', explode: true, explodeIndex: 0, explodeOffset: '10%', dataLabelSettings: DataLabelSettings(isVisible: true, labelPosition: ChartDataLabelPosition.outside, connectorLineSettings: ConnectorLineSettings(type: ConnectorType.curve), textStyle: const TextStyle(fontSize: 10)))]);
