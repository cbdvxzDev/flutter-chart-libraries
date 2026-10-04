// Básica 30 · ATR (rango verdadero medio)
import 'package:flutter/material.dart';

import '../common.dart';

Widget b30Atr() => FcView(build: (d) {
      d.add('atr', atr(d.h, d.l, d.c), label: 'ATR 14');
      return fcChart(d, [
        fcPanel(
          scale: ['atr'],
          min: 0,
          marginBottom: 0,
          graphs: [
            // No dice hacia dónde va el precio, solo cuánto se mueve cada día.
            fcArea('atr', fcOrange, alpha: 0.20, w: 2),
          ],
          tooltip: fcTip(['atr']),
        ),
      ]);
    });
