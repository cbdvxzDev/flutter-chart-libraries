import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'gallery_meta.dart';

/// Dibuja la miniatura de una gráfica en un solo color.
///
/// Las formas vienen de los SVG de referencia del plan, con un lienzo de
/// 120 × 64. El lienzo se escala para ocupar el tamaño disponible.
class GlyphPainter extends CustomPainter {
  const GlyphPainter({required this.glyph, required this.color});

  final ChartGlyph glyph;
  final Color color;

  static const _width = 120.0;
  static const _height = 64.0;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width / _width, size.height / _height);
    canvas.save();
    canvas.translate(
      (size.width - _width * scale) / 2,
      (size.height - _height * scale) / 2,
    );
    canvas.scale(scale);
    _GlyphPen(canvas, color).draw(glyph);
    canvas.restore();
  }

  @override
  bool shouldRepaint(GlyphPainter oldDelegate) =>
      oldDelegate.glyph != glyph || oldDelegate.color != color;
}

/// Ayudantes de dibujo sobre el lienzo de 120 × 64.
class _GlyphPen {
  _GlyphPen(this.canvas, this.color);

  final Canvas canvas;
  final Color color;

  Paint _fill([double opacity = 1]) =>
      Paint()..color = color.withValues(alpha: opacity);

  Paint _stroke(
    double width, {
    double opacity = 1,
    bool roundCap = false,
    bool roundJoin = false,
  }) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..color = color.withValues(alpha: opacity)
    ..strokeCap = roundCap ? StrokeCap.round : StrokeCap.butt
    ..strokeJoin = roundJoin ? StrokeJoin.round : StrokeJoin.miter;

  /// Camino que une los puntos [xy] = [x1, y1, x2, y2, ...].
  Path _poly(List<double> xy, {bool close = false}) {
    final path = Path()..moveTo(xy[0], xy[1]);
    for (var i = 2; i < xy.length; i += 2) {
      path.lineTo(xy[i], xy[i + 1]);
    }
    if (close) path.close();
    return path;
  }

  /// Línea de un trazo (equivale a `<polyline>`).
  void _line(List<double> xy, double width, {double opacity = 1}) =>
      canvas.drawPath(
        _poly(xy),
        _stroke(width, opacity: opacity, roundCap: true, roundJoin: true),
      );

  /// Segmentos sueltos [x1, y1, x2, y2] (equivale a `M x1 y1 L x2 y2`).
  void _segments(List<List<double>> lines, Paint paint) {
    for (final l in lines) {
      canvas.drawLine(Offset(l[0], l[1]), Offset(l[2], l[3]), paint);
    }
  }

  void _rect(double x, double y, double w, double h, [double opacity = 1]) =>
      canvas.drawRect(Rect.fromLTWH(x, y, w, h), _fill(opacity));

  /// Cuerpo de vela: relleno con [opacity] y contorno sólido de 1,6.
  void _candleBody(double x, double y, double w, double h, double opacity) {
    final r = Rect.fromLTWH(x, y, w, h);
    canvas.drawRect(r, _fill(opacity));
    canvas.drawRect(r, _stroke(1.6));
  }

  /// Línea horizontal discontinua (trazo 4, hueco 4).
  void _dashedH(double y, double x1, double x2, Paint paint) {
    for (var x = x1; x < x2; x += 8) {
      canvas.drawLine(Offset(x, y), Offset(math.min(x + 4, x2), y), paint);
    }
  }

