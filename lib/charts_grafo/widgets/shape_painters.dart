import 'dart:math';
import 'package:flutter/material.dart';
import 'drawing.dart';

class Slice {
  const Slice(this.label, this.value, this.color);
  final String label;
  final double value;
  final Color color;
}

/// Pastel o dona (si [donut] es true, con texto al centro).
class PiePainter extends CustomPainter {
  PiePainter({
    required this.slices,
    this.donut = false,
    this.centerTop,
    this.centerBottom,
  });
  final List<Slice> slices;
  final bool donut;
  final String? centerTop, centerBottom;

  @override
  void paint(Canvas canvas, Size size) {
    final total = slices.fold<double>(0, (a, s) => a + s.value);
    if (total <= 0) return;
    final top = 8 +
        drawLegend(canvas, size.width,
            [for (final s in slices) MapEntry('${s.label} (${fmt(s.value)})', s.color)]) +
        8;
    final area = Rect.fromLTRB(0, top, size.width, size.height);
    final r = max(20.0, min(area.width, area.height) / 2 - 8);
    final c = area.center;
    final rect = Rect.fromCircle(center: c, radius: r);

    var start = -pi / 2;
    for (final s in slices) {
      final sweep = s.value / total * 2 * pi;
      canvas.drawArc(rect, start, sweep, true, Paint()..color = s.color);
      canvas.drawArc(
          rect,
          start,
          sweep,
          true,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = Colors.white);
      if (sweep > 0.28) {
        final mid = start + sweep / 2;
        final rr = donut ? r * 0.79 : r * 0.64;
        drawText(canvas, '${(s.value / total * 100).round()}%',
            c + Offset(cos(mid), sin(mid)) * rr,
            size: 12, bold: true, color: Colors.white);
      }
      start += sweep;
    }
    if (donut) {
      canvas.drawCircle(c, r * 0.58, Paint()..color = Colors.white);
      if (centerTop != null) {
        drawText(canvas, centerTop!, c - const Offset(0, 8), size: 26, bold: true);
      }
      if (centerBottom != null) {
        drawText(canvas, centerBottom!, c + const Offset(0, 16),
            size: 12, color: kMuted);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Medidor: semicirculo (gauge) o anillo completo (progreso circular).
class GaugePainter extends CustomPainter {
  GaugePainter({
    required this.value,
    required this.caption,
    this.semi = true,
    this.color = const Color(0xFF4C78A8),
  });
  final double value; // 0..1
  final String caption;
  final bool semi;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final v = value.clamp(0.0, 1.0).toDouble();
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFE8ECF4);
    final fill = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round
      ..color = color;
    final pct = '${(v * 100).toStringAsFixed(1)}%';

    if (semi) {
      final r = max(30.0, min(size.width / 2 - 28, size.height * 0.55));
      final c = Offset(size.width / 2, size.height * 0.62);
      final rect = Rect.fromCircle(center: c, radius: r);
      canvas.drawArc(rect, pi, pi, false, track);
      canvas.drawArc(rect, pi, pi * v, false, fill);
      drawText(canvas, pct, c - Offset(0, r * 0.22), size: 32, bold: true);
      drawText(canvas, caption, c + const Offset(0, 22), size: 12, color: kMuted);
      drawText(canvas, '0%', c + Offset(-r, 22), size: 10, color: kMuted);
      drawText(canvas, '100%', c + Offset(r, 22), size: 10, color: kMuted);
    } else {
      final r = max(30.0, min(size.width, size.height) / 2 - 24);
      final c = size.center(Offset.zero);
      final rect = Rect.fromCircle(center: c, radius: r);
      canvas.drawArc(rect, 0, 2 * pi, false, track);
      canvas.drawArc(rect, -pi / 2, 2 * pi * v, false, fill);
      drawText(canvas, pct, c - const Offset(0, 8), size: 32, bold: true);
      drawText(canvas, caption, c + const Offset(0, 22), size: 12, color: kMuted);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Embudo: etapas centradas cuyo ancho es proporcional al valor.
class FunnelPainter extends CustomPainter {
  FunnelPainter(this.stages);
  final List<Slice> stages;

  @override
  void paint(Canvas canvas, Size size) {
    final n = stages.length;
    if (n == 0) return;
    final labelW = min(150.0, size.width * 0.34);
    final area = Rect.fromLTRB(labelW + 8, 8, size.width - 8, size.height - 8);
    final maxV = stages.map((s) => s.value).reduce(max);
    final rowH = area.height / n;
    final cx = area.center.dx;
    for (var i = 0; i < n; i++) {
      final s = stages[i];
      final topW = area.width * s.value / maxV;
      final nextV = i + 1 < n ? stages[i + 1].value : s.value * 0.8;
      final botW = area.width * nextV / maxV;
      final y0 = area.top + rowH * i;
      final y1 = y0 + rowH - 4;
      final path = Path()
        ..moveTo(cx - topW / 2, y0)
        ..lineTo(cx + topW / 2, y0)
        ..lineTo(cx + botW / 2, y1)
        ..lineTo(cx - botW / 2, y1)
        ..close();
      canvas.drawPath(path, Paint()..color = s.color);
      drawText(canvas, fmt(s.value), Offset(cx, (y0 + y1) / 2),
          size: 15, bold: true, color: Colors.white);
      drawText(canvas, s.label, Offset(8, (y0 + y1) / 2),
          size: 12, bold: true, alignment: Alignment.centerLeft);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Treemap: el area de cada rectangulo es proporcional al valor.
class TreemapPainter extends CustomPainter {
  TreemapPainter(this.items);
  final List<Slice> items;

  void _split(List<Slice> list, Rect r, List<MapEntry<Slice, Rect>> out) {
    if (list.length == 1) {
      out.add(MapEntry(list.first, r));
      return;
    }
    final total = list.fold<double>(0, (a, s) => a + s.value);
    var acc = 0.0, best = double.infinity;
    var bestK = 1;
    for (var i = 1; i < list.length; i++) {
      acc += list[i - 1].value;
      final d = (acc - total / 2).abs();
      if (d < best) {
        best = d;
        bestK = i;
      }
    }
    final left = list.sublist(0, bestK);
    final right = list.sublist(bestK);
    final frac = left.fold<double>(0, (a, s) => a + s.value) / total;
    if (r.width >= r.height) {
      final w = r.width * frac;
      _split(left, Rect.fromLTWH(r.left, r.top, w, r.height), out);
      _split(right, Rect.fromLTWH(r.left + w, r.top, r.width - w, r.height), out);
    } else {
      final h = r.height * frac;
      _split(left, Rect.fromLTWH(r.left, r.top, r.width, h), out);
      _split(right, Rect.fromLTWH(r.left, r.top + h, r.width, r.height - h), out);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final list = items.where((s) => s.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (list.isEmpty) return;
    final out = <MapEntry<Slice, Rect>>[];
    _split(list, Rect.fromLTWH(4, 4, size.width - 8, size.height - 8), out);
    for (final e in out) {
      final rect = e.value.deflate(2);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)),
          Paint()..color = e.key.color);
      if (rect.width > 46 && rect.height > 36) {
        drawText(canvas, e.key.label, rect.topLeft + const Offset(10, 8),
            size: 16, bold: true, color: Colors.white, alignment: Alignment.topLeft);
        drawText(canvas, fmt(e.key.value), rect.topLeft + const Offset(10, 30),
            size: 12, color: Colors.white, alignment: Alignment.topLeft);
      } else if (rect.width > 18 && rect.height > 18) {
        drawText(canvas, e.key.label, rect.center,
            size: 12, bold: true, color: Colors.white);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
