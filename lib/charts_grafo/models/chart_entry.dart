import 'package:flutter/widgets.dart';

/// Texto largo de la pantalla de detalle de una gráfica.
class ChartDetail {
  const ChartDetail(this.detail, this.methods, this.difference);

  /// Explicación detallada de lo que presenta la librería.
  final String detail;

  /// Métodos / clases de directed_graph que intervienen.
  final List<String> methods;

  /// Qué la distingue de una gráfica equivalente en otras librerías.
  final String difference;
}

/// Una gráfica del catálogo. Si [builder] es null, aún no está implementada.
class ChartEntry {
  const ChartEntry({
    required this.number,
    required this.group,
    required this.title,
    required this.description,
    this.useCase = '',
    this.detail = '',
    this.methods = const [],
    this.difference = '',
    this.builder,
  });

  final int number;
  final String group;
  final String title;

  /// Descripción corta.
  final String description;

  /// Cómo se puede utilizar en un caso real (se ve en la miniatura).
  final String useCase;

  /// Descripción larga (pantalla de detalle).
  final String detail;
  final List<String> methods;
  final String difference;
  final Widget Function()? builder;

  bool get isReady => builder != null;
}
