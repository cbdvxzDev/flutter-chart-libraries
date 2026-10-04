import 'package:flutter/material.dart';
import '../models/chart_entry.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key, required this.entry});
  final ChartEntry entry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final h = (MediaQuery.of(context).size.height * 0.45).clamp(280.0, 460.0);
    return Scaffold(
      appBar: AppBar(title: Text('${entry.number}. ${entry.title}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: h,
                  child: Card(
                    color: Colors.white,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: entry.builder!(),
                    ),
                  ),
                ),
                _Section('Qué muestra', Text(entry.detail)),
                if (entry.methods.isNotEmpty)
                  _Section(
                    'Métodos de directed_graph que intervienen',
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        for (final m in entry.methods)
                          Chip(
                            label: Text(m,
                                style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                  ),
                if (entry.difference.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: scheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lightbulb_outline, color: scheme.onTertiaryContainer),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Qué la hace distinta',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: scheme.onTertiaryContainer)),
                              const SizedBox(height: 4),
                              Text(entry.difference,
                                  style: TextStyle(color: scheme.onTertiaryContainer)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                _Section('Cómo se puede usar', Text(entry.useCase)),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title, this.child);
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            child,
          ],
        ),
      );
}
