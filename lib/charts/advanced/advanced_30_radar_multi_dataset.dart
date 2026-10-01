import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced30RadarMultiDataset extends StatefulWidget {
  const Advanced30RadarMultiDataset({super.key});

  @override
  State<Advanced30RadarMultiDataset> createState() =>
      _Advanced30RadarMultiDatasetState();
}

class _Advanced30RadarMultiDatasetState
    extends State<Advanced30RadarMultiDataset> {
  static const labels = ['Fuerza', 'Velocidad', 'Magia', 'Resistencia', 'Astucia'];

  static const names = ['Héroe', 'Rival', 'Aliado'];
  static const colors = [Colors.indigo, Colors.deepOrange, Colors.teal];
  static const List<List<double>> data = [
    [9, 7, 4, 6, 8],
    [5, 9, 8, 4, 6],
    [6, 5, 7, 9, 5],
  ];

  int? _selected;

  static List<RadarEntry> entries(List<double> values) =>
      [for (final v in values) RadarEntry(value: v)];

  RadarDataSet _buildSet(int index) {
    final activo = _selected == index || _selected == null;
    final color = colors[index];
    return RadarDataSet(
      dataEntries: entries(data[index]),
      fillColor: color.withValues(alpha: activo ? 0.32 : 0.1),
      fillGradient: _selected == index
          ? LinearGradient(
              colors: [
                color.withValues(alpha: 0.75),
                color.withValues(alpha: 0.15),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
          : null,
      borderColor: color,
      borderWidth: _selected == index ? 3 : 1.5,
      entryRadius: _selected == index ? 5 : 2.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;

    return Scaffold(
      appBar: AppBar(title: const Text('30. Radar con selección de dataset')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: RadarChart(
                  RadarChartData(
                    radarBorderData: BorderSide(color: Colors.grey.shade400),
                    gridBorderData: BorderSide(color: Colors.grey.shade300),
                    tickBorderData: BorderSide(color: Colors.grey.shade400),
                    tickCount: 4,
                    ticksTextStyle: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                    titlePositionPercentageOffset: 0.24,
                    getTitle: (index, angle) => RadarChartTitle(
                      text: labels[index],
                      angle: angle,
                    ),
                    radarTouchData: RadarTouchData(
                      touchSpotThreshold: 28,
                      touchCallback: (event, response) {
                        final index = response?.touchedSpot?.touchedDataSetIndex;
                        setState(() {
                          _selected =
                              !event.isInterestedForInteractions || index == null
                                  ? null
                                  : index;
                        });
                      },
                    ),
                    dataSets: [for (var i = 0; i < data.length; i++) _buildSet(i)],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: [
                  for (var i = 0; i < names.length; i++)
                    _LegendItem(
                      color: colors[i],
                      label: names[i],
                      selected: selected == i,
                      onTap: () => setState(() => _selected = i),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                selected == null
                    ? 'Toca un vértice o elige una serie en la leyenda'
                    : _detalle(selected),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected == null ? FontWeight.normal : FontWeight.bold,
                  color: selected == null ? Colors.black54 : colors[selected],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _detalle(int index) {
    final valores = [
      for (var i = 0; i < labels.length; i++) '${labels[i]} ${data[index][i].toInt()}',
    ];
    return '${names[index]}: ${valores.join(' · ')}';
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.15) : null,
          border: Border.all(
            color: selected ? color : Colors.grey.shade400,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
