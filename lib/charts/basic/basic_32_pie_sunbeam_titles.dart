import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic32PieSunbeamTitles extends StatelessWidget {
  const Basic32PieSunbeamTitles({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo'];
    const List<double> values = [22.0, 26, 18, 20, 14];
    const colors = [Colors.indigo, Colors.teal, Colors.orange, Colors.pink, Colors.deepPurple];

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
