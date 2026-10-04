import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic43CandleAxis extends StatelessWidget {
  const Basic43CandleAxis({super.key});

  @override
  Widget build(BuildContext context) {
    final spots = <CandlestickSpot>[
      CandlestickSpot(x: 1, open: 105, high: 112, low: 103, close: 110),
      CandlestickSpot(x: 2, open: 110, high: 114, low: 106, close: 107),
      CandlestickSpot(x: 3, open: 107, high: 115, low: 105, close: 114),
      CandlestickSpot(x: 4, open: 114, high: 117, low: 110, close: 111),
      CandlestickSpot(x: 5, open: 111, high: 118, low: 109, close: 117),
      CandlestickSpot(x: 6, open: 117, high: 121, low: 113, close: 115),
      CandlestickSpot(x: 7, open: 115, high: 119, low: 112, close: 118),
      CandlestickSpot(x: 8, open: 118, high: 124, low: 116, close: 123),
      CandlestickSpot(x: 9, open: 123, high: 127, low: 120, close: 121),
      CandlestickSpot(x: 10, open: 121, high: 128, low: 119, close: 126),
    ];

    Widget bottomTitle(double value, TitleMeta meta) {
      if (value % 5 != 0) return const SizedBox.shrink();
      return SideTitleWidget(
        meta: meta,
        child: Text(
          'Día ${value.toInt()}',
          style: const TextStyle(fontSize: 12),
        ),
      );
    }

    Widget leftTitle(double value, TitleMeta meta) {
      if (value % 5 != 0) return const SizedBox.shrink();
      return Text(
        '\$${value.toInt()}',
        style: const TextStyle(fontSize: 12),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('43. Velas con ejes personalizados')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.4,
            child: CandlestickChart(
              CandlestickChartData(
                candlestickSpots: spots,
                candlestickPainter: DefaultCandlestickPainter(
                  candlestickStyleProvider: (spot, index) {
                    final up = spot.isUp;
                    final color = up ? Colors.green.shade700 : Colors.red.shade600;
                    return CandlestickStyle(
                      lineColor: color,
                      lineWidth: 1.5,
                      bodyStrokeColor: color,
                      bodyStrokeWidth: 1,
                      bodyFillColor: up ? Colors.white : color,
                      bodyWidth: 10,
                      bodyRadius: 4,
                    );
                  },
                ),
                minY: 95,
                maxY: 130,
                gridData: const FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 5,
                  verticalInterval: 5,
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
                      reservedSize: 44,
                      interval: 5,
                      getTitlesWidget: leftTitle,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 5,
                      getTitlesWidget: bottomTitle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
