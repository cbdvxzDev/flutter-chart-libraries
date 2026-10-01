import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced24PieGradient extends StatefulWidget {
  const Advanced24PieGradient({super.key});

  @override
  State<Advanced24PieGradient> createState() => _Advanced24PieGradientState();
}

class _Advanced24PieGradientState extends State<Advanced24PieGradient> {
  static const labels = ['Ana', 'Luis', 'Marta', 'Diego'];
  static const List<double> values = [30, 25, 25, 20];
  static const gradients = [
    [Color(0xFF5C6BC0), Color(0xFF1A237E)],
    [Color(0xFF4DB6AC), Color(0xFF00695C)],
    [Color(0xFFFFB74D), Color(0xFFE65100)],
    [Color(0xFFF06292), Color(0xFFAD1457)],
  ];

  int _tocada = -1;

  double get _total => values.reduce((a, b) => a + b);

  List<Color> _colores(int index) {
    if (_tocada == -1 || _tocada == index) return gradients[index];
    return [for (final c in gradients[index]) c.withValues(alpha: 0.3)];
  }

  @override
  Widget build(BuildContext context) {
    final hayTocado = _tocada != -1;

    return Scaffold(
      appBar: AppBar(title: const Text('24. Tortas con degradado radial')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 4,
                              centerSpaceRadius: 34,
                              centerSpaceColor: Colors.grey.shade50,
                              pieTouchData: PieTouchData(
                                touchCallback: (event, response) {
                                  final section = response?.touchedSection;
                                  setState(() {
                                    _tocada =
                                        !event.isInterestedForInteractions ||
                                            section == null
                                        ? -1
                                        : section.touchedSectionIndex;
                                  });
                                },
                              ),
                              sections: [
                                for (var i = 0; i < values.length; i++)
                                  PieChartSectionData(
                                    value: values[i],
                                    gradient: RadialGradient(
                                      colors: _colores(i),
                                      center: Alignment.center,
                                      radius: 1.1,
                                    ),
                                    radius: _tocada == i ? 84 : 70,
                                    title: '${values[i]}%',
                                    titleStyle: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: _tocada != -1 && _tocada != i
                                          ? Colors.white60
                                          : Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          IgnorePointer(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    hayTocado ? labels[_tocada] : 'Total',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    '${(hayTocado ? values[_tocada] : _total).toInt()}%',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: hayTocado
                                          ? Colors.black87
                                          : Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                                      gradient: LinearGradient(
                                        colors: _colores(i),
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${labels[i]}  ${values[i]}%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: _tocada == i
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: _tocada == i
                                          ? Colors.black87
                                          : Colors.black54,
                                    ),
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
              const SizedBox(height: 12),
              Text(
                hayTocado
                    ? '${labels[_tocada]} — ${values[_tocada].toInt()}% de '
                        '${_total.toInt()}% · las demás secciones se atenúan'
                    : 'Cada sección usa RadialGradient · toca una sección para '
                        'ver su dato en el centro',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: hayTocado ? FontWeight.bold : FontWeight.normal,
                  color: hayTocado ? Colors.black87 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
