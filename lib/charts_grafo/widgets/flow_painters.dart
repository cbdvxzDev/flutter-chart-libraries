import 'dart:math';
import 'package:flutter/material.dart';
import '../grafos/algoritmos.dart';
import 'drawing.dart';

// ------------------------------------------------------------------- Gantt

/// Gantt de un [Schedule]: una barra por tarea y una linea por dependencia.
class GanttPainter extends CustomPainter {
  GanttPainter({required this.schedule, required this.dag, this.critical = false});
  final Schedule schedule;
  final EdgeMap dag;

  /// Si es true, la ruta critica se pinta en rojo y la holgura en gris claro.
  final bool critical;

  static const _blue = Color(0xFF4C78A8);
  static const _red = Color(0xFFE45756);

  @override
  void paint(Canvas canvas, Size size) {
    final tasks = schedule.tasks;
    final n = tasks.length;
    if (n == 0) return;
    final plot = Rect.fromLTRB(34, 8, size.width - 16, size.height - 26);
    final rowH = plot.height / n;
    final barH = min(18.0, rowH * 0.64);
    double x(num t) => plot.left + t / schedule.length * plot.width;
    double rowY(int i) => plot.top + rowH * (i + 0.5);
    final row = {for (var i = 0; i < n; i++) tasks[i].id: i};
    final byId = {for (final t in tasks) t.id: t};

    final step = schedule.length > 14 ? 2 : 1;
    final grid = Paint()
      ..color = kGrid
      ..strokeWidth = 1;
    for (var t = 0; t <= schedule.length; t += step) {
      canvas.drawLine(Offset(x(t), plot.top), Offset(x(t), plot.bottom), grid);
      drawText(canvas, '$t', Offset(x(t), plot.bottom + 4),
          size: 10, color: kMuted, alignment: Alignment.topCenter);
    }

    // Dependencias (debajo de las barras)
    for (final e in dag.entries) {
      for (final t in e.value.keys) {
        final u = byId[e.key];
        final v = byId[t];
        if (u == null || v == null) continue;
        final isCrit = critical && schedule.criticalDeps.contains('${e.key}>$t');
        final x1 = x(u.end);
        final x2 = x(v.start);
        final y1 = rowY(row[e.key]!);
        final y2 = rowY(row[t]!);
        final mx = (x1 + x2) / 2;
        final p = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = isCrit ? 2 : 1
          ..color = isCrit ? _red : const Color(0xFFB0BEC5);
        canvas.drawPath(
          Path()
            ..moveTo(x1, y1)
            ..lineTo(mx, y1)
            ..lineTo(mx, y2)
            ..lineTo(x2, y2),
          p,
        );
        final head = Path()
          ..moveTo(x2, y2)
          ..lineTo(x2 - 5, y2 - 3)
          ..lineTo(x2 - 5, y2 + 3)
          ..close();
        canvas.drawPath(head, Paint()..color = p.color);
      }
    }

    for (var i = 0; i < n; i++) {
      final t = tasks[i];
      final y = rowY(i);
      drawText(canvas, t.id, Offset(plot.left - 8, y),
          size: 12, bold: true, alignment: Alignment.centerRight);
      if (critical && !t.critical && t.slack > 0) {
        final r = Rect.fromLTRB(x(t.end), y - barH / 2, x(t.end + t.slack), y + barH / 2);
        canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(4)),
            Paint()..color = const Color(0xFFE3E8EB));
      }
      final bar = Rect.fromLTRB(x(t.start), y - barH / 2, x(t.end), y + barH / 2);
      canvas.drawRRect(
        RRect.fromRectAndRadius(bar, const Radius.circular(4)),
        Paint()..color = critical && t.critical ? _red : _blue,
      );
      if (bar.width > 16) {
        drawText(canvas, '${t.dur}', bar.center,
            size: 10, bold: true, color: Colors.white);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ------------------------------------------------------------------ Sankey

class _Link {
  _Link(this.u, this.v, this.w);
  final String u, v;
  final double w;
  double sy = 0, ty = 0;
}

/// Sankey: columnas por capa; el grosor de cada banda es el peso de la arista.
class SankeyPainter extends CustomPainter {
  SankeyPainter({required this.edges, required this.layers});
  final EdgeMap edges;
  final Map<String, int> layers;

  @override
  void paint(Canvas canvas, Size size) {
    final vs = layers.keys.toList()..sort();
    if (vs.isEmpty) return;
    final maxL = layers.values.fold<int>(0, (a, b) => max(a, b));
    final cols = List.generate(maxL + 1, (_) => <String>[]);
    for (final v in vs) {
      cols[layers[v]!].add(v);
    }
    final outW = {for (final v in vs) v: 0.0};
    final inW = {for (final v in vs) v: 0.0};
    final links = <_Link>[];
    for (final e in edges.entries) {
      for (final t in e.value.entries) {
        if (t.value <= 0 || e.key == t.key) continue;
        links.add(_Link(e.key, t.key, t.value.toDouble()));
        outW[e.key] = outW[e.key]! + t.value;
        inW[t.key] = inW[t.key]! + t.value;
      }
    }
    final val = {for (final v in vs) v: max(1.0, max(outW[v]!, inW[v]!))};

    const gap = 10.0;
    const nodeW = 12.0;
    final plot = Rect.fromLTRB(12, 10, size.width - 34, size.height - 10);
    var scale = double.infinity;
    for (final c in cols) {
      if (c.isEmpty) continue;
      final sum = c.fold<double>(0, (a, v) => a + val[v]!);
      scale = min(scale, (plot.height - gap * (c.length - 1)) / sum);
    }
    double colX(int l) =>
        plot.left + (maxL == 0 ? 0.0 : l / maxL * (plot.width - nodeW));

    final top = <String, double>{};
    for (final c in cols) {
      if (c.isEmpty) continue;
      final total = c.fold<double>(0, (a, v) => a + val[v]! * scale) + gap * (c.length - 1);
      var y = plot.top + (plot.height - total) / 2;
      for (final v in c) {
        top[v] = y;
        y += val[v]! * scale + gap;
      }
    }

    for (final u in vs) {
      final out = links.where((l) => l.u == u).toList()
        ..sort((a, b) => top[a.v]!.compareTo(top[b.v]!));
      var cur = top[u]!;
      for (final l in out) {
        l.sy = cur + l.w * scale / 2;
        cur += l.w * scale;
      }
      final inc = links.where((l) => l.v == u).toList()
        ..sort((a, b) => top[a.u]!.compareTo(top[b.u]!));
      var cin = top[u]!;
      for (final l in inc) {
        l.ty = cin + l.w * scale / 2;
        cin += l.w * scale;
      }
    }

    for (final l in links) {
      final x0 = colX(layers[l.u]!) + nodeW;
      final x1 = colX(layers[l.v]!);
      final mx = (x0 + x1) / 2;
      canvas.drawPath(
        Path()
          ..moveTo(x0, l.sy)
          ..cubicTo(mx, l.sy, mx, l.ty, x1, l.ty),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = max(1.5, l.w * scale)
          ..color = colorFor(vs.indexOf(l.u)).withAlpha(120),
      );
    }

    for (final v in vs) {
      final r = Rect.fromLTWH(colX(layers[v]!), top[v]!, nodeW, val[v]! * scale);
      canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(3)),
          Paint()..color = colorFor(vs.indexOf(v)));
      drawText(canvas, v, Offset(r.right + 4, r.center.dy),
          size: 12, bold: true, alignment: Alignment.centerLeft);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ------------------------------------------------------------------ Cuerdas

class _Slot {
  _Slot(this.a0, this.a1);
  final double a0, a1;
}

/// Diagrama de cuerdas: cada vertice es un arco; cada arista, una cinta cuyo
/// ancho es su peso.
class ChordPainter extends CustomPainter {
  ChordPainter(this.edges);
  final EdgeMap edges;

  @override
  void paint(Canvas canvas, Size size) {
    final all = allVertices(edges);
    final total = {for (final v in all) v: 0.0};
    final live = <List<String>>[]; // aristas con peso > 0 y sin bucle
    for (final e in edges.entries) {
      for (final t in e.value.entries) {
        if (t.value <= 0 || e.key == t.key) continue;
        total[e.key] = total[e.key]! + t.value;
        total[t.key] = total[t.key]! + t.value;
        live.add([e.key, t.key]);
      }
    }
    final vs = [for (final v in all) if (total[v]! > 0) v];
    if (vs.isEmpty) return;
    final sum = vs.fold<double>(0, (a, v) => a + total[v]!);
    const gap = 0.07;
    final k = (2 * pi - gap * vs.length) / sum;
    final c = size.center(Offset.zero);
    final R = min(size.width, size.height) / 2 - 26;
    const ring = 10.0;
    final rin = R - ring - 2;
    final rect = Rect.fromCircle(center: c, radius: rin);

    final start = <String, double>{};
    var a = -pi / 2;
    for (final v in vs) {
      start[v] = a;
      a += total[v]! * k + gap;
    }

    // Reparto de tramos dentro de cada arco: primero salientes, luego entrantes
    final outSlot = <String, _Slot>{};
    final inSlot = <String, _Slot>{};
    for (final v in vs) {
      var cur = start[v]!;
      for (final t in edges[v]?.entries ?? const <MapEntry<String, int>>[]) {
        if (t.value <= 0 || t.key == v) continue;
        final w = t.value * k;
        outSlot['$v>${t.key}'] = _Slot(cur, cur + w);
        cur += w;
      }
      for (final e in edges.entries) {
        final w0 = e.value[v];
        if (w0 == null || w0 <= 0 || e.key == v) continue;
        final w = w0 * k;
        inSlot['${e.key}>$v'] = _Slot(cur, cur + w);
        cur += w;
      }
    }

    Offset pt(double ang) => c + Offset(cos(ang), sin(ang)) * rin;

    final order = [...live]..sort(
        (x, y) => edges[y[0]]![y[1]]!.compareTo(edges[x[0]]![x[1]]!));
    for (final e in order) {
      final s = outSlot['${e[0]}>${e[1]}']!;
      final d = inSlot['${e[0]}>${e[1]}']!;
      final path = Path()
        ..moveTo(pt(s.a0).dx, pt(s.a0).dy)
        ..arcTo(rect, s.a0, s.a1 - s.a0, false)
        ..quadraticBezierTo(c.dx, c.dy, pt(d.a0).dx, pt(d.a0).dy)
        ..arcTo(rect, d.a0, d.a1 - d.a0, false)
        ..quadraticBezierTo(c.dx, c.dy, pt(s.a0).dx, pt(s.a0).dy)
        ..close();
      canvas.drawPath(path, Paint()..color = colorFor(vs.indexOf(e[0])).withAlpha(120));
    }

    final outer = Rect.fromCircle(center: c, radius: R - ring / 2);
    for (final v in vs) {
      final sweep = total[v]! * k;
      canvas.drawArc(
          outer,
          start[v]!,
          sweep,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = ring
            ..color = colorFor(vs.indexOf(v)));
      final mid = start[v]! + sweep / 2;
      drawText(canvas, v, c + Offset(cos(mid), sin(mid)) * (R + 12),
          size: 13, bold: true);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ----------------------------------------------------------------- Sunburst

Path _sector(Offset c, double r0, double r1, double a0, double sweep) => Path()
  ..arcTo(Rect.fromCircle(center: c, radius: r1), a0, sweep, true)
  ..arcTo(Rect.fromCircle(center: c, radius: r0), a0 + sweep, -sweep, false)
  ..close();

/// Sunburst: el centro es el origen y cada anillo es un salto mas.
class SunburstPainter extends CustomPainter {
  SunburstPainter({required this.root, required this.kids, required this.hops});
  final String root;
  final Map<String, List<String>> kids;
  final Map<String, int> hops;

  double _value(String v) {
    final ks = kids[v] ?? const <String>[];
    if (ks.isEmpty) return 1;
    return ks.fold<double>(0, (a, k) => a + _value(k));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final maxD = max(1, hops.values.fold<int>(0, (a, b) => max(a, b)));
    final R = min(size.width, size.height) / 2 - 6;
    final r0 = R * 0.2;
    final ring = (R - r0) / maxD;

    void draw(String v, double a0, double sweep, int depth, int ci) {
      final ks = kids[v] ?? const <String>[];
      if (ks.isEmpty) return;
      final tot = ks.fold<double>(0, (a, k) => a + _value(k));
      var cur = a0;
      for (var i = 0; i < ks.length; i++) {
        final k = ks[i];
        final sw = sweep * _value(k) / tot;
        final d = depth + 1;
        final branch = depth == 0 ? i : ci;
        final rIn = r0 + (d - 1) * ring;
        final rOut = r0 + d * ring;
        canvas.drawPath(_sector(c, rIn, rOut, cur, sw),
            Paint()..color = Color.lerp(colorFor(branch), Colors.white, 0.14 * (d - 1))!);
        canvas.drawPath(
            _sector(c, rIn, rOut, cur, sw),
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = Colors.white);
        final mid = cur + sw / 2;
        final rm = (rIn + rOut) / 2;
        if (sw * rm > 18) {
          drawText(canvas, k, c + Offset(cos(mid), sin(mid)) * rm,
              size: 13, bold: true, color: Colors.white);
        }
        draw(k, cur, sw, d, branch);
        cur += sw;
      }
    }

    draw(root, -pi / 2, 2 * pi, 0, 0);
    canvas.drawCircle(c, r0 - 2, Paint()..color = kInk);
    drawText(canvas, root, c, size: 16, bold: true, color: Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// --------------------------------------------------------- Treemap jerarquico

class TNode {
  const TNode(this.label, this.value, [this.kids = const []]);
  final String label;

  /// Solo cuenta en las hojas; un grupo suma el area de sus hijos.
  final double value;
  final List<TNode> kids;
  double get area => kids.isEmpty ? value : kids.fold(0.0, (a, k) => a + k.area);
}

/// Treemap con grupos anidados (cada grupo es un subarbol del bosque).
class HierTreemapPainter extends CustomPainter {
  HierTreemapPainter(this.root);
  final TNode root;

  void _draw(Canvas canvas, TNode n, Rect r, int depth, Color branch) {
    final leaf = n.kids.isEmpty;
    final rr = RRect.fromRectAndRadius(r.deflate(1), const Radius.circular(8));
    canvas.drawRRect(
        rr, Paint()..color = leaf ? branch : Color.lerp(branch, Colors.white, 0.82)!);
    if (!leaf) {
      canvas.drawRRect(
          rr,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5
            ..color = branch.withAlpha(140));
    }
    final canLabel = r.width > 30 && r.height > 24;
    if (canLabel) {
      drawText(canvas, n.label, r.topLeft + const Offset(8, 5),
          size: leaf ? 14 : 12,
          bold: true,
          color: leaf ? Colors.white : kInk,
          alignment: Alignment.topLeft);
    }
    if (leaf) return;
    final inner = Rect.fromLTRB(
        r.left + 5, r.top + (canLabel ? 22 : 5), r.right - 5, r.bottom - 5);
    if (inner.width <= 4 || inner.height <= 4) return;
    final total = n.area;
    var cur = 0.0;
    for (var i = 0; i < n.kids.length; i++) {
      final k = n.kids[i];
      final f = k.area / total;
      final Rect kr = inner.width >= inner.height
          ? Rect.fromLTWH(inner.left + inner.width * cur, inner.top, inner.width * f, inner.height)
          : Rect.fromLTWH(inner.left, inner.top + inner.height * cur, inner.width, inner.height * f);
      cur += f;
      _draw(canvas, k, kr, depth + 1, depth == 0 ? colorFor(i) : branch);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _draw(canvas, root, Rect.fromLTWH(2, 2, size.width - 4, size.height - 4), 0, kInk);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// -------------------------------------------------------------- Streamgraph

class StreamSeries {
  const StreamSeries(this.name, this.values, this.color);
  final String name;
  final List<double> values;
  final Color color;
}

/// Streamgraph: areas apiladas con la linea base centrada y curvas suaves.
class StreamgraphPainter extends CustomPainter {
  StreamgraphPainter({required this.xLabels, required this.series});
  final List<String> xLabels;
  final List<StreamSeries> series;

  @override
  void paint(Canvas canvas, Size size) {
    final n = xLabels.length;
    if (n < 2 || series.isEmpty) return;
    final legendH = drawLegend(
        canvas, size.width, [for (final s in series) MapEntry(s.name, s.color)]);
    final plot = Rect.fromLTRB(20, legendH + 14, size.width - 20, size.height - 26);
    final totals = [
      for (var i = 0; i < n; i++) series.fold<double>(0, (a, s) => a + s.values[i]),
    ];
    final maxT = max(1.0, totals.reduce(max));
    final sy = plot.height / maxT;
    double x(int i) => plot.left + i / (n - 1) * plot.width;

    final base = [for (final t in totals) plot.center.dy - t * sy / 2];
    var lower = List<double>.from(base);
    canvas.drawLine(Offset(plot.left, plot.bottom), Offset(plot.right, plot.bottom),
        Paint()..color = kGrid);
    for (var i = 0; i < n; i++) {
      drawText(canvas, xLabels[i], Offset(x(i), plot.bottom + 5),
          size: 10, color: kMuted, alignment: Alignment.topCenter);
    }

    for (final s in series) {
      final upper = [for (var i = 0; i < n; i++) lower[i] + s.values[i] * sy];
      final up = [for (var i = 0; i < n; i++) Offset(x(i), lower[i])];
      final lo = [for (var i = 0; i < n; i++) Offset(x(i), upper[i])];
      final path = Path()..moveTo(up.first.dx, up.first.dy);
      for (var i = 1; i < n; i++) {
        final mx = (up[i - 1].dx + up[i].dx) / 2;
        path.cubicTo(mx, up[i - 1].dy, mx, up[i].dy, up[i].dx, up[i].dy);
      }
      path.lineTo(lo.last.dx, lo.last.dy);
      for (var i = n - 1; i > 0; i--) {
        final mx = (lo[i - 1].dx + lo[i].dx) / 2;
        path.cubicTo(mx, lo[i].dy, mx, lo[i - 1].dy, lo[i - 1].dx, lo[i - 1].dy);
      }
      path.close();
      canvas.drawPath(path, Paint()..color = s.color.withAlpha(215));
      lower = upper;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
