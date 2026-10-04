// Avanzada 25 · Mosaico de cuatro activos
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';
import '../panels.dart';

Widget a25MosaicoActivos() => Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _tile('ALFA · velas', 0.016, 0.0010, 0)),
              const SizedBox(width: 8),
              Expanded(child: _tile('BETA · montaña', 0.024, -0.0004, 1)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _tile('GAMA · Heikin-Ashi', 0.020, 0.0006, 2)),
              const SizedBox(width: 8),
              Expanded(child: _tile('DELTA · línea base', 0.012, 0.0002, 3)),
            ],
          ),
        ),
      ],
    );

/// Una gráfica pequeña e independiente: cada una genera su propio activo.
Widget _tile(String name, double vol, double drift, int kind) => FcView(
      n: 140,
      vol: vol,
      drift: drift,
      build: (d) {
        final change = 100 * (d.c[d.last] / d.c[0] - 1);
        final color = change >= 0 ? fcUp : fcDown;
        final title = fcPanelTitle('$name  ${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)} %', color: color);
        final ha = heikinAshi(d.o, d.h, d.l, d.c);
        d.add('haO', ha.o);
        d.add('haH', ha.h);
        d.add('haL', ha.l);
        d.add('haC', ha.c);
        final GGraph graph = switch (kind) {
          0 => fcCandles(markers: [title]),
          1 => fcArea(kC, color, alpha: 0.22, w: 1.6, markers: [title]),
          2 => fcCandles(keys: const ['haO', 'haH', 'haL', 'haC'], markers: [title]),
          _ => fcArea(kC, fcUp, base: d.c[0], below: fcDown, w: 1.6, markers: [title]),
        };
        return fcChart(
          d,
          [
            fcPanel(scale: [kH, kL], marginTop: 0.18, graphs: [graph]),
          ],
          barWidth: 4,
          minSize: const Size(120, 100),
        );
      },
    );
