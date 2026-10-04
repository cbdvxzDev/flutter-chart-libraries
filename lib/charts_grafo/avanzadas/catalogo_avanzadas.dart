import 'package:flutter/material.dart';

import '../grafos/algoritmos.dart';
import '../grafos/grafo_muestra.dart';
import '../grafos/layouts.dart';
import '../models/chart_entry.dart';
import '../widgets/composicion.dart';
import '../widgets/drawing.dart';
import '../widgets/flow_painters.dart';
import '../widgets/graph_painter.dart';
import '../widgets/misc_painters.dart';
import '../widgets/node_link_painter.dart';
import '../widgets/stats_painters.dart';
import 'detalles_avanzadas.dart';
import 'interactivas.dart';

// ---------------------------------------------------------------- datos base
final _info = GraphInfo(buildSampleGraph());
EdgeMap get _g => _info.edgeMap;
List<String> get _vs => _info.vertices;

const _red = Color(0xFFE45756);
const _green = Color(0xFF54A24B);
const _orange = Color(0xFFF58518);
const _blue = Color(0xFF4C78A8);
const _grey = Color(0xFF78909C);

Widget _nodeLink(NodeLinkPainter p) =>
    CustomPaint(painter: p, child: const SizedBox.expand());

String _list(Iterable<String> xs) => xs.join(', ');

/// Nombre de una componente: "{f,i,k}" si tiene varios vertices.
String _compName(List<String> c) => c.length > 1 ? '{${c.join(',')}}' : c.first;

// ------------------------------------------------------------------ 1 a 8
/// 1. Orden topologico en capas: cada ciclo se contrae y queda en una capa.
Widget _topoLayers() {
  final comps = stronglyConnected(_g);
  final layer = sccLayers(_g);
  final maxL = layer.values.fold<int>(0, (a, b) => a > b ? a : b);
  final cyc = cycleEdges(_g);
  final parts = <String>[];
  for (var l = 0; l <= maxL; l++) {
    final names = [
      for (final c in comps)
        if (layer[c.first] == l) _compName(c),
    ];
    parts.add('capa $l: ${names.join(' ')}');
  }
  final caption = parts.join('  ·  ');
  return Captioned(
    _nodeLink(NodeLinkPainter(
      pos: layeredLayout(_g, layer),
      edges: _g,
      margin: const EdgeInsets.fromLTRB(30, 34, 30, 24),
      headers: {
        for (var l = 0; l <= maxL; l++) (maxL == 0 ? 0.5 : l / maxL): 'Capa $l',
      },
      groups: [
        for (final c in comps)
          if (c.length > 1) NodeGroup(c, _red, label: 'ciclo'),
      ],
      edgeColor: {for (final k in cyc) k: _red},
    )),
    caption,
  );
}

/// 2. Ciclos resaltados.
Widget _cycles() {
  final comps = stronglyConnected(_g);
  final cyc = cycleEdges(_g);
  final onCycle = <String>{
    for (final c in comps)
      if (c.length > 1) ...c,
    for (final k in cyc) ...k.split('>'),
  };
  final texts = <String>[
    for (final c in comps)
      if (c.length > 1) (findCycle(_g, c) ?? c).join(' → '),
    for (final e in _g.entries)
      if (e.value.containsKey(e.key)) '${e.key} → ${e.key} (bucle)',
  ];
  return Captioned(
    graphView(_g, highlightEdges: cyc, highlightVertices: onCycle, dim: true),
    'Ciclos: ${texts.join('   ·   ')}',
  );
}

