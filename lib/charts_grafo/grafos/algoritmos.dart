import 'dart:math';

/// Mapa vertice -> {destino: peso}. Es el mismo formato que `GraphInfo.edgeMap`.
typedef EdgeMap = Map<String, Map<String, int>>;

Map<String, int> _out(EdgeMap g, String v) => g[v] ?? const <String, int>{};

/// Todos los vertices (origenes y destinos), ordenados.
List<String> allVertices(EdgeMap g) {
  final s = <String>{
    ...g.keys,
    for (final m in g.values) ...m.keys,
  };
  return s.toList()..sort();
}

int edgeCount(EdgeMap g) => g.values.fold(0, (a, m) => a + m.length);

/// Etiquetas 'u>v' -> peso, para dibujar los pesos sobre las flechas.
Map<String, String> weightLabels(EdgeMap g) => {
      for (final e in g.entries)
        for (final t in e.value.entries) '${e.key}>${t.key}': '${t.value}',
    };

// ------------------------------------------------------------ componentes

/// Componentes fuertemente conexas (Tarjan). Cada componente va ordenada y la
/// lista completa se ordena por su primer vertice.
List<List<String>> stronglyConnected(EdgeMap g) {
  var counter = 0;
  final index = <String, int>{};
  final low = <String, int>{};
  final stack = <String>[];
  final onStack = <String>{};
  final out = <List<String>>[];

  void visit(String v) {
    index[v] = counter;
    low[v] = counter;
    counter++;
    stack.add(v);
    onStack.add(v);
    for (final w in _out(g, v).keys) {
      if (!index.containsKey(w)) {
        visit(w);
        low[v] = min(low[v]!, low[w]!);
      } else if (onStack.contains(w)) {
        low[v] = min(low[v]!, index[w]!);
      }
    }
    if (low[v] == index[v]) {
      final comp = <String>[];
      while (true) {
        final w = stack.removeLast();
        onStack.remove(w);
        comp.add(w);
        if (w == v) break;
      }
      comp.sort();
      out.add(comp);
    }
  }

  for (final v in allVertices(g)) {
    if (!index.containsKey(v)) visit(v);
  }
  out.sort((a, b) => a.first.compareTo(b.first));
  return out;
}

Map<String, int> componentOf(List<List<String>> comps) => {
      for (var i = 0; i < comps.length; i++)
        for (final v in comps[i]) v: i,
    };

/// Aristas que pertenecen a algun ciclo: las que unen dos vertices de la misma
/// componente (incluye los bucles u>u).
Set<String> cycleEdges(EdgeMap g) {
  final compOf = componentOf(stronglyConnected(g));
  return {
    for (final e in g.entries)
      for (final t in e.value.keys)
        if (compOf[e.key] == compOf[t]) '${e.key}>$t',
  };
}

/// Un ciclo simple dentro de [comp] (empieza y termina en el mismo vertice).
List<String>? findCycle(EdgeMap g, List<String> comp) {
  final inside = comp.toSet();
  final start = comp.first;
  final path = <String>[start];
  final seen = <String>{start};
  bool dfs(String v) {
    for (final w in _out(g, v).keys) {
      if (!inside.contains(w)) continue;
      if (w == start && path.length > 1) return true;
      if (seen.add(w)) {
        path.add(w);
        if (dfs(w)) return true;
        path.removeLast();
        seen.remove(w);
      }
    }
    return false;
  }

  return dfs(start) ? [...path, start] : null;
}

/// Capa de cada vertice en el grafo de componentes (cada ciclo se contrae).
Map<String, int> sccLayers(EdgeMap g) {
  final comps = stronglyConnected(g);
  final compOf = componentOf(comps);
  final preds = List.generate(comps.length, (_) => <int>{});
  for (final e in g.entries) {
    for (final t in e.value.keys) {
      final a = compOf[e.key]!;
      final b = compOf[t]!;
      if (a != b) preds[b].add(a);
    }
  }
  final memo = <int, int>{};
  int calc(int c) {
    final m = memo[c];
    if (m != null) return m;
    var r = 0;
    for (final p in preds[c]) {
      r = max(r, calc(p) + 1);
    }
    memo[c] = r;
    return r;
  }

  return {for (final v in allVertices(g)) v: calc(compOf[v]!)};
}

