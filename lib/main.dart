import 'package:flutter/material.dart';

import 'charts/basic/basic_01_line_simple.dart';
import 'charts/basic/basic_02_line_curved.dart';
import 'charts/basic/basic_03_line_area_below.dart';
import 'charts/basic/basic_04_line_area_above.dart';
import 'charts/basic/basic_05_line_gradient.dart';
import 'charts/basic/basic_06_line_dots.dart';
import 'charts/basic/basic_07_line_dot_shapes.dart';
import 'charts/basic/basic_08_line_dashed.dart';
import 'charts/basic/basic_09_line_width.dart';
import 'charts/basic/basic_10_line_two_series.dart';
import 'charts/basic/basic_11_line_step.dart';
import 'charts/basic/basic_12_line_shadow.dart';
import 'charts/basic/basic_13_line_round_caps.dart';
import 'charts/basic/basic_14_line_no_grid.dart';
import 'charts/basic/basic_15_line_axis_titles.dart';
import 'charts/basic/basic_16_bar_simple.dart';
import 'charts/basic/basic_17_bar_grouped.dart';
import 'charts/basic/basic_18_bar_stacked.dart';
import 'charts/basic/basic_19_bar_horizontal.dart';
import 'charts/basic/basic_20_bar_rounded.dart';
import 'charts/basic/basic_21_bar_background.dart';
import 'charts/basic/basic_22_bar_gradient.dart';
import 'charts/basic/basic_23_bar_labels.dart';
import 'charts/basic/basic_24_bar_alignment.dart';
import 'charts/basic/basic_25_bar_dashed_border.dart';
import 'charts/basic/basic_26_pie_simple.dart';
import 'charts/basic/basic_27_pie_donut.dart';
import 'charts/basic/basic_28_pie_sections_space.dart';
import 'charts/basic/basic_29_pie_rounded.dart';
import 'charts/basic/basic_30_pie_start_offset.dart';
import 'charts/basic/basic_31_pie_variable_radius.dart';
import 'charts/basic/basic_32_pie_sunbeam_titles.dart';
import 'charts/basic/basic_33_pie_borders.dart';
import 'charts/basic/basic_34_pie_no_titles.dart';
import 'charts/basic/basic_35_scatter_basic.dart';
import 'charts/basic/basic_36_scatter_shapes.dart';
import 'charts/basic/basic_37_scatter_axis.dart';
import 'charts/basic/basic_38_radar_circle.dart';
import 'charts/basic/basic_39_radar_polygon.dart';
import 'charts/basic/basic_40_radar_ticks.dart';
import 'charts/basic/basic_41_radar_two_series.dart';
import 'charts/basic/basic_42_candle_basic.dart';
import 'charts/basic/basic_43_candle_axis.dart';
import 'charts/advanced/advanced_01_line_between_bars.dart';
import 'charts/advanced/advanced_02_line_horizontal_line.dart';
import 'charts/advanced/advanced_03_line_vertical_line.dart';
import 'charts/advanced/advanced_04_line_h_range.dart';
import 'charts/advanced/advanced_05_line_v_range.dart';
import 'charts/advanced/advanced_06_line_indicators.dart';
import 'charts/advanced/advanced_07_line_fixed_tooltip.dart';
import 'charts/advanced/advanced_08_line_custom_tooltip.dart';
import 'charts/advanced/advanced_09_line_touch_indicator.dart';
import 'charts/advanced/advanced_10_line_cutoff.dart';
import 'charts/advanced/advanced_11_line_error_bars.dart';
import 'charts/advanced/advanced_12_line_highlight_dots.dart';
import 'charts/advanced/advanced_13_line_grid_callback.dart';
import 'charts/advanced/advanced_14_bar_error_range.dart';
import 'charts/advanced/advanced_15_bar_stack_labels.dart';
import 'charts/advanced/advanced_16_bar_stack_tooltip.dart';
import 'charts/advanced/advanced_17_bar_negative.dart';
import 'charts/advanced/advanced_18_bar_rotated_label.dart';
import 'charts/advanced/advanced_19_bar_fixed_tooltip.dart';
import 'charts/advanced/advanced_20_bar_touch_selection.dart';
import 'charts/advanced/advanced_21_bar_axis_widgets.dart';
import 'charts/advanced/advanced_22_bar_animated.dart';
import 'charts/advanced/advanced_23_pie_touch_grow.dart';
import 'charts/advanced/advanced_24_pie_gradient.dart';
import 'charts/advanced/advanced_25_pie_badge.dart';
import 'charts/advanced/advanced_26_scatter_error_bars.dart';
import 'charts/advanced/advanced_27_scatter_fixed_tooltip.dart';
import 'charts/advanced/advanced_28_scatter_labels.dart';
import 'charts/advanced/advanced_29_scatter_touch_priority.dart';
import 'charts/advanced/advanced_30_radar_multi_dataset.dart';
import 'charts/advanced/advanced_31_radar_gradient.dart';
import 'charts/advanced/advanced_32_radar_touch_highlight.dart';
import 'charts/advanced/advanced_33_radar_custom_title.dart';
import 'charts/advanced/advanced_34_candlestick_custom_tooltip.dart';
import 'charts/advanced/advanced_35_candlestick_point_indicator.dart';
import 'charts/advanced/advanced_36_candle_range_annotation.dart';

