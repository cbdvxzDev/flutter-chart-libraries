import 'package:fl_chart_taller/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final charts = <(String, WidgetBuilder)>[
    ...HomeScreen.basicCharts,
    ...HomeScreen.advancedCharts,
  ];

  for (var i = 0; i < charts.length; i++) {
    final entry = charts[i];
    testWidgets('chart ${i + 1} ${entry.$1}', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(builder: (context) => entry.$2(context)),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