/// 3. Componentes fuertemente conexas.
Widget _sccView() {
  final comps = stronglyConnected(_g);
  final compOf = componentOf(comps);
  final cyclic = cycleEdges(_g);
  bool isCyclic(List<String> c) =>
      c.length > 1 || cyclic.contains('${c.first}>${c.first}');
  final order = [...comps]..sort((a, b) {
      final c = (isCyclic(b) ? 1 : 0).compareTo(isCyclic(a) ? 1 : 0);
      return c != 0 ? c : a.first.compareTo(b.first);
    });
  final ordered = [for (final c in order) ...c];
  var ci = 0;
  final colorOfComp = <int, Color>{};
  for (final c in order) {
    if (isCyclic(c)) colorOfComp[compOf[c.first]!] = colorFor(ci++ * 3 + 1);
  }
  final multi = comps.where((c) => c.length > 1).map(_compName).join(' ');
  final loops = [
    for (final e in _g.entries)
      if (e.value.containsKey(e.key)) e.key,
  ];
  return Captioned(
    _nodeLink(NodeLinkPainter(
      pos: circularLayout(ordered),
      edges: _g,
      square: true,
      nodeColor: {for (final v in _vs) v: colorOfComp[compOf[v]] ?? _grey},
      edgeColor: {
        for (final k in cyclic) k: colorOfComp[compOf[k.split('>').first]] ?? _red,
      },
    )),
    '${_vs.length} vértices → ${comps.length} componentes · '
    'con varios vértices: $multi · con bucle: ${_list(loops)}',
  );
}

Schedule _schedule() {
  final dag = dagOf(_g);
  return schedule(dag, {for (final v in _vs) v: 1 + _info.outDeg(v)});
}

/// 4. Gantt de dependencias.
Widget _gantt() => Captioned(
      CustomPaint(
          painter: GanttPainter(schedule: _schedule(), dag: dagOf(_g)),
          child: const SizedBox.expand()),
      'Duración de cada tarea = 1 + grado de salida · una flecha por dependencia',
    );

/// 5. Ruta critica sobre el Gantt.
Widget _critical() {
  final s = _schedule();
  final path = s.tasks.where((t) => t.critical).map((t) => t.id).join(' → ');
  return Captioned(
    CustomPaint(
        painter: GanttPainter(schedule: s, dag: dagOf(_g), critical: true),
        child: const SizedBox.expand()),
    'Ruta crítica: $path · duración total ${s.length}',
  );
}

/// 6. Camino mas corto animado.
Widget _animatedPath() =>
    CaminoAnimado(edges: _g, path: _info.shortest('d', 'l'));

/// 7. Frontera de exploracion tipo Dijkstra.
Widget _dijkstra() => DijkstraAnimado(edges: _g, source: 'd');

/// 8. Editor interactivo.
Widget _editor() => EditorGrafo(initial: _g);

// ----------------------------------------------------------------- 9 a 12
/// 9. Layout de fuerzas.
Widget _force() => Captioned(
      _nodeLink(NodeLinkPainter(
        pos: forceLayout(_g),
        edges: _g,
        edgeLabels: weightLabels(_g),
      )),
      'Las aristas atraen, los vértices se repelen · posiciones calculadas, no escritas a mano',
    );

/// 10. Layout por capas.
Widget _layered() {
  final dag = dagOf(_g);
  final back = backEdges(_g);
  final layer = dagLayers(dag);
  final maxL = layer.values.fold<int>(0, (a, b) => a > b ? a : b);
  return Captioned(
    _nodeLink(NodeLinkPainter(
      pos: layeredLayout(_g, layer, ignore: back),
      edges: _g,
      margin: const EdgeInsets.fromLTRB(30, 34, 30, 24),
      headers: {
        for (var l = 0; l <= maxL; l++) (maxL == 0 ? 0.5 : l / maxL): 'Capa $l',
      },
      dashed: back,
      curved: back,
      edgeColor: {for (final k in back) k: _red},
    )),
    'Línea roja punteada = arista que cierra un ciclo (${back.join(', ').replaceAll('>', '→')})',
  );
}

