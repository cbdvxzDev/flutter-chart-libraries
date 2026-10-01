import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic31PieVariableRadius extends StatelessWidget {
  const Basic31PieVariableRadius({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Móvil', 'Web', 'Tienda', 'Call center'];
    const List<double> values = [45.0, 30, 15, 10];
    const List<double> radii = [95.0, 75, 58, 45];
    const colors = [Colors.indigo, Colors.teal, Colors.orange, Colors.pink];

    return Scaffold(
      appBar: AppBar(title: const Text('31. Pastel con radios variables')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1.3,
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 0,
                    sectionsSpace: 3,
                    sections: [
                      for (var i = 0; i < values.length; i++)
                        PieChartSectionData(
                          value: values[i],
                          color: colors[i],
                          radius: radii[i],
                          title: '${values[i].toInt()}%',
                          titleStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  for (var i = 0; i < labels.length; i++)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: colors[i],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(labels[i], style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
