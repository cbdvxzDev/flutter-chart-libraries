import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic30PieStartOffset extends StatelessWidget {
  const Basic30PieStartOffset({super.key});

  @override
  Widget build(BuildContext context) {
    const List<double> values = [35.0, 25, 25, 15];
    const colors = [Colors.indigo, Colors.teal, Colors.orange, Colors.pink];

    return Scaffold(
      appBar: AppBar(title: const Text('30. Pastel con inicio rotado (45°)')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.2,
            child: PieChart(
              PieChartData(
                startDegreeOffset: 45,
                sectionsSpace: 3,
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
