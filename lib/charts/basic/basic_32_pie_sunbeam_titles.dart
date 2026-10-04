import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic32PieSunbeamTitles extends StatelessWidget {
  const Basic32PieSunbeamTitles({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo'];
    const List<double> values = [24.0, 21, 19, 20, 16];
    const colors = [
      Colors.teal,
      Colors.pink,
      Colors.blue,
      Colors.green,
      Colors.deepPurple,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('32. Pastel con títulos rotados')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.2,
            child: PieChart(
              PieChartData(
                titleSunbeamLayout: true,
                sectionsSpace: 2,
                sections: [
                  for (var i = 0; i < values.length; i++)
                    PieChartSectionData(
                      value: values[i],
                      color: colors[i],
                      radius: 55,
                      title: '${labels[i]} ${values[i].toInt()}%',
                      titleStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
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
