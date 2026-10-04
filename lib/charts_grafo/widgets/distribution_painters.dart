import 'dart:math';
import 'package:flutter/material.dart';
import 'drawing.dart';

const _red = Color(0xFFE45756);
const _blue = Color(0xFF4C78A8);
const _orange = Color(0xFFF58518);

void _dashedH(Canvas canvas, double x0, double x1, double y, Color c) {
  final p = Paint()
    ..color = c
    ..strokeWidth = 1.6;
  var x = x0;
  while (x < x1) {
    canvas.drawLine(Offset(x, y), Offset(min(x + 5, x1), y), p);
    x += 9;
  }
}

/// Histograma con opcion de poligono de frecuencias y curva de densidad (KDE).
class HistogramPainter extends CustomPainter {
  HistogramPainter({
    required this.values,
    required this.binWidth,
    this.showBars = true,
    this.showPolygon = false,
    this.showDensity = false,
  });
  final List<double> values;
  final double binWidth;
  final bool showBars, showPolygon, showDensity;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final n = values.length;
    final maxV = values.reduce(max);
    final nBins = (maxV / binWidth).floor() + 1;
    final counts = List<int>.filled(nBins, 0);
    for (final v in values) {
      counts[min(nBins - 1, (v / binWidth).floor())]++;
    }
    final xTotal = nBins * binWidth;

    // Densidad (nucleo gaussiano, ancho de banda de Silverman robusto)
    final dens = <Offset>[];
    double maxDens = 0;
    if (showDensity) {
      final sorted = [...values]..sort();
      final mean = values.fold<double>(0, (a, b) => a + b) / n;
      final variance =
          values.fold<double>(0, (a, b) => a + (b - mean) * (b - mean)) / n;
      final std = sqrt(variance);
      final iqr = sorted[min(n - 1, (n * 0.75).floor())] - sorted[(n * 0.25).floor()];
      final spread = iqr > 0 ? min(std, iqr / 1.34) : std;
      final h = max(0.5, 0.9 * spread * pow(n, -0.2).toDouble());
      const samples = 90;
      for (var i = 0; i <= samples; i++) {
        final x = xTotal * i / samples;
        double s = 0;
        for (final v in values) {
          final z = (x - v) / h;
          s += exp(-0.5 * z * z);
        }
        final y = s / (h * sqrt(2 * pi)) * binWidth;
        dens.add(Offset(x, y));
        maxDens = max(maxDens, y);
      }
    }

    final legend = <MapEntry<String, Color>>[
      if (showBars) const MapEntry('Frecuencia', _blue),
      if (showPolygon) const MapEntry('Polígono de frecuencias', _orange),
      if (showDensity) const MapEntry('Densidad (KDE)', _red),
    ];
    final top = 6 + drawLegend(canvas, size.width, legend) + 14;
    final plot = Rect.fromLTRB(40, top, size.width - 16, size.height - 30);
    final maxCount = counts.reduce(max).toDouble();
    final sc = niceScale(0, max(maxCount, maxDens));
    double xAt(double x) => plot.left + x / xTotal * plot.width;
    double yAt(double c) => plot.bottom - c / sc.hi * plot.height;

    drawGrid(canvas, plot, 0, sc.hi, sc.step, valueOnY: true);

    for (var i = 0; i < nBins; i++) {
      final x0 = xAt(i * binWidth), x1 = xAt((i + 1) * binWidth);
      if (showBars) {
        canvas.drawRect(Rect.fromLTRB(x0 + 1, yAt(counts[i].toDouble()), x1 - 1, plot.bottom),
            Paint()..color = _blue.withAlpha(showDensity ? 190 : 225));
      }
      if (counts[i] > 0 && (showBars || !showPolygon)) {
        drawText(canvas, '${counts[i]}', Offset((x0 + x1) / 2, yAt(counts[i].toDouble()) - 2),
            size: 10, alignment: Alignment.bottomCenter);
      }
      drawText(canvas, '${fmt(i * binWidth)}–${fmt((i + 1) * binWidth)}',
          Offset((x0 + x1) / 2, plot.bottom + 6),
          size: 9, color: kMuted, alignment: Alignment.topCenter);
    }

    if (showPolygon) {
      final pts = <Offset>[
        Offset(xAt(0), plot.bottom),
        for (var i = 0; i < nBins; i++)
          Offset(xAt((i + 0.5) * binWidth), yAt(counts[i].toDouble())),
        Offset(xAt(xTotal), plot.bottom),
      ];
      final path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (final p in pts.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(
          Path.from(path)..close(), Paint()..color = _orange.withAlpha(55));
      canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5
            ..color = _orange);
      for (var i = 1; i < pts.length - 1; i++) {
        canvas.drawCircle(pts[i], 4, Paint()..color = _orange);
        drawText(canvas, '${counts[i - 1]}', pts[i] - const Offset(0, 8),
            size: 10, alignment: Alignment.bottomCenter);
      }
    }

