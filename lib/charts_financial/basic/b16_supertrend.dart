// Básica 16 · SuperTrend
import 'package:flutter/material.dart';

import '../common.dart';

Widget b16Supertrend() => FcView(build: (d) {
      final st = supertrend(d.h, d.l, d.c);
      d.add('st', st.line, label: 'SuperTrend');
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL, 'st'],
          graphs: [
            // El relleno va del cierre al stop: verde mientras el precio está
            // por encima (alcista), rojo cuando cae por debajo (bajista).
            fcArea(kC, fcUp, baseKey: 'st', below: fcDown, alpha: 0.20, border: false),
            fcLine('st', fcInk, w: 1.8),
            fcCandles(ratio: 0.6),
          ],
          tooltip: fcTip([kC, 'st'], follow: kC),
        ),
      ]);
    });
