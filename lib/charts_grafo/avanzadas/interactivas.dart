import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../grafos/algoritmos.dart';
import '../grafos/grafo_muestra.dart';
import '../grafos/layouts.dart';
import '../widgets/bars_painter.dart';
import '../widgets/drawing.dart';
import '../widgets/graph_painter.dart';
import '../widgets/lines_painter.dart';
import '../widgets/node_link_painter.dart';

const _green = Color(0xFF54A24B);
const _orange = Color(0xFFF58518);
const _red = Color(0xFFE45756);
const _blueGrey = Color(0xFFB0BEC5);

EdgeMap _copy(EdgeMap m) => {
      for (final e in m.entries) e.key: Map<String, int>.of(e.value),
    };

// ------------------------------------------------- 6. camino mas corto animado

/// Un punto recorre el camino mas corto y va encendiendo vertices y aristas.
class CaminoAnimado extends StatefulWidget {
  const CaminoAnimado({super.key, required this.edges, required this.path});
  final EdgeMap edges;
  final List<String> path;

  @override
  State<CaminoAnimado> createState() => _CaminoAnimadoState();
}

class _CaminoAnimadoState extends State<CaminoAnimado>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    final steps = max(1, widget.path.length - 1);
    _c = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000 * steps + 1500))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final path = widget.path;
    final steps = max(1, path.length - 1);
    final pos = circularLayout(allVertices(widget.edges));
    final labels = weightLabels(widget.edges);
    const margin = EdgeInsets.all(30);
    return Column(children: [
      Expanded(
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            final p = min(steps.toDouble(), _c.value * (steps + 1.5));
            final done = p.floor();
            final i = min(done, steps - 1);
            return CustomPaint(
              painter: NodeLinkPainter(
                pos: pos,
                edges: widget.edges,
                square: true,
                margin: margin,
                edgeLabels: labels,
                nodeColor: {
                  for (var k = 0; k < path.length; k++)
                    if (k <= done) path[k]: k == 0 ? _green : _red,
                  for (final v in allVertices(widget.edges))
                    if (!path.sublist(0, min(path.length, done + 1)).contains(v))
                      v: _blueGrey,
                },
                edgeColor: {
                  for (var k = 0; k < done && k < steps; k++)
                    '${path[k]}>${path[k + 1]}': _red,
                },
              ),
              foregroundPainter: path.length < 2
                  ? null
                  : DotPainter(
                      pos: pos,
                      from: path[i],
                      to: path[i + 1],
                      t: p - i,
                      margin: margin,
                      square: true,
                    ),
              child: const SizedBox.expand(),
            );
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text('Camino más corto: ${path.join(' → ')}',
            style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    ]);
  }
}

// ------------------------------------------------- 7. frontera tipo Dijkstra

/// Dijkstra paso a paso: verde = fijado, naranja = frontera, gris = sin ver.
class DijkstraAnimado extends StatefulWidget {
  const DijkstraAnimado({super.key, required this.edges, required this.source});
  final EdgeMap edges;
  final String source;

  @override
  State<DijkstraAnimado> createState() => _DijkstraAnimadoState();
}

class _DijkstraAnimadoState extends State<DijkstraAnimado>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final List<DijkstraStep> _steps;

  @override
  void initState() {
    super.initState();
    _steps = dijkstraSteps(widget.edges, widget.source);
    _c = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1100 * (_steps.length + 1)))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vs = allVertices(widget.edges);
    final pos = circularLayout(vs);
    final labels = weightLabels(widget.edges);
    return Column(children: [
      Expanded(
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            final i = min(_steps.length - 1, (_c.value * (_steps.length + 1)).floor());
            final s = _steps[i];
            return CustomPaint(
              painter: NodeLinkPainter(
                pos: pos,
                edges: widget.edges,
                square: true,
                edgeLabels: labels,
                nodeColor: {
                  for (final v in vs)
                    v: s.done.contains(v)
                        ? _green
                        : (s.dist.containsKey(v) ? _orange : _blueGrey),
                },
                nodeCaption: {
                  for (final e in s.dist.entries) e.key: '${e.value}',
                },
                edgeColor: {
                  for (final e in s.prev.entries) '${e.value}>${e.key}': _green,
                },
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
      ),
      AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final i = min(_steps.length - 1, (_c.value * (_steps.length + 1)).floor());
          final s = _steps[i];
          final text = s.settled == null
              ? 'Inicio: "${widget.source}" tiene distancia 0'
              : 'Paso $i de ${_steps.length - 1}: se fija "${s.settled}" '
                  'con distancia ${s.dist[s.settled!]}';
          return Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Column(children: [
              Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text.rich(
                TextSpan(style: const TextStyle(fontSize: 11, color: kMuted), children: [
                  TextSpan(text: '●', style: TextStyle(color: _green)),
                  TextSpan(text: ' fijado    '),
                  TextSpan(text: '●', style: TextStyle(color: _orange)),
                  TextSpan(text: ' frontera (distancia provisional)    '),
                  TextSpan(text: '●', style: TextStyle(color: _blueGrey)),
                  TextSpan(text: ' sin visitar'),
                ]),
              ),
            ]),
          );
        },
      ),
    ]);
  }
}

