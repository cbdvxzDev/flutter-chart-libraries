import 'dart:math';
import 'package:flutter/material.dart';

const palette = <Color>[
  Color(0xFF4C78A8), Color(0xFFF58518), Color(0xFF54A24B), Color(0xFFE45756),
  Color(0xFF72B7B2), Color(0xFFEECA3B), Color(0xFFB279A2), Color(0xFF9D755D),
  Color(0xFFBAB0AC), Color(0xFFFF9DA6), Color(0xFF79706E),
];
Color colorFor(int i) => palette[i % palette.length];

const kInk = Color(0xFF263238);
const kMuted = Color(0xFF78909C);
const kGrid = Color(0xFFE3E8EB);

String fmt(num v) =>
    v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);

/// Dibuja texto alineado respecto a [pos] (Alignment.center = centrado).
Size drawText(Canvas canvas, String text, Offset pos,
    {double size = 11,
    Color color = kInk,
    bool bold = false,
    Alignment alignment = Alignment.center}) {
  final tp = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        fontSize: size,
        color: color,
        fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  tp.paint(
    canvas,
    pos - Offset(tp.width * (alignment.x + 1) / 2, tp.height * (alignment.y + 1) / 2),
  );
  return tp.size;
}

double textWidth(String text, double size) {
  final tp = TextPainter(
    text: TextSpan(text: text, style: TextStyle(fontSize: size)),
    textDirection: TextDirection.ltr,
  )..layout();
  return tp.width;
}

/// Leyenda en filas que se ajustan al ancho. Devuelve la altura usada.
double drawLegend(Canvas canvas, double width, List<MapEntry<String, Color>> items,
    {double left = 12, double top = 6}) {
  double x = left, y = top;
  const rowH = 16.0;
  for (final it in items) {
    final w = textWidth(it.key, 10) + 20;
    if (x + w > width - 8 && x > left) {
      x = left;
      y += rowH;
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y + 3, 10, 10), const Radius.circular(2)),
      Paint()..color = it.value,
    );
    drawText(canvas, it.key, Offset(x + 14, y + 8),
        size: 10, alignment: Alignment.centerLeft);
    x += w + 6;
  }
  return y + rowH - top;
}

({double lo, double hi, double step}) niceScale(double minV, double maxV,
    {int ticks = 5}) {
  if (maxV == minV) maxV = minV + 1;
  final raw = (maxV - minV) / ticks;
  final mag = pow(10, (log(raw) / ln10).floorToDouble()).toDouble();
  final norm = raw / mag;
  final step = (norm <= 1 ? 1 : norm <= 2 ? 2 : norm <= 5 ? 5 : 10) * mag;
  return (
    lo: (minV / step).floorToDouble() * step,
    hi: (maxV / step).ceilToDouble() * step,
    step: step,
  );
}

void drawGrid(Canvas canvas, Rect plot, double lo, double hi, double step,
    {required bool valueOnY}) {
  final grid = Paint()
    ..color = kGrid
    ..strokeWidth = 1;
  final count = ((hi - lo) / step).round();
  for (var k = 0; k <= count; k++) {
    final v = lo + k * step;
    final t = (v - lo) / (hi - lo);
    if (valueOnY) {
      final y = plot.bottom - t * plot.height;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), grid);
      drawText(canvas, fmt(v), Offset(plot.left - 6, y),
          size: 10, color: kMuted, alignment: Alignment.centerRight);
    } else {
      final x = plot.left + t * plot.width;
      canvas.drawLine(Offset(x, plot.top), Offset(x, plot.bottom), grid);
      drawText(canvas, fmt(v), Offset(x, plot.bottom + 6),
          size: 10, color: kMuted, alignment: Alignment.topCenter);
    }
  }
}

void drawTextRotated(Canvas canvas, String text, Offset pos, double angle,
    {double size = 10, Color color = kInk, bool bold = false}) {
  canvas.save();
  canvas.translate(pos.dx, pos.dy);
  canvas.rotate(angle);
  drawText(canvas, text, Offset.zero,
      size: size, color: color, bold: bold, alignment: Alignment.centerRight);
  canvas.restore();
}

void drawDashedLine(Canvas canvas, Offset a, Offset b, Paint paint,
    {double dash = 6, double gap = 4}) {
  final d = b - a;
  final len = d.distance;
  if (len == 0) return;
  final u = d / len;
  var t = 0.0;
  while (t < len) {
    final e = min(t + dash, len);
    canvas.drawLine(a + u * t, a + u * e, paint);
    t += dash + gap;
  }
}
