import 'dart:math';
import 'package:flutter/material.dart';
import 'drawing.dart';

class ScatterPoint {
  const ScatterPoint(this.x, this.y, this.label, {this.size, this.count = 1});
  final double x, y;
  final String label;

  /// Solo para burbujas: valor que define el tamaño.
  final double? size;

  /// Cuántos vértices comparten este punto (pondera la regresión).
  final int count;
}

class ScatterPainter extends CustomPainter {
  ScatterPainter({
    required this.points,
    required this.xTitle,
    required this.yTitle,
    this.regression = false,
    this.bubble = false,
    this.color = const Color(0xFF4C78A8),
  });

  final List<ScatterPoint> points;
  final String xTitle, yTitle;
  final bool regression, bubble;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final plot = Rect.fromLTRB(52, 14, size.width - 20, size.height - 46);

    double maxX = 0, maxY = 0;
    for (final p in points) {
      maxX = max(maxX, p.x);
      maxY = max(maxY, p.y);
    }
    final sx = niceScale(0, maxX * 1.08 + 0.001);
    final sy = niceScale(0, maxY * 1.08 + 0.001);
    double px(double x) => plot.left + (x - sx.lo) / (sx.hi - sx.lo) * plot.width;
    double py(double y) => plot.bottom - (y - sy.lo) / (sy.hi - sy.lo) * plot.height;

    drawGrid(canvas, plot, sy.lo, sy.hi, sy.step, valueOnY: true);
    drawGrid(canvas, plot, sx.lo, sx.hi, sx.step, valueOnY: false);
    drawText(canvas, xTitle, Offset(plot.center.dx, size.height - 4),
        size: 11, color: kMuted, alignment: Alignment.bottomCenter);
    canvas.save();
    canvas.translate(12, plot.center.dy);
    canvas.rotate(-pi / 2);
    drawText(canvas, yTitle, Offset.zero, size: 11, color: kMuted);
    canvas.restore();

    // Regresion lineal ponderada
    if (regression) {
      double sw = 0, mx = 0, my = 0;
      for (final p in points) {
        sw += p.count;
        mx += p.x * p.count;
        my += p.y * p.count;
      }
      mx /= sw;
      my /= sw;
      double sxx = 0, sxy = 0, syy = 0;
      for (final p in points) {
        final dx = p.x - mx, dy = p.y - my;
        sxx += p.count * dx * dx;
        sxy += p.count * dx * dy;
        syy += p.count * dy * dy;
      }
      if (sxx > 0) {
        final m = sxy / sxx;
        final b = my - m * mx;
        final r2 = syy == 0 ? 1.0 : (sxy * sxy) / (sxx * syy);
        double x0 = points.first.x, x1 = points.first.x;
        for (final p in points) {
          x0 = min(x0, p.x);
          x1 = max(x1, p.x);
        }
        const red = Color(0xFFE45756);
        final line = Paint()
          ..color = red
          ..strokeWidth = 2.5;
        final a = Offset(px(x0), py(m * x0 + b));
        final z = Offset(px(x1), py(m * x1 + b));
        const dashes = 24;
        for (var i = 0; i < dashes; i += 2) {
          canvas.drawLine(Offset.lerp(a, z, i / dashes)!,
              Offset.lerp(a, z, (i + 1) / dashes)!, line);
        }
        drawText(
          canvas,
          'y = ${m.toStringAsFixed(1)}x ${b < 0 ? '−' : '+'} ${b.abs().toStringAsFixed(1)}    r² = ${r2.toStringAsFixed(2)}',
          Offset(plot.left + 8, plot.top + 6),
          size: 11,
          bold: true,
          color: red,
          alignment: Alignment.topLeft,
        );
      }
    }

    double maxSize = 1;
    for (final p in points) {
      maxSize = max(maxSize, p.size ?? 0);
    }
    double radiusOf(ScatterPoint p) => bubble
        ? 9 + 20 * sqrt((p.size ?? 0) / maxSize)
        : (p.count > 1 ? 8.0 : 6.0);

    final ordered = [...points]..sort((a, b) => radiusOf(b).compareTo(radiusOf(a)));
    for (final p in ordered) {
      final c = Offset(px(p.x), py(p.y));
      final r = radiusOf(p);
      canvas.drawCircle(c, r, Paint()..color = color.withAlpha(bubble ? 120 : 220));
      canvas.drawCircle(
          c,
          r,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5
            ..color = color);
      if (bubble) {
        drawText(canvas, p.label, c, size: 11, bold: true);
      } else {
        drawText(canvas, p.label, c + Offset(r + 3, -r - 1),
            size: 11, bold: true, alignment: Alignment.centerLeft);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