/// 11. Arbol (bosque) de expansion.
Widget _spanning() {
  final f = spanningForest(_g);
  final keys = f.edgeKeys;
  final labels = {
    for (final e in f.parent.entries) '${e.value}>${e.key}': '${f.weight[e.key]}',
  };
  final others = {
    for (final e in _g.entries)
      for (final t in e.value.keys)
        if (!keys.contains('${e.key}>$t')) '${e.key}>$t',
  };
  return Captioned(
    _nodeLink(NodeLinkPainter(
      pos: treeLayout(f),
      edges: _g,
      edgeLabels: labels,
      faded: others,
      edgeColor: {for (final k in keys) k: _green},
      nodeColor: {for (final r in f.roots) r: _orange},
    )),
    'Bosque con raíces ${_list(f.roots)} (naranja) · ${keys.length} aristas · peso total ${f.totalWeight}',
  );
}

/// 12. Diagrama de flujo de proceso.
Widget _flowchart() {
  final dag = dagOf(_g);
  final back = backEdges(_g);
  final layer = dagLayers(dag);
  final maxL = layer.values.fold<int>(0, (a, b) => a > b ? a : b);
  final hasIn = <String>{for (final m in dag.values) ...m.keys};
  final shapes = <String, NodeShape>{};
  final colors = <String, Color>{};
  for (final v in _vs) {
    final outs = dag[v]?.length ?? 0;
    if (!hasIn.contains(v) || outs == 0) {
      shapes[v] = NodeShape.pill;
      colors[v] = _green;
    } else if (outs >= 2) {
      shapes[v] = NodeShape.diamond;
      colors[v] = _orange;
    } else {
      shapes[v] = NodeShape.rect;
      colors[v] = _blue;
    }
  }
  return Captioned(
    _nodeLink(NodeLinkPainter(
      pos: layeredLayout(_g, layer, ignore: back),
      edges: _g,
      nodeR: 15,
      margin: const EdgeInsets.fromLTRB(36, 34, 36, 24),
      headers: {
        for (var l = 0; l <= maxL; l++) (maxL == 0 ? 0.5 : l / maxL): 'Paso $l',
      },
      nodeShape: shapes,
      nodeColor: colors,
      dashed: back,
      curved: back,
      edgeColor: {for (final k in back) k: _red},
    )),
    'Óvalo = inicio o fin · rombo = decisión (2 o más salidas) · rectángulo = paso · rojo = repetir',
  );
}

// ---------------------------------------------------------------- 13 a 17
/// 13. Sankey de pesos.
Widget _sankey() {
  final dag = dagOf(_g);
  return Captioned(
    CustomPaint(
        painter: SankeyPainter(edges: dag, layers: dagLayers(dag)),
        child: const SizedBox.expand()),
    'El grosor de cada banda es el peso de la arista (sin la que cierra el ciclo)',
  );
}

/// 14. Diagrama de cuerdas.
Widget _chord() => Captioned(
      CustomPaint(painter: ChordPainter(_g), child: const SizedBox.expand()),
      'Cada arco es un vértice · el ancho de la cinta es el peso de la arista',
    );

/// 15. Sunburst por saltos.
Widget _sunburst() {
  const root = 'd';
  final t = bfs(_g, root);
  final kids = <String, List<String>>{};
  for (final e in t.parent.entries) {
    kids.putIfAbsent(e.value, () => []).add(e.key);
  }
  for (final l in kids.values) {
    l.sort();
  }
  return Captioned(
    CustomPaint(
        painter: SunburstPainter(root: root, kids: kids, hops: t.hops),
        child: const SizedBox.expand()),
    'Desde "$root": cada anillo es un salto más · ${t.hops.length - 1} vértices alcanzados',
  );
}

/// 16. Treemap jerarquico.
Widget _hierTreemap() {
  final f = spanningForest(_g);
  final kids = f.children;
  double own(String v) {
    var w = 1.0;
    for (final x in _info.edgesOf(v).values) {
      w += x;
    }
    return w + _info.inWeight(v);
  }

  TNode build(String v) {
    final ks = kids[v] ?? const <String>[];
    return ks.isEmpty ? TNode(v, own(v)) : TNode(v, 0, [for (final k in ks) build(k)]);
  }

  final root = TNode('Grafo', 0, [for (final r in f.roots) build(r)]);
  return Captioned(
    CustomPaint(painter: HierTreemapPainter(root), child: const SizedBox.expand()),
    'Cada grupo es un subárbol del bosque · el área de una hoja es su peso total (1 + entra + sale)',
  );
}

