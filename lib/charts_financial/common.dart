// Datos aleatorios, estilos y utilidades compartidas por todas las gráficas
// hechas con la librería financial_chart.
import 'dart:math' as math;

import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import 'indicators.dart';

export 'indicators.dart';

// ───────────────────────── Paleta ─────────────────────────
const fcUp = Color(0xFF26A69A);
const fcDown = Color(0xFFEF5350);
const fcBlue = Color(0xFF2962FF);
const fcOrange = Color(0xFFFF9800);
const fcPurple = Color(0xFF8E24AA);
const fcPink = Color(0xFFE91E63);
const fcTeal = Color(0xFF00897B);
const fcAmber = Color(0xFFFFB300);
const fcIndigo = Color(0xFF3949AB);
const fcGrey = Color(0xFF78909C);
const fcInk = Color(0xFF263238);
const fcPaper = Color(0xFFFCFCFC);
const fcNight = Color(0xFF0F0F0F); // fondo de los paneles en el tema oscuro

// Claves de las series base que trae todo conjunto de datos.
const kO = 'o', kH = 'h', kL = 'l', kC = 'c', kV = 'v';
const fcOhlc = <String>[kO, kH, kL, kC];

double _gauss(math.Random r) {
  // Box-Muller: convierte dos números uniformes en uno con distribución normal.
  final u1 = 1 - r.nextDouble();
  final u2 = r.nextDouble();
  return math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2);
}

/// Conjunto de datos de una gráfica: tiempos + series con nombre.
///
/// El constructor normal inventa un activo con un paseo aleatorio (apertura,
/// máximo, mínimo, cierre y volumen). Cada vez que se crea salen datos nuevos.
class FcData {
  FcData({
    int n = 260,
    int? seed,
    double start = 100,
    double vol = 0.018,
    double drift = 0.0005,
  }) : rnd = math.Random(seed) {
    var day = DateTime(2025, 1, 2);
    var prev = start;
    final o = <double>[], h = <double>[], l = <double>[], c = <double>[], v = <double>[];
    for (var i = 0; i < n; i++) {
      while (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday) {
        day = day.add(const Duration(days: 1));
      }
      t.add(day.millisecondsSinceEpoch);
      day = day.add(const Duration(days: 1));
      final open = prev * (1 + _gauss(rnd) * vol * 0.25);
      final close = open * (1 + drift + _gauss(rnd) * vol);
      final high = math.max(open, close) * (1 + _gauss(rnd).abs() * vol * 0.5);
      final low = math.min(open, close) * (1 - _gauss(rnd).abs() * vol * 0.5);
      final ret = (close / prev - 1).abs();
      o.add(open);
      h.add(high);
      l.add(low);
      c.add(close);
      v.add(1e6 * math.exp(_gauss(rnd) * 0.35) * (1 + 14 * ret));
      prev = close;
    }
    add(kO, o, label: 'Apertura');
    add(kH, h, label: 'Máximo');
    add(kL, l, label: 'Mínimo');
    add(kC, c, label: 'Cierre');
    add(kV, v, label: 'Volumen', precision: 0);
  }

  /// Conjunto de datos armado a mano (por ejemplo los ladrillos Renko).
  FcData.raw(List<int> times, {int? seed}) : rnd = math.Random(seed) {
    t.addAll(times);
  }

  final math.Random rnd;
  final List<int> t = [];
  final Map<String, List<double>> _series = {};
  final Map<String, String> _labels = {};
  final Map<String, int> _precision = {};

  int get n => t.length;
  int get last => n - 1;
  List<double> get o => _series[kO]!;
  List<double> get h => _series[kH]!;
  List<double> get l => _series[kL]!;
  List<double> get c => _series[kC]!;
  List<double> get v => _series[kV]!;

  List<double> operator [](String key) => _series[key]!;

