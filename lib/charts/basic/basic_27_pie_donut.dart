import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic27PieDonut extends StatelessWidget {
  const Basic27PieDonut({super.key});

  @override
  Widget build(BuildContext context) {
    const sections = [
      ('Windows', 38.0, Colors.deepPurple),
      ('macOS', 26.0, Colors.cyan),
      ('Linux', 21.0, Colors.amber),
      ('Otros', 15.0, Colors.blueGrey),
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
              Expanded(
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 55,
                    centerSpaceColor: Colors.deepPurple.shade50,
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
