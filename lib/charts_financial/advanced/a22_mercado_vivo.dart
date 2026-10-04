// Avanzada 22 · Mercado en vivo
import 'dart:async';
import 'dart:math' as math;

import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget a22MercadoVivo() => const _A22();

class _A22 extends StatefulWidget {
  const _A22();

  @override
  State<_A22> createState() => _A22State();
}

class _A22State extends FcState<_A22> {
  static const _ticksPerBar = 12;
  final _rnd = math.Random();
  Timer? _timer;
  int _ticks = 0;
  bool running = true;
  late GDataSource<int, GData<int>> _src;
  late GValueAxisMarker _priceTag;
  late GPolyLineMarker _priceLine;

  @override
  FcData createData() => FcData(n: 120);

  @override
  GChart buildChart() {
    _src = d.source();
    final last = d.c[d.last];
    _priceTag = GValueAxisMarker.label(labelValue: last);
    _priceLine = fcHLine(last, fcBlue, dash: const [4, 4]);
    return fcChart(
      d,
      [
        fcPanel(
          scale: [kH, kL],
          valueMarkers: [_priceTag],
          graphs: [
            fcCandles(markers: [_priceLine]),
          ],
        ),
      ],
      source: _src,
      barWidth: 10,
      endSpace: 8,
    );
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 350), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tick() {
    if (!running || !mounted) return;
    final rows = _src.dataList;
    var row = rows.last;
    // Cada tic mueve un poco el precio de la última vela.
    final price = row[3] * (1 + (_rnd.nextDouble() - 0.5) * 0.006);
    _ticks++;
    if (_ticks % _ticksPerBar == 0) {
      // Cada cierto número de tics se cierra la vela y nace una nueva.
      row = GData<int>(
        pointValue: row.pointValue + const Duration(days: 1).inMilliseconds,
        seriesValues: [price, price, price, price, 0.0],
      );
      rows.add(row);
    }
    row[3] = price; // cierre
    row[1] = math.max(row[1], price); // máximo
    row[2] = math.min(row[2], price); // mínimo
    row[4] = row[4] + 20000 + _rnd.nextDouble() * 60000; // volumen
    // La etiqueta del eje y la línea punteada siguen al último precio.
    _priceTag.labelValue = price;
    _priceLine.keyCoordinates[0] = atValue(0, price);
    _priceLine.keyCoordinates[1] = atValue(1, price);
    chart.autoScaleViewports(animation: false);
    repaint();
  }

  @override
  List<Widget> controls(BuildContext context) => [
        Row(
          children: [
            Expanded(child: fcHint('Precio simulado: la última vela se va formando tic a tic.')),
            TextButton.icon(
              onPressed: () => setState(() => running = !running),
              icon: Icon(running ? Icons.pause : Icons.play_arrow, size: 18),
              label: Text(running ? 'Pausar' : 'Reanudar'),
            ),
          ],
        ),
      ];
}