  /// Agrega (o reemplaza) una serie, por ejemplo un indicador ya calculado.
  void add(String key, List<double> values, {String? label, int precision = 2}) {
    assert(values.length == n, 'La serie "$key" tiene ${values.length} valores y se esperaban $n');
    _series[key] = values;
    _labels[key] = label ?? key;
    _precision[key] = precision;
  }

  /// Otro paseo aleatorio con las mismas fechas (un segundo activo o un índice).
  List<double> walk({double start = 100, double vol = 0.012, double drift = 0.0004}) {
    final out = <double>[];
    var p = start;
    for (var i = 0; i < n; i++) {
      p = p * (1 + drift + _gauss(rnd) * vol);
      out.add(p);
    }
    return out;
  }

  /// Trayectoria simulada que arranca en el cierre de la barra [from]. Antes
  /// de esa barra no hay dato (NaN).
  List<double> simulate(int from, {double vol = 0.018, double drift = 0.0005}) {
    final out = nanList(n);
    var p = c[from];
    out[from] = p;
    for (var i = from + 1; i < n; i++) {
      p = p * (1 + drift + _gauss(rnd) * vol);
      out[i] = p;
    }
    return out;
  }

  /// Índice de la barra con el máximo más alto entre [from] y [to].
  int highestIndex([int from = 0, int? to]) {
    var best = from;
    for (var i = from; i <= (to ?? last); i++) {
      if (h[i] > h[best]) best = i;
    }
    return best;
  }

  /// Índice de la barra con el mínimo más bajo entre [from] y [to].
  int lowestIndex([int from = 0, int? to]) {
    var best = from;
    for (var i = from; i <= (to ?? last); i++) {
      if (l[i] < l[best]) best = i;
    }
    return best;
  }

  /// Fuente de datos que entiende financial_chart: una fila por barra.
  GDataSource<int, GData<int>> source() {
    final keys = _series.keys.toList();
    return GDataSource<int, GData<int>>(
      dataList: List.generate(
        n,
        (i) => GData<int>(pointValue: t[i], seriesValues: [for (final k in keys) _series[k]![i]]),
      ),
      seriesProperties: [
        for (final k in keys)
          GDataSeriesProperty(key: k, label: _labels[k] ?? k, precision: _precision[k] ?? 2),
      ],
    );
  }
}

// ───────────────────────── Estilos ─────────────────────────

/// Resalte que financial_chart dibuja sobre una serie al pasar el cursor.
GGraphHighlightMarkerTheme get _highlight => GThemeLight.graphHighlightMarkThemeDefault;

GTheme fcTheme({bool dark = false}) => dark ? GThemeDark() : GThemeLight();

/// Tema de los marcadores (líneas, formas y textos dibujados sobre la gráfica).
GOverlayMarkerTheme fcMk({
  Color? fill,
  Color? stroke,
  double w = 1.5,
  List<double>? dash,
  Color text = fcInk,
  double size = 11,
  Color? labelBg,
  Color? labelBorder,
  FontWeight weight = FontWeight.w500,
}) {
  return GThemeLight.overlayMarkerThemeDefault.copyWith(
    markerStyle: PaintStyle(
      fillColor: fill,
      strokeColor: stroke,
      strokeWidth: stroke == null ? null : w,
      dash: dash,
    ),
    labelStyle: LabelStyle(
      textStyle: TextStyle(color: text, fontSize: size, fontWeight: weight),
      backgroundStyle: PaintStyle(
        fillColor: labelBg,
        strokeColor: labelBorder,
        strokeWidth: labelBorder == null ? null : 1,
      ),
      backgroundPadding: const EdgeInsets.all(4),
      backgroundCornerRadius: 4,
    ),
  );
}

// ───────────────────────── Series (graphs) ─────────────────────────

