import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced24PieGradient extends StatelessWidget {
  const Advanced24PieGradient({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Ana', 'Luis', 'Marta', 'Diego'];
    const List<double> values = [30, 25, 25, 20];

    const gradients = [
      [Color(0xFF5C6BC0), Color(0xFF1A237E)],
      [Color(0xFF4DB6AC), Color(0xFF00695C)],
      [Color(0xFFFFB74D), Color(0xFFE65100)],
      [Color(0xFFF06292), Color(0xFFAD1457)],
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('24. Tortas con degradado radial')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.4,
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 34,
                      centerSpaceColor: Colors.grey.shade50,
                      sections: [
                        for (var i = 0; i < values.length; i++)
                          PieChartSectionData(
                            value: values[i],
                            gradient: RadialGradient(
                              colors: gradients[i],
                              center: Alignment.center,
                              radius: 1.1,
                            ),
                            radius: 70,
                            title: '${values[i]}%',
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
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < labels.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: gradients[i]),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${labels[i]}  ${values[i]}%',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