void main() {
  runApp(const FlChartTallerApp());
}

class FlChartTallerApp extends StatelessWidget {
  const FlChartTallerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FL Chart Taller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final List<(String, WidgetBuilder)> basicCharts = [
    ('Línea simple', (_) => const Basic01LineSimple()),
    ('Línea curva', (_) => const Basic02LineCurved()),
    ('Línea con área debajo', (_) => const Basic03LineAreaBelow()),
    ('Línea con área encima', (_) => const Basic04LineAreaAbove()),
    ('Línea con degradado', (_) => const Basic05LineGradient()),
    ('Línea con puntos', (_) => const Basic06LineDots()),
    ('Línea con formas de punto', (_) => const Basic07LineDotShapes()),
    ('Línea discontinua', (_) => const Basic08LineDashed()),
    ('Línea con grosor variable', (_) => const Basic09LineWidth()),
    ('Línea con dos series', (_) => const Basic10LineTwoSeries()),
    ('Línea escalonada', (_) => const Basic11LineStep()),
    ('Línea con sombra', (_) => const Basic12LineShadow()),
    ('Línea con extremos redondeados', (_) => const Basic13LineRoundCaps()),
    ('Línea sin rejilla', (_) => const Basic14LineNoGrid()),
    ('Línea con títulos de eje', (_) => const Basic15LineAxisTitles()),
    ('Barras simples', (_) => const Basic16BarSimple()),
    ('Barras agrupadas', (_) => const Basic17BarGrouped()),
    ('Barras apiladas', (_) => const Basic18BarStacked()),
    ('Barras horizontales', (_) => const Basic19BarHorizontal()),
    ('Barras con esquinas redondeadas', (_) => const Basic20BarRounded()),
    ('Barras con barra de fondo', (_) => const Basic21BarBackground()),
    ('Barras con degradado', (_) => const Basic22BarGradient()),
    ('Barras con etiquetas', (_) => const Basic23BarLabels()),
    ('Barras con alineación espaciada', (_) => const Basic24BarAlignment()),
    ('Barras con borde punteado', (_) => const Basic25BarDashedBorder()),
    ('Pastel simple', (_) => const Basic26PieSimple()),
    ('Dona (centerSpaceRadius)', (_) => const Basic27PieDonut()),
    ('Pastel con separación entre secciones', (_) => const Basic28PieSectionsSpace()),
    ('Pastel con esquinas redondeadas', (_) => const Basic29PieRounded()),
    ('Pastel con inicio rotado (45°)', (_) => const Basic30PieStartOffset()),
    ('Pastel con radios variables', (_) => const Basic31PieVariableRadius()),
    ('Pastel con títulos rotados', (_) => const Basic32PieSunbeamTitles()),
    ('Pastel con bordes', (_) => const Basic33PieBorders()),
    ('Pastel sin títulos', (_) => const Basic34PieNoTitles()),
    ('Dispersión simple', (_) => const Basic35ScatterBasic()),
    ('Dispersión con formas', (_) => const Basic36ScatterShapes()),
    ('Dispersión con ejes personalizados', (_) => const Basic37ScatterAxis()),
    ('Radar circular', (_) => const Basic38RadarCircle()),
    ('Radar poligonal', (_) => const Basic39RadarPolygon()),
    ('Radar con rejilla y marcas', (_) => const Basic40RadarTicks()),
    ('Radar con dos series', (_) => const Basic41RadarTwoSeries()),
    ('Velas (candlestick) básico', (_) => const Basic42CandleBasic()),
    ('Velas con ejes personalizados', (_) => const Basic43CandleAxis()),
  ];

