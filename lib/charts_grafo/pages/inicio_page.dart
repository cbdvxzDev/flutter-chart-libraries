import 'package:flutter/material.dart';
import '../avanzadas/catalogo_avanzadas.dart';
import '../simples/catalogo_simples.dart';
import '../theme/colores.dart';
import 'galeria_page.dart';

/// Ventana 1: elegir entre gráficos básicos y avanzados.
class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  void _open(BuildContext context, Categoria c) {
    Navigator.of(context).push(PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) => GaleriaPage(categoria: c),
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final basic = _CategoryCard(
      title: 'Gráficos básicos',
      subtitle: '${simpleCharts.length} gráficos',
      color: kBasicA,
      onTap: () => _open(context, Categoria.basicos),
    );
    final adv = _CategoryCard(
      title: 'Gráficos avanzados',
      subtitle: '${advancedCharts.length} gráficos',
      color: kAdvA,
      onTap: () => _open(context, Categoria.avanzados),
    );

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
              child: Column(
                children: [
                  const Text(
                    'Atlas de Grafos Dirigidos',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: kInkDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Visualizaciones con directed_graph · Flutter',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: LayoutBuilder(builder: (context, c) {
                      final wide = c.maxWidth > 600;
                      return Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: wide ? 320 : double.infinity),
                          child: wide
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(child: basic),
                                    const SizedBox(width: 20),
                                    Expanded(child: adv),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(child: basic),
                                    const SizedBox(height: 16),
                                    Expanded(child: adv),
                                  ],
                                ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    '¿Qué deseas escoger?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: kInkDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
  final String title, subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: color,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    )),
                const SizedBox(height: 6),
                Text(subtitle,
                    style: TextStyle(color: Colors.white.withAlpha(220), fontSize: 14)),
              ],
            ),
          ),
        ),
      );
}
