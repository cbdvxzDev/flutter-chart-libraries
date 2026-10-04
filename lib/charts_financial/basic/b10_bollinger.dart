// Básica 10 · Bandas de Bollinger
import 'package:flutter/material.dart';

import '../common.dart';

Widget b10Bollinger() => FcView(build: (d) {
      final bb = bollinger(d.c);
      d.add('bbM', bb.mid, label: 'Media 20');
      d.add('bbU', bb.up, label: 'Banda superior');
      d.add('bbL', bb.lo, label: 'Banda inferior');
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL, 'bbU', 'bbL'],
          graphs: [
            // La banda se ensancha cuando sube la volatilidad.
            fcArea('bbU', fcBlue, baseKey: 'bbL', alpha: 0.10, w: 1),
            fcLine('bbM', fcBlue, w: 1),
            fcCandles(),
          ],
          tooltip: fcTip([kC, 'bbU', 'bbM', 'bbL'], follow: kC),
        ),
      ]);
    });
