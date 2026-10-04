// Medidor semicircular - Avance de la meta
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../common.dart';

Widget medidorSemicircular() => Stack(alignment: Alignment.center, children: [
        p(lg: false, cy: '70%', [DoughnutSeries<Pt, String>(dataSource: const [Pt('Completado', 74), Pt('Pendiente', 26)], xValueMapper: x, yValueMapper: y, startAngle: 270, endAngle: 90, radius: '110%', innerRadius: '70%', cornerStyle: CornerStyle.bothCurve, pointColorMapper: (d, i) => i == 0 ? pal[1] : track)]),
        const Align(alignment: Alignment(0, .35), child: Text('74%', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800))),
      ]);
