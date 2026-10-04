// Básica 32 · Aroon
import 'package:flutter/material.dart';

import '../common.dart';

Widget b32Aroon() => FcView(build: (d) {
      final ar = aroon(d.h, d.l);
      d.add('arUp', ar.up, label: 'Aroon alcista');
      d.add('arDn', ar.down, label: 'Aroon bajista');
      return fcChart(d, [
        fcPanel(
          scale: ['arUp', 'arDn'],
          min: 0,
          max: 100,
          precision: 0,
          graphs: [
            // El relleno muestra quién manda: verde si el último máximo es más
            // reciente que el último mínimo.
            fcArea('arUp', fcUp, baseKey: 'arDn', below: fcDown, alpha: 0.14, border: false),
            fcLine('arDn', fcDown, w: 1.6),
            fcLine('arUp', fcUp, w: 1.6),
          ],
          tooltip: fcTip(['arUp', 'arDn']),
        ),
      ]);
    });
