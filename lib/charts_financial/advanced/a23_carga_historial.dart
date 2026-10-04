// Avanzada 23 · Carga de historial bajo demanda
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';

Widget a23CargaHistorial() => const _A23();

class _A23 extends StatefulWidget {
  const _A23();

  @override
  State<_A23> createState() => _A23State();
}

class _A23State extends FcState<_A23> {
  static const _initial = 200; // barras que se entregan al abrir
  int loaded = _initial;

  /// "Servidor" simulado: 900 barras, de las que al principio solo se ven 200.
  @override
  FcData createData() => FcData(n: 900);

  GData<int> _row(int i) => GData<int>(
        pointValue: d.t[i],
        seriesValues: [d.o[i], d.h[i], d.l[i], d.c[i], d.v[i]],
      );

  @override
  GChart buildChart() {
    final source = GDataSource<int, GData<int>>(
      dataList: [for (var i = d.n - _initial; i < d.n; i++) _row(i)],
      seriesProperties: const [
        GDataSeriesProperty(key: kO, label: 'Apertura', precision: 2),
        GDataSeriesProperty(key: kH, label: 'Máximo', precision: 2),
        GDataSeriesProperty(key: kL, label: 'Mínimo', precision: 2),
        GDataSeriesProperty(key: kC, label: 'Cierre', precision: 2),
        GDataSeriesProperty(key: kV, label: 'Volumen', precision: 0),
      ],
      // La librería llama a esta función cuando el usuario se desplaza más
      // atrás de la primera barra cargada.
      priorDataLoader: ({
        required int toPointExclusive,
        required int toPointValueExclusive,
        required int pointCount,
      }) async {
        await Future<void>.delayed(const Duration(milliseconds: 700)); // "red" lenta
        final end = d.t.indexOf(toPointValueExclusive);
        if (end <= 0) return <GData<int>>[];
        final start = end - pointCount < 0 ? 0 : end - pointCount;
        if (mounted) setState(() => loaded += end - start);
        return [for (var i = start; i < end; i++) _row(i)];
      },
    );
    return fcChart(
      d,
      [
        fcPanel(
          scale: [kH, kL],
          graphs: [fcCandles()],
          tooltip: fcTip(fcOhlc, follow: kC),
        ),
      ],
      source: source,
    );
  }

  @override
  List<Widget> controls(BuildContext context) => [
        fcHint(
          'Arrastra la gráfica hacia la derecha para ir al pasado: el historial se pide por '
          'bloques. Barras cargadas: $loaded de ${d.n}.',
        ),
      ];
}