/// Línea. Con `stroke: false` y `dot > 0` solo se ven los puntos.
GGraphLine fcLine(
  String key,
  Color color, {
  double w = 1.5,
  double dot = 0,
  bool stroke = true,
  bool smooth = false,
  String vp = '',
  String? id,
  bool visible = true,
  List<String>? crosshairKeys,
  List<GOverlayMarker> markers = const [],
}) {
  return GGraphLine(
    id: id,
    valueKey: key,
    valueViewPortId: vp,
    smoothing: smooth,
    visible: visible,
    crosshairHighlightValueKeys: crosshairKeys,
    overlayMarkers: markers,
    theme: GGraphLineTheme(
      lineStyle: stroke ? PaintStyle(strokeColor: color, strokeWidth: w) : PaintStyle(),
      pointRadius: dot,
      pointStyle: PaintStyle(fillColor: color),
      highlightMarkerTheme: _highlight,
    ),
  );
}

/// Área. Con [baseKey] se rellena el espacio entre dos series; con [base] se
/// rellena hasta ese valor; sin ninguno, hasta el borde inferior.
/// [below] es el color cuando la serie queda por debajo de la base.
GGraphArea fcArea(
  String key,
  Color color, {
  String? baseKey,
  double? base,
  Color? below,
  double alpha = 0.22,
  double w = 1.2,
  bool border = true,
  String vp = '',
  String? id,
  bool visible = true,
  List<GOverlayMarker> markers = const [],
}) {
  PaintStyle style(Color c) => PaintStyle(
        fillColor: c.withValues(alpha: alpha),
        strokeColor: border ? c : null,
        strokeWidth: border ? w : null,
      );
  return GGraphArea(
    id: id,
    valueKey: key,
    baseValueKey: baseKey,
    baseValue: baseKey != null ? null : base,
    valueViewPortId: vp,
    visible: visible,
    overlayMarkers: markers,
    theme: GGraphAreaTheme(
      styleAboveBase: style(color),
      styleBelowBase: style(below ?? color),
      highlightMarkerTheme: _highlight,
    ),
  );
}

/// Barras. [base] es el valor desde el que crecen; lo que queda por debajo usa
/// el color [down].
GGraphBar fcBars(
  String key, {
  Color up = fcUp,
  Color? down,
  double? base,
  double ratio = 0.7,
  String vp = '',
  String? id,
  bool visible = true,
  List<GOverlayMarker> markers = const [],
}) {
  return GGraphBar(
    id: id,
    valueKey: key,
    baseValue: base,
    valueViewPortId: vp,
    visible: visible,
    overlayMarkers: markers,
    theme: GGraphBarTheme(
      barStyleAboveBase: PaintStyle(fillColor: up),
      barStyleBelowBase: PaintStyle(fillColor: down ?? up),
      barWidthRatio: ratio,
      highlightMarkerTheme: _highlight,
    ),
  );
}

/// Barras apiladas. Las series deben venir ya acumuladas (cada una incluye a
/// la anterior). Con `base: null` la primera serie hace de suelo y el resultado
/// son barras flotantes.
GGraphStackedBar fcStack(
  List<String> keys,
  List<Color> colors, {
  double? base = 0,
  double ratio = 0.7,
  String vp = '',
  String? id,
}) {
  assert(colors.length >= keys.length);
  return GGraphStackedBar(
    id: id,
    valueKeys: keys,
    baseValue: base,
    valueViewPortId: vp,
    theme: GGraphStackedBarTheme(
      barStyles: [for (final c in colors) PaintStyle(fillColor: c)],
      barWidthRatio: ratio,
      highlightMarkerTheme: _highlight,
    ),
  );
}

/// Velas japonesas (o barras OHLC con `candle: false`).
/// [hollow] deja las velas alcistas sin relleno.
GGraphOhlc fcCandles({
  List<String> keys = fcOhlc,
  bool candle = true,
  Color up = fcUp,
  Color down = fcDown,
  bool hollow = false,
  Color paper = fcPaper,
  double ratio = 0.7,
  String vp = '',
  String? id,
  bool visible = true,
  List<String>? crosshairKeys,
  List<GOverlayMarker> markers = const [],
}) {
  return GGraphOhlc(
    id: id,
    ohlcValueKeys: keys,
    drawAsCandle: candle,
    valueViewPortId: vp,
    visible: visible,
    crosshairHighlightValueKeys: crosshairKeys,
    overlayMarkers: markers,
    theme: GGraphOhlcTheme(
      barStylePlus: PaintStyle(fillColor: hollow ? paper : up, strokeColor: up, strokeWidth: 1),
      barStyleMinus: PaintStyle(fillColor: down, strokeColor: down, strokeWidth: 1),
      barWidthRatio: ratio,
      highlightMarkerTheme: _highlight,
    ),
  );
}

