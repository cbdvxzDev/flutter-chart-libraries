import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced31RadarGradient extends StatefulWidget {
  const Advanced31RadarGradient({super.key});

  @override
  State<Advanced31RadarGradient> createState() =>
      _Advanced31RadarGradientState();
}

class _Advanced31RadarGradientState extends State<Advanced31RadarGradient> {
  static const labels = ['Comida', 'Salud', 'Hogar', 'Viajes', 'Ahorro', 'Ocio'];
  static const escenarios = ['Real', 'Planificado', 'Ideal'];
  static const List<List<double>> datos = [
    [70, 55, 85, 40, 62, 50],
    [60, 65, 80, 55, 70, 45],
    [55, 75, 70, 60, 85, 40],
  ];
  static const degradados = [
    [Color(0xFFFFCDD2), Color(0xFFB71C1C)],
    [Color(0xFFC8E6C9), Color(0xFF1B5E20)],
    [Color(0xFFFFF9C4), Color(0xFFF57F17)],
  ];

  int _escenario = 0;

  @override
  Widget build(BuildContext context) {
    final valores = datos[_escenario];
    var maximo = 0;
    for (var i = 1; i < valores.length; i++) {
      if (valores[i] > valores[maximo]) maximo = i;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('31. Radar con relleno degradado')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<int>(
                segments: [
                  for (var i = 0; i < escenarios.length; i++)
                    ButtonSegment(value: i, label: Text(escenarios[i])),
                ],
                selected: {_escenario},
                onSelectionChanged: (seleccion) =>
                    setState(() => _escenario = seleccion.first),
                showSelectedIcon: false,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: RadarChart(
                  RadarChartData(
                    radarBorderData: BorderSide(color: Colors.grey.shade400),
                    gridBorderData: BorderSide(color: Colors.grey.shade300),
                    tickBorderData: BorderSide(color: Colors.grey.shade400),
                    tickCount: 4,
                    ticksTextStyle: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                    getTitle: (index, angle) => RadarChartTitle(
                      text: labels[index],
                      angle: angle,
                    ),
                    dataSets: [
                      RadarDataSet(
                        dataEntries: [
                          for (final v in valores) RadarEntry(value: v),
                        ],
                        fillColor: degradados[_escenario].first,
                        fillGradient: LinearGradient(
                          colors: degradados[_escenario],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderColor: degradados[_escenario].last,
                        borderWidth: 2,
                        entryRadius: 3.5,
                      ),
                    ],
                  ),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Escenario ${escenarios[_escenario].toLowerCase()} · mayor '
                'valor en ${labels[maximo]} (${valores[maximo].toInt()})',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              Text(
                'RadarChart(duration: 600ms, curve: easeInOut) anima '
                'entries, borde y degradado',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: degradados[_escenario].last.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
