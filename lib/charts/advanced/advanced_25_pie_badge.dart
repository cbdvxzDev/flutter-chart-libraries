import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced25PieBadge extends StatelessWidget {
  const Advanced25PieBadge({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Electrónica', 'Ropa', 'Deportes', 'Libros'];
    const List<double> values = [44, 26, 17, 13];
    const colors = [
      Colors.deepOrange,
      Colors.blueGrey,
      Colors.lime,
      Colors.amber,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('25. Torta con insignias (badges)')),
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
                      sectionsSpace: 6,
                      sections: [
                        for (var i = 0; i < values.length; i++)
                          PieChartSectionData(
                            value: values[i],
                            color: colors[i],
                            radius: 72,
                            showTitle: false,
                            badgeWidget: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Icon(
                                i == 0
                                    ? Icons.star
                                    : i == 1
                                        ? Icons.favorite
                                        : i == 2
                                            ? Icons.bolt
                                            : Icons.menu_book,
                                size: 18,
                                color: colors[i],
                              ),
                            ),
                            badgePositionPercentageOffset: 0.95,
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
                                  color: colors[i],
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
