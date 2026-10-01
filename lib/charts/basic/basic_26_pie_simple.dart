import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic26PieSimple extends StatelessWidget {
  const Basic26PieSimple({super.key});

  @override
  Widget build(BuildContext context) {
    const sections = [
      ('Alimentación', 35.0, Colors.indigo),
      ('Transporte', 20.0, Colors.teal),
      ('Vivienda', 25.0, Colors.orange),
      ('Otros', 20.0, Colors.pink),
    ];

    Widget legendItem(Color color, String label) {
      return Row(
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
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('26. Pastel simple')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    sections: [
                      for (final (_, value, color) in sections)
                        PieChartSectionData(
                          value: value,
                          color: color,
                          radius: 60,
                          title: '${value.toInt()}%',
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
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  for (final (label, _, color) in sections)
                    legendItem(color, label),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
