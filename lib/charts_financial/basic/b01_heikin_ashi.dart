// Básica 01 · Velas Heikin-Ashi
import 'package:flutter/material.dart';

import '../common.dart';

Widget b01HeikinAshi() => FcView(build: (d) {
      // Cada vela se promedia con la anterior: las rachas quedan del mismo color.
      final ha = heikinAshi(d.o, d.h, d.l, d.c);
      d.add('haO', ha.o, label: 'HA apertura');
      d.add('haH', ha.h, label: 'HA máximo');
      d.add('haL', ha.l, label: 'HA mínimo');
      d.add('haC', ha.c, label: 'HA cierre');
      const keys = ['haO', 'haH', 'haL', 'haC'];
      return fcChart(d, [
        fcPanel(
          scale: ['haH', 'haL'],
          graphs: [fcCandles(keys: keys)],
          tooltip: fcTip(keys, follow: 'haC'),
        ),
      ]);
    });
