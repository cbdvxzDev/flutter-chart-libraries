import 'dart:math';
import 'package:flutter/material.dart';
import 'drawing.dart';

class ValueGroup {
  const ValueGroup(this.label, this.values, this.color);
  final String label;
  final List<double> values;
  final Color color;
}

double quantile(List<double> sorted, double p) {
  if (sorted.length == 1) return sorted.first;
  final pos = (sorted.length - 1) * p;
  final lo = pos.floor();
  final hi = pos.ceil();
  return sorted[lo] + (sorted[hi] - sorted[lo]) * (pos - lo);
}

// ----------------------------------------------------------------- Boxplot

/// Diagrama de caja: mediana, cuartiles, bigotes y valores atipicos (1,5 x IQR).
class BoxPlotPainter extends CustomPainter {
  BoxPlotPainter(this.groups);
  final List<ValueGroup> groups;

  @override
  void paint(Canvas canvas, Size size) {
    if (groups.isEmpty) return;
    var maxV = 1.0;
    for (final g in groups) {
      for (final v in g.values) {
        maxV = max(maxV, v);
      }
    }
    final sc = niceScale(0, maxV);
    final plot = Rect.fromLTRB(40, 14, size.width - 14, size.height - 44);
    drawGrid(canvas, plot, 0, sc.hi, sc.step, valueOnY: true);
    double y(double v) => plot.bottom - v / sc.hi * plot.height;
    final slot = plot.width / groups.length;
    final bw = min(46.0, slot * 0.5);

    for (var i = 0; i < groups.length; i++) {
      final g = groups[i];
      final cx = plot.left + slot * (i + 0.5);
      final s = [...g.values]..sort();
      final q1 = quantile(s, 0.25);
      final med = quantile(s, 0.5);
      final q3 = quantile(s, 0.75);
      final iqr = q3 - q1;
      final inside = s.where((v) => v >= q1 - 1.5 * iqr && v <= q3 + 1.5 * iqr).toList();
      final wLo = inside.first;
      final wHi = inside.last;

      final line = Paint()
        ..color = g.color
        ..strokeWidth = 1.6
        ..style = PaintingStyle.stroke;
      canvas.drawLine(Offset(cx, y(wHi)), Offset(cx, y(q3)), line);
      canvas.drawLine(Offset(cx, y(q1)), Offset(cx, y(wLo)), line);
      canvas.drawLine(Offset(cx - bw / 4, y(wHi)), Offset(cx + bw / 4, y(wHi)), line);
      canvas.drawLine(Offset(cx - bw / 4, y(wLo)), Offset(cx + bw / 4, y(wLo)), line);
      final box = Rect.fromLTRB(cx - bw / 2, y(q3), cx + bw / 2, y(q1));
      canvas.drawRect(box, Paint()..color = g.color.withAlpha(70));
      canvas.drawRect(box, line);
      canvas.drawLine(Offset(box.left, y(med)), Offset(box.right, y(med)),
          Paint()
            ..color = kInk
            ..strokeWidth = 2.4);
      for (final v in s) {
        final out = v < q1 - 1.5 * iqr || v > q3 + 1.5 * iqr;
        if (out) {
          canvas.drawCircle(
              Offset(cx, y(v)),
              4,
              Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1.5
                ..color = g.color);
          drawText(canvas, fmt(v), Offset(cx + 8, y(v)),
              size: 10, color: kMuted, alignment: Alignment.centerLeft);
        } else {
          canvas.drawCircle(Offset(cx + bw / 2 + 6, y(v)), 2, Paint()..color = g.color.withAlpha(150));
        }
      }
      drawText(canvas, g.label, Offset(cx, plot.bottom + 6),
          size: 12, bold: true, alignment: Alignment.topCenter);
      drawText(canvas, 'n = ${s.length}', Offset(cx, plot.bottom + 22),
          size: 10, color: kMuted, alignment: Alignment.topCenter);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ------------------------------------------------------------------ Violin

/// Violin: la densidad (suavizada) de los valores, espejada a cada lado.
class ViolinPainter extends CustomPainter {
  ViolinPainter(this.groups);
  final List<ValueGroup> groups;

  double _density(List<double> xs, double h, double at) {
    var s = 0.0;
    for (final x in xs) {
      final z = (at - x) / h;
      s += exp(-0.5 * z * z);
    }
    return s / (xs.length * h);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (groups.isEmpty) return;
    var maxV = 1.0;
    for (final g in groups) {
      for (final v in g.values) {
        maxV = max(maxV, v);
      }
    }
    final sc = niceScale(0, maxV);
    final plot = Rect.fromLTRB(40, 14, size.width - 14, size.height - 44);
    drawGrid(canvas, plot, 0, sc.hi, sc.step, valueOnY: true);
    double y(double v) => plot.bottom - v / sc.hi * plot.height;
    final slot = plot.width / groups.length;
    final half = min(60.0, slot * 0.42);

    for (var i = 0; i < groups.length; i++) {
      final g = groups[i];
      final cx = plot.left + slot * (i + 0.5);
      final xs = g.values;
      final mean = xs.fold<double>(0, (a, v) => a + v) / xs.length;
      final variance = xs.fold<double>(0, (a, v) => a + (v - mean) * (v - mean)) / xs.length;
      final h = max(1.2, 1.06 * sqrt(variance) * pow(xs.length, -0.2).toDouble());
      final lo = max(0.0, xs.reduce(min) - 1.5 * h);
      final hi = min(sc.hi, xs.reduce(max) + 1.5 * h);
      const steps = 48;
      final ys = [for (var k = 0; k <= steps; k++) lo + (hi - lo) * k / steps];
      final ds = [for (final v in ys) _density(xs, h, v)];
      final dMax = ds.reduce(max);
      final right = [
        for (var k = 0; k <= steps; k++) Offset(cx + half * ds[k] / dMax, y(ys[k])),
      ];
      final left = [
        for (var k = steps; k >= 0; k--) Offset(cx - half * ds[k] / dMax, y(ys[k])),
      ];
      final path = Path()..moveTo(right.first.dx, right.first.dy);
      for (final p in [...right, ...left]) {
        path.lineTo(p.dx, p.dy);
      }
      path.close();
      canvas.drawPath(path, Paint()..color = g.color.withAlpha(110));
      canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5
            ..color = g.color);
      final sorted = [...xs]..sort();
      final med = quantile(sorted, 0.5);
      canvas.drawLine(Offset(cx - 10, y(med)), Offset(cx + 10, y(med)),
          Paint()
            ..color = kInk
            ..strokeWidth = 2.4);
      for (final v in xs) {
        canvas.drawCircle(Offset(cx, y(v)), 2.2, Paint()..color = kInk.withAlpha(150));
      }
      drawText(canvas, g.label, Offset(cx, plot.bottom + 6),
          size: 12, bold: true, alignment: Alignment.topCenter);
      drawText(canvas, 'n = ${xs.length}', Offset(cx, plot.bottom + 22),
          size: 10, color: kMuted, alignment: Alignment.topCenter);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ------------------------------------------------------ Coordenadas paralelas

class ParRow {
  const ParRow(this.label, this.values);
  final String label;
  final List<double> values;
}

class ParallelPainter extends CustomPainter {
  ParallelPainter({required this.axes, required this.rows});
  final List<String> axes;
  final List<ParRow> rows;

  @override
  void paint(Canvas canvas, Size size) {
    final m = axes.length;
    if (m < 2 || rows.isEmpty) return;
    final legendH = drawLegend(canvas, size.width,
        [for (var i = 0; i < rows.length; i++) MapEntry(rows[i].label, colorFor(i))]);
    final plot = Rect.fromLTRB(36, legendH + 34, size.width - 36, size.height - 18);
    double x(int j) => plot.left + j / (m - 1) * plot.width;

    final lo = <double>[];
    final hi = <double>[];
    for (var j = 0; j < m; j++) {
      final col = [for (final r in rows) r.values[j]];
      lo.add(col.reduce(min));
      hi.add(col.reduce(max));
    }
    double ny(int j, double v) {
      final span = hi[j] - lo[j];
      final t = span == 0 ? 0.5 : (v - lo[j]) / span;
      return plot.bottom - t * plot.height;
    }

    for (var j = 0; j < m; j++) {
      canvas.drawLine(Offset(x(j), plot.top), Offset(x(j), plot.bottom),
          Paint()
            ..color = kMuted
            ..strokeWidth = 1.5);
      drawText(canvas, axes[j], Offset(x(j), plot.top - 18),
          size: 11, bold: true, alignment: Alignment.bottomCenter);
      drawText(canvas, fmt(hi[j]), Offset(x(j), plot.top - 4),
          size: 10, color: kMuted, alignment: Alignment.bottomCenter);
      drawText(canvas, fmt(lo[j]), Offset(x(j), plot.bottom + 4),
          size: 10, color: kMuted, alignment: Alignment.topCenter);
    }
    for (var i = 0; i < rows.length; i++) {
      final path = Path();
      for (var j = 0; j < m; j++) {
        final p = Offset(x(j), ny(j, rows[i].values[j]));
        if (j == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..strokeJoin = StrokeJoin.round
            ..color = colorFor(i).withAlpha(200));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// -------------------------------------------------- Matriz de dispersion

class ScatterMatrixPainter extends CustomPainter {
  ScatterMatrixPainter({required this.names, required this.columns});
  final List<String> names;

  /// columns[k] = valores de la metrica k, un valor por vertice.
  final List<List<double>> columns;

  @override
  void paint(Canvas canvas, Size size) {
    final m = names.length;
    if (m == 0 || columns.isEmpty) return;
    final area = Rect.fromLTWH(10, 8, size.width - 20, size.height - 16);
    final cw = area.width / m;
    final ch = area.height / m;
    final lo = [for (final c in columns) c.reduce(min)];
    final hi = [for (final c in columns) c.reduce(max)];
    double norm(int k, double v) => hi[k] == lo[k] ? 0.5 : (v - lo[k]) / (hi[k] - lo[k]);

    for (var r = 0; r < m; r++) {
      for (var c = 0; c < m; c++) {
        final cell = Rect.fromLTWH(area.left + c * cw, area.top + r * ch, cw, ch).deflate(3);
        canvas.drawRRect(
            RRect.fromRectAndRadius(cell, const Radius.circular(6)),
            Paint()..color = r == c ? const Color(0xFFF1F3F8) : Colors.white);
        canvas.drawRRect(
            RRect.fromRectAndRadius(cell, const Radius.circular(6)),
            Paint()
              ..style = PaintingStyle.stroke
              ..color = kGrid);
        if (r == c) {
          drawText(canvas, names[r], cell.center, size: 13, bold: true);
          drawText(canvas, '${fmt(lo[r])} a ${fmt(hi[r])}', cell.center + const Offset(0, 16),
              size: 10, color: kMuted);
          continue;
        }
        final inner = cell.deflate(10);
        for (var i = 0; i < columns[c].length; i++) {
          final p = Offset(
            inner.left + norm(c, columns[c][i]) * inner.width,
            inner.bottom - norm(r, columns[r][i]) * inner.height,
          );
          canvas.drawCircle(p, 3.6, Paint()..color = colorFor(0).withAlpha(150));
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
