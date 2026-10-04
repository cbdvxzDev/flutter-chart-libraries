import 'package:directed_graph/directed_graph.dart';
import 'package:flutter/material.dart';

import '../grafos/grafo_muestra.dart';
import '../models/chart_entry.dart';
import '../widgets/bars_painter.dart';
import '../widgets/drawing.dart';
import '../widgets/graph_painter.dart';
import '../widgets/distribution_painters.dart';
import '../widgets/lines_painter.dart';
import '../widgets/misc_painters.dart';
import '../widgets/scatter_painter.dart';
import '../widgets/shape_painters.dart';
import '../widgets/sorted_edges_painter.dart';
import 'detalles_simples.dart';

// ---------------------------------------------------------------- datos base
final _info = GraphInfo(buildSampleGraph());
List<String> get _vs => _info.vertices;

List<double> _perVertex(num Function(String) f) => [for (final v in _vs) f(v).toDouble()];

Set<String> _pathEdges(List<String> p) =>
    {for (var i = 0; i < p.length - 1; i++) '${p[i]}>${p[i + 1]}'};

// ------------------------------------------------------------ widgets ayuda
class _SideBySide extends StatelessWidget {
  const _SideBySide(this.children);
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
        final items = [for (final w in children) Expanded(child: w)];
        return c.maxWidth > 700 ? Row(children: items) : Column(children: items);
      });
}

class _Titled extends StatelessWidget {
  const _Titled(this.title, this.child);
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        Expanded(child: child),
      ]);
}

