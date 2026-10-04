import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced34CandlestickCustomTooltip extends StatelessWidget {
  const Advanced34CandlestickCustomTooltip({super.key});

  static List<CandlestickSpot> get spots => [
        CandlestickSpot(x: 0, open: 45, high: 52, low: 44, close: 51),
        CandlestickSpot(x: 1, open: 51, high: 54, low: 47, close: 48),
        CandlestickSpot(x: 2, open: 48, high: 55, low: 46, close: 54),
        CandlestickSpot(x: 3, open: 54, high: 58, low: 51, close: 52),
        CandlestickSpot(x: 4, open: 52, high: 59, low: 50, close: 58),
        CandlestickSpot(x: 5, open: 58, high: 62, low: 55, close: 56),
        CandlestickSpot(x: 6, open: 56, high: 63, low: 53, close: 62),
        CandlestickSpot(x: 7, open: 62, high: 67, low: 60, close: 64),
        CandlestickSpot(x: 8, open: 64, high: 69, low: 61, close: 66),
        CandlestickSpot(x: 9, open: 66, high: 72, low: 63, close: 70),
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
