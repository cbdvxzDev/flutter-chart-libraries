import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic27PieDonut extends StatelessWidget {
  const Basic27PieDonut({super.key});

  @override
  Widget build(BuildContext context) {
    const sections = [
      ('Windows', 42.0, Colors.indigo),
      ('macOS', 22.0, Colors.teal),
      ('Linux', 18.0, Colors.orange),
      ('Otros', 18.0, Colors.pink),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('27. Dona (centerSpaceRadius)')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sistemas operativos',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              AspectRatio(
                aspectRatio: 1.2,
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 55,
                    centerSpaceColor: Colors.indigo.shade50,
                    sectionsSpace: 3,
                    sections: [
                      for (final (_, value, color) in sections)
                        PieChartSectionData(
                          value: value,
                          color: color,
                          radius: 55,
                          showTitle: false,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final (label, value, color) in sections)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$label  ${value.toInt()}%',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
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
