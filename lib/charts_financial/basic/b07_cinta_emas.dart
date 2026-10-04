// Básica 07 · Cinta de medias exponenciales
import 'package:flutter/material.dart';

import '../common.dart';

Widget b07CintaEmas() => FcView(build: (d) {
      // Siete EMAs de periodos crecientes: juntas forman una cinta que se abre
      // en tendencia y se enreda cuando el precio va lateral.
      const periods = [5, 8, 13, 21, 34, 55, 89];
      for (final p in periods) {
        d.add('e$p', ema(d.c, p), label: 'EMA $p');
      }
      return fcChart(d, [
        fcPanel(
          scale: [kC],
          graphs: [
            for (var i = periods.length - 1; i >= 0; i--)
              fcLine(
                'e${periods[i]}',
                Color.lerp(fcAmber, fcIndigo, i / (periods.length - 1))!,
                w: 1.4,
              ),
            fcLine(kC, fcInk, w: 1),
          ],
          tooltip: fcTip([kC, for (final p in periods) 'e$p'], follow: kC),
        ),
      ]);
    });