/// 17. Streamgraph por saltos.
Widget _stream() {
  const origins = ['a', 'd', 'i', 'k'];
  final hops = {for (final o in origins) o: bfs(_g, o).hops};
  final maxH = hops.values
      .expand((h) => h.values)
      .fold<int>(0, (a, b) => a > b ? a : b);
  return Captioned(
    CustomPaint(
      painter: StreamgraphPainter(
        xLabels: [for (var h = 0; h <= maxH; h++) 'salto $h'],
        series: [
          for (var i = 0; i < origins.length; i++)
            StreamSeries('desde ${origins[i]}', [
              for (var h = 0; h <= maxH; h++)
                hops[origins[i]]!.values.where((x) => x == h).length.toDouble(),
            ], colorFor(i)),
        ],
      ),
      child: const SizedBox.expand(),
    ),
    'Vértices alcanzados en cada salto, desde cuatro orígenes',
  );
}

// ---------------------------------------------------------------- 18 a 23
List<double> _allWeights() => [
      for (final m in _g.values)
        for (final w in m.values) w.toDouble(),
    ];

/// 18. Boxplot de pesos.
Widget _boxplot() {
  final groups = <ValueGroup>[
    ValueGroup('Todas', _allWeights(), _grey),
  ];
  var i = 0;
  for (final e in _g.entries) {
    if (e.value.length >= 2) {
      groups.add(ValueGroup(
          e.key, [for (final w in e.value.values) w.toDouble()], colorFor(i)));
      i++;
    }
  }
  return Captioned(
    CustomPaint(painter: BoxPlotPainter(groups), child: const SizedBox.expand()),
    'Pesos de las aristas: todas y por vértice de origen (solo los que tienen 2 o más)',
  );
}

/// 19. Violin de pesos (agrupado por capa del vertice de origen).
Widget _violin() {
  final layer = dagLayers(dagOf(_g));
  final byLayer = <int, List<double>>{};
  for (final e in _g.entries) {
    for (final w in e.value.values) {
      byLayer.putIfAbsent(layer[e.key]!, () => []).add(w.toDouble());
    }
  }
  final keys = byLayer.keys.toList()..sort();
  return Captioned(
    CustomPaint(
      painter: ViolinPainter([
        for (final k in keys)
          if (byLayer[k]!.length >= 2) ValueGroup('Capa $k', byLayer[k]!, colorFor(k)),
      ]),
      child: const SizedBox.expand(),
    ),
    'Distribución de los pesos según la capa del vértice de origen',
  );
}

/// 20. Coordenadas paralelas.
Widget _parallel() {
  double reachCount(String v) => (bfs(_g, v).hops.length - 1).toDouble();
  return Captioned(
    CustomPaint(
      painter: ParallelPainter(
        axes: const ['Sale', 'Entra', 'Peso sale', 'Peso entra', 'Alcance'],
        rows: [
          for (final v in _vs)
            ParRow(v, [
              _info.outDeg(v).toDouble(),
              _info.inDeg(v).toDouble(),
              _info.outWeight(v).toDouble(),
              _info.inWeight(v).toDouble(),
              reachCount(v),
            ]),
        ],
      ),
      child: const SizedBox.expand(),
    ),
    'Una línea por vértice · cada eje va de su mínimo a su máximo',
  );
}

/// 21. Matriz de dispersion.
Widget _scatterMatrix() => Captioned(
      CustomPaint(
        painter: ScatterMatrixPainter(
          names: const ['Sale', 'Entra', 'Peso entra'],
          columns: [
            [for (final v in _vs) _info.outDeg(v).toDouble()],
            [for (final v in _vs) _info.inDeg(v).toDouble()],
            [for (final v in _vs) _info.inWeight(v).toDouble()],
          ],
        ),
        child: const SizedBox.expand(),
      ),
      'Cada punto es un vértice · fila = eje vertical, columna = eje horizontal',
    );

