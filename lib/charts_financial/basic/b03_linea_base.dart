// Básica 03 · Línea base bicolor
import 'package:flutter/material.dart';

import '../common.dart';

Widget b03LineaBase() => FcView(build: (d) {
      // La base es el precio medio del periodo: verde por encima, rojo por debajo.
      final base = d.c.reduce((a, b) => a + b) / d.n;
      return fcChart(d, [
        fcPanel(
          scale: [kC],
          graphs: [
            fcArea(
              kC,
              fcUp,
              base: base,
              below: fcDown,
              markers: [
                fcHLine(base, fcGrey, dash: const [5, 4]),
                fcLabel(
                  'Línea base ${base.toStringAsFixed(2)}',
                  atValue(0.01, base),
                  align: Alignment.topRight,
                  color: fcGrey,
                ),
              ],
            ),
          ],
          tooltip: fcTip([kC], follow: kC),
        ),
      ]);
    });
