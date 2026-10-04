// Dona doble - Actual vs. proyectado
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget donaDoble() => p(lg: false, [
        DoughnutSeries<Pt, String>(dataSource: cats, xValueMapper: x, yValueMapper: y, radius: '100%', innerRadius: '72%'),
        DoughnutSeries<Pt, String>(dataSource: cats2, xValueMapper: x, yValueMapper: y, radius: '66%', innerRadius: '42%'),
      ]);
