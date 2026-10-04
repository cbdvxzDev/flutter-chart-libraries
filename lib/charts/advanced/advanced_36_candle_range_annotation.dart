import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced36CandlestickRangeAnnotation extends StatelessWidget {
  const Advanced36CandlestickRangeAnnotation({super.key});

  static final List<CandlestickSpot> spots = [
    CandlestickSpot(x: 0, open: 46, high: 51, low: 44, close: 50),
    CandlestickSpot(x: 1, open: 50, high: 56, low: 48, close: 55),
    CandlestickSpot(x: 2, open: 55, high: 60, low: 52, close: 53),
    CandlestickSpot(x: 3, open: 53, high: 61, low: 51, close: 60),
    CandlestickSpot(x: 4, open: 60, high: 66, low: 57, close: 64),
    CandlestickSpot(x: 5, open: 64, high: 70, low: 62, close: 69),
    CandlestickSpot(x: 6, open: 69, high: 75, low: 66, close: 72),
    CandlestickSpot(x: 7, open: 72, high: 79, low: 70, close: 78),
    CandlestickSpot(x: 8, open: 78, high: 83, low: 75, close: 80),
    CandlestickSpot(x: 9, open: 80, high: 82, low: 74, close: 76),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('36. Velas con anotaciones de rango')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.4,
            child: CandlestickChart(
              CandlestickChartData(
                candlestickSpots: spots,
                minY: 40,
                maxY: 85,
                rangeAnnotations: RangeAnnotations(
                  horizontalRangeAnnotations: [
                    HorizontalRangeAnnotation(
                      y1: 42,
                      y2: 50,
                      color: Colors.green.withValues(alpha: 0.14),
                    ),
                    HorizontalRangeAnnotation(
                      y1: 75,
                      y2: 85,
                      color: Colors.red.withValues(alpha: 0.14),
                    ),
                  ],
                  verticalRangeAnnotations: [
                    VerticalRangeAnnotation(
                      x1: 3,
                      x2: 6,
                      color: Colors.amber.withValues(alpha: 0.16),
                    ),
                  ],
                ),
                gridData: const FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                titlesData: const FlTitlesData(
                  topTitles: AxisTitles(),
                  rightTitles: AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 10,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
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
