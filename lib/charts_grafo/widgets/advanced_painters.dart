import 'dart:math';
import 'package:flutter/material.dart';
import 'drawing.dart';

/// Orden topológico en capas (Kahn).
/// Cada capa = vértices que pueden procesarse en paralelo (grado de entrada 0 en el subgrafo restante).
class TopologicalLayersPainter extends CustomPainter {
  TopologicalLayersPainter({required this.edges, this.highlightCycle = false});

  final Map<String, Map<String, int>> edges;
  final bool highlightCycle;

  @override
  void paint(Canvas canvas, Size size) {
    final layers = _topologicalLayers(edges);
    if (layers.isEmpty) return;

    final nLayers = layers.length;
    final maxLayerSize = layers.map((l) => l.length).reduce(max);
    final nodeR = min(24.0, (size.width - 80) / max(maxLayerSize, 1) * 0.4);
    final layerGap = (size.width - 80) / (nLayers + 1);
    final centerY = size.height / 2;

    // Dibujar aristas primero
    final pos = <String, Offset>{};
    for (var li = 0; li < nLayers; li++) {
      final layer = layers[li];
      final startY = centerY - (layer.length - 1) * (nodeR * 2.5) / 2;
      for (var i = 0; i < layer.length; i++) {
        pos[layer[i]] = Offset(40 + li * layerGap, startY + i * nodeR * 2.5);
      }
    }

    final drawnEdges = <String>{};
    for (final u in edges.keys) {
      for (final v in edges[u]!.keys) {
        final key = '$u>$v';
        if (drawnEdges.contains(key)) continue;
        drawnEdges.add(key);
        final a = pos[u];
        final b = pos[v];
        if (a == null || b == null) continue;
        final isBackEdge = layers.indexWhere((l) => l.contains(u)) >=
            layers.indexWhere((l) => l.contains(v));
        _drawEdge(canvas, a, b, isBackEdge && highlightCycle);
      }
    }

    // Dibujar nodos y etiquetas de capa
    for (var li = 0; li < nLayers; li++) {
      final layer = layers[li];
      final x = 40 + li * layerGap;
      drawText(canvas, 'Capa $li', Offset(x, 20), size: 12, bold: true, color: kMuted, alignment: Alignment.bottomCenter);
      for (final v in layer) {
        final p = pos[v]!;
        canvas.drawCircle(p, nodeR, Paint()..color = colorFor(li % palette.length));
        canvas.drawCircle(p, nodeR, Paint()..style = PaintingStyle.stroke..strokeWidth = 2..color = Colors.white);
        drawText(canvas, v, p, size: 13, bold: true, color: Colors.white);
      }
    }
  }

  void _drawEdge(Canvas canvas, Offset a, Offset b, bool isCycle) {
    final paint = Paint()
      ..color = isCycle ? const Color(0xFFE45756) : const Color(0xFF90A4AE)
      ..strokeWidth = isCycle ? 2.5 : 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final d = b - a;
    final dist = d.distance;
    if (dist == 0) return;
    final u = d / dist;
    final p1 = a + u * 18;
    final p2 = b - u * 18;
    canvas.drawLine(p1, p2, paint);
    // Flecha
    final arrow = Path()
      ..moveTo(p2.dx, p2.dy)
      ..lineTo(p2.dx - u.dx * 10 + u.dy * 4, p2.dy - u.dy * 10 - u.dx * 4)
      ..lineTo(p2.dx - u.dx * 10 - u.dy * 4, p2.dy - u.dy * 10 + u.dx * 4)
      ..close();
    canvas.drawPath(arrow, Paint()..color = paint.color);
  }

  List<List<String>> _topologicalLayers(Map<String, Map<String, int>> edges) {
    final vs = <String>{...edges.keys, for (final m in edges.values) ...m.keys}.toList()..sort();
    final inDeg = <String, int>{for (final v in vs) v: 0};
    for (final u in edges.keys) {
      for (final v in edges[u]!.keys) {
        inDeg[v] = (inDeg[v] ?? 0) + 1;
      }
    }
    final adj = <String, List<String>>{for (final v in vs) v: []};
    for (final u in edges.keys) {
      adj[u]!.addAll(edges[u]!.keys);
    }

    final layers = <List<String>>[];
    var queue = vs.where((v) => inDeg[v] == 0).toList()..sort();
    var visited = <String>{};

    while (queue.isNotEmpty) {
      layers.add(List.from(queue)..sort());
      final next = <String>[];
      for (final u in queue) {
        visited.add(u);
        for (final v in adj[u]!) {
          if (visited.contains(v)) continue;
          inDeg[v] = inDeg[v]! - 1;
          if (inDeg[v] == 0) next.add(v);
        }
      }
      queue = next..sort();
    }

    // Si quedan vértices sin visitar, hay ciclo: añadir como última capa
    final remaining = vs.where((v) => !visited.contains(v)).toList()..sort();
    if (remaining.isNotEmpty) {
      layers.add(remaining);
    }
    return layers;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}