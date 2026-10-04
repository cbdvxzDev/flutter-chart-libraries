import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic33PieBorders extends StatelessWidget {
  const Basic33PieBorders({super.key});

  @override
  Widget build(BuildContext context) {
    const List<double> values = [36.0, 29, 21, 14];
    const colors = [
      Colors.blueGrey,
      Colors.orange,
      Colors.green,
      Colors.purple,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('33. Pastel con bordes')),
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
                      radius: 70,
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 3,
                      ),
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
