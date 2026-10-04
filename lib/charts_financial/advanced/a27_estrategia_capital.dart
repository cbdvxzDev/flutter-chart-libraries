// Avanzada 27 · Estrategia de cruce de medias con curva de capital
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';
import '../panels.dart';

Widget a27EstrategiaCapital() => FcView(
      n: 360,
      build: (d) {
        final fast = sma(d.c, 15);
        final slow = sma(d.c, 45);
        d.add('fast', fast, label: 'SMA 15');
        d.add('slow', slow, label: 'SMA 45');
        // Regla: comprar cuando la media rápida cruza hacia arriba a la lenta
        // y vender cuando cruza hacia abajo. La curva de capital solo se
        // mueve mientras se está dentro del mercado.
        final signals = <GOverlayMarker>[];
        final equity = List<double>.filled(d.n, 100.0, growable: true);
        var inside = false;
        var trades = 0;
        for (var i = 1; i < d.n; i++) {
          equity[i] = inside ? equity[i - 1] * d.c[i] / d.c[i - 1] : equity[i - 1];
          if (fast[i - 1].isNaN || slow[i - 1].isNaN) continue;
          final before = fast[i - 1] - slow[i - 1];
          final now = fast[i] - slow[i];
          if (!inside && before <= 0 && now > 0) {
            inside = true;
            trades++;
            signals.add(fcBuy(i, d.l[i]));
          } else if (inside && before >= 0 && now < 0) {
            inside = false;
            signals.add(fcSell(i, d.h[i]));
          }
        }
        d.add('equity', equity, label: 'Estrategia');
        d.add('hold', base100(d.c), label: 'Comprar y mantener');
        final result = equity[d.last] - 100;
        return fcChart(d, [
          fcPricePanel(
            d,
            weight: 0.58,
            markers: signals,
            over: [fcLine('slow', fcIndigo, w: 1.6), fcLine('fast', fcOrange, w: 1.6)],
            tip: const ['fast', 'slow'],
          ),
          fcPanel(
            weight: 0.42,
            scale: ['equity', 'hold'],
            graphs: [
              fcLine('hold', fcGrey, w: 1.4),
              fcArea(
                'equity',
                fcUp,
                base: 100,
                below: fcDown,
                w: 2,
                markers: [
                  fcHLine(100, fcGrey, dash: const [2, 4]),
                  fcPanelTitle(
                    'Capital (base 100) · $trades operaciones · '
                    '${result >= 0 ? '+' : ''}${result.toStringAsFixed(1)} %',
                    color: result >= 0 ? fcUp : fcDown,
                  ),
                ],
              ),
            ],
            tooltip: fcTip(['equity', 'hold'], position: GTooltipPosition.bottomLeft),
          ),
        ]);
      },
    );
