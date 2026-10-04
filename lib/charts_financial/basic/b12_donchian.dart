// Básica 12 · Canal de Donchian
import 'package:flutter/material.dart';

import '../common.dart';

Widget b12Donchian() => FcView(build: (d) {
      final dc = donchian(d.h, d.l);
      d.add('dU', dc.up, label: 'Máximo 20');
      d.add('dL', dc.lo, label: 'Mínimo 20');
      d.add('dM', dc.mid, label: 'Punto medio');
      return fcChart(d, [
        fcPanel(
          scale: ['dU', 'dL'],
          graphs: [
            // El canal avanza en escalones: solo cambia cuando hay un nuevo
            // máximo o mínimo de 20 barras.
            fcArea('dU', fcTeal, baseKey: 'dL', alpha: 0.12, w: 1.6),
            fcLine('dM', fcTeal, w: 1),
            fcCandles(ratio: 0.6),
          ],
          tooltip: fcTip([kC, 'dU', 'dM', 'dL'], follow: kC),
        ),
      ]);
    });
