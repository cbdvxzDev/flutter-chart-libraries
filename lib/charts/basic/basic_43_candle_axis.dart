import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic43CandleAxis extends StatelessWidget {
  const Basic43CandleAxis({super.key});

  @override
  Widget build(BuildContext context) {
    final spots = <CandlestickSpot>[
      CandlestickSpot(x: 1, open: 102, high: 108, low: 100, close: 106),
      CandlestickSpot(x: 2, open: 106, high: 110, low: 103, close: 104),
      CandlestickSpot(x: 3, open: 104, high: 112, low: 103, close: 111),
      CandlestickSpot(x: 4, open: 111, high: 113, low: 107, close: 108),
      CandlestickSpot(x: 5, open: 108, high: 115, low: 107, close: 114),
      CandlestickSpot(x: 6, open: 114, high: 118, low: 112, close: 116),
      CandlestickSpot(x: 7, open: 116, high: 117, low: 110, close: 112),
      CandlestickSpot(x: 8, open: 112, high: 121, low: 111, close: 120),
      CandlestickSpot(x: 9, open: 120, high: 124, low: 116, close: 117),
      CandlestickSpot(x: 10, open: 117, high: 126, low: 115, close: 125),
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