// ───────────────────────── Coordenadas ─────────────────────────

/// Coordenada "de datos": barra número [point] y [value] en el eje de precios.
GViewPortCoord at(num point, double value) =>
    GViewPortCoord(point: point.toDouble(), value: value);

/// x como fracción del ancho (0 izquierda, 1 derecha), y como valor del eje.
GCustomCoord atValue(double x, double value) => GCustomCoord(
      x: x,
      y: value,
      coordinateConvertor: kCoordinateConvertorXPositionYValue,
      coordinateConvertorReverse: kCoordinateConvertorXPositionYValueReverse,
    );

/// x como número de barra, y como fracción del alto (0 arriba, 1 abajo).
GCustomCoord atPoint(num point, double y) => GCustomCoord(
      x: point.toDouble(),
      y: y,
      coordinateConvertor: kCoordinateConvertorXPointYPosition,
      coordinateConvertorReverse: kCoordinateConvertorXPointYPositionReverse,
    );

/// Posición fija en la pantalla, como fracción del área de la gráfica.
GPositionCoord atScreen(double x, double y) => GPositionCoord.rational(x: x, y: y);

// ───────────────────────── Marcadores ─────────────────────────
//
// Los marcadores de adorno llevan `hitTestMode: GHitTestMode.none` para que no
// reaccionen al cursor (si no, la librería les dibuja tiradores de edición).

/// Línea horizontal de lado a lado en [value].
GPolyLineMarker fcHLine(double value, Color color, {double w = 1, List<double>? dash}) =>
    GPolyLineMarker(
      hitTestMode: GHitTestMode.none,
      coordinates: [atValue(0, value), atValue(1, value)],
      theme: fcMk(stroke: color, w: w, dash: dash),
    );

/// Línea vertical de arriba abajo en la barra [point].
GPolyLineMarker fcVLine(num point, Color color, {double w = 1, List<double>? dash}) =>
    GPolyLineMarker(
      hitTestMode: GHitTestMode.none,
      coordinates: [atPoint(point, 0), atPoint(point, 1)],
      theme: fcMk(stroke: color, w: w, dash: dash),
    );

/// Franja horizontal entre dos valores.
GRectMarker fcHBand(double from, double to, Color color, {double alpha = 0.12}) => GRectMarker(
      hitTestMode: GHitTestMode.none,
      startCoord: atValue(0, from),
      endCoord: atValue(1, to),
      theme: fcMk(fill: color.withValues(alpha: alpha)),
    );

/// Franja vertical entre dos barras.
GRectMarker fcVBand(num from, num to, Color color, {double alpha = 0.12}) => GRectMarker(
      hitTestMode: GHitTestMode.none,
      startCoord: atPoint(from, 0),
      endCoord: atPoint(to, 1),
      theme: fcMk(fill: color.withValues(alpha: alpha)),
    );

/// Línea quebrada que une varias coordenadas.
GPolyLineMarker fcPath(List<GCoordinate> points, Color color, {double w = 1.5, List<double>? dash}) =>
    GPolyLineMarker(
      hitTestMode: GHitTestMode.none,
      coordinates: points,
      theme: fcMk(stroke: color, w: w, dash: dash),
    );

