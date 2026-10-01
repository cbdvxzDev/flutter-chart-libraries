import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic36ScatterShapes extends StatelessWidget {
  const Basic36ScatterShapes({super.key});

  @override
  Widget build(BuildContext context) {
    Widget bottomTitle(double value, TitleMeta meta) {
      if (value % 10 != 0) return const SizedBox.shrink();
      return SideTitleWidget(
        meta: meta,
        child: Text(
          value.toInt().toString(),
          style: const TextStyle(fontSize: 12),
        ),
      );
    }

    Widget leftTitle(double value, TitleMeta meta) {
      if (value % 10 != 0) return const SizedBox.shrink();
      return Text(
        value.toInt().toString(),
        style: const TextStyle(fontSize: 12),
      );
    }

    final spots = <ScatterSpot>[
      ScatterSpot(
        12,
        18,
        dotPainter: FlDotCirclePainter(radius: 9, color: Colors.indigo),
      ),
      ScatterSpot(
        28,
        40,
        dotPainter: FlDotSquarePainter(size: 14, color: Colors.teal),
      ),
      ScatterSpot(
        45,
        26,
        dotPainter: FlDotCrossPainter(size: 16, color: Colors.orange),
      ),
      ScatterSpot(
        58,
        62,
        dotPainter: FlDotCirclePainter(radius: 9, color: Colors.indigo),
      ),
      ScatterSpot(
        72,
        48,
        dotPainter: FlDotSquarePainter(size: 14, color: Colors.teal),
      ),
      ScatterSpot(
        86,
        74,
        dotPainter: FlDotCrossPainter(size: 16, color: Colors.orange),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('36. Dispersión con formas')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ScatterChart(
                  ScatterChartData(
                    minX: 0,
                    maxX: 100,
                    minY: 0,
                    maxY: 100,
                    gridData: const FlGridData(
                      show: true,
                      horizontalInterval: 10,
                      verticalInterval: 10,
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: leftTitle,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: bottomTitle,
                        ),
                      ),
                    ),
                    scatterSpots: spots,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 20,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _LegendItem(
                    painter: FlDotCirclePainter(radius: 7, color: Colors.indigo),
                    label: 'Círculo',
                  ),
                  _LegendItem(
                    painter: FlDotSquarePainter(size: 12, color: Colors.teal),
                    label: 'Cuadrado',
                  ),
                  _LegendItem(
                    painter: FlDotCrossPainter(size: 14, color: Colors.orange),
                    label: 'Cruz',
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

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.painter, required this.label});

  final FlDotPainter painter;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: CustomPaint(
            painter: _DotPainterPreview(painter),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

class _DotPainterPreview extends CustomPainter {
  const _DotPainterPreview(this.painter);

  final FlDotPainter painter;

  @override
  void paint(Canvas canvas, Size size) {
    painter.draw(canvas, const FlSpot(0, 0), size.center(Offset.zero));
  }

  @override
  bool shouldRepaint(covariant _DotPainterPreview oldDelegate) => false;
}
