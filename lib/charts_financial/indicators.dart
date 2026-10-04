// Indicadores técnicos calculados en Dart puro.
//
// Todas las funciones reciben listas de `double` (una por serie de precios) y
// devuelven listas del mismo tamaño. Los primeros valores, que todavía no se
// pueden calcular porque faltan datos, se rellenan con `double.nan`:
// financial_chart ignora los NaN al dibujar líneas y áreas.
import 'dart:math' as math;

/// Lista de [n] valores NaN ("todavía sin dato").
List<double> nanList(int n) => List<double>.filled(n, double.nan, growable: true);

/// Cambia los NaN por cero. Las barras no aceptan NaN, las líneas sí.
List<double> nz(List<double> x) => [for (final v in x) v.isNaN ? 0.0 : v];

/// Rellena los NaN del principio con el primer valor válido.
List<double> backfill(List<double> x) {
  final first = x.indexWhere((v) => !v.isNaN);
  if (first <= 0) return x;
  return [for (var i = 0; i < x.length; i++) i < first ? x[first] : x[i]];
}

/// Desplaza la serie [k] posiciones hacia adelante (los primeros quedan NaN).
List<double> shift(List<double> x, int k) => [
      for (var i = 0; i < x.length; i++) (i - k >= 0 && i - k < x.length) ? x[i - k] : double.nan,
    ];

/// Operación elemento a elemento entre dos series.
List<double> zip(List<double> a, List<double> b, double Function(double, double) f) => [
      for (var i = 0; i < a.length; i++) f(a[i], b[i]),
    ];

/// Operación elemento a elemento sobre una serie.
List<double> each(List<double> a, double Function(double) f) => [for (final v in a) f(v)];

// ───────────────────────── Medias ─────────────────────────

/// Media móvil simple de [p] periodos.
List<double> sma(List<double> x, int p) {
  final out = nanList(x.length);
  var sum = 0.0;
  var count = 0;
  for (var i = 0; i < x.length; i++) {
    final v = x[i];
    if (v.isNaN) {
      sum = 0.0;
      count = 0;
      continue;
    }
    sum += v;
    count++;
    if (count > p) {
      sum -= x[i - p];
      count = p;
    }
    if (count == p) out[i] = sum / p;
  }
  return out;
}

List<double> _expAvg(List<double> x, int p, double k) {
  final out = nanList(x.length);
  double? prev;
  var sum = 0.0;
  var count = 0;
  for (var i = 0; i < x.length; i++) {
    final v = x[i];
    if (v.isNaN) continue;
    if (prev == null) {
      // Arranque: la primera media es una SMA de los primeros p valores.
      sum += v;
      count++;
      if (count == p) {
        prev = sum / p;
        out[i] = prev;
      }
    } else {
      prev = v * k + prev * (1 - k);
      out[i] = prev;
    }
  }
  return out;
}

/// Media móvil exponencial (da más peso a los datos recientes).
List<double> ema(List<double> x, int p) => _expAvg(x, p, 2 / (p + 1));

/// Media de Wilder (la que usan RSI, ATR y ADX).
List<double> rma(List<double> x, int p) => _expAvg(x, p, 1 / p);

/// Media móvil ponderada linealmente.
List<double> wma(List<double> x, int p) {
  final out = nanList(x.length);
  final den = p * (p + 1) / 2;
  for (var i = p - 1; i < x.length; i++) {
    var s = 0.0;
    var ok = true;
    for (var j = 0; j < p; j++) {
      final v = x[i - j];
      if (v.isNaN) {
        ok = false;
        break;
      }
      s += v * (p - j);
    }
    if (ok) out[i] = s / den;
  }
  return out;
}

/// Desviación estándar móvil.
List<double> stdev(List<double> x, int p) {
  final out = nanList(x.length);
  for (var i = p - 1; i < x.length; i++) {
    var s = 0.0;
    var s2 = 0.0;
    var ok = true;
    for (var j = i - p + 1; j <= i; j++) {
      final v = x[j];
      if (v.isNaN) {
        ok = false;
        break;
      }
      s += v;
      s2 += v * v;
    }
    if (ok) {
      final m = s / p;
      out[i] = math.sqrt(math.max(0.0, s2 / p - m * m));
    }
  }
  return out;
}