/// Texto suelto. [align] indica hacia qué lado del punto queda el texto.
GLabelMarker fcLabel(
  String text,
  GCoordinate where, {
  Alignment align = Alignment.center,
  Color color = fcInk,
  double size = 11,
  Color? bg,
  Color? border,
  FontWeight weight = FontWeight.w500,
}) =>
    GLabelMarker(
      hitTestMode: GHitTestMode.none,
      text: text,
      anchorCoord: where,
      alignment: align,
      theme: fcMk(text: color, size: size, labelBg: bg, labelBorder: border, weight: weight),
    );

/// Globo de texto con una punta que señala el punto.
GCalloutMarker fcCallout(
  String text,
  GCoordinate where, {
  Alignment align = Alignment.topCenter,
  Color color = fcInk,
  Color bg = Colors.white,
  Color? border,
  double size = 11,
}) =>
    GCalloutMarker(
      hitTestMode: GHitTestMode.none,
      text: text,
      anchorCoord: where,
      alignment: align,
      theme: fcMk(text: color, size: size, labelBg: bg, labelBorder: border ?? color),
    );

/// Forma (círculo por defecto). [align] la separa del punto en esa dirección.
GShapeMarker fcShape(
  GCoordinate where,
  Color color, {
  double r = 6,
  Path Function(double radius) shape = GShapes.circle,
  double rotation = 0,
  Alignment align = Alignment.center,
  Color? stroke,
}) =>
    GShapeMarker(
      hitTestMode: GHitTestMode.none,
      anchorCoord: where,
      radiusSize: GSize.viewSize(r),
      rotation: rotation,
      alignment: align,
      pathGenerator: shape,
      theme: fcMk(fill: color, stroke: stroke, w: 1),
    );

/// Leyenda: una etiqueta de color por serie, apilada arriba a la izquierda.
List<GOverlayMarker> fcLegend(Map<String, Color> items) {
  var row = 0;
  return [
    for (final e in items.entries)
      fcLabel(
        '● ${e.key}',
        GPositionCoord.absolute(x: 8, y: 8.0 + 16 * row++),
        align: Alignment.bottomRight,
        color: e.value,
        weight: FontWeight.w700,
      ),
  ];
}

Path _triangle(double r) => GShapes.polygon(r, vertexCount: 3);

/// Triángulo hacia arriba debajo de la barra (señal de compra).
GShapeMarker fcBuy(num point, double low, {Color color = fcUp, double r = 7}) => fcShape(
      at(point, low),
      color,
      r: r,
      shape: _triangle,
      rotation: 3 * math.pi / 2,
      align: Alignment.bottomCenter,
    );

/// Triángulo hacia abajo encima de la barra (señal de venta).
GShapeMarker fcSell(num point, double high, {Color color = fcDown, double r = 7}) => fcShape(
      at(point, high),
      color,
      r: r,
      shape: _triangle,
      rotation: math.pi / 2,
      align: Alignment.topCenter,
    );

/// Flecha entre dos coordenadas.
GArrowLineMarker fcArrow(
  GCoordinate from,
  GCoordinate to,
  Color color, {
  double w = 1.5,
  GArrowHeadType head = GArrowHeadType.triangle,
  GArrowHeadType tail = GArrowHeadType.none,
}) =>
    GArrowLineMarker(
      hitTestMode: GHitTestMode.none,
      startCoord: from,
      endCoord: to,
      startHead: GArrowHead(type: tail),
      endHead: GArrowHead(type: head),
      theme: fcMk(stroke: color, fill: color, w: w),
    );

// ───────────────────────── Paneles y gráfica ─────────────────────────

/// Recuadro con valores que aparece al pasar el cursor.
GTooltip fcTip(
  List<String> keys, {
  String? follow,
  GTooltipPosition position = GTooltipPosition.followPointer,
  GToolTipWidgetBuilder? builder,
}) =>
    GTooltip(
      position: position,
      dataKeys: keys,
      followValueKey: follow,
      followValueViewPortId: follow == null ? null : '',
      tooltipWidgetBuilder: builder,
    );

