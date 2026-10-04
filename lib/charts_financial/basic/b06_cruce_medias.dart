// Básica 06 · Cruce de medias con señales
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget b06CruceMedias() => FcView(build: (d) {
      final fast = sma(d.c, 20);
      final slow = sma(d.c, 50);
      d.add('s20', fast, label: 'SMA 20');
      d.add('s50', slow, label: 'SMA 50');
      // Señal cuando la media rápida cruza a la lenta.
      final signals = <GOverlayMarker>[];
      for (var i = 1; i < d.n; i++) {
        if (fast[i - 1].isNaN || slow[i - 1].isNaN) continue;
        final before = fast[i - 1] - slow[i - 1];
        final now = fast[i] - slow[i];
        if (before <= 0 && now > 0) signals.add(fcBuy(i, d.l[i]));
        if (before >= 0 && now < 0) signals.add(fcSell(i, d.h[i]));
      }
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL],
          graphs: [
            fcCandles(),
            fcLine('s50', fcPurple, w: 1.8),
            fcLine(
              's20',
              fcOrange,
              w: 1.8,
              markers: [...fcLegend(const {'SMA 20': fcOrange, 'SMA 50': fcPurple}), ...signals],
            ),
          ],
          tooltip: fcTip([kC, 's20', 's50'], follow: kC),
        ),
      ]);
    });
