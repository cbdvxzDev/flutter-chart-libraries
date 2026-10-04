// Paneles ya armados (precio, volumen y osciladores) que se combinan en las
// gráficas avanzadas. Cada función calcula su indicador, lo agrega a los datos
// y devuelve el panel listo para meter en la gráfica.
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import 'common.dart';

/// Panel de precio con velas y las superposiciones que se le pasen.
GPanel fcPricePanel(
  FcData d, {
  double weight = 0.6,
  bool timeAxis = false,
  List<GGraph> under = const [],
  List<GGraph> over = const [],
  List<String> scale = const [],
  List<GOverlayMarker> markers = const [],
  List<String> tip = const [],
  GGraph? price,
  String? id,
}) {
  return fcPanel(
    weight: weight,
    timeAxis: timeAxis,
    scale: [kH, kL, ...scale],
    graphs: [...under, price ?? fcCandles(id: id, markers: markers), ...over],
    tooltip: fcTip([...fcOhlc, ...tip], follow: kC),
  );
}

/// Panel de volumen, verde o rojo según cierre la barra.
GPanel fcVolumePanel(FcData d, {double weight = 0.2, bool timeAxis = false}) {
  d.add('vUp', [for (var i = 0; i < d.n; i++) d.c[i] >= d.o[i] ? d.v[i] : 0.0],
      label: 'Volumen al alza', precision: 0);
  d.add('vDn', [for (var i = 0; i < d.n; i++) d.c[i] < d.o[i] ? d.v[i] : 0.0],
      label: 'Volumen a la baja', precision: 0);
  return fcPanel(
    weight: weight,
    timeAxis: timeAxis,
    scale: [kV],
    min: 0,
    marginBottom: 0,
    precision: 0,
    graphs: [
      fcBars('vUp', up: fcUp),
      fcBars('vDn', up: fcDown),
    ],
    tooltip: fcTip([kV], position: GTooltipPosition.topLeft),
  );
}

/// Panel de RSI con sus zonas de sobrecompra y sobreventa.
GPanel fcRsiPanel(
  FcData d, {
  double weight = 0.2,
  bool timeAxis = false,
  List<GOverlayMarker> markers = const [],
}) {
  d.add('rsi', rsi(d.c), label: 'RSI 14');
  return fcPanel(
    weight: weight,
    timeAxis: timeAxis,
    scale: ['rsi'],
    min: 0,
    max: 100,
    precision: 0,
    graphs: [
      fcLine(
        'rsi',
        fcPurple,
        w: 1.6,
        markers: [
          fcHBand(70, 100, fcDown, alpha: 0.10),
          fcHBand(0, 30, fcUp, alpha: 0.10),
          fcHLine(70, fcDown, dash: const [5, 4]),
          fcHLine(30, fcUp, dash: const [5, 4]),
          ...markers,
        ],
      ),
    ],
    tooltip: fcTip(['rsi'], position: GTooltipPosition.topLeft),
  );
}

/// Panel de MACD: histograma, línea y señal.
GPanel fcMacdPanel(FcData d, {double weight = 0.2, bool timeAxis = false}) {
  final m = macd(d.c);
  d.add('macd', m.line, label: 'MACD');
  d.add('sig', m.signal, label: 'Señal');
  d.add('hist', nz(m.hist), label: 'Histograma');
  return fcPanel(
    weight: weight,
    timeAxis: timeAxis,
    scale: ['macd', 'sig', 'hist'],
    graphs: [
      fcBars('hist', up: fcUp.withValues(alpha: 0.7), down: fcDown.withValues(alpha: 0.7), base: 0),
      fcLine('sig', fcOrange, w: 1.4),
      fcLine('macd', fcBlue, w: 1.4, markers: [fcHLine(0, fcGrey)]),
    ],
    tooltip: fcTip(['macd', 'sig', 'hist'], position: GTooltipPosition.topLeft),
  );
}

