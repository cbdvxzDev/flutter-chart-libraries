import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced34CandlestickCustomTooltip extends StatelessWidget {
  const Advanced34CandlestickCustomTooltip({super.key});

  static List<CandlestickSpot> get spots => [
        CandlestickSpot(x: 0, open: 50, high: 56, low: 47, close: 54),
        CandlestickSpot(x: 1, open: 54, high: 58, low: 50, close: 51),
        CandlestickSpot(x: 2, open: 51, high: 62, low: 49, close: 60),
        CandlestickSpot(x: 3, open: 60, high: 63, low: 55, close: 57),
        CandlestickSpot(x: 4, open: 57, high: 66, low: 56, close: 65),
        CandlestickSpot(x: 5, open: 65, high: 68, low: 60, close: 62),
        CandlestickSpot(x: 6, open: 62, high: 74, low: 61, close: 72),
        CandlestickSpot(x: 7, open: 72, high: 75, low: 66, close: 68),
        CandlestickSpot(x: 8, open: 68, high: 79, low: 67, close: 77),
        CandlestickSpot(x: 9, open: 77, high: 80, low: 71, close: 73),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('34. Velas con tooltip personalizado')),
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
                gridData: const FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                candlestickTouchData: CandlestickTouchData(
                  touchTooltipData: CandlestickTouchTooltipData(
                    getTooltipColor: (spot) => spot.isUp
                        ? const Color(0xFF14532D)
                        : const Color(0xFF7F1D1D),
                    getTooltipItems: (painter, spot, index) {
                      final subida = spot.isUp;
                      return CandlestickTooltipItem(
                        '${subida ? '▲' : '▼'} Vela ${index + 1} · '
                        '${subida ? 'al alza' : 'a la baja'}\n'
                        'A:${spot.open.toStringAsFixed(1)}  '
                        'M:${spot.high.toStringAsFixed(1)}\n'
                        'B:${spot.low.toStringAsFixed(1)}  '
                        'C:${spot.close.toStringAsFixed(1)}',
                        textAlign: TextAlign.left,
                        textStyle: TextStyle(
                          color: subida
                              ? Colors.greenAccent.shade400
                              : Colors.redAccent.shade200,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      );
                    },
                    tooltipBorder: const BorderSide(color: Colors.white24),
                  ),
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
