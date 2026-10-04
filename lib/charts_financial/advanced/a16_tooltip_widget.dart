// Avanzada 16 · Tooltip hecho con widgets de Flutter
import 'package:flutter/material.dart';

import '../common.dart';

Widget a16TooltipWidget() => FcView(build: (d) {
      // Se guarda la fuente de datos para poder consultarla desde el tooltip.
      final src = d.source();
      return fcChart(
        d,
        [
          fcPanel(
            scale: [kH, kL],
            graphs: [fcCandles()],
            tooltip: fcTip(
              fcOhlc,
              follow: kC,
              // En vez del recuadro de texto de la librería, se devuelve un
              // widget cualquiera: aquí, una tarjeta con la vela resumida.
              builder: (context, maxSize, tooltip, point) {
                final v = src.getSeriesValueAsMap(point: point, keys: fcOhlc);
                final time = src.getPointValue(point);
                if (v.isEmpty || time == null) return const SizedBox.shrink();
                final change = 100 * (v[kC]! / v[kO]! - 1);
                final color = change >= 0 ? fcUp : fcDown;
                return _Card(
                  date: fcFecha(point, time),
                  color: color,
                  change: change,
                  rows: {
                    'Apertura': v[kO]!,
                    'Máximo': v[kH]!,
                    'Mínimo': v[kL]!,
                    'Cierre': v[kC]!,
                  },
                );
              },
            ),
          ),
        ],
        source: src,
        barWidth: 10,
      );
    });

class _Card extends StatelessWidget {
  const _Card({required this.date, required this.color, required this.change, required this.rows});

  final String date;
  final Color color;
  final double change;
  final Map<String, double> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(change >= 0 ? Icons.trending_up : Icons.trending_down, color: color, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(date, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
              ),
              Text(
                '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)} %',
                style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ],
          ),
          const Divider(height: 12),
          for (final e in rows.entries)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(e.key, style: const TextStyle(fontSize: 12, color: fcGrey)),
                Text(e.value.toStringAsFixed(2), style: const TextStyle(fontSize: 12)),
              ],
            ),
        ],
      ),
    );
  }
}
