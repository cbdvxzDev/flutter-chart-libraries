import 'dart:math';
import 'package:flutter/material.dart';
import 'drawing.dart';

/// Barras de aristas agrupadas por vértice origen, en el orden en que las
/// entrega el grafo. Altura = peso, etiqueta = destino, color = origen.
class SortedEdgesPainter extends CustomPainter {
  SortedEdgesPainter(this.edges);
  final Map<String, Map<String, int>> edges;

  @override
  void paint(Canvas canvas, Size size) {
    final groups = [
      for (final e in edges.entries)
        if (e.value.isNotEmpty) e,
    ];
    final total = groups.fold<int>(0, (a, g) => a + g.value.length);
    if (total == 0) return;

    var maxW = 1;
    for (final g in groups) {
      for (final w in g.value.values) {
        maxW = max(maxW, w);
      }
    }
    final sc = niceScale(0, maxW.toDouble());
    final plot = Rect.fromLTRB(34, 14, size.width - 10, size.height - 44);
    const gap = 10.0;
    final slotW = (plot.width - gap * (groups.length - 1)) / total;

    drawGrid(canvas, plot, 0, sc.hi, sc.step, valueOnY: true);

    var x = plot.left;
    var gi = 0;
    for (final g in groups) {
      final color = colorFor(gi++);
      final startX = x;
      for (final t in g.value.entries) {
        final h = t.value / sc.hi * plot.height;
        final rect = Rect.fromLTWH(x + slotW * 0.12, plot.bottom - h, slotW * 0.76, h);
        canvas.drawRect(rect, Paint()..color = color);
        drawText(canvas, '${t.value}', Offset(rect.center.dx, rect.top - 2),
            size: 9, alignment: Alignment.bottomCenter);
        drawText(canvas, t.key, Offset(rect.center.dx, plot.bottom + 4),
            size: 11, bold: true, alignment: Alignment.topCenter);
        x += slotW;
      }
      final y = plot.bottom + 22;
      canvas.drawLine(
        Offset(startX + 2, y),
        Offset(x - 2, y),
        Paint()
          ..color = color
          ..strokeWidth = 2.5,
      );
      drawText(canvas, g.key, Offset((startX + x) / 2, y + 3),
          size: 12, bold: true, color: color, alignment: Alignment.topCenter);
      x += gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
