import 'package:flutter/widgets.dart';

import 'gallery_meta.dart';

/// Una gráfica dentro de la galería unificada, sin importar su librería.
class GalleryEntry {
  const GalleryEntry({
    required this.number,
    required this.title,
    required this.category,
    required this.glyph,
    required this.open,
  });

  /// Posición en la lista original de su librería (empieza en 1).
  final int number;

  /// Título tal como está escrito en la lista de la librería.
  final String title;

  /// Texto del filtro de categorías.
  final String category;

  /// Miniatura que se dibuja en la tarjeta.
  final ChartGlyph glyph;

  /// Crea la página que se abre al pulsar la tarjeta.
  final WidgetBuilder open;

  /// Título para mostrar, con la primera letra en mayúscula.
  String get displayTitle => capitalizeFirst(title);
}

/// Una librería de gráficas con sus colores y sus dos listas.
class GalleryLibrary {
  const GalleryLibrary({
    required this.name,
    required this.package,
    required this.version,
    required this.description,
    required this.color,
    required this.railColor,
    required this.lightColor,
    required this.basic,
    required this.advanced,
  });

  /// Nombre visible, por ejemplo "FL Chart".
  final String name;

  /// Nombre del paquete de pub.dev, por ejemplo "fl_chart".
  final String package;

  /// Versión del paquete que usa el proyecto.
  final String version;

  /// Descripción de una línea.
  final String description;

  /// Color principal (fichas activas, miniaturas, paquete en el encabezado).
  final Color color;

  /// Color del cuadrado en el riel.
  final Color railColor;

  /// Fondo claro detrás de la miniatura.
  final Color lightColor;

  /// Gráficas básicas, en el orden original.
  final List<GalleryEntry> basic;

  /// Gráficas avanzadas, en el orden original.
  final List<GalleryEntry> advanced;

  /// Paquete y versión juntos, por ejemplo "fl_chart 1.2.0".
  String get packageLabel => '$package $version';

  /// Cantidad total de gráficas de la librería.
  int get total => basic.length + advanced.length;
}

/// Devuelve [text] con la primera letra en mayúscula ("spline" -> "Spline").
String capitalizeFirst(String text) =>
    text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
