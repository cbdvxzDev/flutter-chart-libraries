// Avanzada 01 · Velas y volumen en paneles con divisor
import 'package:flutter/material.dart';

import '../common.dart';
import '../panels.dart';

Widget a01VelasVolumen() => FcView(build: (d) {
      return fcChart(d, [
        fcPricePanel(d, weight: 0.72),
        // El divisor entre los dos paneles se puede arrastrar.
        fcVolumePanel(d, weight: 0.28, timeAxis: true),
      ]);
    });
