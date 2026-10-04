import 'package:fl_chart_taller/financial_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('el catálogo tiene 43 básicas y 36 avanzadas, sin títulos repetidos', () {
    expect(financialBasic, hasLength(43));
    expect(financialAdvanced, hasLength(36));
    final titles = [...financialBasic, ...financialAdvanced].map((e) => e.title).toSet();
    expect(titles, hasLength(79));
  });

  final all = <(String, FcEntry)>[
    for (var i = 0; i < financialBasic.length; i++) ('básica ${i + 1}', financialBasic[i]),
    for (var i = 0; i < financialAdvanced.length; i++) ('avanzada ${i + 1}', financialAdvanced[i]),
  ];

  // Abre cada gráfica con datos aleatorios y comprueba que se dibuja sin errores.
  for (final (name, entry) in all) {
    testWidgets('$name · ${entry.title}', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: FinancialChartPage(number: 1, entry: entry)),
      );
      // Primer cuadro, carga de datos y animación del ajuste de escala.
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 260));
      }
      expect(tester.takeException(), isNull);

      // Nuevos datos aleatorios: la gráfica se vuelve a crear desde cero.
      await tester.tap(find.byIcon(Icons.casino_outlined));
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 260));
      }
      expect(tester.takeException(), isNull);

      // Se desmonta y se deja terminar cualquier temporizador pendiente.
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
      expect(tester.takeException(), isNull);
    });
  }
}