/// Máximo de los últimos [p] valores.
List<double> highest(List<double> x, int p) {
  final out = nanList(x.length);
  for (var i = p - 1; i < x.length; i++) {
    var m = x[i];
    for (var j = i - p + 1; j < i; j++) {
      if (x[j] > m) m = x[j];
    }
    out[i] = m;
  }
  return out;
}

/// Mínimo de los últimos [p] valores.
List<double> lowest(List<double> x, int p) {
  final out = nanList(x.length);
  for (var i = p - 1; i < x.length; i++) {
    var m = x[i];
    for (var j = i - p + 1; j < i; j++) {
      if (x[j] < m) m = x[j];
    }
    out[i] = m;
  }
  return out;
}

/// Precio típico: (máximo + mínimo + cierre) / 3.
List<double> typical(List<double> h, List<double> l, List<double> c) => [
      for (var i = 0; i < c.length; i++) (h[i] + l[i] + c[i]) / 3,
    ];

// ───────────────────────── Bandas y canales ─────────────────────────

typedef Band = ({List<double> mid, List<double> up, List<double> lo});

/// Bandas de Bollinger: media ± k desviaciones estándar.
Band bollinger(List<double> c, {int p = 20, double k = 2}) {
  final mid = sma(c, p);
  final sd = stdev(c, p);
  return (
    mid: mid,
    up: zip(mid, sd, (m, s) => m + k * s),
    lo: zip(mid, sd, (m, s) => m - k * s),
  );
}

/// Canal de Keltner: EMA ± k veces el ATR.
Band keltner(List<double> h, List<double> l, List<double> c, {int p = 20, double k = 2}) {
  final mid = ema(c, p);
  final a = atr(h, l, c, p);
  return (
    mid: mid,
    up: zip(mid, a, (m, x) => m + k * x),
    lo: zip(mid, a, (m, x) => m - k * x),
  );
}

/// Canal de Donchian: máximo y mínimo de los últimos p periodos.
Band donchian(List<double> h, List<double> l, [int p = 20]) {
  final up = highest(h, p);
  final lo = lowest(l, p);
  return (mid: zip(up, lo, (a, b) => (a + b) / 2), up: up, lo: lo);
}

/// Envolventes: media ± un porcentaje fijo.
Band envelope(List<double> c, {int p = 20, double pct = 0.03}) {
  final mid = sma(c, p);
  return (mid: mid, up: each(mid, (m) => m * (1 + pct)), lo: each(mid, (m) => m * (1 - pct)));
}

typedef Ichimoku = ({List<double> conv, List<double> base, List<double> spanA, List<double> spanB});

/// Ichimoku: conversión (9), base (26) y la nube (spans A y B desplazados 26).
Ichimoku ichimoku(List<double> h, List<double> l) {
  List<double> midOf(int p) => zip(highest(h, p), lowest(l, p), (a, b) => (a + b) / 2);
  final conv = midOf(9);
  final base = midOf(26);
  return (
    conv: conv,
    base: base,
    spanA: shift(zip(conv, base, (a, b) => (a + b) / 2), 26),
    spanB: shift(midOf(52), 26),
  );
}

/// Parabolic SAR: puntos que siguen al precio y marcan el cambio de tendencia.
List<double> psar(List<double> h, List<double> l, {double step = 0.02, double maxAf = 0.2}) {
  final n = h.length;
  final out = nanList(n);
  if (n < 2) return out;
  var up = h[1] >= h[0];
  var af = step;
  var ep = up ? h[0] : l[0];
  var sar = up ? l[0] : h[0];
  out[0] = sar;
  for (var i = 1; i < n; i++) {
    sar = sar + af * (ep - sar);
    if (up) {
      sar = math.min(sar, l[i - 1]);
      if (i > 1) sar = math.min(sar, l[i - 2]);
      if (l[i] < sar) {
        up = false;
        sar = ep;
        ep = l[i];
        af = step;
      } else if (h[i] > ep) {
        ep = h[i];
        af = math.min(af + step, maxAf);
      }
    } else {
      sar = math.max(sar, h[i - 1]);
      if (i > 1) sar = math.max(sar, h[i - 2]);
      if (h[i] > sar) {
        up = true;
        sar = ep;
        ep = h[i];
        af = step;
      } else if (l[i] < ep) {
        ep = l[i];
        af = math.min(af + step, maxAf);
      }
    }
    out[i] = sar;
  }
  return out;
}

