import 'dart:math';
import 'package:flutter/material.dart';
import 'drawing.dart';

/// Mapa de calor de una matriz (null = sin arista).
class HeatmapPainter extends CustomPainter {
  HeatmapPainter({required this.labels, required this.cells});
  final List<String> labels;
  final List<List<double?>> cells;

  @override
  void paint(Canvas canvas, Size size) {
    final n = labels.length;
    if (n == 0) return;
    const margin = 26.0;
    final cs = min((size.width - margin) / n, (size.height - margin) / n);
    final left = (size.width - cs * n + margin) / 2;
    final top = margin / 2 + (size.height - cs * n - margin) / 2 + margin / 2;
    var maxV = 0.0;
    for (final row in cells) {
      for (final v in row) {
        if (v != null) maxV = max(maxV, v);
      }
    }
    if (maxV == 0) maxV = 1;
    const low = Color(0xFFDCE8FB), high = Color(0xFF2F6BFF);
    for (var r = 0; r < n; r++) {
      drawText(canvas, labels[r], Offset(left - 8, top + cs * (r + 0.5)),
          size: 12, bold: true, alignment: Alignment.centerRight);
      drawText(canvas, labels[r], Offset(left + cs * (r + 0.5), top - 8),
          size: 12, bold: true, alignment: Alignment.bottomCenter);
      for (var c = 0; c < n; c++) {
        final v = cells[r][c];
        final rect = Rect.fromLTWH(left + cs * c + 1, top + cs * r + 1, cs - 2, cs - 2);
        final t = v == null ? 0.0 : sqrt(v / maxV);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(4)),
          Paint()..color = v == null ? const Color(0xFFF3F5F9) : Color.lerp(low, high, t)!,
        );
        if (v != null && cs >= 22) {
          drawText(canvas, fmt(v), rect.center,
              size: 10, bold: true, color: t > 0.55 ? Colors.white : kInk);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PictoRow {
  const PictoRow(this.label, this.count, this.color);
  final String label;
  final int count;
  final Color color;
}

/// Pictograma: una flecha por cada unidad.
class PictogramPainter extends CustomPainter {
  PictogramPainter(this.rows);
  final List<PictoRow> rows;

  @override
  void paint(Canvas canvas, Size size) {
    final n = rows.length;
    if (n == 0) return;
    final rowH = size.height / n;
    for (var i = 0; i < n; i++) {
      final r = rows[i];
      final cy = rowH * (i + 0.5);
      if (i > 0) {
        canvas.drawLine(Offset(8, rowH * i), Offset(size.width - 8, rowH * i),
            Paint()..color = kGrid);
      }
      drawText(canvas, r.label, Offset(16, cy),
          size: 13, bold: true, alignment: Alignment.centerLeft);
      if (r.count == 0) {
        drawText(canvas, '—', Offset(52, cy), size: 14, color: kMuted,
            alignment: Alignment.centerLeft);
        continue;
      }
      final paint = Paint()
        ..color = r.color
        ..strokeWidth = 2.6
        ..strokeCap = StrokeCap.round;
      for (var k = 0; k < r.count; k++) {
        final x = 52.0 + k * 30;
        canvas.drawLine(Offset(x, cy), Offset(x + 16, cy), paint);
        final head = Path()
          ..moveTo(x + 22, cy)
          ..lineTo(x + 13, cy - 5)
          ..lineTo(x + 13, cy + 5)
          ..close();
        canvas.drawPath(head, Paint()..color = r.color);
      }
      drawText(canvas, '${r.count}', Offset(52.0 + r.count * 30 + 4, cy),
          size: 12, bold: true, color: r.color, alignment: Alignment.centerLeft);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SparkRow {
  const SparkRow(this.label, this.values, this.color);
  final String label;
  final List<double> values;
  final Color color;
}

/// Una minigrafica de linea por fila.
class SparklinesPainter extends CustomPainter {
  SparklinesPainter(this.rows);
  final List<SparkRow> rows;

  @override
  void paint(Canvas canvas, Size size) {
    final n = rows.length;
    if (n == 0) return;
    final rowH = size.height / n;
    final x0 = 40.0, x1 = size.width - 52;
    for (var i = 0; i < n; i++) {
      final r = rows[i];
      final cy = rowH * (i + 0.5);
      if (i > 0) {
        canvas.drawLine(Offset(8, rowH * i), Offset(size.width - 8, rowH * i),
            Paint()..color = kGrid);
      }
      drawText(canvas, r.label, Offset(16, cy),
          size: 13, bold: true, alignment: Alignment.centerLeft);
      if (r.values.isEmpty) {
        drawText(canvas, 'sin salidas', Offset((x0 + x1) / 2, cy), size: 11, color: kMuted);
        continue;
      }
      var lo = r.values.reduce(min), hi = r.values.reduce(max);
      if (hi == lo) {
        lo -= 1;
        hi += 1;
      }
      final pad = rowH * 0.22;
      Offset pt(int k) {
        final x = r.values.length == 1
            ? (x0 + x1) / 2
            : x0 + (x1 - x0) * k / (r.values.length - 1);
        final y = (rowH * i + rowH - pad) - (r.values[k] - lo) / (hi - lo) * (rowH - 2 * pad);
        return Offset(x, y);
      }

      if (r.values.length > 1) {
        final path = Path()..moveTo(pt(0).dx, pt(0).dy);
        for (var k = 1; k < r.values.length; k++) {
          path.lineTo(pt(k).dx, pt(k).dy);
        }
        canvas.drawPath(
            path,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.2
              ..strokeJoin = StrokeJoin.round
              ..color = r.color);
      }
      canvas.drawCircle(pt(r.values.length - 1), 3.6, Paint()..color = r.color);
      drawText(canvas, fmt(r.values.last), Offset(size.width - 10, cy),
          size: 12, bold: true, color: r.color, alignment: Alignment.centerRight);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class RadarSeries {
  const RadarSeries(this.name, this.values, this.color);
  final String name;
  final List<double> values; // 0..1
  final Color color;
}

class RadarPainter extends CustomPainter {
  RadarPainter({required this.axes, required this.series});
  final List<String> axes;
  final List<RadarSeries> series;

  @override
  void paint(Canvas canvas, Size size) {
    final n = axes.length;
    if (n < 3) return;
    final top = 6 +
        drawLegend(canvas, size.width,
            [for (final s in series) MapEntry(s.name, s.color)]) +
        8;
    final area = Rect.fromLTRB(0, top, size.width, size.height);
    final c = area.center;
    final r = max(20.0, min(area.width / 2 - 70, area.height / 2 - 22));
    Offset at(int i, double f) {
      final a = -pi / 2 + 2 * pi * i / n;
      return c + Offset(cos(a), sin(a)) * (r * f);
    }

    final grid = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = kGrid;
    for (var ring = 1; ring <= 4; ring++) {
      final path = Path()..moveTo(at(0, ring / 4).dx, at(0, ring / 4).dy);
      for (var i = 1; i < n; i++) {
        path.lineTo(at(i, ring / 4).dx, at(i, ring / 4).dy);
      }
      path.close();
      canvas.drawPath(path, grid);
    }
    for (var i = 0; i < n; i++) {
      canvas.drawLine(c, at(i, 1), grid);
      final a = -pi / 2 + 2 * pi * i / n;
      drawText(canvas, axes[i], at(i, 1) + Offset(cos(a), sin(a)) * 8,
          size: 11, bold: true, alignment: Alignment(-cos(a), -sin(a)));
    }
    for (final s in series) {
      final path = Path()..moveTo(at(0, s.values[0]).dx, at(0, s.values[0]).dy);
      for (var i = 1; i < n; i++) {
        path.lineTo(at(i, s.values[i]).dx, at(i, s.values[i]).dy);
      }
      path.close();
      canvas.drawPath(path, Paint()..color = s.color.withAlpha(45));
      canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.4
            ..strokeJoin = StrokeJoin.round
            ..color = s.color);
      for (var i = 0; i < n; i++) {
        canvas.drawCircle(at(i, s.values[i]), 3.5, Paint()..color = s.color);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
