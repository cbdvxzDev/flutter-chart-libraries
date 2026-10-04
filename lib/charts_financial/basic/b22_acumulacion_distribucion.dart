// Básica 22 · Línea de acumulación/distribución
import 'package:flutter/material.dart';

import '../common.dart';

Widget b22AcumulacionDistribucion() => FcView(build: (d) {
      d.add('ad', adLine(d.h, d.l, d.c, d.v), label: 'A/D', precision: 0);
      return fcChart(d, [
        fcPanel(
          scale: ['ad'],
          precision: 0,
          graphs: [
            // Por encima de cero domina la compra (acumulación); por debajo,
            // la venta (distribución).
            fcArea(
              'ad',
              fcUp,
              base: 0,
              below: fcDown,
              w: 1.8,
              markers: [fcHLine(0, fcGrey)],
            ),
          ],
          tooltip: fcTip(['ad'], follow: 'ad'),
        ),
      ]);
    });
