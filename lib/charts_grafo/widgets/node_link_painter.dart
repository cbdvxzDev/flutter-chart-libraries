import 'dart:math';
import 'package:flutter/material.dart';
import 'drawing.dart';

enum NodeShape { circle, pill, diamond, rect }

/// Recuadro que agrupa varios vertices (por ejemplo, un ciclo).
class NodeGroup {
  const NodeGroup(this.vertices, this.color, {this.label = ''});
  final List<String> vertices;
  final Color color;
  final String label;
}

/// Dibuja un grafo dirigido con posiciones dadas (normalizadas de 0 a 1).
/// Sirve para todos los layouts: circular, por capas, de fuerzas, arbol...
class NodeLinkPainter extends CustomPainter {
  NodeLinkPainter({
    required this.pos,
    required this.edges,
    this.nodeColor = const {},
    this.nodeShape = const {},
    this.nodeCaption = const {},
    this.edgeColor = const {},
    this.dashed = const {},
    this.faded = const {},
    this.curved = const {},
    this.edgeLabels = const {},
    this.groups = const [],
    this.headers = const {},
    this.nodeR = 14,
    this.square = false,
    this.defaultColor = const Color(0xFF4C78A8),
    this.margin = const EdgeInsets.all(30),
  });

  final Map<String, Offset> pos;
  final Map<String, Map<String, int>> edges;
  final Map<String, Color> nodeColor;
  final Map<String, NodeShape> nodeShape;
  final Map<String, String> nodeCaption;

  /// Las aristas con color propio se dibujan mas gruesas.
  final Map<String, Color> edgeColor;
  final Set<String> dashed, faded, curved;
  final Map<String, String> edgeLabels;
  final List<NodeGroup> groups;

  /// Titulos de columna: x normalizada -> texto.
  final Map<double, String> headers;
  final double nodeR;

  /// Si es true, el area de dibujo es un cuadrado (para layouts circulares).
  final bool square;
  final Color defaultColor;
  final EdgeInsets margin;

  static const _grey = Color(0xFF90A4AE);
  static const _fadedColor = Color(0xFFDDE3E7);

  static Rect _area(Size size, EdgeInsets m, bool square) {
    var r = Rect.fromLTRB(m.left, m.top, size.width - m.right, size.height - m.bottom);
    if (square) {
      final s = max(1.0, min(r.width, r.height));
      r = Rect.fromCenter(center: r.center, width: s, height: s);
    }
    return r;
  }

  /// Convierte una posicion normalizada a pixeles (tambien la usan los toques).
  static Offset toPixel(Offset n, Size size, EdgeInsets m, bool square) {
    final r = _area(size, m, square);
    return Offset(r.left + n.dx * r.width, r.top + n.dy * r.height);
  }

  Size _half(NodeShape s) {
    switch (s) {
      case NodeShape.circle:
        return Size(nodeR, nodeR);
      case NodeShape.pill:
        return Size(nodeR * 1.7, nodeR * 0.85);
      case NodeShape.rect:
        return Size(nodeR * 1.5, nodeR * 0.9);
      case NodeShape.diamond:
        return Size(nodeR * 1.6, nodeR * 1.15);
    }
  }

  double _boundary(NodeShape s, Offset u) {
    final h = _half(s);
    final ux = u.dx.abs();
    final uy = u.dy.abs();
    switch (s) {
      case NodeShape.circle:
        return h.width;
      case NodeShape.diamond:
        return 1 / (ux / h.width + uy / h.height);
      case NodeShape.pill:
      case NodeShape.rect:
        final tx = ux < 1e-6 ? double.infinity : h.width / ux;
        final ty = uy < 1e-6 ? double.infinity : h.height / uy;
        return min(tx, ty);
    }
  }

  Offset _unit(Offset d) => d.distance == 0 ? const Offset(1, 0) : d / d.distance;

