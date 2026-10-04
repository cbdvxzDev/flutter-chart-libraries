import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fl_chart_taller/charts_grafo/simples/catalogo_simples.dart';
import 'package:fl_chart_taller/main.dart';

void main() {
  Future<void> scrollTo(WidgetTester tester, String text) async {
    await tester.scrollUntilVisible(
      find.text(text),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('muestra el catálogo completo (43 básicas + 36 avanzadas)',
      (tester) async {
    await tester.pumpWidget(const FlChartTallerApp());

    expect(find.text('FL Chart — Taller'), findsOneWidget);
    expect(find.text('Básicas (43)'), findsOneWidget);
    expect(find.text('Línea simple'), findsOneWidget);
    expect(HomeScreen.basicCharts, hasLength(43));
    expect(HomeScreen.advancedCharts, hasLength(36));

    await scrollTo(tester, 'Avanzadas (36)');

    expect(find.text('Avanzadas (36)'), findsOneWidget);
  });

  testWidgets('navega a una gráfica básica', (tester) async {
    await tester.pumpWidget(const FlChartTallerApp());

    await tester.tap(find.text('Línea simple'));
    await tester.pumpAndSettle();

    expect(find.text('01. Línea simple'), findsOneWidget);
    expect(find.byType(LineChart), findsOneWidget);
  });

  testWidgets('navega a una gráfica avanzada', (tester) async {
    await tester.pumpWidget(const FlChartTallerApp());

    await scrollTo(tester, 'Línea con bandas entre series');

    await tester.tap(find.text('Línea con bandas entre series'));
    await tester.pumpAndSettle();

    expect(find.text('01. Área entre dos series'), findsOneWidget);
    expect(find.byType(LineChart), findsOneWidget);
  });

  testWidgets('abre la galería de grafos dirigidos', (tester) async {
    await tester.pumpWidget(const FlChartTallerApp());

    await tester.tap(find.byIcon(Icons.account_tree));
    await tester.pumpAndSettle();

    expect(find.text('Atlas de Grafos Dirigidos'), findsOneWidget);
    expect(find.text('Gráficos básicos'), findsOneWidget);
    expect(find.text('Gráficos avanzados'), findsOneWidget);
  });

  testWidgets('navega al catálogo de grafos básicos', (tester) async {
    await tester.pumpWidget(const FlChartTallerApp());

    await tester.tap(find.byIcon(Icons.account_tree));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gráficos básicos'));
    await tester.pumpAndSettle();

    expect(find.text(simpleCharts.first.title), findsOneWidget);
  });
}