class _Captioned extends StatelessWidget {
  const _Captioned(this.child, this.caption);
  final Widget child;
  final String caption;
  @override
  Widget build(BuildContext context) => Column(children: [
        Expanded(child: child),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(caption,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      ]);
}

// ------------------------------------------------------------ builders 1-10
Widget _pathChart(List<String> path) => _Captioned(
      graphView(
        _info.edgeMap,
        showWeights: true,
        highlightEdges: _pathEdges(path),
        highlightVertices: path.toSet(),
        dim: true,
      ),
      'Camino: ${path.join(' → ')}   ·   peso total: ${_info.graph.weightAlong(path)}',
    );

Widget _reachable() {
  const origin = 'd';
  final reach = _info.reach(origin);
  final from = {origin, ...reach};
  final edges = <String>{
    for (final e in _info.edgeMap.entries)
      if (from.contains(e.key)) for (final t in e.value.keys) '${e.key}>$t',
  };
  return _Captioned(
    graphView(_info.edgeMap,
        highlightEdges: edges,
        highlightVertices: reach,
        source: origin,
        dim: true),
    'Desde "$origin" se alcanzan ${reach.length} vértices: ${(reach.toList()..sort()).join(', ')}',
  );
}

Widget _closure() {
  final orig = _info.edgeMap;
  final closure = GraphInfo(WeightedDirectedGraph.transitiveClosure(_info.graph)).edgeMap;
  final added = <String>{
    for (final e in closure.entries)
      for (final t in e.value.keys)
        if (!(orig[e.key]?.containsKey(t) ?? false)) '${e.key}>$t',
  };
  return _SideBySide([
    _Titled('Original (${_count(orig)} aristas)', graphView(orig)),
    _Titled('Cerradura transitiva (${_count(closure)} aristas, naranja = nuevas)',
        graphView(closure, newEdges: added)),
  ]);
}

int _count(Map<String, Map<String, int>> m) =>
    m.values.fold(0, (a, b) => a + b.length);

Widget _sortedEdges() {
  final g = buildSampleGraph();
  g.sortEdgesByWeight();
  final sorted = GraphInfo(g).edgeMap;
  Widget panel(Map<String, Map<String, int>> m) =>
      CustomPaint(painter: SortedEdgesPainter(m), child: const SizedBox.expand());
  return _Captioned(
    Column(children: [
      Expanded(child: _Titled('Orden original (como se insertaron las aristas)', panel(_info.edgeMap))),
      Expanded(child: _Titled('Después de sortEdgesByWeight()', panel(sorted))),
    ]),
    'Cada grupo es un vértice origen · la letra bajo la barra es el destino · la altura es el peso',
  );
}

Widget _updateWeight() {
  final g2 = buildSampleGraph();
  g2.updateEdgeWeight(vertex: 'a', connectedVertex: 'b', weight: 101);
  final after = GraphInfo(g2).edgeMap;
  const hi = {'a>b'};
  return _SideBySide([
    _Titled('Antes: a→b = ${_info.edgesOf('a')['b']}',
        graphView(_info.edgeMap, showWeights: true, highlightEdges: hi)),
    _Titled('Después: a→b = ${after['a']!['b']}',
        graphView(after, showWeights: true, highlightEdges: hi)),
  ]);
}

Widget _graphWithDegrees() => _SideBySide([
      _Titled('Grafo', graphView(_info.edgeMap)),
      _Titled(
        'Grado de salida por vértice',
        barsView(
          cats: _vs,
          horizontal: true,
          series: [BarSeries('Salida', _perVertex(_info.outDeg), colorFor(0))],
        ),
      ),
    ]);

// ----------------------------------------------------------- builders 11-22
Widget _stackedByEdge(BarMode mode) {
  final dests = {
    for (final m in _info.edgeMap.values) ...m.keys,
  }.toList()
    ..sort();
  return barsView(
    cats: _vs,
    mode: mode,
    series: [
      for (final d in dests)
        BarSeries(
          'hacia $d',
          [for (final v in _vs) (_info.edgesOf(v)[d] ?? 0).toDouble()],
          colorFor(_vs.indexOf(d)),
        ),
    ],
  );
}

// Camino de muestra para las graficas de linea: d -> g (el mas pesado).
List<String> get _longPath => _info.heaviest('d', 'g');

Widget _cumLine(LineMode mode, String name, Color color) {
  final p = _longPath;
  return _Captioned(
    linesView(
      xLabels: p,
      mode: mode,
      series: [LineSeries(name, _info.cumulative(p).map((e) => e.toDouble()).toList(), color)],
    ),
    'Camino más pesado d → g: ${p.join(' → ')}',
  );
}

Widget _threePaths() {
  final paths = {
    'Más corto': _info.shortest('a', 'g'),
    'Más ligero': _info.lightest('a', 'g'),
    'Más pesado': _info.heaviest('a', 'g'),
  };
  var i = 0;
  return _Captioned(
    linesView(
      xLabels: const ['inicio', 'salto 1', 'salto 2'],
      series: [
        for (final e in paths.entries)
          LineSeries(
            '${e.key} (${e.value.join('→')})',
            _info.cumulative(e.value).map((x) => x.toDouble()).toList(),
            colorFor(i++),
          ),
      ],
    ),
    'Peso acumulado de los tres caminos a → g',
  );
}

// ----------------------------------------------------------- builders 23-43
Widget _paint(CustomPainter p) => CustomPaint(painter: p, child: const SizedBox.expand());

List<MapEntry<String, int>> get _edgeList => [
      for (final e in _info.edgeMap.entries)
        for (final t in e.value.entries) MapEntry('${e.key}→${t.key}', t.value),
    ];

List<double> get _weights => [for (final e in _edgeList) e.value.toDouble()];

int _reachCount(String v) => _info.reach(v).where((u) => u != v).length;
int _totalDeg(String v) => _info.inDeg(v) + _info.outDeg(v);
int _totalW(String v) => _info.inWeight(v) + _info.outWeight(v);

List<ScatterPoint> _mergeDuplicates(List<ScatterPoint> pts) {
  final groups = <String, List<ScatterPoint>>{};
  for (final p in pts) {
    groups.putIfAbsent('${p.x}|${p.y}', () => []).add(p);
  }
  return [
    for (final g in groups.values)
      ScatterPoint(g.first.x, g.first.y, g.map((p) => p.label).join(','), count: g.length),
  ];
}

Widget _lollipopEdges() => barsView(
      cats: [for (final e in _edgeList) e.key],
      lollipop: true,
      series: [BarSeries('Peso', _weights, colorFor(4))],
    );

Widget _scatterOut() => _Captioned(
      _paint(ScatterPainter(
        points: _mergeDuplicates([
          for (final v in _vs)
            ScatterPoint(_info.outDeg(v).toDouble(), _info.outWeight(v).toDouble(), v),
        ]),
        xTitle: 'Grado de salida',
        yTitle: 'Peso total saliente',
      )),
      'Cada punto es un vértice (si dos coinciden, se etiquetan juntos)',
    );

Widget _bubbles() {
  final seen = <String, int>{};
  final pts = <ScatterPoint>[];
  for (final v in _vs) {
    final x = _totalDeg(v).toDouble(), y = _totalW(v).toDouble();
    final k = '$x|$y';
    final n = seen[k] ?? 0;
    seen[k] = n + 1;
    pts.add(ScatterPoint(x + 0.16 * n, y, v, size: _reachCount(v).toDouble()));
  }
  return _Captioned(
    _paint(ScatterPainter(
      points: pts,
      bubble: true,
      xTitle: 'Grado total (entrada + salida)',
      yTitle: 'Peso total',
    )),
    'Tamaño de la burbuja = vértices alcanzables',
  );
}

Widget _histogram({bool bars = true, bool polygon = false, bool density = false}) =>
    _paint(HistogramPainter(
      values: _weights,
      binWidth: 5,
      showBars: bars,
      showPolygon: polygon,
      showDensity: density,
    ));

Widget _dumbbell() {
  final g = buildSampleGraph();
  g.updateEdgeWeight(vertex: 'a', connectedVertex: 'b', weight: 101);
  g.updateEdgeWeight(vertex: 'b', connectedVertex: 'h', weight: 1);
  g.updateEdgeWeight(vertex: 'e', connectedVertex: 'g', weight: 20);
  final after = GraphInfo(g);
  return _Captioned(
    _paint(DumbbellPainter(
      labels: _vs,
      before: _perVertex(_info.outWeight),
      after: [for (final v in _vs) after.outWeight(v).toDouble()],
    )),
    'Peso saliente por vértice · cambios: a→b 1→101, b→h 6→1, e→g 2→20',
  );
}

Widget _sparklines() {
  final g = buildSampleGraph();
  g.sortEdgesByWeight();
  final sorted = GraphInfo(g);
  var i = 0;
  final rows = <SparkRow>[];
  for (final v in _vs) {
    var acc = 0.0;
    final cum = <double>[];
    for (final w in sorted.edgesOf(v).values) {
      acc += w;
      cum.add(acc);
    }
    rows.add(SparkRow(v, cum, colorFor(i++)));
  }
  return _paint(SparklinesPainter(rows));
}

Widget _radar() {
  final metrics = <String, double Function(String)>{
    'Grado entrada': (v) => _info.inDeg(v).toDouble(),
    'Grado salida': (v) => _info.outDeg(v).toDouble(),
    'Peso entrante': (v) => _info.inWeight(v).toDouble(),
    'Peso saliente': (v) => _info.outWeight(v).toDouble(),
    'Alcanzables': (v) => _reachCount(v).toDouble(),
  };
  final maxes = <String, double>{
    for (final m in metrics.entries)
      m.key: _vs.map(m.value).fold<double>(1, (a, b) => a > b ? a : b),
  };
  const chosen = ['a', 'd', 'e', 'g'];
  return _Captioned(
    _paint(RadarPainter(
      axes: metrics.keys.toList(),
      series: [
        for (var i = 0; i < chosen.length; i++)
          RadarSeries(
            chosen[i],
            [for (final m in metrics.entries) m.value(chosen[i]) / maxes[m.key]!],
            colorFor(i),
          ),
      ],
    )),
    'Cada eje se normaliza respecto al máximo del grafo',
  );
}

Widget _waterfall() {
  final p = _longPath;
  return _Captioned(
    _paint(WaterfallPainter(
      labels: [for (var i = 1; i < p.length; i++) '${p[i - 1]}→${p[i]}'],
      values: [
        for (var i = 1; i < p.length; i++) (_info.edgesOf(p[i - 1])[p[i]] ?? 0).toDouble(),
      ],
    )),
    'Camino más pesado d → g: ${p.join(' → ')}',
  );
}

Widget _pictogram() => _Captioned(
      _paint(PictogramPainter([
        for (var i = 0; i < _vs.length; i++)
          PictoRow(_vs[i], _info.outDeg(_vs[i]), colorFor(i)),
      ])),
      'Cada flecha = una arista saliente',
    );

Widget _funnel() {
  const origin = 'd';
  final hops = <int>[
    for (final u in _info.reach(origin))
      if (u != origin) _info.shortest(origin, u).length - 1,
  ];
  final maxHop = hops.fold<int>(0, (a, b) => a > b ? a : b);
  final stages = <Slice>[Slice('Vértices del grafo', _vs.length.toDouble(), colorFor(0))];
  for (var k = maxHop; k >= 1; k--) {
    stages.add(Slice(
      k == 1 ? '1 salto' : '≤ $k saltos',
      hops.where((h) => h <= k).length.toDouble(),
      colorFor(stages.length + 3),
    ));
  }
  return _Captioned(_paint(FunnelPainter(stages)), 'Vértices alcanzables desde "$origin" según el número de saltos');
}

Widget _pieReach() {
  const origin = 'd';
  final reach = _reachCount(origin);
  return _Captioned(
    _paint(PiePainter(slices: [
      Slice('Alcanzables', reach.toDouble(), colorFor(0)),
      Slice('No alcanzables', (_vs.length - 1 - reach).toDouble(), const Color(0xFFBAB0AC)),
      Slice('Origen ($origin)', 1, colorFor(2)),
    ])),
    'Alcance desde "$origin"',
  );
}

Widget _donutEdges() {
  final total = _info.edgeMap.values.fold<int>(0, (a, m) => a + m.length);
  return _paint(PiePainter(
    donut: true,
    centerTop: '$total',
    centerBottom: 'aristas',
    slices: [
      for (var i = 0; i < _vs.length; i++)
        if (_info.outDeg(_vs[i]) > 0)
          Slice(_vs[i], _info.outDeg(_vs[i]).toDouble(), colorFor(i)),
    ],
  ));
}

int get _edgesNoLoop {
  var c = 0;
  for (final e in _info.edgeMap.entries) {
    for (final t in e.value.keys) {
      if (t != e.key) c++;
    }
  }
  return c;
}

int get _possiblePairs => _vs.length * (_vs.length - 1);

Widget _gaugeDensity() => _paint(GaugePainter(
      value: _edgesNoLoop / _possiblePairs,
      caption: '$_edgesNoLoop de $_possiblePairs aristas posibles',
      color: colorFor(0),
    ));

Widget _ringReach() {
  final connected = _vs.fold<int>(0, (a, v) => a + _reachCount(v));
  return _paint(GaugePainter(
    value: connected / _possiblePairs,
    caption: '$connected de $_possiblePairs pares conectados',
    semi: false,
    color: colorFor(2),
  ));
}

Widget _treemap() => _Captioned(
      _paint(TreemapPainter([
        for (var i = 0; i < _vs.length; i++)
          Slice(_vs[i], _totalW(_vs[i]).toDouble(), colorFor(i)),
      ])),
      'Área = peso total del vértice (entrante + saliente)',
    );

Widget _heatmap() => _Captioned(
      _paint(HeatmapPainter(
        labels: _vs,
        cells: [
          for (final r in _vs)
            [for (final c in _vs) _info.edgesOf(r)[c]?.toDouble()],
        ],
      )),
      'Filas = origen · columnas = destino · color = peso',
    );

Widget _pareto() {
  final es = [..._edgeList]
    ..sort((a, b) => b.value != a.value ? b.value.compareTo(a.value) : a.key.compareTo(b.key));
  return _paint(ParetoPainter(
    labels: [for (final e in es) e.key],
    values: [for (final e in es) e.value.toDouble()],
  ));
}

Widget _regression() => _Captioned(
      _paint(ScatterPainter(
        regression: true,
        points: _mergeDuplicates([
          for (final v in _vs)
            ScatterPoint(_info.inDeg(v).toDouble(), _info.inWeight(v).toDouble(), v),
        ]),
        xTitle: 'Grado de entrada',
        yTitle: 'Peso total entrante',
      )),
      'Recta de mínimos cuadrados sobre los vértices del grafo',
    );

Widget _degreesWithMean() {
  final vals = _perVertex(_totalDeg);
  final mean = vals.fold<double>(0, (a, b) => a + b) / vals.length;
  return barsView(
    cats: _vs,
    hLine: mean,
    hLineLabel: 'Promedio ${mean.toStringAsFixed(2)}',
    series: [BarSeries('Grado total', vals, colorFor(5))],
  );
}

// ------------------------------------------------------------------ catalogo
const _g1 = 'Vistas del grafo';
const _g2 = 'Barras y líneas';
const _g3 = 'Distribución y relación';
const _g4 = 'Proporciones y mapas';
const _g5 = 'Combinadas';

ChartEntry _e(int n, String g, String t, String d, String u, Widget Function() b) {
  final x = simpleDetails[n];
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

final List<ChartEntry> simpleCharts = [
  _e(1, _g1, 'Grafo dirigido básico',
      'Vértices y flechas del grafo de muestra, tal como los guarda directed_graph.',
      'Entender de un vistazo quién se conecta con quién: dependencias, rutas o flujos.',
      () => graphView(_info.edgeMap)),
  _e(2, _g1, 'Grafo con pesos',
      'Igual que el anterior, mostrando el peso de cada arista.',
      'Ver el costo, la distancia o el tiempo de cada conexión (rutas, tareas, redes).',
      () => graphView(_info.edgeMap, showWeights: true)),
  _e(3, _g1, 'Camino más corto',
      'shortestPath(a, g): el camino con menos aristas.',
      'Encontrar la ruta con menos escalas o menos intermediarios entre dos puntos.',
      () => _pathChart(_info.shortest('a', 'g'))),
  _e(4, _g1, 'Camino más ligero',
      'lightestPath(a, g): el camino con menor suma de pesos.',
      'Elegir la ruta más barata o más rápida, por ejemplo en logística o transporte.',
      () => _pathChart(_info.lightest('a', 'g'))),
  _e(5, _g1, 'Camino más pesado',
      'heaviestPath(a, g): el camino con mayor suma de pesos.',
      'Detectar la ruta crítica o de mayor carga al planificar un proyecto.',
      () => _pathChart(_info.heaviest('a', 'g'))),
  _e(6, _g1, 'Alcanzables desde un vértice',
      'reachableVertices(d): todos los vértices a los que se llega desde d.',
      'Saber qué partes de un sistema se ven afectadas si algo falla en un punto.',
      _reachable),
  _e(7, _g1, 'Cerradura transitiva',
      'transitiveClosure: aparece una arista por cada par conectado por algún camino.',
      'Descubrir conexiones indirectas y su costo mínimo, como enlaces posibles entre sistemas.',
      _closure),
  _e(8, _g1, 'Aristas ordenadas por peso',
      'sortEdgesByWeight(): los vecinos de cada vértice se reordenan de menor a mayor peso.',
      'Priorizar: atender primero las conexiones más baratas o más pesadas de cada nodo.',
      _sortedEdges),
  _e(9, _g1, 'Antes y después de actualizar un peso',
      'Se cambia el peso de la arista a→b de 1 a 101 y se compara.',
      'Simular qué pasa si cambia una tarifa o hay congestión, y comparar escenarios.',
      _updateWeight),
  _e(10, _g1, 'Grafo con barras de grado',
      'Combinada: el grafo y, junto a él, el grado de salida de cada vértice.',
      'Relacionar la estructura de la red con la importancia de cada nodo.',
      _graphWithDegrees),
  _e(11, _g2, 'Barras: grado de salida',
      'Número de aristas que salen de cada vértice (outDegree).',
      'Identificar los nodos que más reparten: centros emisores o distribuidores.',
      () => barsView(cats: _vs, series: [BarSeries('Salida', _perVertex(_info.outDeg), colorFor(0))])),
  _e(12, _g2, 'Barras: grado de entrada',
      'Número de aristas que llegan a cada vértice (inDegree).',
      'Encontrar los nodos más dependientes o posibles cuellos de botella.',
      () => barsView(cats: _vs, series: [BarSeries('Entrada', _perVertex(_info.inDeg), colorFor(2))])),
  _e(13, _g2, 'Barras horizontales: peso saliente',
      'Suma de los pesos de las aristas que salen de cada vértice.',
      'Comparar la carga o el costo total que genera cada nodo.',
      () => barsView(
            cats: _vs,
            horizontal: true,
            series: [BarSeries('Peso saliente', _perVertex(_info.outWeight), colorFor(1))],
          )),
  _e(14, _g2, 'Barras agrupadas: entrada vs. salida',
      'Grado de entrada y de salida lado a lado para cada vértice.',
      'Ver si un nodo es más emisor o más receptor.',
      () => barsView(cats: _vs, series: [
            BarSeries('Entrada', _perVertex(_info.inDeg), colorFor(2)),
            BarSeries('Salida', _perVertex(_info.outDeg), colorFor(0)),
          ])),
  _e(15, _g2, 'Barras apiladas: peso por arista',
      'Cada barra es un vértice origen; cada color, el peso de la arista hacia un destino.',
      'Descomponer el peso de un nodo en las conexiones que lo forman.',
      () => _stackedByEdge(BarMode.stacked)),
  _e(16, _g2, 'Barras apiladas 100%',
      'Lo mismo, pero cada vértice se normaliza a 100% para ver cómo reparte su peso.',
      'Comparar cómo reparte cada nodo su peso, sin importar su tamaño total.',
      () => _stackedByEdge(BarMode.percent)),
  _e(17, _g2, 'Barras con negativos',
      'Salida menos entrada: positivo (azul) emite más de lo que recibe, negativo (rojo) al revés.',
      'Ver el balance de la red: emisores netos frente a receptores netos.',
      () => barsView(
            cats: _vs,
            negativeColor: const Color(0xFFE45756),
            series: [
              BarSeries('Salida − entrada',
                  _perVertex((v) => _info.outDeg(v) - _info.inDeg(v)), colorFor(0)),
            ],
          )),
  _e(18, _g2, 'Línea: peso acumulado',
      'Cómo crece el peso paso a paso a lo largo del camino más pesado d → g.',
      'Seguir cómo se acumula un costo o un tiempo a lo largo de una ruta.',
      () => _cumLine(LineMode.line, 'Peso acumulado', colorFor(0))),
  _e(19, _g2, 'Líneas múltiples: tres caminos',
      'Peso acumulado de los caminos más corto, más ligero y más pesado entre a y g.',
      'Comparar rutas alternativas y ver en qué punto se separan.',
      _threePaths),
  _e(20, _g2, 'Línea escalonada',
      'El peso se mantiene constante en cada vértice y salta al cruzar una arista.',
      'Representar costos que cambian por tramos, como tarifas por etapa.',
      () => _cumLine(LineMode.step, 'Peso acumulado', colorFor(3))),
  _e(21, _g2, 'Área del peso acumulado',
      'El mismo acumulado, rellenando el área bajo la curva.',
      'Dar sensación de volumen acumulado, como un presupuesto que se va consumiendo.',
      () => _cumLine(LineMode.area, 'Peso acumulado', colorFor(2))),
  _e(22, _g2, 'Área apilada: entrante + saliente',
      'Para cada vértice, peso que sale (azul) y peso que llega (naranja), apilados.',
      'Ver cuánto entra y cuánto sale de cada nodo en un solo vistazo.',
      () => linesView(
            xLabels: _vs,
            mode: LineMode.stackedArea,
            series: [
              LineSeries('Saliente', _perVertex(_info.outWeight), colorFor(0)),
              LineSeries('Entrante', _perVertex(_info.inWeight), colorFor(1)),
            ],
          )),
  _e(23, _g2, 'Lollipop: peso por arista',
      'Una paleta por cada arista del grafo; la altura es su peso.',
      'Comparar muchos valores con poca tinta, por ejemplo el costo de cada enlace de una red.',
      _lollipopEdges),
  _e(24, _g3, 'Dispersión: grado vs. peso',
      'Cada punto es un vértice: grado de salida contra peso total saliente.',
      'Comprobar si los nodos con más conexiones también concentran más carga.',
      _scatterOut),
  _e(25, _g3, 'Burbujas: grado, peso y alcance',
      'Posición por grado total y peso total; el tamaño indica cuántos vértices alcanza.',
      'Cruzar tres métricas de una red para encontrar nodos clave de un vistazo.',
      _bubbles),
  _e(26, _g3, 'Histograma de pesos',
      'Cuántas aristas caen en cada intervalo de peso.',
      'Ver cómo se reparten los costos de una red y detectar valores atípicos.',
      () => _histogram()),
  _e(27, _g3, 'Polígono de frecuencias',
      'La forma de la distribución de pesos unida por una línea.',
      'Comparar distribuciones de varias redes sobre un mismo eje.',
      () => _histogram(bars: false, polygon: true)),
  _e(28, _g3, 'Dumbbell: antes y después',
      'Peso saliente de cada vértice antes y después de actualizar varias aristas.',
      'Medir el impacto de un cambio de tarifas o capacidades en cada nodo.',
      _dumbbell),
  _e(29, _g3, 'Sparkline por vértice',
      'Minigráfica del peso acumulado de las aristas de cada vértice, ya ordenadas.',
      'Resumir en una tabla el comportamiento de muchos nodos sin saturar la pantalla.',
      _sparklines),
  _e(30, _g3, 'Radar de métricas',
      'Cuatro vértices comparados en cinco métricas del grafo.',
      'Comparar perfiles de nodos: quién emite, quién recibe y quién llega más lejos.',
      _radar),
  _e(31, _g3, 'Cascada del peso de un camino',
      'Aporte de cada arista al peso total del camino más pesado.',
      'Ver qué tramo de una ruta pesa más en el costo total.',
      _waterfall),
  _e(32, _g3, 'Pictograma: aristas por vértice',
      'Una flecha por cada arista saliente de cada vértice.',
      'Explicar el grado de salida a un público no técnico, contando símbolos.',
      _pictogram),
  _e(33, _g3, 'Embudo: alcance por saltos',
      'Vértices alcanzables desde un origen según el número de saltos.',
      'Medir cuánto se propaga algo (una falla, un mensaje) en cada paso.',
      _funnel),
  _e(34, _g4, 'Pastel: alcanzables vs. no alcanzables',
      'Proporción de vértices a los que se llega desde el origen.',
      'Resumir la cobertura de una red desde un punto de partida.',
      _pieReach),
  _e(35, _g4, 'Dona: aristas por vértice origen',
      'Qué parte de todas las aristas sale de cada vértice.',
      'Ver qué nodos concentran las conexiones salientes de la red.',
      _donutEdges),
  _e(36, _g4, 'Gauge: densidad del grafo',
      'Porcentaje de aristas posibles que realmente existen.',
      'Saber qué tan conectada está una red frente a su máximo posible.',
      _gaugeDensity),
  _e(37, _g4, 'Progreso circular: alcanzabilidad',
      'Porcentaje de pares de vértices unidos por algún camino.',
      'Indicador rápido de qué tanto de la red se puede recorrer.',
      _ringReach),
  _e(38, _g4, 'Treemap: peso por vértice',
      'Cada rectángulo es un vértice y su área es el peso que lo atraviesa.',
      'Identificar de golpe los nodos que dominan el peso de la red.',
      _treemap),
  _e(39, _g4, 'Mapa de calor: matriz de adyacencia',
      'Matriz origen × destino coloreada por el peso de cada arista.',
      'Revisar todas las conexiones de una red a la vez, incluso si es grande.',
      _heatmap),
  _e(40, _g5, 'Pareto: pesos + acumulado',
      'Barras de mayor a menor peso con la línea de porcentaje acumulado.',
      'Encontrar las pocas conexiones que explican la mayor parte del costo.',
      _pareto),
  _e(41, _g5, 'Histograma + curva de densidad',
      'Histograma de pesos con una curva suavizada encima.',
      'Ver la forma real de la distribución más allá de los intervalos elegidos.',
      () => _histogram(density: true)),
  _e(42, _g5, 'Dispersión + recta de regresión',
      'Grado de entrada contra peso entrante, con su recta de tendencia.',
      'Cuantificar si más conexiones entrantes implican más carga recibida.',
      _regression),
  _e(43, _g5, 'Barras de grado + promedio',
      'Grado total de cada vértice con una línea en el promedio.',
      'Distinguir qué nodos están por encima o por debajo de lo habitual.',
      _degreesWithMean),
];
