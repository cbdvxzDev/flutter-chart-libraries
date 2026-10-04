import 'dart:math';
import 'package:flutter/material.dart';
import 'drawing.dart';

/// Histograma de [values] con intervalos de [binWidth]. Se puede dibujar solo
/// el polígono de frecuencias ([polygon]) o añadir la curva de densidad (KDE).
class HistogramPainter extends CustomPainter {
  HistogramPainter({
    required this.values,
    this.binWidth = 5,
    this.bars = true,
    this.polygon = false,
    this.density = false,
  });

  final List<double> values;
  final double binWidth;
  final bool bars, polygon, density;

  @override
  void paint(Canvas canvas, Size size) {
    final n = values.length;
    if (n == 0) return;
    final maxV = values.fold(0.0, (a, v) => max(a, v));
    final nb = (maxV / binWidth).floor() + 1;
    final counts = List<int>.filled(nb, 0);
    for (final v in values) {
      counts[min((v / binWidth).floor(), nb - 1)]++;
    }
    final pad = polygon ? 1 : 0;
    final lo = -pad * binWidth;
    final hi = (nb + pad) * binWidth;

    // Densidad de núcleo gaussiano, escalada a "conteos por intervalo".
    final mean = values.fold(0.0, (a, v) => a + v) / n;
    final variance = values.fold(0.0, (a, v) => a + (v - mean) * (v - mean)) / n;
    final bw = max(1.06 * sqrt(variance) * pow(n, -0.2).toDouble(), 0.5);
    double dens(double x) {
      var s = 0.0;
      for (final v in values) {
        final z = (x - v) / bw;
        s += exp(-0.5 * z * z);
      }
      return s * binWidth / (bw * sqrt(2 * pi));
    }

    final curve = <Offset>[];
    var maxDens = 0.0;
    if (density) {
      const samples = 90;
      for (var i = 0; i <= samples; i++) {
        final x = lo + (hi - lo) * i / samples;
        final y = dens(x);
        maxDens = max(maxDens, y);
        curve.add(Offset(x, y));
      }
    }

    final maxCount = counts.fold(0, (a, c) => max(a, c)).toDouble();
    final sc = niceScale(0, max(maxCount, maxDens));
    final plot = Rect.fromLTRB(40, 20, size.width - 16, size.height - 30);
    double xAt(double v) => plot.left + (v - lo) / (hi - lo) * plot.width;
    double yAt(double c) => plot.bottom - c / sc.hi * plot.height;

    drawGrid(canvas, plot, 0, sc.hi, sc.step, valueOnY: true);
    for (var k = 0; k <= nb; k++) {
      drawText(canvas, fmt(k * binWidth), Offset(xAt(k * binWidth), plot.bottom + 6),
          size: 10, color: kMuted, alignment: Alignment.topCenter);
    }

    if (bars) {
      for (var i = 0; i < nb; i++) {
        if (counts[i] == 0) continue;
        final rect = Rect.fromLTRB(xAt(i * binWidth), yAt(counts[i].toDouble()),
            xAt((i + 1) * binWidth), plot.bottom);
        canvas.drawRect(rect, Paint()..color = colorFor(0).withAlpha(215));
        canvas.drawRect(
            rect,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.2
              ..color = Colors.white);
        drawText(canvas, '${counts[i]}', Offset(rect.center.dx, rect.top - 2),
            size: 10, bold: true, alignment: Alignment.bottomCenter);
      }
    }

    if (polygon) {
      final pts = [
        for (var i = -1; i <= nb; i++)
          Offset(xAt((i + 0.5) * binWidth),
              yAt(i >= 0 && i < nb ? counts[i].toDouble() : 0)),
      ];
      final line = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (var i = 1; i < pts.length; i++) {
        line.lineTo(pts[i].dx, pts[i].dy);
      }
      final fill = Path.from(line)
        ..lineTo(pts.last.dx, plot.bottom)
        ..lineTo(pts.first.dx, plot.bottom)
        ..close();
      canvas.drawPath(fill, Paint()..color = colorFor(2).withAlpha(55));
      canvas.drawPath(
          line,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5
            ..color = colorFor(2));
      for (var i = 0; i < pts.length; i++) {
        canvas.drawCircle(pts[i], 4, Paint()..color = colorFor(2));
        final interior = i > 0 && i < pts.length - 1;
        if (interior && counts[i - 1] > 0) {
          drawText(canvas, '${counts[i - 1]}', pts[i] - const Offset(0, 8),
              size: 10, bold: true, alignment: Alignment.bottomCenter);
        }
      }
    }

    if (density && curve.isNotEmpty) {
      canvas.save();
      canvas.clipRect(plot);
      final path = Path()..moveTo(xAt(curve.first.dx), yAt(curve.first.dy));
      for (final c in curve.skip(1)) {
        path.lineTo(xAt(c.dx), yAt(c.dy));
      }
      canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.8
            ..strokeJoin = StrokeJoin.round
            ..color = const Color(0xFFE45756));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
