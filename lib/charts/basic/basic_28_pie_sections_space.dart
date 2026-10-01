import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic28PieSectionsSpace extends StatelessWidget {
  const Basic28PieSectionsSpace({super.key});

  @override
  Widget build(BuildContext context) {
    const List<double> values = [30.0, 25, 25, 20];
    const colors = [Colors.indigo, Colors.teal, Colors.orange, Colors.purple];

    return Scaffold(
      appBar: AppBar(title: const Text('28. Pastel con separación entre secciones')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.2,
            child: PieChart(
              PieChartData(
                sectionsSpace: 12,
                sections: [
                  for (var i = 0; i < values.length; i++)
                    PieChartSectionData(
                      value: values[i],
                      color: colors[i],
                      radius: 70,
                      title: '${values[i].toInt()}%',
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
