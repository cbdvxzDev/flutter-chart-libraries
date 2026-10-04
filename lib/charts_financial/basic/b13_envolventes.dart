// Básica 13 · Envolventes de porcentaje fijo
import 'package:flutter/material.dart';

import '../common.dart';

Widget b13Envolventes() => FcView(build: (d) {
      final inner = envelope(d.c, pct: 0.03);
      final outer = envelope(d.c, pct: 0.06);
      d.add('m', inner.mid, label: 'SMA 20');
      d.add('u3', inner.up, label: '+3 %');
      d.add('l3', inner.lo, label: '−3 %');
      d.add('u6', outer.up, label: '+6 %');
      d.add('l6', outer.lo, label: '−6 %');
      return fcChart(d, [
        fcPanel(
          scale: [kH, kL, 'u6', 'l6'],
          graphs: [
            fcArea('u6', fcOrange, baseKey: 'l6', alpha: 0.08, w: 1),
            fcArea('u3', fcOrange, baseKey: 'l3', alpha: 0.14, w: 1),
            fcLine('m', fcOrange, w: 1.6),
            fcLine(kC, fcInk, w: 1.4),
          ],
          tooltip: fcTip([kC, 'u6', 'u3', 'm', 'l3', 'l6'], follow: kC),
        ),
      ]);
    });