/// Un panel: su escala vertical, sus ejes y sus series.
///
/// [scale] son las series que deciden el rango automático del eje. Con [min] y
/// [max] se fija el rango (por ejemplo 0 a 100 en un RSI).
GPanel fcPanel({
  required List<String> scale,
  required List<GGraph> graphs,
  double weight = 1,
  int precision = 2,
  bool grid = true,
  bool timeAxis = true,
  double? min,
  double? max,
  double marginTop = 0.08,
  double marginBottom = 0.08,
  GValueViewPortScaleType scaleType = GValueViewPortScaleType.linear,
  GAxisPosition valueAxisPosition = GAxisPosition.end,
  GAxisPosition timeAxisPosition = GAxisPosition.end,
  GAxisScaleMode timeAxisMode = GAxisScaleMode.zoom,
  String Function(double value, int precision)? valueFormatter,
  String Function(int point, dynamic pointValue)? timeFormatter,
  List<GValueAxisMarker> valueMarkers = const [],
  List<GPointAxisMarker> timeMarkers = const [],
  List<GValueViewPort> extraViewPorts = const [],
  List<GValueAxis> extraAxes = const [],
  List<GPointAxis> extraTimeAxes = const [],
  GTooltip? tooltip,
  bool resizable = true,
  void Function(Offset)? onTap,
  void Function(Offset)? onDoubleTap,
}) {
  return GPanel(
    heightWeight: weight,
    resizable: resizable,
    onTapGraphArea: onTap,
    onDoubleTapGraphArea: onDoubleTap,
    valueViewPorts: [
      GValueViewPort(
        valuePrecision: precision,
        scaleType: scaleType,
        autoScaleStrategy: GValueViewPortAutoScaleStrategyMinMax(
          dataKeys: scale,
          fixedStartValue: min,
          fixedEndValue: max,
          marginStart: GSize.viewHeightRatio(marginBottom),
          marginEnd: GSize.viewHeightRatio(marginTop),
        ),
      ),
      ...extraViewPorts,
    ],
    valueAxes: [
      GValueAxis(
        position: valueAxisPosition,
        valueFormatter: valueFormatter,
        axisMarkers: valueMarkers,
      ),
      ...extraAxes,
    ],
    pointAxes: [
      if (timeAxis)
        GPointAxis(
          position: timeAxisPosition,
          scaleMode: timeAxisMode,
          pointFormatter: timeFormatter,
          axisMarkers: timeMarkers,
        ),
      ...extraTimeAxes,
    ],
    graphs: [if (grid) GGraphGrids(), ...graphs],
    tooltip: tooltip,
  );
}

/// La gráfica completa: datos + paneles + tema.
///
/// [barWidth] es el ancho en píxeles de cada barra al abrir: con valores
/// pequeños caben más barras en pantalla.
GChart fcChart(
  FcData d,
  List<GPanel> panels, {
  bool dark = false,
  double barWidth = 8,
  int endSpace = 4,
  GTheme? theme,
  GCrosshair? crosshair,
  GSplitter? splitter,
  GPointViewPort? pointViewPort,
  GDataSource? source,
  Size minSize = const Size(200, 200),
}) {
  return GChart(
    dataSource: source ?? d.source(),
    panels: panels,
    theme: theme ?? fcTheme(dark: dark),
    crosshair: crosshair,
    splitter: splitter,
    minSize: minSize,
    pointViewPort: pointViewPort ??
        GPointViewPort(
          defaultPointWidth: barWidth,
          autoScaleStrategy: GPointViewPortAutoScaleStrategyLatest(endSpacingPoints: endSpace),
        ),
  );
}

/// Vuelve al zoom automático: últimas barras y escala vertical ajustada.
void fcResetZoom(GChart chart) {
  chart.pointViewPort.autoScaleReset(chart: chart, panel: chart.panels[0], finished: true);
  for (final panel in chart.panels) {
    for (final viewPort in panel.valueViewPorts) {
      viewPort.autoScaleReset(chart: chart, panel: panel);
    }
  }
}

// ───────────────────────── Widgets ─────────────────────────

