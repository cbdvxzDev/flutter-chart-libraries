import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced21BarAxisWidgets extends StatefulWidget {
  const Advanced21BarAxisWidgets({super.key});

  @override
  State<Advanced21BarAxisWidgets> createState() =>
      _Advanced21BarAxisWidgetsState();
}

class _Advanced21BarAxisWidgetsState extends State<Advanced21BarAxisWidgets> {
  static const labels = ['Web', 'App', 'Tienda', 'Email', 'Social', 'Retail'];
  static const List<double> values = [64, 88, 52, 96, 73, 58];
  static const icons = [
    Icons.language,
    Icons.phone_iphone,
    Icons.store,
    Icons.mail,
    Icons.share,
    Icons.local_mall,
  ];
  static const double intervalo = 30;
  static const alineaciones = [
    SideTitleAlignment.outside,
    SideTitleAlignment.border,
    SideTitleAlignment.inside,
  ];
  static const nombres = ['outside', 'border', 'inside'];
  static const efectos = [
    'padding = reservedSize: fuera del borde',
    'padding = reservedSize / 2: sobre el borde',
    'padding = 0: dentro del área de la gráfica',
  ];

  int? _tocada;
  SideTitleAlignment _alineacion = SideTitleAlignment.outside;

  double get _maximo => values.reduce((a, b) => a > b ? a : b);
  double get _nivelSuperior => (_maximo / intervalo).floor() * intervalo;

  Widget bottomTitle(double value, TitleMeta meta) {
    if (value < 0 || value >= labels.length || value % 1 != 0) {
      return const SizedBox.shrink();
    }
    final index = value.toInt();
    final activa = _tocada == index;
    return SideTitleWidget(
      meta: meta,
      space: 6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icons[index],
            size: 16,
            color: activa ? Colors.deepOrange : Colors.indigo,
          ),
          Text(
            labels[index],
            style: TextStyle(
              fontSize: 11,
              fontWeight: activa ? FontWeight.bold : FontWeight.w600,
              color: activa ? Colors.deepOrange : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget leftTitle(double value, TitleMeta meta) {
    if (value % intervalo != 0) return const SizedBox.shrink();
    final alto = _nivelSuperior > 0 && value >= _nivelSuperior;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: alto ? Colors.deepOrange : Colors.indigo,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        value.toInt().toString(),
        style: const TextStyle(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxY = (_maximo / intervalo).ceil() * intervalo;
    final indice = alineaciones.indexOf(_alineacion);

    return Scaffold(
      appBar: AppBar(title: const Text('21. Títulos de eje con widgets')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<SideTitleAlignment>(
                segments: [
                  for (var i = 0; i < alineaciones.length; i++)
                    ButtonSegment(
                      value: alineaciones[i],
                      label: Text(nombres[i]),
                    ),
                ],
                selected: {_alineacion},
                onSelectionChanged: (seleccion) =>
                    setState(() => _alineacion = seleccion.first),
                showSelectedIcon: false,
              ),
              const SizedBox(height: 14),
              Expanded(
                child: BarChart(
                  BarChartData(
                    minY: 0,
                    maxY: maxY,
                    gridData: const FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 30,
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    barTouchData: BarTouchData(
                      handleBuiltInTouches: false,
                      touchCallback: (event, response) {
                        final grupo = response?.spot?.touchedBarGroupIndex;
                        setState(() {
                          _tocada =
                              !event.isInterestedForInteractions ||
                                  grupo == null
                              ? null
                              : grupo;
                        });
                      },
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      leftTitles: AxisTitles(
                        axisNameWidget: const Text(
                          'Ventas',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        axisNameSize: 26,
                        sideTitleAlignment: _alineacion,
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 30,
                          getTitlesWidget: leftTitle,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        axisNameWidget: const Text(
                          'Canal de venta',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        axisNameSize: 26,
                        sideTitleAlignment: _alineacion,
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 46,
                          interval: 1,
                          getTitlesWidget: bottomTitle,
                        ),
                      ),
                    ),
                    barGroups: [
                      for (var i = 0; i < values.length; i++)
                        BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: values[i],
                              width: 26,
                              color: _tocada == i
                                  ? Colors.deepOrange
                                  : Colors.indigo,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'sideTitleAlignment: ${nombres[indice]} · ${efectos[indice]}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 4),
              Text(
                _tocada == null
                    ? 'Ejes: "Canal de venta" y "Ventas" · toca una barra para resaltar su etiqueta'
                    : 'Resaltado: ${labels[_tocada!]} — ${values[_tocada!].toInt()}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: _tocada == null
                      ? FontWeight.normal
                      : FontWeight.bold,
                  color: _tocada == null ? Colors.black54 : Colors.deepOrange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
