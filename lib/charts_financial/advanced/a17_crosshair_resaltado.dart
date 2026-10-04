// Avanzada 17 · Retícula con puntos resaltados sobre cada serie
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget a17CrosshairResaltado() => FcView(build: (d) {
      // backfill: el punto resaltado necesita un valor en todas las barras, así
      // que el arranque de cada media se rellena con su primer valor.
      d.add('s20', backfill(sma(d.c, 20)), label: 'SMA 20');
      d.add('s50', backfill(sma(d.c, 50)), label: 'SMA 50');
      return fcChart(
        d,
        [
          fcPanel(
            scale: [kC, 's20', 's50'],
            graphs: [
              fcArea(kC, fcBlue, alpha: 0.10, w: 1.6),
              // crosshairKeys: la serie dibuja un punto donde la corta la
              // línea vertical de la retícula.
              fcLine(kC, fcBlue, w: 1.6, crosshairKeys: const [kC]),
              fcLine('s20', fcOrange, w: 1.6, crosshairKeys: const ['s20']),
              fcLine('s50', fcPurple, w: 1.6, crosshairKeys: const ['s50']),
            ],
            // El recuadro de valores se queda fijo en la esquina.
            tooltip: fcTip([kC, 's20', 's50'], position: GTooltipPosition.topLeft),
          ),
        ],
        crosshair: GCrosshair(
          // La línea salta de barra en barra en vez de seguir al cursor.
          snapToPoint: true,
          // En pantallas táctiles aparece también con un toque.
          updateStrategy: GCrosshairUpdateStrategyDefault(withTap: true),
          theme: GThemeLight.crosshairThemeDefault.copyWith(
            lineStyle: PaintStyle(strokeColor: fcInk, strokeWidth: 1, dash: const [2, 3]),
          ),
        ),
      );
    });
