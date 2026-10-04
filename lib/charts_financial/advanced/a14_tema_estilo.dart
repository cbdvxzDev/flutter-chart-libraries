// Avanzada 14 · Tema y estilo de velas combinables
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';
import '../panels.dart';

Widget a14TemaEstilo() => const _A14();

class _A14 extends StatefulWidget {
  const _A14();

  @override
  State<_A14> createState() => _A14State();
}

class _A14State extends FcState<_A14> {
  bool dark = true;
  String paleta = 'clasica';

  // Colores de vela alcista y bajista de cada paleta.
  static const paletas = <String, (Color, Color)>{
    'clasica': (fcUp, fcDown),
    'asiatica': (Color(0xFFE53935), Color(0xFF1E88E5)),
    'mono': (Color(0xFF9E9E9E), Color(0xFF616161)),
    'neon': (Color(0xFF00E676), Color(0xFFFF4081)),
  };

  @override
  GChart buildChart() {
    final (up, down) = paletas[paleta]!;
    return fcChart(
      d,
      [
        fcPricePanel(
          d,
          weight: 0.72,
          price: fcCandles(up: up, down: down, hollow: paleta == 'mono', paper: dark ? fcNight : fcPaper),
        ),
        fcVolumePanel(d, weight: 0.28, timeAxis: true),
      ],
      dark: dark,
    );
  }

  @override
  List<Widget> controls(BuildContext context) => [
        fcSeg<bool>(
          options: const {false: 'Tema claro', true: 'Tema oscuro'},
          value: dark,
          onChanged: (v) {
            dark = v;
            rebuildChart();
          },
        ),
        fcSeg<String>(
          options: const {
            'clasica': 'Clásica',
            'asiatica': 'Asiática',
            'mono': 'Monocroma',
            'neon': 'Neón',
          },
          value: paleta,
          onChanged: (v) {
            paleta = v;
            rebuildChart();
          },
        ),
      ];
}