/// 22. Mapa de calor de distancias.
Widget _distances() {
  final dist = {for (final v in _vs) v: lightestFrom(_g, v)};
  return Captioned(
    CustomPaint(
      painter: HeatmapPainter(
        labels: _vs,
        cells: [
          for (final u in _vs) [for (final v in _vs) dist[u]![v]?.toDouble()],
        ],
      ),
      child: const SizedBox.expand(),
    ),
    'Peso del camino más ligero de la fila a la columna · gris = sin camino',
  );
}

List<List<double?>> _adjacency(List<String> order) {
  final g = _g;
  return [
    for (final u in order) [for (final v in order) g[u]?[v]?.toDouble()],
  ];
}

/// 23. Matriz de adyacencia reordenada.
Widget _reordered() {
  final order = topoOrder(dagOf(_g));
  return SideBySide([
    Titled(
      'Orden alfabético',
      CustomPaint(
          painter: HeatmapPainter(labels: _vs, cells: _adjacency(_vs)),
          child: const SizedBox.expand()),
    ),
    Titled(
      'Orden topológico (por capas)',
      CustomPaint(
          painter: HeatmapPainter(labels: order, cells: _adjacency(order)),
          child: const SizedBox.expand()),
    ),
  ]);
}

// ---------------------------------------------------------------- 24 a 26
Widget _dashboard() => DashboardSincronizado(info: _info);
Widget _zoom() => ZoomDesplazamiento(edges: _g);
Widget _realTime() => TiempoReal(edges: _g);

// ------------------------------------------------------------------ catalogo
const _alg = 'Algoritmos sobre el grafo';
const _lay = 'Layouts';
const _flu = 'Flujo y jerarquía';
const _est = 'Estadísticas';
const _int = 'Interactivas';

ChartEntry _e(int n, String g, String t, String d, String u, Widget Function() b) {
  final x = advancedDetails[n];
  return ChartEntry(
    number: n,
    group: g,
    title: t,
    description: d,
    useCase: u,
    detail: x?.detail ?? d,
    methods: x?.methods ?? const [],
    difference: x?.difference ?? '',
    builder: b,
  );
}

