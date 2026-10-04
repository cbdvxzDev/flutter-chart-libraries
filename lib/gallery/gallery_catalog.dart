import 'package:flutter/material.dart';

import '../charts_gallery.dart' as sync;
import '../charts_sync/common.dart' as sync show S;
import '../charts_grafo/avanzadas/catalogo_avanzadas.dart' as grafos;
import '../charts_grafo/models/chart_entry.dart';
import '../charts_grafo/pages/chart_page.dart';
import '../charts_grafo/simples/catalogo_simples.dart' as grafos;
import '../charts_grafo/theme/colores.dart';
import '../financial_gallery.dart';
import '../main.dart';
import 'gallery_meta.dart';
import 'gallery_models.dart';

/// Las cuatro librerías de la galería unificada, en el orden del riel.
final List<GalleryLibrary> galleryLibraries = [
  GalleryLibrary(
    name: 'FL Chart',
    package: 'fl_chart',
    version: '1.2.0',
    description: 'Líneas, barras, pastel, dispersión, radar y velas.',
    color: const Color(0xFF3949AB),
    railColor: const Color(0xFF8C9EFF),
    lightColor: const Color(0xFFE8EAF6),
    basic: _entries(
      HomeScreen.basicCharts,
      flBasicMeta,
      title: (chart) => chart.$1,
      open: (i, chart) => chart.$2,
    ),
    advanced: _entries(
      HomeScreen.advancedCharts,
      flAdvancedMeta,
      title: (chart) => chart.$1,
      open: (i, chart) => chart.$2,
    ),
  ),
  GalleryLibrary(
    name: 'Syncfusion Charts',
    package: 'syncfusion_flutter_charts',
    version: '28',
    description: 'Series cartesianas, apiladas, circulares y sparklines.',
    color: const Color(0xFFB45309),
    railColor: const Color(0xFFFDBA74),
    lightColor: const Color(0xFFFBEEDD),
    basic: _entries(
      sync.basic,
      syncBasicMeta,
      title: (s) => s.t,
      open: (i, s) =>
          (_) => _SyncfusionChartPage(entry: s),
    ),
    advanced: _entries(
      sync.adv,
      syncAdvancedMeta,
      title: (s) => s.t,
      open: (i, s) =>
          (_) => _SyncfusionChartPage(entry: s),
    ),
  ),
  GalleryLibrary(
    name: 'Directed Graph',
    package: 'directed_graph',
    version: '0.5.6',
    description: 'Grafos dirigidos y gráficas alimentadas con sus datos.',
    color: const Color(0xFF0F766E),
    railColor: const Color(0xFF5EEAD4),
    lightColor: const Color(0xFFDDF1EE),
    basic: _entries(
      grafos.simpleCharts,
      directedBasicMeta,
      title: (e) => e.title,
      open: (i, e) => _openGrafo(e, kBasicA),
    ),
    advanced: _entries(
      grafos.advancedCharts,
      directedAdvancedMeta,
      title: (e) => e.title,
      open: (i, e) => _openGrafo(e, kAdvA),
    ),
  ),
  GalleryLibrary(
    name: 'Financial Chart',
    package: 'financial_chart',
    version: '0.4.1',
    description:
        'Análisis técnico: velas, indicadores y herramientas de dibujo.',
    color: const Color(0xFF9D174D),
    railColor: const Color(0xFFF9A8D4),
    lightColor: const Color(0xFFF8E1EA),
    basic: _entries(
      financialBasic,
      financialBasicMeta,
      title: (e) => e.title,
      open: (i, e) =>
          (_) => FinancialChartPage(number: i + 1, entry: e),
    ),
    advanced: _entries(
      financialAdvanced,
      financialAdvancedMeta,
      title: (e) => e.title,
      open: (i, e) =>
          (_) => FinancialChartPage(number: i + 1, entry: e),
    ),
  ),
];

/// Cantidad total de gráficas de todas las librerías.
int get galleryTotal =>
    galleryLibraries.fold(0, (sum, library) => sum + library.total);

/// Convierte la lista de una librería en [GalleryEntry], uniéndola con sus
/// metadatos (categoría y miniatura) posición por posición.
List<GalleryEntry> _entries<T>(
  List<T> items,
  List<ChartMeta> meta, {
  required String Function(T item) title,
  required WidgetBuilder Function(int index, T item) open,
}) {
  assert(
    items.length == meta.length,
    'La lista tiene ${items.length} gráficas y sus metadatos ${meta.length}.',
  );
  return [
    for (var i = 0; i < items.length; i++)
      GalleryEntry(
        number: i + 1,
        title: title(items[i]),
        category: meta[i].$1,
        glyph: meta[i].$2,
        open: open(i, items[i]),
      ),
  ];
}

/// Abre una gráfica de Directed Graph con el mismo tema que usa `GaleriaPage`.
WidgetBuilder _openGrafo(ChartEntry entry, Color seed) =>
    (context) => Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        scaffoldBackgroundColor: kBg,
      ),
      child: ChartPage(entry: entry),
    );

/// Página de detalle de una gráfica de Syncfusion (esa rama no tenía una).
class _SyncfusionChartPage extends StatelessWidget {
  const _SyncfusionChartPage({required this.entry});

  final sync.S entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(capitalizeFirst(entry.t))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.s,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(child: entry.b()),
          ],
        ),
      ),
    );
  }
}
