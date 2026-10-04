import 'dart:math';
import 'package:flutter/material.dart';
import 'drawing.dart';

enum LineMode { line, step, area, stackedArea }

class LineSeries {
  const LineSeries(this.name, this.values, this.color);
  final String name;
  final List<double> values;
  final Color color;
}

class LinesPainter extends CustomPainter {
  LinesPainter({
    required this.xLabels,
    required this.series,
    this.mode = LineMode.line,
    this.showValues = true,
  });

  final List<String> xLabels;
  final List<LineSeries> series;
  final LineMode mode;
  final bool showValues;

  @override
  void paint(Canvas canvas, Size size) {
    final n = xLabels.length;
    if (n == 0) return;
    var top = 20.0;
    if (series.length > 1) {
      top += drawLegend(canvas, size.width,
              [for (final s in series) MapEntry(s.name, s.color)]) +
          4;
    }
    final plot = Rect.fromLTRB(40, top, size.width - 20, size.height - 30);
    final stacked = mode == LineMode.stackedArea;

    // Acumulados (para areas apiladas)
    final cum = <List<double>>[];
    var running = List<double>.filled(n, 0);
    for (final s in series) {
      final prev = running;
      running = [
        for (var i = 0; i < n; i++)
          prev[i] + (i < s.values.length ? s.values[i] : 0),
      ];
      cum.add(running);
    }

    double hi = 0, lo = 0;
    if (stacked) {
      for (final v in cum.last) {
        hi = max(hi, v);
      }
    } else {
      for (final s in series) {
        for (final v in s.values) {
          hi = max(hi, v);
          lo = min(lo, v);
        }
      }
    }
    final sc = niceScale(lo, hi);
    double xAt(int i) =>
        n == 1 ? plot.center.dx : plot.left + 12 + i * (plot.width - 24) / (n - 1);
    double yAt(double v) =>
        plot.bottom - (v - sc.lo) / (sc.hi - sc.lo) * plot.height;

    drawGrid(canvas, plot, sc.lo, sc.hi, sc.step, valueOnY: true);
    for (var i = 0; i < n; i++) {
      drawText(canvas, xLabels[i], Offset(xAt(i), plot.bottom + 6),
          size: 11, bold: true, alignment: Alignment.topCenter);
    }

    if (stacked) {
      for (var s = series.length - 1; s >= 0; s--) {
        final upper = cum[s];
        final lower = s == 0 ? List<double>.filled(n, 0) : cum[s - 1];
        final path = Path()..moveTo(xAt(0), yAt(upper[0]));
        for (var i = 1; i < n; i++) {
          path.lineTo(xAt(i), yAt(upper[i]));
        }
        for (var i = n - 1; i >= 0; i--) {
          path.lineTo(xAt(i), yAt(lower[i]));
        }
        path.close();
        canvas.drawPath(path, Paint()..color = series[s].color.withAlpha(190));
        final line = Path()..moveTo(xAt(0), yAt(upper[0]));
        for (var i = 1; i < n; i++) {
          line.lineTo(xAt(i), yAt(upper[i]));
        }
        canvas.drawPath(
            line,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = series[s].color);
      }
      return;
    }

    for (final s in series) {
      final pts = [
        for (var i = 0; i < s.values.length; i++)
          Offset(xAt(i), yAt(s.values[i])),
      ];
      if (pts.isEmpty) continue;
      final line = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (var i = 1; i < pts.length; i++) {
        if (mode == LineMode.step) line.lineTo(pts[i].dx, pts[i - 1].dy);
        line.lineTo(pts[i].dx, pts[i].dy);
      }
      if (mode == LineMode.area) {
        final fill = Path.from(line)
          ..lineTo(pts.last.dx, yAt(0))
          ..lineTo(pts.first.dx, yAt(0))
          ..close();
        canvas.drawPath(fill, Paint()..color = s.color.withAlpha(70));
      }
      canvas.drawPath(
          line,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5
            ..strokeJoin = StrokeJoin.round
            ..color = s.color);
      for (var i = 0; i < pts.length; i++) {
        canvas.drawCircle(pts[i], 4, Paint()..color = Colors.white);
        canvas.drawCircle(
            pts[i],
            4,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = s.color);
        if (showValues && series.length == 1) {
          drawText(canvas, fmt(s.values[i]), pts[i] - const Offset(0, 8),
              size: 10, alignment: Alignment.bottomCenter);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Widget linesView({
  required List<String> xLabels,
  required List<LineSeries> series,
  LineMode mode = LineMode.line,
  bool showValues = true,
}) =>
    CustomPaint(
      painter: LinesPainter(
          xLabels: xLabels, series: series, mode: mode, showValues: showValues),
      child: const SizedBox.expand(),
    );
