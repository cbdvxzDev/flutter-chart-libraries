import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic29PieRounded extends StatelessWidget {
  const Basic29PieRounded({super.key});

  @override
  Widget build(BuildContext context) {
    const List<double> values = [40.0, 30, 18, 12];
    const colors = [Colors.indigo, Colors.teal, Colors.orange, Colors.pink];

    return Scaffold(
      appBar: AppBar(title: const Text('29. Pastel con esquinas redondeadas')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.2,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                sections: [
                  for (var i = 0; i < values.length; i++)
                    PieChartSectionData(
                      value: values[i],
                      color: colors[i],
                      radius: 75,
                      cornerRadius: 18,
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