  void draw(ChartGlyph glyph) {
    switch (glyph) {
      case ChartGlyph.line:
        _line([6, 48, 22, 38, 38, 43, 56, 22, 74, 31, 92, 14, 114, 20], 2.4);

      case ChartGlyph.multi:
        _line(
          [6, 34, 26, 38, 46, 24, 66, 36, 88, 18, 114, 26],
          2.4,
          opacity: 0.4,
        );
        _line([6, 50, 26, 40, 46, 44, 66, 26, 88, 30, 114, 14], 2.4);

      case ChartGlyph.step:
        _line([
          6, 50, 28, 50, 28, 38, 50, 38, 50, 44, //
          72, 44, 72, 22, 94, 22, 94, 14, 114, 14,
        ], 2.4);

      case ChartGlyph.area:
        canvas.drawPath(
          _poly([
            6,
            58,
            6,
            44,
            26,
            34,
            46,
            40,
            66,
            20,
            88,
            26,
            114,
            12,
            114,
            58,
          ], close: true),
          _fill(0.25),
        );
        canvas.drawPath(
          _poly([6, 44, 26, 34, 46, 40, 66, 20, 88, 26, 114, 12]),
          _stroke(2.4, roundJoin: true),
        );

      case ChartGlyph.stackArea:
        canvas.drawPath(
          _poly([
            6,
            58,
            6,
            46,
            28,
            40,
            50,
            44,
            72,
            34,
            94,
            38,
            114,
            30,
            114,
            58,
          ], close: true),
          _fill(0.6),
        );
        canvas.drawPath(
          _poly([
            6, 46, 28, 40, 50, 44, 72, 34, 94, 38, 114, 30, //
            114, 12, 94, 22, 72, 14, 50, 28, 28, 22, 6, 30,
          ], close: true),
          _fill(0.25),
        );

      case ChartGlyph.bars:
        _rect(10, 34, 12, 24);
        _rect(28, 20, 12, 38);
        _rect(46, 28, 12, 30);
        _rect(64, 10, 12, 48);
        _rect(82, 24, 12, 34);
        _rect(100, 38, 12, 20);

      case ChartGlyph.hbars:
        _rect(10, 6, 70, 9);
        _rect(10, 21, 96, 9);
        _rect(10, 36, 52, 9);
        _rect(10, 51, 82, 9);

      case ChartGlyph.stack:
        _rect(12, 40, 12, 18);
        _rect(34, 30, 12, 28);
        _rect(56, 36, 12, 22);
        _rect(78, 26, 12, 32);
        _rect(100, 42, 12, 16);
        _rect(12, 28, 12, 12, 0.3);
        _rect(34, 14, 12, 16, 0.3);
        _rect(56, 24, 12, 12, 0.3);
        _rect(78, 8, 12, 18, 0.3);
        _rect(100, 30, 12, 12, 0.3);

      case ChartGlyph.range:
        _rect(10, 30, 12, 20);
        _rect(28, 18, 12, 22);
        _rect(46, 24, 12, 14);
        _rect(64, 8, 12, 24);
        _rect(82, 20, 12, 26);
        _rect(100, 12, 12, 18);

      case ChartGlyph.pie:
        const center = Offset(60, 32);
        canvas.drawCircle(center, 24, _fill(0.22));
        canvas.drawCircle(center, 24, _stroke(2.4));
        // Porción desde arriba (-90°) hasta 30°, es decir, 120°.
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: 24),
          -math.pi / 2,
          math.pi * 2 / 3,
          true,
          _fill(),
        );

