// Avanzada 04 · Ichimoku con ADX y volumen
import 'package:flutter/material.dart';

import '../common.dart';
import '../panels.dart';

Widget a04IchimokuAdxVolumen() => FcView(
      n: 340,
      build: (d) {
        final ich = ichimoku(d.h, d.l);
        d.add('conv', ich.conv, label: 'Conversión');
        d.add('base', ich.base, label: 'Base');
        d.add('spanA', ich.spanA, label: 'Span A');
        d.add('spanB', ich.spanB, label: 'Span B');
        // La nube dice hacia dónde va la tendencia y el ADX qué tan fuerte es.
        return fcChart(d, [
          fcPricePanel(
            d,
            weight: 0.56,
            scale: const ['spanA', 'spanB'],
            under: [
              fcArea('spanA', fcUp, baseKey: 'spanB', below: fcDown, alpha: 0.18, w: 1),
              fcLine('base', fcDown, w: 1.2),
              fcLine('conv', fcBlue, w: 1.2),
            ],
            tip: const ['conv', 'base'],
          ),
          fcAdxPanel(d, weight: 0.24),
          fcVolumePanel(d, weight: 0.20, timeAxis: true),
        ]);
      },
    );
