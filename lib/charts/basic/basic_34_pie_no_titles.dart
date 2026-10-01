import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic34PieNoTitles extends StatelessWidget {
  const Basic34PieNoTitles({super.key});

  @override
  Widget build(BuildContext context) {
    const sections = [
      ('Producto A', 34.0, Colors.indigo),
      ('Producto B', 28.0, Colors.teal),
      ('Producto C', 22.0, Colors.orange),
      ('Producto D', 16.0, Colors.pink),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('34. Pastel sin títulos')),
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
                    sectionsSpace: 6,
                    sections: [
                      for (final (_, _, color) in sections)
                        PieChartSectionData(
                          color: color,
                          radius: 70,
                          showTitle: false,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final (label, value, color) in sections)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$label — ${value.toInt()}%',
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