// ------------------------------------------------------------------- DAG

/// Aristas 'u>v' que cierran un ciclo en un recorrido en profundidad.
Set<String> backEdges(EdgeMap g) {
  final state = <String, int>{}; // 1 = en la pila, 2 = terminado
  final back = <String>{};
  void dfs(String v) {
    state[v] = 1;
    for (final w in _out(g, v).keys) {
      final s = state[w];
      if (s == null) {
        dfs(w);
      } else if (s == 1) {
        back.add('$v>$w');
      }
    }
    state[v] = 2;
  }

  for (final v in allVertices(g)) {
    if (!state.containsKey(v)) dfs(v);
  }
  return back;
}

/// El grafo sin las aristas que cierran ciclos (queda aciclico).
EdgeMap dagOf(EdgeMap g) {
  final back = backEdges(g);
  return {
    for (final e in g.entries)
      e.key: {
        for (final t in e.value.entries)
          if (!back.contains('${e.key}>${t.key}')) t.key: t.value,
      },
  };
}

/// Capa = longitud del camino mas largo que llega al vertice (solo para DAG).
Map<String, int> dagLayers(EdgeMap dag) {
  final vs = allVertices(dag);
  final preds = {for (final v in vs) v: <String>[]};
  for (final e in dag.entries) {
    for (final t in e.value.keys) {
      preds[t]!.add(e.key);
    }
  }
  final memo = <String, int>{};
  int calc(String v) {
    final m = memo[v];
    if (m != null) return m;
    var r = 0;
    for (final p in preds[v]!) {
      r = max(r, calc(p) + 1);
    }
    memo[v] = r;
    return r;
  }

  return {for (final v in vs) v: calc(v)};
}

/// Un orden topologico valido: por capa y, dentro de la capa, alfabetico.
List<String> topoOrder(EdgeMap dag) {
  final layer = dagLayers(dag);
  final vs = allVertices(dag);
  vs.sort((a, b) {
    final c = layer[a]!.compareTo(layer[b]!);
    return c != 0 ? c : a.compareTo(b);
  });
  return vs;
}

// ------------------------------------------------------- planificacion

class Task {
  const Task(this.id, this.start, this.dur, this.slack);
  final String id;
  final int start, dur, slack;
  int get end => start + dur;
  bool get critical => slack == 0;
}

class Schedule {
  const Schedule(this.tasks, this.length, this.criticalDeps);
  final List<Task> tasks; // ordenadas por inicio
  final int length;
  final Set<String> criticalDeps; // aristas 'u>v' de la ruta critica
}

/// Metodo de la ruta critica sobre un DAG: u>v significa "u termina antes de
/// que empiece v". [dur] es la duracion de cada tarea.
Schedule schedule(EdgeMap dag, Map<String, int> dur) {
  final order = topoOrder(dag);
  final preds = {for (final v in order) v: <String>[]};
  for (final e in dag.entries) {
    for (final t in e.value.keys) {
      preds[t]!.add(e.key);
    }
  }
  final es = <String, int>{};
  final ef = <String, int>{};
  for (final v in order) {
    var s = 0;
    for (final p in preds[v]!) {
      s = max(s, ef[p]!);
    }
    es[v] = s;
    ef[v] = s + (dur[v] ?? 1);
  }
  final length = ef.values.fold<int>(0, (a, b) => max(a, b));
  final ls = <String, int>{};
  for (final v in order.reversed) {
    var f = length;
    for (final t in _out(dag, v).keys) {
      f = min(f, ls[t]!);
    }
    ls[v] = f - (dur[v] ?? 1);
  }
  final tasks = [
    for (final v in order) Task(v, es[v]!, dur[v] ?? 1, ls[v]! - es[v]!),
  ]..sort((a, b) {
      final c = a.start.compareTo(b.start);
      return c != 0 ? c : a.id.compareTo(b.id);
    });
  final byId = {for (final t in tasks) t.id: t};
  final crit = <String>{
    for (final e in dag.entries)
      for (final t in e.value.keys)
        if (byId[e.key]!.critical &&
            byId[t]!.critical &&
            byId[e.key]!.end == byId[t]!.start)
          '${e.key}>$t',
  };
  return Schedule(tasks, length, crit);
}

// ---------------------------------------------------------------- caminos

