import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced23PieTouchGrow extends StatefulWidget {
  const Advanced23PieTouchGrow({super.key});

  @override
  State<Advanced23PieTouchGrow> createState() => _Advanced23PieTouchGrowState();
}

class _Advanced23PieTouchGrowState extends State<Advanced23PieTouchGrow> {
  static const labels = ['Fútbol', 'Baloncesto', 'Natación', 'Atletismo'];
  static const List<double> values = [31, 28, 23, 18];
  static const colors = [
    Colors.pink,
    Colors.indigo,
    Colors.teal,
    Colors.deepOrange,
  ];

  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('23. Sección que crece al tocar')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        final section = response?.touchedSection;
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              section == null) {
                            _touchedIndex = -1;
                          } else {
                            _touchedIndex = section.touchedSectionIndex;
                          }
                        });
                      },
                    ),
                    sections: [
                      for (var i = 0; i < values.length; i++)
                        PieChartSectionData(
                          value: values[i],
                          color: colors[i],
                          radius: _touchedIndex == i ? 85 : 62,
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
              const SizedBox(height: 16),
              Wrap(
                spacing: 14,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  for (var i = 0; i < labels.length; i++)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: colors[i],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          labels[i],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: _touchedIndex == i
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
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
