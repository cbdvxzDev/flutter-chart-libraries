import 'package:flutter/material.dart';

/// Colores compartidos por toda la galería unificada.
///
/// Los colores propios de cada librería están en `gallery_catalog.dart`.
abstract final class GalleryColors {
  /// Fondo de la página.
  static const page = Color(0xFFF3F4F6);

  /// Texto principal y fondo del riel.
  static const ink = Color(0xFF161A23);

  /// Texto secundario.
  static const inkSoft = Color(0xFF4A5160);

  /// Borde de las tarjetas.
  static const cardBorder = Color(0xFFD8DBE2);

  /// Borde de los campos y de las fichas.
  static const fieldBorder = Color(0xFFC9CDD6);

  /// Texto sobre el riel.
  static const railText = Color(0xFFF3F4F6);

  /// Texto secundario sobre el riel.
  static const railTextSoft = Color(0xFFB4BAC8);

  /// Fondo del botón de la librería elegida.
  static const railSelected = Color(0xFF2B3142);

  /// Fondo de tarjetas, campos y botones inactivos.
  static const surface = Colors.white;
}

/// Nombres de las familias declaradas en la sección `fonts:` de pubspec.yaml.
abstract final class GalleryFonts {
  /// Títulos.
  static const display = 'SpaceGrotesk';

  /// Texto.
  static const sans = 'IBMPlexSans';

  /// Números y etiquetas.
  static const mono = 'IBMPlexMono';
}

/// Estilos de texto de la galería unificada.
abstract final class GalleryText {
  static const railTitle = TextStyle(
    fontFamily: GalleryFonts.display,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: GalleryColors.railText,
  );

  static const railSubtitle = TextStyle(
    fontFamily: GalleryFonts.mono,
    fontSize: 12,
    color: GalleryColors.railTextSoft,
  );

  static const railName = TextStyle(
    fontFamily: GalleryFonts.sans,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: GalleryColors.railText,
  );

  static const railPackage = TextStyle(
    fontFamily: GalleryFonts.mono,
    fontSize: 11,
    color: GalleryColors.railTextSoft,
  );

  static const railCount = TextStyle(
    fontFamily: GalleryFonts.mono,
    fontSize: 12,
    color: GalleryColors.railText,
  );

  /// Paquete y versión en el encabezado (el color se pone con la librería).
  static const headerPackage = TextStyle(
    fontFamily: GalleryFonts.mono,
    fontSize: 12,
  );

  static const headerTitle = TextStyle(
    fontFamily: GalleryFonts.display,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: GalleryColors.ink,
  );

  static const headerDescription = TextStyle(
    fontFamily: GalleryFonts.sans,
    fontSize: 15,
    color: GalleryColors.inkSoft,
  );

  static const search = TextStyle(
    fontFamily: GalleryFonts.sans,
    fontSize: 14,
    color: GalleryColors.ink,
  );

  static const segment = TextStyle(
    fontFamily: GalleryFonts.sans,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const segmentCount = TextStyle(
    fontFamily: GalleryFonts.mono,
    fontSize: 12,
  );

  static const chip = TextStyle(
    fontFamily: GalleryFonts.sans,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static const cardMeta = TextStyle(
    fontFamily: GalleryFonts.mono,
    fontSize: 12,
    height: 1.3,
    color: GalleryColors.inkSoft,
  );

  static const cardTitle = TextStyle(
    fontFamily: GalleryFonts.sans,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: GalleryColors.ink,
  );

  static const empty = TextStyle(
    fontFamily: GalleryFonts.sans,
    fontSize: 15,
    color: GalleryColors.inkSoft,
  );
}