  Offset _quad(Offset a, Offset c, Offset b, double t) {
    final u = 1 - t;
    return a * (u * u) + c * (2 * u * t) + b * (t * t);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Offset px(String v) => toPixel(pos[v]!, size, margin, square);

    // Recuadros de grupo
    for (final g in groups) {
      final pts = [for (final v in g.vertices) if (pos.containsKey(v)) px(v)];
      if (pts.isEmpty) continue;
      var rect = Rect.fromPoints(pts.first, pts.first);
      for (final p in pts) {
        rect = rect.expandToInclude(Rect.fromPoints(p, p));
      }
      rect = rect.inflate(nodeR + 12);
      final rr = RRect.fromRectAndRadius(rect, const Radius.circular(14));
      canvas.drawRRect(rr, Paint()..color = g.color.withAlpha(30));
      canvas.drawRRect(
          rr,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5
            ..color = g.color.withAlpha(150));
      if (g.label.isNotEmpty) {
        drawText(canvas, g.label, rect.topLeft + const Offset(8, 3),
            size: 10, bold: true, color: g.color, alignment: Alignment.topLeft);
      }
    }

    // Titulos de columna
    headers.forEach((nx, text) {
      final x = toPixel(Offset(nx, 0), size, margin, square).dx;
      drawText(canvas, text, Offset(x, 4),
          size: 11, bold: true, color: kMuted, alignment: Alignment.topCenter);
    });

    // Aristas: primero las atenuadas, al final las resaltadas
    final list = <List<Object>>[];
    for (final e in edges.entries) {
      for (final t in e.value.entries) {
        if (!pos.containsKey(e.key) || !pos.containsKey(t.key)) continue;
        final key = '${e.key}>${t.key}';
        final rank = faded.contains(key) ? 0 : (edgeColor.containsKey(key) ? 2 : 1);
        list.add([rank, e.key, t.key]);
      }
    }
    list.sort((a, b) => (a[0] as int).compareTo(b[0] as int));
    for (final it in list) {
      final u = it[1] as String;
      final v = it[2] as String;
      final key = '$u>$v';
      final isFaded = faded.contains(key);
      final color = edgeColor[key] ?? (isFaded ? _fadedColor : _grey);
      final strong = edgeColor.containsKey(key);
      _edge(canvas, px(u), px(v), u, v, color, strong ? 3.0 : 1.6,
          dashed.contains(key), curved.contains(key), edgeLabels[key], strong);
    }

    // Vertices
    for (final v in pos.keys) {
      final p = px(v);
      final shape = nodeShape[v] ?? NodeShape.circle;
      final h = _half(shape);
      final fill = Paint()..color = nodeColor[v] ?? defaultColor;
      final stroke = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white;
      switch (shape) {
        case NodeShape.circle:
          canvas.drawCircle(p, nodeR, fill);
          canvas.drawCircle(p, nodeR, stroke);
        case NodeShape.pill:
        case NodeShape.rect:
          final rr = RRect.fromRectAndRadius(
              Rect.fromCenter(center: p, width: h.width * 2, height: h.height * 2),
              Radius.circular(shape == NodeShape.pill ? h.height : 6));
          canvas.drawRRect(rr, fill);
          canvas.drawRRect(rr, stroke);
        case NodeShape.diamond:
          final path = Path()
            ..moveTo(p.dx, p.dy - h.height)
            ..lineTo(p.dx + h.width, p.dy)
            ..lineTo(p.dx, p.dy + h.height)
            ..lineTo(p.dx - h.width, p.dy)
            ..close();
          canvas.drawPath(path, fill);
          canvas.drawPath(path, stroke);
      }
      drawText(canvas, v, p, size: 13, bold: true, color: Colors.white);
      final cap = nodeCaption[v];
      if (cap != null) {
        drawText(canvas, cap, p + Offset(0, h.height + 3),
            size: 10, bold: true, alignment: Alignment.topCenter);
      }
    }
  }

  void _edge(Canvas canvas, Offset a, Offset b, String u, String v, Color color,
      double width, bool dash, bool curve, String? label, bool strong) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    Offset labelAt;

    if (u == v) {
      // Bucle: circulo sobre el vertice
      final lc = a + Offset(0, -(nodeR + 8));
      canvas.drawCircle(lc, 9, paint);
      _head(canvas, a + Offset(0, -(nodeR + 1)), const Offset(0, 1), color);
      labelAt = lc + const Offset(0, -16);
    } else {
      final su = nodeShape[u] ?? NodeShape.circle;
      final sv = nodeShape[v] ?? NodeShape.circle;
      Offset c = a;
      if (curve) {
        final d = b - a;
        final nrm = Offset(-d.dy, d.dx) / max(d.distance, 1);
        c = (a + b) / 2 + nrm * min(70.0, d.distance * 0.4);
      }
      final dirStart = _unit((curve ? c : b) - a);
      final dirEnd = _unit(b - (curve ? c : a));
      final p1 = a + dirStart * (_boundary(su, dirStart) + 1);
      final p2 = b - dirEnd * (_boundary(sv, dirEnd) + 2);
      if (curve) {
        if (dash) {
          const n = 24;
          for (var i = 0; i < n; i += 2) {
            canvas.drawLine(_quad(p1, c, p2, i / n), _quad(p1, c, p2, (i + 1) / n), paint);
          }
        } else {
          final path = Path()
            ..moveTo(p1.dx, p1.dy)
            ..quadraticBezierTo(c.dx, c.dy, p2.dx, p2.dy);
          canvas.drawPath(path, paint);
        }
        labelAt = _quad(p1, c, p2, 0.5);
      } else {
        if (dash) {
          drawDashedLine(canvas, p1, p2, paint);
        } else {
          canvas.drawLine(p1, p2, paint);
        }
        labelAt = Offset.lerp(p1, p2, 0.5)!;
      }
      _head(canvas, p2, dirEnd, color);
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
          size: 10, bold: true, color: strong ? color : kInk);
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

/// Punto que se mueve de un vertice a otro (para las animaciones).
class DotPainter extends CustomPainter {
  DotPainter({
    required this.pos,
    required this.from,
    required this.to,
    required this.t,
    this.margin = const EdgeInsets.all(30),
    this.square = false,
    this.color = const Color(0xFFE45756),
  });
  final Map<String, Offset> pos;
  final String from, to;
  final double t;
  final EdgeInsets margin;
  final bool square;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final a = pos[from];
    final b = pos[to];
    if (a == null || b == null) return;
    final pa = NodeLinkPainter.toPixel(a, size, margin, square);
    final pb = NodeLinkPainter.toPixel(b, size, margin, square);
    final p = Offset.lerp(pa, pb, t.clamp(0.0, 1.0))!;
    canvas.drawCircle(p, 7, Paint()..color = Colors.white);
    canvas.drawCircle(p, 5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