/// SuperTrend: línea de stop que cambia de lado cuando la tendencia gira.
({List<double> line, List<bool> up}) supertrend(
  List<double> h,
  List<double> l,
  List<double> c, {
  int p = 10,
  double m = 3,
}) {
  final n = c.length;
  final a = atr(h, l, c, p);
  final line = nanList(n);
  final ups = List<bool>.filled(n, true, growable: true);
  var fu = double.nan;
  var fl = double.nan;
  var up = true;
  for (var i = 0; i < n; i++) {
    if (a[i].isNaN) continue;
    final mid = (h[i] + l[i]) / 2;
    final bu = mid + m * a[i];
    final bl = mid - m * a[i];
    if (fu.isNaN) {
      fu = bu;
      fl = bl;
    } else {
      fu = (bu < fu || c[i - 1] > fu) ? bu : fu;
      fl = (bl > fl || c[i - 1] < fl) ? bl : fl;
      if (up && c[i] < fl) {
        up = false;
      } else if (!up && c[i] > fu) {
        up = true;
      }
    }
    line[i] = up ? fl : fu;
    ups[i] = up;
  }
  return (line: line, up: ups);
}

/// VWAP acumulado: precio medio ponderado por volumen.
List<double> vwap(List<double> h, List<double> l, List<double> c, List<double> v) {
  final out = nanList(c.length);
  var pv = 0.0;
  var vol = 0.0;
  for (var i = 0; i < c.length; i++) {
    pv += (h[i] + l[i] + c[i]) / 3 * v[i];
    vol += v[i];
    if (vol > 0) out[i] = pv / vol;
  }
  return out;
}

// ───────────────────────── Osciladores ─────────────────────────

/// RSI: fuerza relativa de subidas frente a bajadas (0 a 100).
List<double> rsi(List<double> c, [int p = 14]) {
  final n = c.length;
  final gain = nanList(n);
  final loss = nanList(n);
  for (var i = 1; i < n; i++) {
    final d = c[i] - c[i - 1];
    gain[i] = d > 0 ? d : 0.0;
    loss[i] = d < 0 ? -d : 0.0;
  }
  final ag = rma(gain, p);
  final al = rma(loss, p);
  final out = nanList(n);
  for (var i = 0; i < n; i++) {
    if (ag[i].isNaN || al[i].isNaN) continue;
    out[i] = al[i] == 0 ? 100.0 : 100 - 100 / (1 + ag[i] / al[i]);
  }
  return out;
}

typedef Macd = ({List<double> line, List<double> signal, List<double> hist});

/// MACD: diferencia de dos EMAs, su señal y el histograma.
Macd macd(List<double> c, {int fast = 12, int slow = 26, int sig = 9}) {
  final line = zip(ema(c, fast), ema(c, slow), (a, b) => a - b);
  final signal = ema(line, sig);
  return (line: line, signal: signal, hist: zip(line, signal, (a, b) => a - b));
}

/// Estocástico: dónde cierra el precio dentro del rango reciente (0 a 100).
({List<double> k, List<double> d}) stochastic(
  List<double> h,
  List<double> l,
  List<double> c, {
  int p = 14,
  int smooth = 3,
}) {
  final hh = highest(h, p);
  final ll = lowest(l, p);
  final raw = [
    for (var i = 0; i < c.length; i++)
      (hh[i].isNaN || hh[i] == ll[i]) ? double.nan : 100 * (c[i] - ll[i]) / (hh[i] - ll[i]),
  ];
  final k = sma(raw, smooth);
  return (k: k, d: sma(k, smooth));
}

