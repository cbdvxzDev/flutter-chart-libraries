// Avanzada 30 · Canal de regresión lineal
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget a30CanalRegresion() => FcView(build: (d) {
      // Recta que mejor se ajusta a los últimos 90 cierres, con un canal de
      // ±2 desviaciones a cada lado.
      final from = d.last - 90;
      final to = d.last;
      final reg = linreg(d.c, from, to);
      double y(int i, double k) => reg.intercept + reg.slope * i + k * reg.sd;
      final daily = 100 * reg.slope / d.c[from];
      final color = reg.slope >= 0 ? fcUp : fcDown;
      // Dos series constantes con los extremos del canal, para que la escala
      // siempre lo incluya entero.
      final top = [y(from, 2), y(to, 2)].reduce((a, b) => a > b ? a : b);
      final bottom = [y(from, -2), y(to, -2)].reduce((a, b) => a < b ? a : b);
      d.add('top', List<double>.filled(d.n, top));
      d.add('bottom', List<double>.filled(d.n, bottom));
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL, 'top', 'bottom'],
          graphs: [
            fcCandles(
              ratio: 0.6,
              markers: [
                GPolygonMarker(
                  coordinates: [at(from, y(from, 2)), at(to, y(to, 2)), at(to, y(to, -2)), at(from, y(from, -2))],
                  theme: fcMk(fill: color.withValues(alpha: 0.12), stroke: color, w: 1),
                ),
                fcPath([at(from, y(from, 0)), at(to, y(to, 0))], color, w: 2.2),
                fcPath([at(from, y(from, 1)), at(to, y(to, 1))], color, w: 1, dash: const [4, 4]),
                fcPath([at(from, y(from, -1)), at(to, y(to, -1))], color, w: 1, dash: const [4, 4]),
                fcCallout(
                  'Pendiente: ${daily >= 0 ? '+' : ''}${daily.toStringAsFixed(2)} % por barra\n'
                  'Canal: ±2σ = ±${(2 * reg.sd).toStringAsFixed(2)}',
                  at(to, y(to, 2)),
                  align: Alignment.topLeft,
                  color: color,
                ),
              ],
            ),
          ],
        ),
      ], barWidth: 6, endSpace: 8);
    });