/// Estado base de una gráfica: guarda los datos y la `GChart`, la muestra y la
/// libera al cerrar. Las gráficas con controles heredan de aquí.
abstract class FcState<W extends StatefulWidget> extends State<W>
    with TickerProviderStateMixin<W> {
  late FcData d;
  late GChart chart;
  final List<GChart> _replaced = [];

  /// Datos de la gráfica. Por defecto, un activo aleatorio de 260 barras.
  FcData createData() => FcData();

  /// Arma la gráfica a partir de [d].
  GChart buildChart();

  /// Controles que van encima de la gráfica (segmentadores, botones...).
  List<Widget> controls(BuildContext context) => const [];

  @override
  void initState() {
    super.initState();
    d = createData();
    chart = buildChart();
  }

  /// Vuelve a armar la gráfica (después de cambiar una opción).
  void rebuildChart() {
    _replaced.add(chart);
    setState(() {
      chart = buildChart();
    });
  }

  /// Repinta la gráfica actual sin volver a armarla.
  void repaint() {
    setState(() {
      chart.repaint();
    });
  }

  @override
  void dispose() {
    for (final c in _replaced) {
      c.dispose();
    }
    chart.dispose();
    super.dispose();
  }

  Widget chartView() => GChartWidget(key: ObjectKey(chart), chart: chart, tickerProvider: this);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...controls(context),
        Expanded(child: chartView()),
      ],
    );
  }
}

/// Gráfica sin controles: basta con decir cómo se arma.
class FcView extends StatefulWidget {
  const FcView({
    super.key,
    required this.build,
    this.n = 260,
    this.vol = 0.018,
    this.drift = 0.0005,
  });

  final GChart Function(FcData d) build;
  final int n;
  final double vol;
  final double drift;

  @override
  State<FcView> createState() => _FcViewState();
}

class _FcViewState extends FcState<FcView> {
  @override
  FcData createData() => FcData(n: widget.n, vol: widget.vol, drift: widget.drift);

  @override
  GChart buildChart() => widget.build(d);
}

/// Segmentador de una sola opción.
Widget fcSeg<T>({
  required Map<T, String> options,
  required T value,
  required ValueChanged<T> onChanged,
}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.only(bottom: 8),
    child: SegmentedButton<T>(
      showSelectedIcon: false,
      style: const ButtonStyle(visualDensity: VisualDensity.compact),
      segments: [
        for (final e in options.entries) ButtonSegment<T>(value: e.key, label: Text(e.value)),
      ],
      selected: {value},
      onSelectionChanged: (s) => onChanged(s.first),
    ),
  );
}

/// Fichas que se pueden encender y apagar por separado (varias a la vez).
Widget fcChips({
  required Map<String, String> options,
  required Set<String> selected,
  required void Function(String key, bool on) onChanged,
}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        for (final e in options.entries)
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: FilterChip(
              label: Text(e.value),
              selected: selected.contains(e.key),
              visualDensity: VisualDensity.compact,
              onSelected: (on) => onChanged(e.key, on),
            ),
          ),
      ],
    ),
  );
}

/// Texto pequeño de ayuda encima de una gráfica interactiva.
Widget fcHint(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 12, color: fcGrey)),
    );

/// Formato de dinero para los ejes: 1234.5 -> $1,234.50
String fcMoney(double v, int precision) {
  final fixed = v.abs().toStringAsFixed(precision);
  final parts = fixed.split('.');
  final digits = parts[0];
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
    buf.write(digits[i]);
  }
  final dec = parts.length > 1 ? '.${parts[1]}' : '';
  return '${v < 0 ? '-' : ''}\$$buf$dec';
}

const _meses = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];

/// Fecha corta en español para el eje de tiempo: 14 mar
String fcFecha(int point, dynamic pointValue) {
  if (pointValue is! int) return '$pointValue';
  final dt = DateTime.fromMillisecondsSinceEpoch(pointValue);
  return '${dt.day} ${_meses[dt.month - 1]}';
}
