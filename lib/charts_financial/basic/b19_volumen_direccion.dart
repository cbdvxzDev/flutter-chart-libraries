// Básica 19 · Volumen por dirección
import 'package:flutter/material.dart';

import '../common.dart';

Widget b19VolumenDireccion() => FcView(build: (d) {
      // El volumen se parte en dos series: la de días al alza y la de días a
      // la baja. Cada una se pinta de su color.
      d.add('vUp', [for (var i = 0; i < d.n; i++) d.c[i] >= d.o[i] ? d.v[i] : 0.0],
          label: 'Volumen al alza', precision: 0);
      d.add('vDn', [for (var i = 0; i < d.n; i++) d.c[i] < d.o[i] ? d.v[i] : 0.0],
          label: 'Volumen a la baja', precision: 0);
      return fcChart(d, [
        fcPanel(
          scale: [kV],
          min: 0,
          marginBottom: 0,
          precision: 0,
          graphs: [
            fcBars('vUp', up: fcUp),
            fcBars('vDn', up: fcDown),
          ],
          tooltip: fcTip([kV]),
        ),
      ], barWidth: 10);
    });
