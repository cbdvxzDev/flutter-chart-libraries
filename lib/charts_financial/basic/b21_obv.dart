// Básica 21 · OBV (On-Balance Volume)
import 'package:flutter/material.dart';

import '../common.dart';

Widget b21Obv() => FcView(build: (d) {
      final o = obv(d.c, d.v);
      d.add('obv', o, label: 'OBV', precision: 0);
      d.add('obvM', sma(o, 20), label: 'Media 20', precision: 0);
      return fcChart(d, [
        fcPanel(
          scale: ['obv'],
          precision: 0,
          graphs: [
            // Sube cuando el volumen entra en días alcistas y baja en bajistas.
            fcArea('obv', fcTeal, alpha: 0.18, w: 1.8),
            fcLine('obvM', fcOrange, w: 1.6),
          ],
          tooltip: fcTip(['obv', 'obvM'], follow: 'obv'),
        ),
      ]);
    });
