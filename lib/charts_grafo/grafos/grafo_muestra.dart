import 'package:directed_graph/directed_graph.dart';

typedef Grafo = WeightedDirectedGraph<String, int>;

/// Grafo de ejemplo (el mismo de la documentacion de directed_graph).
/// Se crea uno nuevo cada vez porque algunos metodos lo modifican.
Grafo buildSampleGraph() {
  int sum(int l, int r) => l + r;
  int cmp(String x, String y) => x.compareTo(y);
  return WeightedDirectedGraph<String, int>(
    {
      'a': {'b': 1, 'h': 7, 'c': 2, 'e': 40, 'g': 7},
      'b': {'h': 6},
      'c': {'h': 5, 'g': 4},
      'd': {'e': 1, 'f': 2},
      'e': {'g': 2},
      'f': {'i': 3},
      'i': {'l': 3, 'k': 2},
      'k': {'g': 4, 'f': 5},
      'l': {'l': 0},
    },
    summation: sum,
    zero: 0,
    comparator: cmp,
  );
}

/// Metricas del grafo calculadas con la libreria.
class GraphInfo {
  GraphInfo(this.graph);
  final Grafo graph;

  late final List<String> vertices = (graph.toList()..sort());

  Map<String, int> edgesOf(String v) =>
      graph.weightedEdges(v) ?? const <String, int>{};

  Map<String, Map<String, int>> get edgeMap => {
        for (final v in vertices) v: Map<String, int>.of(edgesOf(v)),
      };

  int outDeg(String v) => graph.outDegree(v) ?? 0;
  int inDeg(String v) => graph.inDegree(v) ?? 0;

  int outWeight(String v) => edgesOf(v).values.fold(0, (a, b) => a + b);
  int inWeight(String v) =>
      vertices.fold(0, (acc, u) => acc + (edgesOf(u)[v] ?? 0));

  Set<String> reach(String v) => graph.reachableVertices(v).toSet();

  List<String> shortest(String a, String b) => graph.shortestPath(a, b);
  List<String> lightest(String a, String b) => graph.lightestPath(a, b);
  List<String> heaviest(String a, String b) {
    try {
      final p = graph.heaviestPath(a, b);
      if (p.isNotEmpty) return p;
    } catch (_) {}
    return graph.shortestPath(a, b);
  }

  /// Peso acumulado a lo largo de un camino: [0, w1, w1+w2, ...].
  List<int> cumulative(List<String> path) {
    final out = <int>[0];
    for (var i = 1; i < path.length; i++) {
      out.add(out.last + (edgesOf(path[i - 1])[path[i]] ?? 0));
    }
    return out;
  }
}