class DijkstraStep {
  const DijkstraStep(this.settled, this.dist, this.done, this.prev);
  final String? settled;
  final Map<String, int> dist;
  final Set<String> done;
  final Map<String, String> prev;
}

/// Dijkstra paso a paso: cada paso fija un vertice.
List<DijkstraStep> dijkstraSteps(EdgeMap g, String source) {
  final dist = <String, int>{source: 0};
  final prev = <String, String>{};
  final done = <String>{};
  final steps = <DijkstraStep>[
    DijkstraStep(null, {...dist}, {...done}, {...prev}),
  ];
  while (true) {
    String? best;
    for (final e in dist.entries) {
      if (done.contains(e.key)) continue;
      if (best == null ||
          e.value < dist[best]! ||
          (e.value == dist[best] && e.key.compareTo(best) < 0)) {
        best = e.key;
      }
    }
    if (best == null) break;
    done.add(best);
    for (final t in _out(g, best).entries) {
      final nd = dist[best]! + t.value;
      final cur = dist[t.key];
      if (cur == null || nd < cur) {
        dist[t.key] = nd;
        prev[t.key] = best;
      }
    }
    steps.add(DijkstraStep(best, {...dist}, {...done}, {...prev}));
  }
  return steps;
}

/// Distancia (suma de pesos) del camino mas ligero desde [source].
Map<String, int> lightestFrom(EdgeMap g, String source) =>
    dijkstraSteps(g, source).last.dist;

/// Recorrido en anchura: saltos y padre de cada vertice alcanzado.
({Map<String, int> hops, Map<String, String> parent}) bfs(EdgeMap g, String s) {
  final hops = <String, int>{s: 0};
  final parent = <String, String>{};
  final queue = <String>[s];
  var i = 0;
  while (i < queue.length) {
    final v = queue[i];
    i++;
    for (final w in _out(g, v).keys) {
      if (!hops.containsKey(w)) {
        hops[w] = hops[v]! + 1;
        parent[w] = v;
        queue.add(w);
      }
    }
  }
  return (hops: hops, parent: parent);
}

// ------------------------------------------------------ bosque de expansion

class Forest {
  const Forest(this.roots, this.parent, this.weight);
  final List<String> roots;
  final Map<String, String> parent; // hijo -> padre
  final Map<String, int> weight; // hijo -> peso de la arista del padre

  Map<String, List<String>> get children {
    final m = <String, List<String>>{};
    for (final e in parent.entries) {
      m.putIfAbsent(e.value, () => []).add(e.key);
    }
    for (final l in m.values) {
      l.sort();
    }
    return m;
  }

  Set<String> get edgeKeys => {
        for (final e in parent.entries) '${e.value}>${e.key}',
      };

  int get totalWeight => weight.values.fold(0, (a, b) => a + b);
}

/// Bosque de expansion: desde cada raiz (vertices sin aristas entrantes) se
/// agrega siempre la arista mas ligera que sale del arbol hacia un vertice
/// aun no cubierto (estilo Prim).
Forest spanningForest(EdgeMap g) {
  final vs = allVertices(g);
  final hasIn = <String>{for (final m in g.values) ...m.keys};
  final candidates = [
    ...vs.where((v) => !hasIn.contains(v)),
    ...vs.where((v) => hasIn.contains(v)),
  ];
  final visited = <String>{};
  final roots = <String>[];
  final parent = <String, String>{};
  final weight = <String, int>{};
  for (final r in candidates) {
    if (visited.contains(r)) continue;
    visited.add(r);
    roots.add(r);
    final tree = <String>{r};
    while (true) {
      String? bu, bv;
      var bw = 0;
      final members = tree.toList()..sort();
      for (final u in members) {
        for (final t in _out(g, u).entries) {
          if (visited.contains(t.key)) continue;
          final better = bu == null ||
              t.value < bw ||
              (t.value == bw && u.compareTo(bu) < 0) ||
              (t.value == bw && u == bu && t.key.compareTo(bv!) < 0);
          if (better) {
            bu = u;
            bv = t.key;
            bw = t.value;
          }
        }
      }
      if (bu == null || bv == null) break;
      visited.add(bv);
      tree.add(bv);
      parent[bv] = bu;
      weight[bv] = bw;
    }
  }
  return Forest(roots, parent, weight);
}
