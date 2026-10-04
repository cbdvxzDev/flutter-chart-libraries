import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fl_chart_taller/main.dart';

void main() {
  final rail = find.byKey(const ValueKey('riel'));

  Finder inRail(String text) =>
      find.descendant(of: rail, matching: find.text(text));

  /// Deja avanzar el tiempo sin esperar a que terminen las animaciones
  /// infinitas que tienen algunas gráficas.
  Future<void> pumpFor(WidgetTester tester) async {
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(milliseconds: 300));
    }
  }

  /// Abre la app en una ventana de escritorio de 1280 × 900.
  ///
  /// La ventana de prueba por defecto (800 × 600) con la fuente de pruebas,
  /// que dibuja cada letra como un cuadrado, deja las tarjetas fuera de vista.
  Future<void> openApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const FlChartTallerApp());
  }

  testWidgets('el riel muestra las cuatro librerías y el total', (
    tester,
  ) async {
    await openApp(tester);

    expect(inRail('Taller de gráficas'), findsOneWidget);
    expect(inRail('4 librerías · 316 gráficas'), findsOneWidget);
    for (final name in [
      'FL Chart',
      'Syncfusion Charts',
      'Directed Graph',
      'Financial Chart',
    ]) {
      expect(inRail(name), findsOneWidget);
    }
    // Al abrir se ve FL Chart con sus básicas.
    expect(find.text('fl_chart 1.2.0'), findsOneWidget);
    expect(find.text('Línea simple'), findsOneWidget);
  });

  testWidgets('al pulsar "Avanzadas" cambia la lista', (tester) async {
    await openApp(tester);

    await tester.tap(find.byKey(const ValueKey('nivel-avanzadas')));
    await tester.pumpAndSettle();

    expect(find.text('Línea con bandas entre series'), findsOneWidget);
    expect(find.text('Línea simple'), findsNothing);
  });

  testWidgets('al pulsar una tarjeta se abre la gráfica', (tester) async {
    await openApp(tester);

    await tester.tap(find.text('Línea simple'));
    await tester.pumpAndSettle();

    expect(find.text('01. Línea simple'), findsOneWidget);
    expect(find.byType(LineChart), findsOneWidget);
  });

  testWidgets('la ficha de categoría filtra las tarjetas', (tester) async {
    await openApp(tester);

    await tester.tap(find.text('Velas'));
    await tester.pumpAndSettle();

    expect(find.text('Velas (candlestick) básico'), findsOneWidget);
    expect(find.text('Línea simple'), findsNothing);
    // El número es la posición original, no la posición filtrada.
    expect(find.text('42'), findsOneWidget);
  });

  testWidgets('la búsqueda ignora mayúsculas y capitaliza Syncfusion', (
    tester,
  ) async {
    await openApp(tester);

    await tester.tap(find.byKey(const ValueKey('libreria-1')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('buscar')), 'SPLINE');
    await tester.pumpAndSettle();

    // En charts_gallery.dart el título es "spline"; se muestra "Spline".
    expect(find.text('Spline'), findsOneWidget);
    expect(find.text('Spline múltiple'), findsOneWidget);
    expect(find.text('Línea'), findsNothing);

    await tester.enterText(find.byKey(const ValueKey('buscar')), 'zzz');
    await tester.pumpAndSettle();

    expect(
      find.text('Ninguna gráfica coincide con la búsqueda.'),
      findsOneWidget,
    );
  });

  testWidgets('cambiar de librería vuelve la categoría a "Todas"', (
    tester,
  ) async {
    await openApp(tester);

    await tester.tap(find.text('Velas'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('libreria-2')));
    await tester.pumpAndSettle();

    expect(find.text('Grafo dirigido básico'), findsOneWidget);
  });

  testWidgets('abre la primera gráfica de las otras tres librerías', (
    tester,
  ) async {
    await openApp(tester);

    for (final (library, card, header) in const [
      (1, 'Línea', 'Línea'),
      (2, 'Grafo dirigido básico', '1. Grafo dirigido básico'),
      (3, 'Velas Heikin-Ashi', '01. Velas Heikin-Ashi'),
    ]) {
      await tester.tap(find.byKey(ValueKey('libreria-$library')));
      await tester.pumpAndSettle();

      await tester.tap(find.text(card));
      await pumpFor(tester);
      expect(find.widgetWithText(AppBar, header), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pageBack();
      await pumpFor(tester);
      expect(rail, findsOneWidget);
    }
  });

  testWidgets('en pantalla estrecha el riel pasa arriba', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const FlChartTallerApp());

    expect(tester.getTopLeft(rail), Offset.zero);
    expect(tester.getSize(rail).width, 400);
    expect(tester.takeException(), isNull);
  });
}
