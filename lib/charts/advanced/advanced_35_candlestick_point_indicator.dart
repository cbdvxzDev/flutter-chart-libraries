import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced35CandlestickPointIndicator extends StatefulWidget {
  const Advanced35CandlestickPointIndicator({super.key});

  @override
  State<Advanced35CandlestickPointIndicator> createState() =>
      _Advanced35CandlestickPointIndicatorState();
}

class _Advanced35CandlestickPointIndicatorState
    extends State<Advanced35CandlestickPointIndicator> {
  static final List<CandlestickSpot> spots = [
    CandlestickSpot(x: 0, open: 50, high: 56, low: 47, close: 54),
    CandlestickSpot(x: 1, open: 54, high: 58, low: 50, close: 51),
    CandlestickSpot(x: 2, open: 51, high: 62, low: 49, close: 60),
    CandlestickSpot(x: 3, open: 60, high: 63, low: 55, close: 57),
    CandlestickSpot(x: 4, open: 57, high: 74, low: 56, close: 72),
    CandlestickSpot(x: 5, open: 72, high: 75, low: 66, close: 68),
    CandlestickSpot(x: 6, open: 68, high: 79, low: 67, close: 77),
    CandlestickSpot(x: 7, open: 77, high: 80, low: 71, close: 73),
  ];

  String _info = 'Toca una vela: el indicador punteado la sigue';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('35. Indicador de punto personalizado'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.4,
                  child: CandlestickChart(
                    CandlestickChartData(
                      candlestickSpots: spots,
                      minY: 40,
                      maxY: 85,
                      candlestickTouchData: CandlestickTouchData(
                        touchCallback: (event, response) {
                          final spot = response?.touchedSpot?.spot;
                          if (!event.isInterestedForInteractions ||
                              spot == null) {
                            return;
                          }
                          setState(() {
                            _info =
                                'Vela ${spot.x.toInt() + 1} · '
                                'A ${spot.open.toStringAsFixed(1)} → '
                                'C ${spot.close.toStringAsFixed(1)}';
                          });
                        },
                      ),
                      touchedPointIndicator: AxisSpotIndicator(
                        painter: AxisLinesIndicatorPainter(
                          horizontalLineProvider: (y) => HorizontalLine(
                            y: y,
                            color: Colors.deepPurple,
                            strokeWidth: 1.5,
                            dashArray: [6, 4],
                          ),
                          verticalLineProvider: (x) => VerticalLine(
                            x: x,
                            color: Colors.deepPurple,
                            strokeWidth: 1.5,
                            dashArray: [6, 4],
                          ),
                        ),
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
              const SizedBox(height: 12),
              Text(
                _info,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
