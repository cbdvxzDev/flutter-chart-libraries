import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Verifica que ninguna demo repita datos, etiquetas ni estructura con otra.
///
/// Reglas:
/// 1. Ningún conjunto de etiquetas (arrays de strings) se repite entre archivos,
///    salvo el presupuesto permitido de ['Ene','Feb','Mar','Abr','May','Jun'].
/// 2. Ninguna secuencia de valores se repite entre archivos.
/// 3. Numeración única: basic_01..43 y advanced_01..36 sin huecos ni repetidos.
/// 4. main.dart no repite widgets ni títulos de la lista.
/// 5. Ningún color (distinto de neutros) aparece en más de 25 archivos.
void main() {
  final files = Directory('lib/charts')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  String norm(String s) => s.replaceAll(RegExp(r'\s+'), '');

  String name(File f) => f.uri.pathSegments.last;

  List<String> labelArrays(String content, String file) =>
      RegExp(r"\w+\s*=\s*\[\s*'[^']+'(?:\s*,\s*'[^']+')+\s*\]")
          .allMatches(content)
          .map((m) => '$file|${norm(m.group(0)!)}')
          .toList();

  List<String> valueSequences(String content) {
    final seqs = <String>[];
    for (final m
        in RegExp(r'List<double>\s*\w*\s*=\s*\[[^\]]+\]').allMatches(content)) {
      seqs.add('V:${norm(m.group(0)!)}');
    }
    final radar = RegExp(r'RadarEntry\(value:\s*([\d.]+)\)')
        .allMatches(content)
        .map((m) => m.group(1)!)
        .join(',');
    if (radar.split(',').length >= 4) {
      seqs.add('R:${norm(radar)}');
    }
    final pie = RegExp(r'value:\s*([\d.]+)')
        .allMatches(content)
        .map((m) => m.group(1)!)
        .join(',');
    if (pie.split(',').length >= 4) {
      seqs.add('P:${norm(pie)}');
    }
    final open = RegExp(r'open:\s*([\d.]+)')
        .allMatches(content)
        .map((m) => m.group(1)!)
        .join(',');
    if (open.split(',').length >= 4) {
      seqs.add('O:${norm(open)}');
    }
    final spot = RegExp(r'FlSpot\(([^)]+)\)')
        .allMatches(content)
        .map((m) => norm(m.group(1)!))
        .join(',');
    if (spot.split(',').length >= 8) {
      seqs.add('S:$spot');
    }
    return seqs;
  }

  test('ningún conjunto de etiquetas se repite entre demos', () {
    final seen = <String, String>{};
    final failures = <String>[];
    final budget = norm("['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun']");
    var budgetUses = 0;

    for (final f in files) {
      final content = f.readAsStringSync();
      for (final entry in labelArrays(content, name(f))) {
        final key = entry.substring(entry.indexOf('|') + 1);
        if (key.endsWith(budget)) {
          budgetUses++;
          continue;
        }
        final other = seen[key];
        if (other != null && other != name(f)) {
          failures.add('${name(f)} repite etiquetas de $other: $key');
        } else {
          seen[key] = name(f);
        }
      }
    }

    expect(failures, isEmpty, reason: failures.join('\n'));
    expect(
      budgetUses,
      lessThanOrEqualTo(8),
      reason: "['Ene'..'Jun'] se usa en $budgetUses archivos (máximo 8)",
    );
  });

  test('ninguna secuencia de valores se repite entre demos', () {
    final seen = <String, String>{};
    final failures = <String>[];

    for (final f in files) {
      for (final seq in valueSequences(f.readAsStringSync())) {
        final other = seen[seq];
        if (other != null && other != name(f)) {
          failures.add('${name(f)} repite valores de $other: $seq');
        } else {
          seen[seq] = name(f);
        }
      }
    }

    expect(failures, isEmpty, reason: failures.join('\n'));
  });

  test('numeración única y sin huecos (basic 01-43, advanced 01-36)', () {
    final basic = <int>[];
    final advanced = <int>[];
    for (final f in files) {
      final n = name(f);
      final b = RegExp(r'^basic_(\d+)_').firstMatch(n);
      final a = RegExp(r'^advanced_(\d+)_').firstMatch(n);
      if (b != null) basic.add(int.parse(b.group(1)!));
      if (a != null) advanced.add(int.parse(a.group(1)!));
    }

    basic.sort();
    advanced.sort();

    expect(basic.length, 43, reason: 'Deben existir 43 demos básicas');
    expect(advanced.length, 36, reason: 'Deben existir 36 demos avanzadas');
    expect(basic.toSet().length, basic.length, reason: 'Número repetido en basic');
    expect(
      advanced.toSet().length,
      advanced.length,
      reason: 'Número repetido en advanced',
    );
    expect(basic, List<int>.generate(43, (i) => i + 1),
        reason: 'Huecos en la numeración de basic');
    expect(advanced, List<int>.generate(36, (i) => i + 1),
        reason: 'Huecos en la numeración de advanced');
  });

  test('main.dart no repite widgets ni títulos', () {
    final content = File('lib/main.dart').readAsStringSync();

    final widgets = RegExp(r'const (?:Basic|Advanced)\w+\(\)')
        .allMatches(content)
        .map((m) => m.group(0)!)
        .toList();
    expect(widgets.toSet().length, widgets.length,
        reason: 'Widget repetido en las listas de main.dart');

    final titles = RegExp(r"\('([^']+)'\s*,\s*\(_\)\s*=>")
        .allMatches(content)
        .map((m) => m.group(1)!)
        .toList();
    expect(titles.toSet().length, titles.length,
        reason: 'Título repetido en las listas de main.dart');
    expect(titles.length, 79, reason: 'Deben listarse 79 demos en main.dart');
  });

  test('ningún color aparece en más de 25 demos', () {
    const neutrals = {
      'grey',
      'black',
      'white',
      'transparent',
      'black12',
      'black26',
      'black38',
      'black45',
      'black54',
      'black87',
      'white10',
      'white24',
      'white30',
      'white38',
      'white54',
      'white60',
      'white70',
    };
    final usedIn = <String, Set<String>>{};

    for (final f in files) {
      final content = f.readAsStringSync();
      for (final m in RegExp(r'Colors\.(\w+)').allMatches(content)) {
        final color = m.group(1)!;
        if (neutrals.contains(color)) continue;
        usedIn.putIfAbsent(color, () => <String>{}).add(name(f));
      }
    }

    final repeated = usedIn.entries
        .where((e) => e.value.length > 25)
        .map((e) => '${e.key}: ${e.value.length} archivos')
        .toList();
    expect(repeated, isEmpty, reason: 'Colores sobreusados:\n${repeated.join('\n')}');
  });
}
