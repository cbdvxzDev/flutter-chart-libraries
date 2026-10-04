import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fl_chart_taller/main.dart';

void main() {
  testWidgets('muestra el catálogo completo (43 básicas + 36 avanzadas)',
      (tester) async {
    await tester.pumpWidget(const FlChartTallerApp());

    expect(find.text('FL Chart — Taller'), findsOneWidget);
    expect(find.text('Básicas (43)'), findsOneWidget);
    expect(find.text('Línea simple'), findsOneWidget);
    expect(HomeScreen.basicCharts, hasLength(43));
    expect(HomeScreen.advancedCharts, hasLength(36));

    // La sección avanzada está fuera de pantalla: hay que desplazar la lista.
    await tester.scrollUntilVisible(find.text('Avanzadas (36)'), 500);
    await tester.pumpAndSettle();
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

    // El elemento está fuera de pantalla: desplazar hacia abajo antes de tocar.
    await tester.scrollUntilVisible(find.text('Línea con bandas entre series'), 500);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Línea con bandas entre series'));
    await tester.pumpAndSettle();

    expect(find.text('01. Área entre dos series'), findsOneWidget);
    expect(find.byType(LineChart), findsOneWidget);
  });
}
