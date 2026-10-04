import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fl_chart_taller/charts_gallery.dart' as sync;
import 'package:fl_chart_taller/charts_grafo/avanzadas/catalogo_avanzadas.dart'
    as grafos;
import 'package:fl_chart_taller/charts_grafo/simples/catalogo_simples.dart'
    as grafos;
import 'package:fl_chart_taller/financial_gallery.dart';
import 'package:fl_chart_taller/gallery/gallery_catalog.dart';
import 'package:fl_chart_taller/gallery/gallery_meta.dart';
import 'package:fl_chart_taller/gallery/glyph_painter.dart';
import 'package:fl_chart_taller/main.dart';

void main() {
  test('cada librería tiene 43 básicas y 36 avanzadas, 316 en total', () {
    expect(galleryLibraries, hasLength(4));
    for (final library in galleryLibraries) {
      expect(library.basic, hasLength(43), reason: library.name);
      expect(library.advanced, hasLength(36), reason: library.name);
    }
    expect(galleryTotal, 316);
  });

  test('ninguna entrada queda sin categoría y los números son 1..n', () {
    for (final library in galleryLibraries) {
      for (final list in [library.basic, library.advanced]) {
        for (var i = 0; i < list.length; i++) {
          expect(
            list[i].category.trim(),
            isNotEmpty,
            reason: '${library.name} ${list[i].title}',
          );
          expect(list[i].number, i + 1);
        }
      }
    }
  });

  test('los títulos conservan el orden de las listas originales', () {
    List<String> titles(int library, bool basic) => [
      for (final e
          in basic
              ? galleryLibraries[library].basic
              : galleryLibraries[library].advanced)
        e.title,
    ];

    expect(titles(0, true), [for (final c in HomeScreen.basicCharts) c.$1]);
    expect(titles(0, false), [for (final c in HomeScreen.advancedCharts) c.$1]);
    expect(titles(1, true), [for (final s in sync.basic) s.t]);
    expect(titles(1, false), [for (final s in sync.adv) s.t]);
    expect(titles(2, true), [for (final e in grafos.simpleCharts) e.title]);
    expect(titles(2, false), [for (final e in grafos.advancedCharts) e.title]);
    expect(titles(3, true), [for (final e in financialBasic) e.title]);
    expect(titles(3, false), [for (final e in financialAdvanced) e.title]);
  });

  test('las categorías de Directed Graph coinciden con su campo group', () {
    final directed = galleryLibraries[2];
    for (final (entries, source) in [
      (directed.basic, grafos.simpleCharts),
      (directed.advanced, grafos.advancedCharts),
    ]) {
      for (var i = 0; i < entries.length; i++) {
        expect(entries[i].category, source[i].group);
        expect(source[i].isReady, isTrue, reason: source[i].title);
      }
    }
  });

  testWidgets('las 27 miniaturas se dibujan sin errores', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Wrap(
          children: [
            for (final glyph in ChartGlyph.values)
              CustomPaint(
                size: const Size(150, 80),
                painter: GlyphPainter(glyph: glyph, color: Colors.indigo),
              ),
          ],
        ),
      ),
    );

    expect(ChartGlyph.values, hasLength(27));
    expect(tester.takeException(), isNull);
  });
}