  static final List<(String, WidgetBuilder)> advancedCharts = [
    ('Línea con bandas entre series', (_) => const Advanced01LineBetweenBars()),
    ('Línea con línea horizontal', (_) => const Advanced02LineHorizontalLine()),
    ('Línea con línea vertical', (_) => const Advanced03LineVerticalLine()),
    ('Línea con rango horizontal', (_) => const Advanced04LineHRange()),
    ('Línea con rango vertical', (_) => const Advanced05LineVRange()),
    ('Línea con indicadores de puntos', (_) => const Advanced06LineIndicators()),
    ('Línea con dos tooltips fijos', (_) => const Advanced07LineFixedTooltip()),
    ('Línea con tooltip personalizado', (_) => const Advanced08LineCustomTooltip()),
    ('Línea con indicador táctil', (_) => const Advanced09LineTouchIndicator()),
    ('Línea con área de corte', (_) => const Advanced10LineCutoff()),
    ('Línea con barras de error', (_) => const Advanced11LineErrorBars()),
    ('Línea con puntos resaltados', (_) => const Advanced12LineHighlightDots()),
    ('Línea con rejilla personalizada', (_) => const Advanced13LineGridCallback()),
    ('Barras con rango de error', (_) => const Advanced14BarErrorRange()),
    ('Barras apiladas con etiquetas', (_) => const Advanced15BarStackLabels()),
    ('Tooltip sobre segmento apilado', (_) => const Advanced16BarStackTooltip()),
    ('Barras con valores negativos', (_) => const Advanced17BarNegative()),
    ('Etiqueta rotada en la barra', (_) => const Advanced18BarRotatedLabel()),
    ('Tooltip fijo con contenido propio', (_) => const Advanced19BarFixedTooltip()),
    ('Selección de barra al tocar', (_) => const Advanced20BarTouchSelection()),
    ('Títulos de eje con widgets', (_) => const Advanced21BarAxisWidgets()),
    ('Barras con animación de datos', (_) => const Advanced22BarAnimated()),
    ('Sección que crece al tocar', (_) => const Advanced23PieTouchGrow()),
    ('Pastel con degradados', (_) => const Advanced24PieGradient()),
    ('Pastel con insignias (badges)', (_) => const Advanced25PieBadge()),
    ('Dispersión con barras de error', (_) => const Advanced26ScatterErrorBars()),
    ('Tooltip manual en dispersión', (_) => const Advanced27ScatterFixedTooltip()),
    ('Etiquetas en dispersión', (_) => const Advanced28ScatterLabels()),
    ('Prioridad de punto y toque', (_) => const Advanced29ScatterTouchPriority()),
    ('Radar con múltiples series', (_) => const Advanced30RadarMultiDataset()),
    ('Radar con relleno degradado', (_) => const Advanced31RadarGradient()),
    ('Radar con punto tocado', (_) => const Advanced32RadarTouchHighlight()),
    ('Radar con títulos personalizados', (_) => const Advanced33RadarCustomTitle()),
    ('Velas con tooltip personalizado', (_) => const Advanced34CandlestickCustomTooltip()),
    ('Indicador de punto personalizado', (_) => const Advanced35CandlestickPointIndicator()),
    ('Velas con anotaciones de rango', (_) => const Advanced36CandlestickRangeAnnotation()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FL Chart — Taller'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const _SectionHeader(
            title: 'Básicas (43)',
            subtitle: 'Líneas, barras, pastel, dispersión, radar y velas',
          ),
          for (var i = 0; i < basicCharts.length; i++)
            ListTile(
              leading: CircleAvatar(
                radius: 16,
                child: Text(
                  '${i + 1}'.padLeft(2, '0'),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              title: Text(basicCharts[i].$1),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: basicCharts[i].$2,
                  ),
                );
              },
            ),
          const _SectionHeader(
            title: 'Avanzadas (36)',
            subtitle: 'Líneas, barras, pastel, dispersión, radar y velas con interacción',
          ),
          for (var i = 0; i < advancedCharts.length; i++)
            ListTile(
              leading: CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  '${i + 1}'.padLeft(2, '0'),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              title: Text(advancedCharts[i].$1),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: advancedCharts[i].$2,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