    if (showDensity) {
      final path = Path();
      for (var i = 0; i < dens.length; i++) {
        final p = Offset(xAt(dens[i].dx), yAt(dens[i].dy));
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.8
            ..color = _red);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Pareto: barras de mayor a menor + linea de porcentaje acumulado.
class ParetoPainter extends CustomPainter {
  ParetoPainter({required this.labels, required this.values});
  final List<String> labels;
  final List<double> values; // ya ordenados de mayor a menor

  @override
  void paint(Canvas canvas, Size size) {
    final n = values.length;
    if (n == 0) return;
    final total = values.fold<double>(0, (a, b) => a + b);
    final top = 6 +
        drawLegend(canvas, size.width,
            const [MapEntry('Peso de la arista', _blue), MapEntry('% acumulado', _red)]) +
        14;
    final plot = Rect.fromLTRB(40, top, size.width - 44, size.height - 32);
    final sc = niceScale(0, values.first);
    drawGrid(canvas, plot, 0, sc.hi, sc.step, valueOnY: true);
    for (var p = 0; p <= 100; p += 20) {
      drawText(canvas, '$p%', Offset(plot.right + 6, plot.bottom - p / 100 * plot.height),
          size: 10, color: _red, alignment: Alignment.centerLeft);
    }
    _dashedH(canvas, plot.left, plot.right, plot.bottom - 0.8 * plot.height,
        const Color(0xFFB0B8C0));

    final slot = plot.width / n;
    final barW = slot * 0.7;
    final pts = <Offset>[];
    var cum = 0.0;
    for (var i = 0; i < n; i++) {
      final x = plot.left + slot * i + (slot - barW) / 2;
      final h = values[i] / sc.hi * plot.height;
      canvas.drawRect(Rect.fromLTWH(x, plot.bottom - h, barW, h), Paint()..color = _blue);
      cum += values[i];
      pts.add(Offset(x + barW / 2, plot.bottom - cum / total * plot.height));
      drawText(canvas, labels[i], Offset(x + barW / 2, plot.bottom + 6),
          size: n > 12 ? 9 : 11, bold: true, alignment: Alignment.topCenter);
    }
    final line = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final p in pts.skip(1)) {
      line.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(
        line,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = _red);
    for (final p in pts) {
      canvas.drawCircle(p, 3.5, Paint()..color = _red);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Dumbbell: un punto "antes", un punto "despues" y la linea que los une.
class DumbbellPainter extends CustomPainter {
  DumbbellPainter({required this.labels, required this.before, required this.after});
  final List<String> labels;
  final List<double> before, after;

  @override
  void paint(Canvas canvas, Size size) {
    final n = labels.length;
    if (n == 0) return;
    final top = 6 +
        drawLegend(canvas, size.width,
            const [MapEntry('Antes', Color(0xFF9E9E9E)), MapEntry('Después', _blue)]) +
        8;
    final plot = Rect.fromLTRB(34, top, size.width - 56, size.height - 26);
    var maxV = 0.0;
    for (var i = 0; i < n; i++) {
      maxV = max(maxV, max(before[i], after[i]));
    }
    final sc = niceScale(0, maxV);
    double xAt(double v) => plot.left + v / sc.hi * plot.width;
    drawGrid(canvas, plot, 0, sc.hi, sc.step, valueOnY: false);
    final rowH = plot.height / n;
    for (var i = 0; i < n; i++) {
      final y = plot.top + rowH * (i + 0.5);
      final changed = before[i] != after[i];
      final color = !changed ? const Color(0xFF9E9E9E) : (after[i] > before[i] ? _red : const Color(0xFF54A24B));
      drawText(canvas, labels[i], Offset(plot.left - 8, y),
          size: 12, bold: true, alignment: Alignment.centerRight);
      canvas.drawLine(
          Offset(xAt(before[i]), y),
          Offset(xAt(after[i]), y),
          Paint()
            ..color = color
            ..strokeWidth = 4
            ..strokeCap = StrokeCap.round);
      canvas.drawCircle(Offset(xAt(before[i]), y), 6, Paint()..color = const Color(0xFF9E9E9E));
      canvas.drawCircle(Offset(xAt(after[i]), y), 6, Paint()..color = changed ? color : _blue);
      if (changed) {
        drawText(canvas, '${fmt(before[i])} → ${fmt(after[i])}',
            Offset(max(xAt(before[i]), xAt(after[i])) + 10, y),
            size: 10, bold: true, color: color, alignment: Alignment.centerLeft);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Cascada: cada paso aporta un tramo flotante y al final aparece el total.
class WaterfallPainter extends CustomPainter {
  WaterfallPainter({required this.labels, required this.values});
  final List<String> labels;
  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    final n = values.length;
    if (n == 0) return;
    final total = values.fold<double>(0, (a, b) => a + b);
    final plot = Rect.fromLTRB(40, 22, size.width - 16, size.height - 30);
    final sc = niceScale(0, total);
    double yAt(double v) => plot.bottom - v / sc.hi * plot.height;
    drawGrid(canvas, plot, 0, sc.hi, sc.step, valueOnY: true);
    final slot = plot.width / (n + 1);
    final barW = slot * 0.6;
    var cum = 0.0;
    for (var i = 0; i <= n; i++) {
      final x = plot.left + slot * i + (slot - barW) / 2;
      final isTotal = i == n;
      final from = isTotal ? 0.0 : cum;
      final to = isTotal ? total : cum + values[i];
      canvas.drawRect(
        Rect.fromLTRB(x, yAt(to), x + barW, yAt(from)),
        Paint()..color = isTotal ? const Color(0xFF263238) : colorFor(0),
      );
      drawText(canvas, isTotal ? fmt(total) : '+${fmt(values[i])}',
          Offset(x + barW / 2, yAt(to) - 3),
          size: 11, bold: true, alignment: Alignment.bottomCenter);
      drawText(canvas, isTotal ? 'Total' : labels[i], Offset(x + barW / 2, plot.bottom + 6),
          size: 11, bold: true, alignment: Alignment.topCenter);
      if (!isTotal) {
        cum = to;
        _dashedH(canvas, x + barW, x + slot, yAt(cum), kMuted);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