/// CCI: distancia del precio típico a su media, en desviaciones medias.
List<double> cci(List<double> h, List<double> l, List<double> c, [int p = 20]) {
  final tp = typical(h, l, c);
  final ma = sma(tp, p);
  final out = nanList(c.length);
  for (var i = p - 1; i < c.length; i++) {
    var dev = 0.0;
    for (var j = i - p + 1; j <= i; j++) {
      dev += (tp[j] - ma[i]).abs();
    }
    dev /= p;
    if (dev > 0) out[i] = (tp[i] - ma[i]) / (0.015 * dev);
  }
  return out;
}

/// Williams %R: como el estocástico pero de -100 a 0.
List<double> williamsR(List<double> h, List<double> l, List<double> c, [int p = 14]) {
  final hh = highest(h, p);
  final ll = lowest(l, p);
  return [
    for (var i = 0; i < c.length; i++)
      (hh[i].isNaN || hh[i] == ll[i]) ? double.nan : -100 * (hh[i] - c[i]) / (hh[i] - ll[i]),
  ];
}

/// ROC: variación porcentual respecto a hace p periodos.
List<double> roc(List<double> c, [int p = 12]) => [
      for (var i = 0; i < c.length; i++) i < p ? double.nan : 100 * (c[i] / c[i - p] - 1),
    ];

/// Rango verdadero: el mayor movimiento del día contando el hueco de apertura.
List<double> trueRange(List<double> h, List<double> l, List<double> c) => [
      for (var i = 0; i < c.length; i++)
        i == 0
            ? h[i] - l[i]
            : math.max(h[i] - l[i], math.max((h[i] - c[i - 1]).abs(), (l[i] - c[i - 1]).abs())),
    ];

/// ATR: rango verdadero medio (mide la volatilidad).
List<double> atr(List<double> h, List<double> l, List<double> c, [int p = 14]) =>
    rma(trueRange(h, l, c), p);

/// ADX con sus dos líneas direccionales (+DI y -DI).
({List<double> adx, List<double> plus, List<double> minus}) adx(
  List<double> h,
  List<double> l,
  List<double> c, [
  int p = 14,
]) {
  final n = c.length;
  final pdm = nanList(n);
  final mdm = nanList(n);
  final tr = trueRange(h, l, c);
  tr[0] = double.nan;
  for (var i = 1; i < n; i++) {
    final up = h[i] - h[i - 1];
    final dn = l[i - 1] - l[i];
    pdm[i] = (up > dn && up > 0) ? up : 0.0;
    mdm[i] = (dn > up && dn > 0) ? dn : 0.0;
  }
  final a = rma(tr, p);
  final sp = rma(pdm, p);
  final sm = rma(mdm, p);
  final plus = nanList(n);
  final minus = nanList(n);
  final dx = nanList(n);
  for (var i = 0; i < n; i++) {
    if (a[i].isNaN || a[i] == 0) continue;
    plus[i] = 100 * sp[i] / a[i];
    minus[i] = 100 * sm[i] / a[i];
    final sum = plus[i] + minus[i];
    dx[i] = sum == 0 ? 0.0 : 100 * (plus[i] - minus[i]).abs() / sum;
  }
  return (adx: rma(dx, p), plus: plus, minus: minus);
}

/// Aroon: cuánto hace del último máximo y del último mínimo (0 a 100).
({List<double> up, List<double> down}) aroon(List<double> h, List<double> l, [int p = 25]) {
  final n = h.length;
  final up = nanList(n);
  final down = nanList(n);
  for (var i = p; i < n; i++) {
    var hi = i - p;
    var lo = i - p;
    for (var j = i - p; j <= i; j++) {
      if (h[j] >= h[hi]) hi = j;
      if (l[j] <= l[lo]) lo = j;
    }
    up[i] = 100 * (p - (i - hi)) / p;
    down[i] = 100 * (p - (i - lo)) / p;
  }
  return (up: up, down: down);
}

