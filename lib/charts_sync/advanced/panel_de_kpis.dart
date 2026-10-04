// Panel de KPIs - Cuatro sparklines en una tarjeta
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../common.dart';

Widget panelDeKpis() {
    const names = ['Ventas', 'Pedidos', 'Ticket', 'Reseñas'];
    const vals = ['48.2K', '1.284', '37.5', '4.8 ★'];
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(children: [
        for (var i = 0; i < 4; i++)
          Expanded(
            child: Row(children: [
              Expanded(child: Text(names[i], style: const TextStyle(fontWeight: FontWeight.w600))),
              SizedBox(
                width: 130,
                child: i.isEven
                    ? SfSparkLineChart(data: [for (final e in sp) e + math.sin(e * (i + 1)) * 6], color: pal[i], axisLineWidth: 0)
                    : SfSparkAreaChart(data: [for (final e in sp) e + math.sin(e * (i + 1)) * 6], color: pal[i].withAlpha(80), borderColor: pal[i], borderWidth: 2, axisLineWidth: 0),
              ),
              SizedBox(width: 62, child: Text(vals[i], textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w800))),
            ]),
          ),
      ]),
    );
  }