final List<ChartEntry> advancedCharts = [
  _e(1, _alg, 'Orden topológico en capas',
      'Cada vértice en la capa que le toca; los ciclos se agrupan en un bloque.',
      'Decidir en qué orden hacer tareas que dependen unas de otras.', _topoLayers),
  _e(2, _alg, 'Ciclos resaltados',
      'Las aristas que forman un ciclo se pintan de rojo.',
      'Detectar dependencias circulares antes de que bloqueen un proceso.', _cycles),
  _e(3, _alg, 'Componentes fuertemente conexas',
      'Cada grupo de vértices que se alcanzan entre sí lleva su propio color.',
      'Encontrar comunidades cerradas dentro de una red de enlaces o referencias.', _sccView),
  _e(4, _alg, 'Gantt de dependencias',
      'Cada tarea empieza cuando terminan las que la preceden.',
      'Planificar un proyecto cuyas tareas dependen unas de otras.', _gantt),
  _e(5, _alg, 'Ruta crítica sobre el Gantt',
      'Las tareas sin holgura en rojo; las demás muestran cuánto pueden retrasarse.',
      'Saber qué tareas no pueden retrasarse sin alargar todo el proyecto.', _critical),
  _e(6, _alg, 'Camino más corto animado',
      'Un punto recorre el camino y enciende cada vértice y arista.',
      'Explicar una ruta paso a paso a quien no conoce el grafo.', _animatedPath),
  _e(7, _alg, 'Frontera de exploración tipo Dijkstra',
      'Se ve cómo crece el conjunto de vértices con distancia definitiva.',
      'Enseñar cómo un algoritmo de rutas decide por dónde seguir.', _dijkstra),
  _e(8, _alg, 'Editor interactivo',
      'Toca dos vértices para crear o borrar una arista y mira cómo cambian los ciclos.',
      'Probar cambios en una red y ver al instante si aparecen ciclos.', _editor),
  _e(9, _lay, 'Layout de fuerzas',
      'Las posiciones salen de simular atracción entre vértices conectados.',
      'Dibujar una red sin coordenadas: los grupos conectados quedan juntos.', _force),
  _e(10, _lay, 'Layout por capas',
      'Columnas por profundidad; la arista que cierra el ciclo va punteada.',
      'Mostrar flujos de trabajo o dependencias de izquierda a derecha.', _layered),
  _e(11, _lay, 'Árbol de expansión',
      'Un bosque que conecta todos los vértices usando las aristas más ligeras.',
      'Elegir pocas conexiones que cubran toda la red al menor costo.', _spanning),
  _e(12, _lay, 'Diagrama de flujo de proceso',
      'Óvalos de inicio y fin, rombos de decisión y rectángulos de paso.',
      'Convertir un grafo de pasos en un diagrama de flujo entendible.', _flowchart),
  _e(13, _flu, 'Sankey de pesos',
      'Bandas cuyo grosor es el peso de cada arista, entre columnas de capas.',
      'Ver por dónde pasa la mayor parte del flujo (dinero, tráfico, energía).', _sankey),
  _e(14, _flu, 'Diagrama de cuerdas',
      'Arcos alrededor de un círculo unidos por cintas del grosor del peso.',
      'Comparar quién envía a quién en una red con muchas conexiones cruzadas.', _chord),
  _e(15, _flu, 'Sunburst por saltos',
      'Anillos concéntricos: cada anillo es un salto más lejos del origen.',
      'Mostrar hasta dónde se propaga algo y por qué ramas lo hace.', _sunburst),
  _e(16, _flu, 'Treemap jerárquico',
      'Rectángulos anidados: cada grupo es una rama y el área es el peso.',
      'Ver qué ramas de una jerarquía concentran más peso.', _hierTreemap),
  _e(17, _flu, 'Streamgraph por saltos',
      'Cuántos vértices se alcanzan en cada salto, apilados y suavizados.',
      'Comparar cómo se expande la influencia de varios orígenes.', _stream),
  _e(18, _est, 'Boxplot de pesos',
      'Mediana, cuartiles y valores atípicos de los pesos de las aristas.',
      'Detectar costos fuera de lo normal en una red.', _boxplot),
  _e(19, _est, 'Violín de pesos',
      'La forma completa de la distribución de pesos en cada capa.',
      'Comparar distribuciones cuando el boxplot esconde su forma.', _violin),
  _e(20, _est, 'Coordenadas paralelas',
      'Una línea por vértice cruzando cinco métricas del grafo.',
      'Comparar perfiles de nodos con varias métricas a la vez.', _parallel),
  _e(21, _est, 'Matriz de dispersión',
      'Todas las parejas de tres métricas cruzadas entre sí.',
      'Buscar relaciones entre métricas de la red sin elegir de antemano.', _scatterMatrix),
  _e(22, _est, 'Mapa de calor de distancias',
      'El costo del camino más ligero entre cada par de vértices.',
      'Ver de un vistazo qué tan lejos queda cada nodo de los demás.', _distances),
  _e(23, _est, 'Matriz de adyacencia reordenada',
      'La misma matriz en orden alfabético y en orden topológico.',
      'Descubrir estructura (capas, bloques) que el orden original esconde.', _reordered),
  _e(24, _int, 'Dashboard sincronizado',
      'Elige un vértice y el grafo, las barras y los datos se actualizan juntos.',
      'Explorar un nodo desde varias vistas sin perder el contexto.', _dashboard),
  _e(25, _int, 'Zoom y desplazamiento',
      'Acerca, aleja y mueve el grafo con el dedo o el mouse.',
      'Revisar con detalle redes grandes sin que las etiquetas se amontonen.', _zoom),
  _e(26, _int, 'Tiempo real',
      'Un grafo que crece arista por arista con sus métricas en vivo.',
      'Monitorear una red que cambia: conexiones nuevas, densidad, componentes.', _realTime),
];