/// MFI: un RSI que además pondera por volumen.
List<double> mfi(List<double> h, List<double> l, List<double> c, List<double> v, [int p = 14]) {
  final tp = typical(h, l, c);
  final out = nanList(c.length);
  for (var i = p; i < c.length; i++) {
    var pos = 0.0;
    var neg = 0.0;
    for (var j = i - p + 1; j <= i; j++) {
      final flow = tp[j] * v[j];
      if (tp[j] > tp[j - 1]) {
        pos += flow;
      } else if (tp[j] < tp[j - 1]) {
        neg += flow;
      }
    }
    out[i] = neg == 0 ? 100.0 : 100 - 100 / (1 + pos / neg);
  }
  return out;
}

/// Awesome Oscillator: SMA(5) - SMA(34) del punto medio de cada barra.
List<double> awesome(List<double> h, List<double> l) {
  final mid = zip(h, l, (a, b) => (a + b) / 2);
  return zip(sma(mid, 5), sma(mid, 34), (a, b) => a - b);
}

// ───────────────────────── Volumen ─────────────────────────

/// OBV: suma el volumen si el precio sube y lo resta si baja.
List<double> obv(List<double> c, List<double> v) {
  final out = List<double>.filled(c.length, 0.0, growable: true);
  for (var i = 1; i < c.length; i++) {
    out[i] = out[i - 1] + (c[i] > c[i - 1] ? v[i] : (c[i] < c[i - 1] ? -v[i] : 0.0));
  }
  return out;
}

List<double> _moneyFlowVolume(List<double> h, List<double> l, List<double> c, List<double> v) => [
      for (var i = 0; i < c.length; i++)
        h[i] == l[i] ? 0.0 : ((c[i] - l[i]) - (h[i] - c[i])) / (h[i] - l[i]) * v[i],
    ];

/// Línea de acumulación/distribución.
List<double> adLine(List<double> h, List<double> l, List<double> c, List<double> v) {
  final mfv = _moneyFlowVolume(h, l, c, v);
  final out = List<double>.filled(c.length, 0.0, growable: true);
  var acc = 0.0;
  for (var i = 0; i < c.length; i++) {
    acc += mfv[i];
    out[i] = acc;
  }
  return out;
}

/// Chaikin Money Flow: presión compradora o vendedora (-1 a 1).
List<double> cmf(List<double> h, List<double> l, List<double> c, List<double> v, [int p = 20]) {
  final a = sma(_moneyFlowVolume(h, l, c, v), p);
  final b = sma(v, p);
  return zip(a, b, (x, y) => (x.isNaN || y.isNaN || y == 0) ? double.nan : x / y);
}

// ───────────────────────── Transformaciones del precio ─────────────────────────

typedef Ohlc = ({List<double> o, List<double> h, List<double> l, List<double> c});

/// Velas Heikin-Ashi: promedian cada vela con la anterior para suavizar el ruido.
Ohlc heikinAshi(List<double> o, List<double> h, List<double> l, List<double> c) {
  final n = c.length;
  final ho = List<double>.filled(n, 0.0, growable: true);
  final hh = List<double>.filled(n, 0.0, growable: true);
  final hl = List<double>.filled(n, 0.0, growable: true);
  final hc = List<double>.filled(n, 0.0, growable: true);
  for (var i = 0; i < n; i++) {
    hc[i] = (o[i] + h[i] + l[i] + c[i]) / 4;
    ho[i] = i == 0 ? (o[i] + c[i]) / 2 : (ho[i - 1] + hc[i - 1]) / 2;
    hh[i] = math.max(h[i], math.max(ho[i], hc[i]));
    hl[i] = math.min(l[i], math.min(ho[i], hc[i]));
  }
  return (o: ho, h: hh, l: hl, c: hc);
}

typedef Pivot = ({int i, double v, bool high});

