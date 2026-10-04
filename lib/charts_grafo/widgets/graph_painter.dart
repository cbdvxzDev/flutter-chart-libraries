import 'dart:math';
import 'package:flutter/material.dart';
import 'drawing.dart';

class _E {
  _E(this.u, this.v, this.w);
  final String u, v;
  final int w;
  String get key => '$u>$v';
}

/// Dibuja un grafo dirigido en disposicion circular.
/// [edges]: mapa vertice -> {destino: peso}.
class GraphPainter extends CustomPainter {
  GraphPainter({
    required this.edges,
    this.showWeights = false,
    this.highlightEdges = const {},
    this.newEdges = const {},
    this.highlightVertices = const {},
    this.source,
    this.dim = false,
  });

  final Map<String, Map<String, int>> edges;
  final bool showWeights;
  final Set<String> highlightEdges; // claves 'u>v'
  final Set<String> newEdges;
  final Set<String> highlightVertices;
  final String? source;
  final bool dim;

  static const nodeR = 14.0;
  static const hiColor = Color(0xFFE45756);
  static const newColor = Color(0xFFF58518);

  List<String> get _vs {
    final s = <String>{
      ...edges.keys,
      for (final m in edges.values) ...m.keys,
    };
    return s.toList()..sort();
  }

  Color _edgeColor(_E e) {
    if (highlightEdges.contains(e.key)) return hiColor;
    if (newEdges.contains(e.key)) return newColor;
    return dim ? const Color(0xFFD5DBDF) : const Color(0xFF90A4AE);
  }

  int _rank(_E e) => highlightEdges.contains(e.key)
      ? 3
      : newEdges.contains(e.key)
          ? 2
          : dim
              ? 0
              : 1;

  @override
  void paint(Canvas canvas, Size size) {
    final vs = _vs;
    if (vs.isEmpty) return;
    final center = size.center(Offset.zero);
    final r = max(20.0, min(size.width, size.height) / 2 - 28);
    final pos = <String, Offset>{};
    for (var i = 0; i < vs.length; i++) {
      final a = -pi / 2 + 2 * pi * i / vs.length;
      pos[vs[i]] = center + Offset(cos(a), sin(a)) * r;
    }

    final all = <_E>[
      for (final e in edges.entries)
        for (final t in e.value.entries) _E(e.key, t.key, t.value),
    ]..sort((x, y) => _rank(x).compareTo(_rank(y)));

    for (final e in all) {
      final color = _edgeColor(e);
      final strong = highlightEdges.contains(e.key);
      _drawEdge(canvas, pos[e.u]!, pos[e.v]!, center, color,
          strong ? 3.2 : 1.6, showWeights ? '${e.w}' : null, strong);
    }

    for (final v in vs) {
      final isHi = highlightVertices.contains(v);
      final isSrc = v == source;
      final greyed = dim && !isHi && !isSrc;
      final fill = isSrc
          ? const Color(0xFF54A24B)
          : isHi
              ? hiColor
              : greyed
                  ? const Color(0xFFCFD8DC)
                  : const Color(0xFF4C78A8);
      canvas.drawCircle(pos[v]!, nodeR, Paint()..color = fill);
      canvas.drawCircle(
          pos[v]!,
          nodeR,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = Colors.white);
      drawText(canvas, v, pos[v]!,
          size: 13, bold: true, color: greyed ? kInk : Colors.white);
    }
  }

  void _drawEdge(Canvas canvas, Offset a, Offset b, Offset center, Color color,
      double w, String? label, bool strong) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = w
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    Offset labelAt;
    if (a == b) {
      var dir = a - center;
      dir = dir.distance == 0 ? const Offset(0, -1) : dir / dir.distance;
      final lc = a + dir * (nodeR + 6);
      canvas.drawCircle(lc, 9, paint);
      _head(canvas, a + dir * (nodeR + 1), -dir, color);
      labelAt = lc + dir * 15;
    } else {
      final d = b - a;
      final u = d / d.distance;
      final p1 = a + u * nodeR;
      final p2 = b - u * (nodeR + 1);
      canvas.drawLine(p1, p2, paint);
      _head(canvas, p2, u, color);
      labelAt = Offset.lerp(p1, p2, 0.5)!;
    }
    if (label != null) {
      final tw = textWidth(label, 10);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: labelAt, width: tw + 8, height: 14),
            const Radius.circular(4)),
        Paint()..color = const Color.fromRGBO(255, 255, 255, 0.92),
      );
      drawText(canvas, label, labelAt,
          size: 10, bold: true, color: strong ? hiColor : kInk);
    }
  }

  void _head(Canvas canvas, Offset tip, Offset u, Color color) {
    const s = 9.0;
    final n = Offset(-u.dy, u.dx);
    final p2 = tip - u * s + n * s * 0.4;
    final p3 = tip - u * s - n * s * 0.4;
    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Widget graphView(
  Map<String, Map<String, int>> edges, {
  bool showWeights = false,
  Set<String> highlightEdges = const {},
  Set<String> newEdges = const {},
  Set<String> highlightVertices = const {},
  String? source,
  bool dim = false,
}) =>
    CustomPaint(
      painter: GraphPainter(
        edges: edges,
        showWeights: showWeights,
        highlightEdges: highlightEdges,
        newEdges: newEdges,
        highlightVertices: highlightVertices,
        source: source,
        dim: dim,
      ),
      child: const SizedBox.expand(),
    );