/// Panel del oscilador estocástico (%K y %D).
GPanel fcStochPanel(FcData d, {double weight = 0.2, bool timeAxis = false}) {
  final st = stochastic(d.h, d.l, d.c);
  d.add('stK', st.k, label: '%K');
  d.add('stD', st.d, label: '%D');
  return fcPanel(
    weight: weight,
    timeAxis: timeAxis,
    scale: ['stK', 'stD'],
    min: 0,
    max: 100,
    precision: 0,
    graphs: [
      fcLine('stD', fcOrange, w: 1.4),
      fcLine(
        'stK',
        fcBlue,
        w: 1.4,
        markers: [
          fcHLine(80, fcDown, dash: const [5, 4]),
          fcHLine(20, fcUp, dash: const [5, 4]),
        ],
      ),
    ],
    tooltip: fcTip(['stK', 'stD'], position: GTooltipPosition.topLeft),
  );
}

/// Panel de CCI con sus niveles de ±100.
GPanel fcCciPanel(FcData d, {double weight = 0.2, bool timeAxis = false}) {
  d.add('cci', cci(d.h, d.l, d.c), label: 'CCI 20');
  return fcPanel(
    weight: weight,
    timeAxis: timeAxis,
    scale: ['cci'],
    precision: 0,
    graphs: [
      fcArea(
        'cci',
        fcUp,
        base: 0,
        below: fcDown,
        alpha: 0.16,
        w: 1.4,
        markers: [
          fcHLine(100, fcDown, dash: const [5, 4]),
          fcHLine(-100, fcUp, dash: const [5, 4]),
        ],
      ),
    ],
    tooltip: fcTip(['cci'], position: GTooltipPosition.topLeft),
  );
}

/// Panel de ATR (volatilidad).
GPanel fcAtrPanel(FcData d, {double weight = 0.2, bool timeAxis = false}) {
  d.add('atr', atr(d.h, d.l, d.c), label: 'ATR 14');
  return fcPanel(
    weight: weight,
    timeAxis: timeAxis,
    scale: ['atr'],
    min: 0,
    marginBottom: 0,
    graphs: [fcArea('atr', fcOrange, alpha: 0.20, w: 1.6)],
    tooltip: fcTip(['atr'], position: GTooltipPosition.topLeft),
  );
}

/// Panel de ADX con +DI y -DI.
GPanel fcAdxPanel(FcData d, {double weight = 0.2, bool timeAxis = false}) {
  final a = adx(d.h, d.l, d.c);
  d.add('adx', a.adx, label: 'ADX');
  d.add('pdi', a.plus, label: '+DI');
  d.add('mdi', a.minus, label: '−DI');
  return fcPanel(
    weight: weight,
    timeAxis: timeAxis,
    scale: ['adx', 'pdi', 'mdi'],
    min: 0,
    marginBottom: 0,
    precision: 0,
    graphs: [
      fcLine('pdi', fcUp, w: 1.2),
      fcLine('mdi', fcDown, w: 1.2),
      fcLine('adx', fcIndigo, w: 2, markers: [fcHLine(25, fcGrey, dash: const [5, 4])]),
    ],
    tooltip: fcTip(['adx', 'pdi', 'mdi'], position: GTooltipPosition.topLeft),
  );
}

/// Panel de Williams %R.
GPanel fcWilliamsPanel(FcData d, {double weight = 0.2, bool timeAxis = false}) {
  d.add('wr', williamsR(d.h, d.l, d.c), label: '%R 14');
  return fcPanel(
    weight: weight,
    timeAxis: timeAxis,
    scale: ['wr'],
    min: -100,
    max: 0,
    precision: 0,
    graphs: [
      fcLine(
        'wr',
        fcIndigo,
        w: 1.6,
        markers: [
          fcHLine(-20, fcDown, dash: const [5, 4]),
          fcHLine(-80, fcUp, dash: const [5, 4]),
        ],
      ),
    ],
    tooltip: fcTip(['wr'], position: GTooltipPosition.topLeft),
  );
}

/// Título pequeño en la esquina de un panel.
GLabelMarker fcPanelTitle(String text, {Color color = fcGrey}) => fcLabel(
      text,
      GPositionCoord.absolute(x: 8, y: 6),
      align: Alignment.bottomRight,
      color: color,
      weight: FontWeight.w700,
    );
