import 'package:flutter/material.dart';
import '../avanzadas/catalogo_avanzadas.dart';
import '../models/chart_entry.dart';
import '../simples/catalogo_simples.dart';
import '../theme/colores.dart';
import '../widgets/chart_thumbnail.dart';
import 'chart_page.dart';

enum Categoria { basicos, avanzados }

/// Ventanas 2 y 3: cuadrícula de gráficos de la categoría elegida.
class GaleriaPage extends StatelessWidget {
  const GaleriaPage({super.key, required this.categoria});
  final Categoria categoria;

  @override
  Widget build(BuildContext context) {
    final basic = categoria == Categoria.basicos;
    final entries = basic ? simpleCharts : advancedCharts;
    final color = basic ? kBasicA : kAdvA;

    final theme = Theme.of(context).copyWith(
      colorScheme: ColorScheme.fromSeed(seedColor: color),
      scaffoldBackgroundColor: kBg,
    );

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 68,
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: color,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(basic ? 'Gráficos básicos' : 'Gráficos avanzados',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text('${entries.length} gráficos',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
        body: _ChartGrid(entries: entries),
      ),
    );
  }
}

class _ChartGrid extends StatelessWidget {
  const _ChartGrid({required this.entries});
  final List<ChartEntry> entries;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final groups = <String, List<ChartEntry>>{};
    for (final e in entries) {
      groups.putIfAbsent(e.group, () => []).add(e);
    }
    return CustomScrollView(
      slivers: [
        for (final g in groups.entries) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 10),
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 20,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(g.key,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700, color: kInkDark)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                mainAxisExtent: 340,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => _ChartCard(entry: g.value[i]),
                childCount: g.value.length,
              ),
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 28)),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.entry});
  final ChartEntry entry;

  @override
  Widget build(BuildContext context) {
    final ready = entry.isReady;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0x14000000)),
      ),
      child: InkWell(
        onTap: ready
            ? () {
                final theme = Theme.of(context);
                Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (_) => Theme(data: theme, child: ChartPage(entry: entry)),
                ));
              }
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 3 / 2,
                  child: ready
                      ? ChartThumbnail(entry.builder!)
                      : Container(
                          color: const Color(0xFFF1F3F8),
                          child: Center(
                            child: Icon(Icons.lock_outline, color: scheme.outline, size: 32),
                          ),
                        ),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: CircleAvatar(
                    radius: 13,
                    backgroundColor: scheme.primary,
                    child: Text('${entry.number}',
                        style: TextStyle(fontSize: 11, color: scheme.onPrimary)),
                  ),
                ),
              ],
            ),
            const Divider(height: 1, color: Color(0x14000000)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, color: kInkDark)),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        ready ? entry.useCase : 'Próxima entrega',
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