// -------------------------------------------------------- 8. editor interactivo

/// Toca un vertice y luego otro: crea la arista (peso 1) o la borra si existe.
class EditorGrafo extends StatefulWidget {
  const EditorGrafo({super.key, required this.initial});
  final EdgeMap initial;

  @override
  State<EditorGrafo> createState() => _EditorGrafoState();
}

class _EditorGrafoState extends State<EditorGrafo> {
  late EdgeMap _g = _copy(widget.initial);
  late final List<String> _vs = allVertices(widget.initial);
  late final Map<String, Offset> _pos = circularLayout(_vs);
  String? _sel;
  static const _margin = EdgeInsets.all(34);

  void _tap(Offset p, Size size) {
    String? hit;
    var best = 28.0;
    for (final v in _vs) {
      final d = (NodeLinkPainter.toPixel(_pos[v]!, size, _margin, true) - p).distance;
      if (d < best) {
        best = d;
        hit = v;
      }
    }
    final h = hit;
    setState(() {
      if (h == null) {
        _sel = null;
        return;
      }
      final target = h;
      final from = _sel;
      if (from == null) {
        _sel = target;
      } else if (from == target) {
        _sel = null;
      } else {
        final m = _g.putIfAbsent(from, () => <String, int>{});
        if (m.containsKey(target)) {
          m.remove(target);
        } else {
          m[target] = 1;
        }
        _sel = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final comps = stronglyConnected(_g);
    final cyc = cycleEdges(_g);
    final sel = _sel;
    return Column(children: [
      Expanded(
        child: LayoutBuilder(
          builder: (context, c) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (d) => _tap(d.localPosition, Size(c.maxWidth, c.maxHeight)),
            child: CustomPaint(
              painter: NodeLinkPainter(
                pos: _pos,
                edges: _g,
                square: true,
                margin: _margin,
                edgeLabels: weightLabels(_g),
                nodeColor: {if (sel != null) sel: _orange},
                edgeColor: {for (final k in cyc) k: _red},
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          sel == null
              ? 'Toca un vértice y luego otro: crea o borra la arista'
              : 'Origen: "$sel" · toca el destino (o el mismo vértice para cancelar)',
          textAlign: TextAlign.center,
          style: const TextStyle(color: kMuted, fontSize: 12),
        ),
      ),
      Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        children: [
          Text('${edgeCount(_g)} aristas · ${comps.length} componentes · '
              '${cyc.isEmpty ? 'sin ciclos (DAG)' : 'con ciclos (en rojo)'}',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          TextButton.icon(
            onPressed: () => setState(() {
              _g = _copy(widget.initial);
              _sel = null;
            }),
            icon: const Icon(Icons.restart_alt, size: 18),
            label: const Text('Restablecer'),
          ),
        ],
      ),
    ]);
  }
}

// ------------------------------------------------ 24. dashboard sincronizado

/// Elegir un vertice actualiza a la vez el grafo, las barras y los datos.
class DashboardSincronizado extends StatefulWidget {
  const DashboardSincronizado({super.key, required this.info});
  final GraphInfo info;

  @override
  State<DashboardSincronizado> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardSincronizado> {
  String _sel = 'a';

  @override
  Widget build(BuildContext context) {
    final info = widget.info;
    final edges = info.edgeMap;
    final vs = info.vertices;
    final reach = bfs(edges, _sel).hops.keys.toSet()..remove(_sel);
    final outE = info.edgesOf(_sel);

    final graph = graphView(
      edges,
      showWeights: true,
      highlightEdges: {for (final t in outE.keys) '$_sel>$t'},
      highlightVertices: reach,
      source: _sel,
      dim: true,
    );
    final bars = outE.isEmpty
        ? Center(child: Text('"$_sel" no tiene aristas salientes'))
        : barsView(
            cats: outE.keys.toList(),
            series: [
              BarSeries('Peso', [for (final w in outE.values) w.toDouble()], colorFor(0)),
            ],
          );

    return Column(children: [
      SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (final v in vs)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: Text(v),
                  selected: v == _sel,
                  onSelected: (_) => setState(() => _sel = v),
                ),
              ),
          ],
        ),
      ),
      Expanded(
        child: LayoutBuilder(builder: (context, c) {
          final wide = c.maxWidth >= 460;
          final panels = [
            Expanded(child: graph),
            Expanded(child: bars),
          ];
          return wide ? Row(children: panels) : Column(children: panels);
        }),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          '"$_sel": sale ${info.outDeg(_sel)} · entra ${info.inDeg(_sel)} · '
          'alcanza ${reach.length} vértices',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    ]);
  }
}

// ------------------------------------------------------ 25. zoom y desplazamiento

/// El grafo se puede acercar y mover (pellizco, rueda o arrastre).
class ZoomDesplazamiento extends StatelessWidget {
  const ZoomDesplazamiento({super.key, required this.edges});
  final EdgeMap edges;

  @override
  Widget build(BuildContext context) {
    final pos = forceLayout(edges);
    final labels = weightLabels(edges);
    return LayoutBuilder(builder: (context, c) {
      final w = max(1.0, c.maxWidth);
      final h = max(1.0, c.maxHeight);
      return Stack(children: [
        InteractiveViewer(
          constrained: false,
          minScale: 0.5,
          maxScale: 6,
          boundaryMargin: const EdgeInsets.all(240),
          child: SizedBox(
            width: w,
            height: h,
            child: CustomPaint(
              painter: NodeLinkPainter(
                pos: pos,
                edges: edges,
                nodeR: 17,
                margin: const EdgeInsets.all(40),
                edgeLabels: labels,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 8,
          bottom: 2,
          child: Text('Pellizca o usa la rueda para acercar · arrastra para mover',
              style: TextStyle(fontSize: 11, color: kMuted)),
        ),
      ]);
    });
  }
}

// ------------------------------------------------------------ 26. tiempo real

class _Arista {
  const _Arista(this.u, this.v, this.w);
  final String u, v;
  final int w;
}

/// Simula un grafo que crece: cada 0,7 s aparece una arista nueva y las
/// metricas y la grafica de abajo se recalculan al instante.
class TiempoReal extends StatefulWidget {
  const TiempoReal({super.key, required this.edges});
  final EdgeMap edges;

  @override
  State<TiempoReal> createState() => _TiempoRealState();
}

class _TiempoRealState extends State<TiempoReal> {
  late final List<_Arista> _all;
  late final Map<String, Offset> _pos;
  Timer? _timer;
  int _n = 0;

  @override
  void initState() {
    super.initState();
    _all = [
      for (final e in widget.edges.entries)
        for (final t in e.value.entries) _Arista(e.key, t.key, t.value),
    ]..shuffle(Random(11));
    _pos = circularLayout(allVertices(widget.edges));
    _timer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      if (!mounted) return;
      setState(() => _n = _n >= _all.length + 3 ? 1 : _n + 1);
    });
    _n = 1;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  EdgeMap _upTo(int k) {
    final m = <String, Map<String, int>>{};
    for (final a in _all.take(k)) {
      m.putIfAbsent(a.u, () => <String, int>{})[a.v] = a.w;
    }
    return m;
  }

  @override
  Widget build(BuildContext context) {
    final k = min(_n, _all.length);
    final g = _upTo(k);
    final vs = allVertices(g);
    final pos = {for (final v in vs) v: _pos[v]!};
    final nV = vs.length;
    final dens = nV < 2 ? 0.0 : edgeCount(g) / (nV * (nV - 1)) * 100;

    final xs = [for (var i = 1; i <= k; i++) '$i'];
    final vSeries = <double>[];
    final eSeries = <double>[];
    for (var i = 1; i <= k; i++) {
      final gi = _upTo(i);
      vSeries.add(allVertices(gi).length.toDouble());
      eSeries.add(i.toDouble());
    }

    final graph = CustomPaint(
      painter: NodeLinkPainter(
        pos: pos,
        edges: g,
        square: true,
        nodeR: 13,
        edgeLabels: weightLabels(g),
        edgeColor: {
          if (k > 0) '${_all[k - 1].u}>${_all[k - 1].v}': _orange,
        },
      ),
      child: const SizedBox.expand(),
    );
    final lines = k < 2
        ? const Center(child: Text('Esperando datos…'))
        : linesView(
            xLabels: xs,
            showValues: false,
            series: [
              LineSeries('Aristas', eSeries, colorFor(0)),
              LineSeries('Vértices', vSeries, colorFor(1)),
            ],
          );

    return Column(children: [
      Expanded(
        child: LayoutBuilder(builder: (context, c) {
          final wide = c.maxWidth >= 460;
          final panels = [Expanded(child: graph), Expanded(child: lines)];
          return wide ? Row(children: panels) : Column(children: panels);
        }),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          'Aristas: $k de ${_all.length} · Vértices: $nV · '
          'Densidad: ${dens.toStringAsFixed(1)} % · '
          'Componentes fuertes: ${stronglyConnected(g).length}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    ]);
  }
}