/// ZigZag: máximos y mínimos relevantes (giros de al menos [pct]).
List<Pivot> zigzag(List<double> h, List<double> l, {double pct = 0.06}) {
  final out = <Pivot>[];
  if (h.isEmpty) return out;
  var hiI = 0;
  var loI = 0;
  var hi = h[0];
  var lo = l[0];
  var dir = 0; // 0 = sin definir, 1 = tramo alcista, -1 = tramo bajista
  for (var i = 1; i < h.length; i++) {
    if (dir >= 0 && h[i] > hi) {
      hi = h[i];
      hiI = i;
    }
    if (dir <= 0 && l[i] < lo) {
      lo = l[i];
      loI = i;
    }
    if (dir == 0) {
      if (hi > lo * (1 + pct)) {
        if (hiI > loI) {
          out.add((i: loI, v: lo, high: false));
          dir = 1;
        } else {
          out.add((i: hiI, v: hi, high: true));
          dir = -1;
        }
      }
    } else if (dir == 1) {
      if (l[i] < hi * (1 - pct)) {
        out.add((i: hiI, v: hi, high: true));
        dir = -1;
        lo = l[i];
        loI = i;
      }
    } else {
      if (h[i] > lo * (1 + pct)) {
        out.add((i: loI, v: lo, high: false));
        dir = 1;
        hi = h[i];
        hiI = i;
      }
    }
  }
  if (dir == 1) {
    out.add((i: hiI, v: hi, high: true));
  } else if (dir == -1) {
    out.add((i: loI, v: lo, high: false));
  }
  return out;
}

/// Ladrillos Renko: cada ladrillo aparece cuando el precio avanza [size].
List<({double from, double to})> renko(List<double> c, double size) {
  final out = <({double from, double to})>[];
  if (c.isEmpty || size <= 0) return out;
  var base = c[0];
  for (final price in c) {
    while (price >= base + size) {
      out.add((from: base, to: base + size));
      base += size;
    }
    while (price <= base - size) {
      out.add((from: base, to: base - size));
      base -= size;
    }
  }
  return out;
}

// ───────────────────────── Rendimiento y riesgo ─────────────────────────

/// Caída desde el máximo anterior, en porcentaje (siempre <= 0).
List<double> drawdown(List<double> c) {
  final out = List<double>.filled(c.length, 0.0, growable: true);
  var peak = c.isEmpty ? 0.0 : c[0];
  for (var i = 0; i < c.length; i++) {
    if (c[i] > peak) peak = c[i];
    out[i] = peak == 0 ? 0.0 : 100 * (c[i] / peak - 1);
  }
  return out;
}

/// Serie reescalada para que el primer valor sea 100.
List<double> base100(List<double> c) => [for (final v in c) 100 * v / c[0]];

/// Retorno porcentual de cada barra respecto a la anterior.
List<double> returnsPct(List<double> c) => [
      for (var i = 0; i < c.length; i++) i == 0 ? 0.0 : 100 * (c[i] / c[i - 1] - 1),
    ];

/// Volatilidad histórica anualizada (%), sobre [p] periodos.
List<double> histVol(List<double> c, [int p = 20]) {
  final logRet = [
    for (var i = 0; i < c.length; i++) i == 0 ? double.nan : math.log(c[i] / c[i - 1]),
  ];
  return each(stdev(logRet, p), (s) => s * math.sqrt(252.0) * 100);
}

/// Regresión lineal entre los índices [from] y [to] (incluidos).
({double slope, double intercept, double sd}) linreg(List<double> y, int from, int to) {
  final n = to - from + 1;
  var sx = 0.0;
  var sy = 0.0;
  var sxy = 0.0;
  var sxx = 0.0;
  for (var i = from; i <= to; i++) {
    sx += i;
    sy += y[i];
    sxy += i * y[i];
    sxx += i * i.toDouble();
  }
  final den = n * sxx - sx * sx;
  final slope = den == 0 ? 0.0 : (n * sxy - sx * sy) / den;
  final intercept = (sy - slope * sx) / n;
  var err = 0.0;
  for (var i = from; i <= to; i++) {
    final e = y[i] - (intercept + slope * i);
    err += e * e;
  }
  return (slope: slope, intercept: intercept, sd: math.sqrt(err / n));
}
