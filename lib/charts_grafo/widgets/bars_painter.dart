import 'dart:math';
import 'package:flutter/material.dart';
import 'drawing.dart';

enum BarMode { grouped, stacked, percent }

class BarSeries {
  const BarSeries(this.name, this.values, this.color);
  final String name;
  final List<double> values;
  final Color color;
}

class BarsPainter extends CustomPainter {
  BarsPainter({
    required this.categories,
    required this.series,
    this.mode = BarMode.grouped,
    this.horizontal = false,
    this.negativeColor,
    this.showValues = true,
    this.lollipop = false,
    this.hLine,
    this.hLineLabel,
  });

  final List<String> categories;
  final List<BarSeries> series;
  final BarMode mode;
  final bool horizontal;
  final Color? negativeColor;
  final bool showValues;
  final bool lollipop;
  final double? hLine;
  final String? hLineLabel;

  @override
  void paint(Canvas canvas, Size size) {
    final n = categories.length;
    if (n == 0) return;
    var top = 16.0;
    if (series.length > 1) {
      top += drawLegend(canvas, size.width,
              [for (final s in series) MapEntry(s.name, s.color)]) +
          6;
    }
    final plot = Rect.fromLTRB(horizontal ? 30 : 38, top, size.width - 18,
        size.height - (horizontal ? 26 : 28));
    final catSize = n > 12 ? 9.0 : 12.0;

    // Rango de valores
    double lo = 0, hi = 0, step;
    if (mode == BarMode.percent) {
      hi = 100;
      step = 20;
    } else {
      for (var i = 0; i < n; i++) {
        double pos = 0, neg = 0;
        for (final s in series) {
          final v = s.values[i];
          if (mode == BarMode.stacked) {
            if (v >= 0) {
              pos += v;
            } else {
              neg += v;
            }
          } else {
            pos = max(pos, v);
            neg = min(neg, v);
          }
        }
        hi = max(hi, pos);
        lo = min(lo, neg);
      }
      if (hLine != null) hi = max(hi, hLine! * 1.05);
      final sc = niceScale(lo, hi);
      lo = sc.lo;
      hi = sc.hi;
      step = sc.step;
    }

    double px(double v) => horizontal
        ? plot.left + (v - lo) / (hi - lo) * plot.width
        : plot.bottom - (v - lo) / (hi - lo) * plot.height;

    drawGrid(canvas, plot, lo, hi, step, valueOnY: !horizontal);
    final zero = px(0);
    final axis = Paint()
      ..color = kMuted
      ..strokeWidth = 1.2;
    if (horizontal) {
      canvas.drawLine(Offset(zero, plot.top), Offset(zero, plot.bottom), axis);
    } else {
      canvas.drawLine(Offset(plot.left, zero), Offset(plot.right, zero), axis);
    }

    final slot = (horizontal ? plot.height : plot.width) / n;
    final groupW = slot * 0.7;
    for (var i = 0; i < n; i++) {
      final c0 = (horizontal ? plot.top : plot.left) + slot * i + (slot - groupW) / 2;
      double posBase = 0, negBase = 0;
      double total = 0;
      if (mode == BarMode.percent) {
        for (final s in series) {
          total += s.values[i].abs();
        }
      }
      for (var s = 0; s < series.length; s++) {
        var v = series[s].values[i];
        double a, b;
        if (mode == BarMode.grouped) {
          a = 0;
          b = v;
        } else {
          if (mode == BarMode.percent) v = total == 0 ? 0 : v / total * 100;
          if (v >= 0) {
            a = posBase;
            posBase += v;
            b = posBase;
          } else {
            a = negBase;
            negBase += v;
            b = negBase;
          }
        }
        final bw = mode == BarMode.grouped ? groupW / series.length : groupW;
        final off = mode == BarMode.grouped ? bw * s : 0.0;
        final pa = px(a), pb = px(b);
        final rect = horizontal
            ? Rect.fromLTRB(min(pa, pb), c0 + off, max(pa, pb), c0 + off + bw)
            : Rect.fromLTRB(c0 + off, min(pa, pb), c0 + off + bw, max(pa, pb));
        final color = (series.length == 1 && negativeColor != null && v < 0)
            ? negativeColor!
            : series[s].color;

        if (lollipop) {
          final base = horizontal
              ? Offset(px(0), rect.center.dy)
              : Offset(rect.center.dx, px(0));
          final tip = horizontal
              ? Offset(v >= 0 ? rect.right : rect.left, rect.center.dy)
              : Offset(rect.center.dx, v >= 0 ? rect.top : rect.bottom);
          canvas.drawLine(
              base,
              tip,
              Paint()
                ..color = color
                ..strokeWidth = 2.5);
          canvas.drawCircle(tip, 5, Paint()..color = color);
        } else {
          canvas.drawRect(rect, Paint()..color = color);
        }

        if (showValues && series.length == 1) {
          final label = fmt(v);
          final gapV = lollipop ? 9.0 : 3.0;
          if (horizontal) {
            v >= 0
                ? drawText(canvas, label, Offset(rect.right + gapV, rect.center.dy),
                    size: 10, alignment: Alignment.centerLeft)
                : drawText(canvas, label, Offset(rect.left - gapV, rect.center.dy),
                    size: 10, alignment: Alignment.centerRight);
          } else {
            v >= 0
                ? drawText(canvas, label, Offset(rect.center.dx, rect.top - gapV),
                    size: 10, alignment: Alignment.bottomCenter)
                : drawText(canvas, label, Offset(rect.center.dx, rect.bottom + gapV),
                    size: 10, alignment: Alignment.topCenter);
          }
        }
      }
      final mid = c0 + groupW / 2;
      if (horizontal) {
        drawText(canvas, categories[i], Offset(plot.left - 8, mid),
            size: catSize, bold: true, alignment: Alignment.centerRight);
      } else {
        drawText(canvas, categories[i], Offset(mid, plot.bottom + 6),
            size: catSize, bold: true, alignment: Alignment.topCenter);
      }
    }

    // Linea horizontal de referencia (por ejemplo, el promedio)
    if (hLine != null && !horizontal) {
      final y = px(hLine!);
      const red = Color(0xFFE45756);
      final p = Paint()
        ..color = red
        ..strokeWidth = 2;
      var x = plot.left;
      while (x < plot.right) {
        canvas.drawLine(Offset(x, y), Offset(min(x + 6, plot.right), y), p);
        x += 11;
      }
      drawText(canvas, hLineLabel ?? fmt(hLine!), Offset(plot.right, y - 3),
          size: 10, bold: true, color: red, alignment: Alignment.bottomRight);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Widget barsView({
  required List<String> cats,
  required List<BarSeries> series,
  BarMode mode = BarMode.grouped,
  bool horizontal = false,
  Color? negativeColor,
  bool showValues = true,
  bool lollipop = false,
  double? hLine,
  String? hLineLabel,
}) =>
    CustomPaint(
      painter: BarsPainter(
        categories: cats,
        series: series,
        mode: mode,
        horizontal: horizontal,
        negativeColor: negativeColor,
        showValues: showValues,
        lollipop: lollipop,
        hLine: hLine,
        hLineLabel: hLineLabel,
      ),
      child: const SizedBox.expand(),
    );
