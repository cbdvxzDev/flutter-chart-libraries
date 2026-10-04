import 'dart:math';
import 'dart:ui' show Offset;
import 'algoritmos.dart';

/// Todas las posiciones son normalizadas (0 a 1); el pintor las escala.

Map<String, Offset> circularLayout(List<String> vs) {
  final n = vs.length;
  return {
    for (var i = 0; i < n; i++)
      vs[i]: Offset(
        0.5 + 0.5 * cos(-pi / 2 + 2 * pi * i / n),
        0.5 + 0.5 * sin(-pi / 2 + 2 * pi * i / n),
      ),
  };
}

/// Columnas por capa. Dentro de cada columna se ordena por baricentro para
/// reducir cruces. [ignore] son aristas 'u>v' que no cuentan para ordenar.
Map<String, Offset> layeredLayout(EdgeMap g, Map<String, int> layer,
    {Set<String> ignore = const {}}) {
  final names = layer.keys.toList()..sort();
  final maxL = layer.values.fold<int>(0, (a, b) => max(a, b));
  final cols = List.generate(maxL + 1, (_) => <String>[]);
  for (final v in names) {
    cols[layer[v]!].add(v);
  }
  final preds = {for (final v in names) v: <String>[]};
  for (final e in g.entries) {
    for (final t in e.value.keys) {
      if (ignore.contains('${e.key}>$t')) continue;
      if (layer[e.key]! < layer[t]!) preds[t]!.add(e.key);
    }
  }
  final idx = <String, double>{
    for (final c in cols)
      for (var i = 0; i < c.length; i++) c[i]: i.toDouble(),
  };
  for (var sweep = 0; sweep < 4; sweep++) {
    for (var l = 1; l <= maxL; l++) {
      double bary(String v) {
        final p = preds[v]!;
        if (p.isEmpty) return idx[v]!;
        return p.fold<double>(0, (a, u) => a + idx[u]!) / p.length;
      }

      cols[l].sort((a, b) {
        final c = bary(a).compareTo(bary(b));
        return c != 0 ? c : a.compareTo(b);
      });
      for (var i = 0; i < cols[l].length; i++) {
        idx[cols[l][i]] = i.toDouble();
      }
    }
  }
  final maxN = cols.fold<int>(1, (a, c) => max(a, c.length));
  final step = maxN <= 1 ? 0.0 : 1.0 / (maxN - 1);
  final out = <String, Offset>{};
  for (var l = 0; l <= maxL; l++) {
    final c = cols[l];
    for (var i = 0; i < c.length; i++) {
      out[c[i]] = Offset(
        maxL == 0 ? 0.5 : l / maxL,
        0.5 + (i - (c.length - 1) / 2) * step,
      );
    }
  }
  return out;
}

/// Fruchterman-Reingold determinista (semilla fija).
Map<String, Offset> forceLayout(EdgeMap g, {int iterations = 300}) {
  final vs = allVertices(g);
  final n = vs.length;
  if (n == 0) return {};
  final rnd = Random(4);
  final p = [for (var i = 0; i < n; i++) Offset(rnd.nextDouble(), rnd.nextDouble())];
  final idx = {for (var i = 0; i < n; i++) vs[i]: i};
  final links = <List<int>>[
    for (final e in g.entries)
      for (final t in e.value.keys)
        if (e.key != t) [idx[e.key]!, idx[t]!],
  ];
  final k = sqrt(1.0 / n);
  var temp = 0.15;
  for (var it = 0; it < iterations; it++) {
    final disp = List<Offset>.filled(n, Offset.zero);
    for (var i = 0; i < n; i++) {
      for (var j = i + 1; j < n; j++) {
        final d = p[i] - p[j];
        final dist = max(d.distance, 0.001);
        final f = k * k / dist;
        final push = d / dist * f;
        disp[i] = disp[i] + push;
        disp[j] = disp[j] - push;
      }
    }
    for (final l in links) {
      final d = p[l[0]] - p[l[1]];
      final dist = max(d.distance, 0.001);
      final f = dist * dist / k;
      final pull = d / dist * f;
      disp[l[0]] = disp[l[0]] - pull;
      disp[l[1]] = disp[l[1]] + pull;
    }
    for (var i = 0; i < n; i++) {
      final dl = disp[i].distance;
      if (dl > 0) p[i] = p[i] + disp[i] / dl * min(dl, temp);
    }
    temp *= 0.985;
  }
  var minX = p.first.dx;
  var maxX = minX;
  var minY = p.first.dy;
  var maxY = minY;
  for (final o in p) {
    minX = min(minX, o.dx);
    maxX = max(maxX, o.dx);
    minY = min(minY, o.dy);
    maxY = max(maxY, o.dy);
  }
  final w = maxX - minX == 0 ? 1.0 : maxX - minX;
  final h = maxY - minY == 0 ? 1.0 : maxY - minY;
  return {
    for (var i = 0; i < n; i++)
      vs[i]: Offset((p[i].dx - minX) / w, (p[i].dy - minY) / h),
  };
}

/// Arbol (o bosque) con la profundidad en x y las hojas repartidas en y.
Map<String, Offset> treeLayout(Forest f) {
  final kids = f.children;
  final depth = <String, int>{};
  final y = <String, double>{};
  var leaf = 0;
  void walk(String v, int d) {
    depth[v] = d;
    final ks = kids[v] ?? const <String>[];
    if (ks.isEmpty) {
      y[v] = leaf.toDouble();
      leaf++;
      return;
    }
    for (final k in ks) {
      walk(k, d + 1);
    }
    y[v] = (y[ks.first]! + y[ks.last]!) / 2;
  }

  for (final r in f.roots) {
    walk(r, 0);
  }
  final maxD = depth.values.fold<int>(0, (a, b) => max(a, b));
  final maxY = max(leaf - 1, 1).toDouble();
  return {
    for (final v in depth.keys)
      v: Offset(maxD == 0 ? 0.5 : depth[v]! / maxD, y[v]! / maxY),
  };
}