      case ChartGlyph.donut:
        const center = Offset(60, 32);
        canvas.drawCircle(center, 20, _stroke(9, opacity: 0.25));
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: 20),
          -math.pi / 2,
          math.pi * 2 / 3,
          false,
          _stroke(9),
        );

      case ChartGlyph.gauge:
        final rect = Rect.fromCircle(center: const Offset(60, 52), radius: 36);
        canvas.drawArc(
          rect,
          math.pi,
          math.pi,
          false,
          _stroke(9, opacity: 0.25),
        );
        // El 60 % del semicírculo (108°).
        canvas.drawArc(rect, math.pi, math.pi * 0.6, false, _stroke(9));

      case ChartGlyph.scatter:
        final fill = _fill();
        for (final (x, y, r) in const [
          (16.0, 46.0, 4.0),
          (30.0, 36.0, 4.0),
          (44.0, 44.0, 4.0),
          (54.0, 26.0, 6.0),
          (70.0, 34.0, 4.0),
          (82.0, 18.0, 4.0),
          (96.0, 26.0, 7.0),
          (108.0, 12.0, 4.0),
        ]) {
          canvas.drawCircle(Offset(x, y), r, fill);
        }

      case ChartGlyph.bubble:
        for (final (x, y, r) in const [
          (26.0, 42.0, 10.0),
          (58.0, 24.0, 15.0),
          (92.0, 42.0, 7.0),
          (102.0, 16.0, 5.0),
        ]) {
          canvas.drawCircle(Offset(x, y), r, _fill(0.3));
          canvas.drawCircle(Offset(x, y), r, _stroke(2));
        }

      case ChartGlyph.radar:
        canvas.drawPath(
          _poly([60, 4, 88, 24, 78, 58, 42, 58, 32, 24], close: true),
          _stroke(1.2, roundJoin: true),
        );
        final inner = _poly([
          60,
          14,
          80,
          28,
          70,
          48,
          46,
          52,
          40,
          26,
        ], close: true);
        canvas.drawPath(inner, _fill(0.25));
        canvas.drawPath(inner, _stroke(2.4, roundJoin: true));

      case ChartGlyph.candle:
        _segments([
          [15, 30, 15, 58],
          [33, 20, 33, 50],
          [51, 26, 51, 54],
          [69, 10, 69, 40],
          [87, 16, 87, 44],
          [105, 6, 105, 32],
        ], _stroke(1.6));
        _candleBody(10, 36, 10, 16, 1);
        _candleBody(28, 26, 10, 18, 0.25);
        _candleBody(46, 32, 10, 14, 1);
        _candleBody(64, 16, 10, 18, 0.25);
        _candleBody(82, 22, 10, 14, 1);
        _candleBody(100, 10, 10, 16, 0.25);

      case ChartGlyph.graph:
        _segments([
          [22, 34, 54, 14],
          [22, 34, 56, 50],
          [54, 14, 92, 22],
          [56, 50, 92, 22],
          [56, 50, 100, 52],
        ], _stroke(2));
        for (final (x, y) in const [
          (22.0, 34.0),
          (54.0, 14.0),
          (56.0, 50.0),
          (92.0, 22.0),
          (100.0, 52.0),
        ]) {
          canvas.drawCircle(Offset(x, y), 6, _fill());
          canvas.drawCircle(Offset(x, y), 6, _stroke(2));
        }

      case ChartGlyph.matrix:
        const opacities = [
          [1.0, 0.3, 0.6, 0.2, 0.8],
          [0.3, 0.8, 0.2, 1.0, 0.5],
          [0.6, 0.2, 1.0, 0.4, 0.3],
        ];
        for (var row = 0; row < 3; row++) {
          for (var col = 0; col < 5; col++) {
            _rect(17.0 + col * 18, 7.0 + row * 18, 14, 14, opacities[row][col]);
          }
        }

      case ChartGlyph.flow:
        for (final (y1, y2, width) in const [
          (16.0, 13.0, 10.0),
          (44.0, 33.0, 10.0),
          (51.0, 52.0, 8.0),
        ]) {
          canvas.drawPath(
            Path()
              ..moveTo(16, y1)
              ..cubicTo(60, y1, 60, y2, 104, y2),
            _stroke(width, opacity: 0.3),
          );
        }
        _rect(8, 6, 8, 20);
        _rect(8, 36, 8, 20);
        _rect(104, 6, 8, 14);
        _rect(104, 26, 8, 14);
        _rect(104, 46, 8, 12);

      case ChartGlyph.funnel:
        canvas.drawPath(
          _poly([18, 8, 102, 8, 92, 22, 28, 22], close: true),
          _fill(),
        );
        canvas.drawPath(
          _poly([31, 26, 89, 26, 80, 40, 40, 40], close: true),
          _fill(0.6),
        );
        canvas.drawPath(
          _poly([43, 44, 77, 44, 71, 58, 49, 58], close: true),
          _fill(0.3),
        );

      case ChartGlyph.box:
        _segments([
          [30, 10, 30, 22],
          [30, 44, 30, 56],
          [60, 6, 60, 16],
          [60, 36, 60, 50],
          [90, 18, 90, 28],
          [90, 48, 90, 58],
          [20, 32, 40, 32],
          [50, 24, 70, 24],
          [80, 40, 100, 40],
        ], _stroke(2));
        for (final r in const [
          Rect.fromLTWH(20, 22, 20, 22),
          Rect.fromLTWH(50, 16, 20, 20),
          Rect.fromLTWH(80, 28, 20, 20),
        ]) {
          canvas.drawRect(r, _fill(0.25));
          canvas.drawRect(r, _stroke(2));
        }

      case ChartGlyph.band:
        canvas.drawPath(
          _poly([
            6, 30, 26, 22, 46, 28, 66, 12, 88, 18, 114, 8, //
            114, 34, 88, 42, 66, 38, 46, 52, 26, 46, 6, 54,
          ], close: true),
          _fill(0.22),
        );
        _line([6, 42, 26, 34, 46, 40, 66, 25, 88, 30, 114, 21], 2.4);

      case ChartGlyph.osc:
        final dash = _stroke(1.2, roundCap: true);
        _dashedH(16, 6, 114, dash);
        _dashedH(48, 6, 114, dash);
        _line([
          6, 36, 18, 20, 30, 12, 42, 26, 54, 46, //
          66, 54, 78, 38, 90, 18, 102, 24, 114, 40,
        ], 2.4);

      case ChartGlyph.panels:
        _segments([
          [16, 8, 16, 34],
          [38, 4, 38, 28],
          [60, 12, 60, 36],
          [82, 6, 82, 26],
          [104, 2, 104, 22],
          [6, 42, 114, 42],
        ], _stroke(1.6));
        _candleBody(11, 14, 10, 14, 1);
        _candleBody(33, 8, 10, 12, 0.25);
        _candleBody(55, 18, 10, 12, 1);
        _candleBody(77, 10, 10, 10, 0.25);
        _candleBody(99, 6, 10, 10, 0.25);
        _rect(11, 52, 10, 8, 0.6);
        _rect(33, 48, 10, 12, 0.6);
        _rect(55, 54, 10, 6, 0.6);
        _rect(77, 50, 10, 10, 0.6);
        _rect(99, 47, 10, 13, 0.6);

      case ChartGlyph.levels:
        _segments([
          [6, 12, 114, 12],
          [6, 26, 114, 26],
          [6, 38, 114, 38],
          [6, 52, 114, 52],
        ], _stroke(1.2, opacity: 0.5, roundCap: true));
        _line([6, 52, 30, 26, 46, 38, 70, 12, 88, 30, 114, 20], 2.4);

      case ChartGlyph.spark:
        _line([10, 18, 26, 12, 42, 16, 58, 8, 74, 14, 90, 6, 110, 10], 2);
        _line(
          [10, 36, 26, 38, 42, 30, 58, 34, 74, 28, 90, 32, 110, 26],
          2,
          opacity: 0.55,
        );
        _line(
          [10, 56, 26, 50, 42, 54, 58, 46, 74, 52, 90, 48, 110, 44],
          2,
          opacity: 0.3,
        );

      case ChartGlyph.gantt:
        _rect(8, 8, 40, 9);
        _rect(30, 22, 34, 9);
        _rect(52, 36, 44, 9);
        _rect(84, 50, 28, 9);
    }
  }
}
