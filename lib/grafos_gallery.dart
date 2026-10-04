import 'package:flutter/material.dart';

import 'charts_grafo/avanzadas/catalogo_avanzadas.dart';
import 'charts_grafo/pages/inicio_page.dart';
import 'charts_grafo/simples/catalogo_simples.dart';
import 'charts_grafo/theme/colores.dart';

/// Entrada de la galería de grafos dirigidos dentro del taller de fl_chart.
///
/// Reutiliza las pantallas de `charts_grafo/` (categoría -> cuadrícula ->
/// detalle) para que el catálogo de directed_graph sea navegable desde la
/// pantalla principal del taller, igual que la galería de Syncfusion.
class GrafosGalleryPage extends StatelessWidget {
  const GrafosGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Grafos dirigidos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Text(
              '${simpleCharts.length} básicas · ${advancedCharts.length} avanzadas',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: kBasicA,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: const InicioPage(),
    );
  }
}