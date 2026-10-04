// Básica 09 · VWAP (precio medio ponderado por volumen)
import 'package:flutter/material.dart';

import '../common.dart';

Widget b09Vwap() => FcView(build: (d) {
      d.add('vwap', vwap(d.h, d.l, d.c, d.v), label: 'VWAP');
      return fcChart(d, [
        fcPanel(
          scale: [kC, 'vwap'],
          graphs: [
            // Relleno entre el cierre y el VWAP: verde si se paga más caro que
            // el promedio ponderado, rojo si se paga más barato.
            fcArea(kC, fcUp, baseKey: 'vwap', below: fcDown, border: false),
            fcLine(kC, fcInk, w: 1.2),
            fcLine(
              'vwap',
              fcOrange,
              w: 2.2,
              markers: fcLegend(const {'Cierre': fcInk, 'VWAP': fcOrange}),
            ),
          ],
          tooltip: fcTip([kC, 'vwap', kV], follow: kC),
        ),
      ]);
    });
