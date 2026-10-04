// Datos, estilos y utilidades compartidas por todas las graficas.
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

const pal = <Color>[
  Color(0xFF6C5CE7), Color(0xFF00B894), Color(0xFFFF7675), Color(0xFFFDCB6E),
  Color(0xFF0984E3), Color(0xFFE84393), Color(0xFF00CEC9), Color(0xFF636E72),
];
const grid = Color(0x22808080);
const track = Color(0x22808080);
const ts = TextStyle(fontSize: 10);

class Pt { const Pt(this.x, this.y, [this.y2 = 0]); final String x; final double y, y2; }
class Nm { const Nm(this.x, this.y, [this.s = 0]); final double x, y, s; }
class Tm { const Tm(this.x, this.y); final DateTime x; final double y; }
class Oh { const Oh(this.d, this.o, this.h, this.l, this.c); final DateTime d; final double o, h, l, c; }
class Bx { const Bx(this.x, this.v); final String x; final List<num> v; }

String x(Pt p, int i) => p.x;
double y(Pt p, int i) => p.y;
double y2(Pt p, int i) => p.y2;
double nx(Nm p, int i) => p.x;
double ny(Nm p, int i) => p.y;
double ns(Nm p, int i) => p.s;
DateTime tx(Tm p, int i) => p.x;
double ty(Tm p, int i) => p.y;
double? gap(Pt p, int i) => (i == 3 || i == 4 || i == 8) ? null : p.y;

final rnd = math.Random(7);
const mes = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
const dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

List<Pt> gen(double b, double a, [double t = 0]) => [
      for (var i = 0; i < 12; i++)
        Pt(mes[i], double.parse((b + t * i + a * math.sin(i / 1.7) + rnd.nextDouble() * a * .6).toStringAsFixed(1)))
    ];
final s1 = gen(60, 18, 2), s2 = gen(45, 14, 1.5), s3 = gen(30, 10, 1);
final rng = [for (final p in s1) Pt(p.x, p.y + 12, p.y - 12)]; // y = alto, y2 = bajo
final cats = const [Pt('Espresso', 42), Pt('Latte', 31), Pt('Capuchino', 24), Pt('Mocha', 18), Pt('Filtrado', 27), Pt('Cold Brew', 35)];
final cats2 = [for (final p in cats) Pt(p.x, p.y * .7 + 5)];
final kpi = const [Pt('Meta A', 82), Pt('Meta B', 64), Pt('Meta C', 47), Pt('Meta D', 91)];
final fun = const [Pt('Visitas', 1000), Pt('Interesados', 720), Pt('Carrito', 400), Pt('Pago', 250), Pt('Fieles', 120)];
final wf = const [Pt('Ingresos', 120), Pt('Costos', -45), Pt('Nómina', -30), Pt('Subtotal', 0), Pt('Marketing', -15), Pt('Otros', 22), Pt('Total', 0)];
final exp = [for (var i = 0; i < 8; i++) Pt('${2019 + i}', 10 * math.pow(2.2, i).toDouble())];

Nm sct() { final x = rnd.nextDouble() * 100; return Nm(x, 15 + x * .65 + (rnd.nextDouble() - .5) * 35); }
final sc = [for (var i = 0; i < 60; i++) sct()];
final bub = [for (var i = 0; i < 14; i++) Nm(10 + rnd.nextDouble() * 80, 10 + rnd.nextDouble() * 80, 6 + rnd.nextDouble() * 30)];
final fast = [for (var i = 0; i < 2000; i++) Nm(i.toDouble(), 50 + math.sin(i / 60) * 35 + math.sin(i / 7) * 6 + rnd.nextDouble() * 5)];
final hist = [for (var i = 0; i < 240; i++) Nm(0, 50 + (rnd.nextDouble() + rnd.nextDouble() + rnd.nextDouble() - 1.5) * 45)];
final box = [
  for (var k = 0; k < 7; k++)
    Bx(dias[k], [for (var i = 0; i < 24; i++) 30 + k * 3 + rnd.nextDouble() * 40 + (i == 0 ? 38 : 0)])
];
final tm = [for (var i = 0; i < 120; i++) Tm(DateTime(2026, 1, 1).add(Duration(days: i)), 50 + math.sin(i / 9) * 22 + i * .18 + rnd.nextDouble() * 7)];
final ohlc = () {
  var p = 100.0;
  final out = <Oh>[];
  for (var i = 0; i < 45; i++) {
    final o = p, c = o + (rnd.nextDouble() - .46) * 8;
    out.add(Oh(DateTime(2026, 1, 1).add(Duration(days: i)), o, math.max(o, c) + rnd.nextDouble() * 4, math.min(o, c) - rnd.nextDouble() * 4, c));
    p = c;
  }
  return out;
}();
final ma = [
  for (var i = 4; i < ohlc.length; i++) Tm(ohlc[i].d, ohlc.sublist(i - 4, i + 1).fold<double>(0, (a, e) => a + e.c) / 5)
];
const sp = <double>[12, 18, 15, 24, 21, 30, 28, 36, 33, 41, 38, 47];
const wl = <double>[1, -1, 1, 1, -1, 1, -1, -1, 1, 1, 1, -1, 1, 1, -1];

// ───────────────────────── Helpers ─────────────────────────
CategoryAxis cx() => CategoryAxis(labelStyle: ts, majorGridLines: MajorGridLines(width: 0), majorTickLines: MajorTickLines(size: 0), axisLine: AxisLine(width: 0));

NumericAxis nv({String? name, bool opp = false, bool g = true, String? fmt, double? min, double? max, List<PlotBand>? bands}) => NumericAxis(
      name: name, opposedPosition: opp, minimum: min, maximum: max, labelFormat: fmt, plotBands: bands ?? const <PlotBand>[], labelStyle: ts,
      axisLine: AxisLine(width: 0), majorTickLines: MajorTickLines(size: 0),
      majorGridLines: MajorGridLines(width: g ? 1 : 0, color: grid, dashArray: const <double>[4, 4]));

DateTimeAxis dx({DateTime? min, DateTime? max}) => DateTimeAxis(
      labelStyle: ts, initialVisibleMinimum: min, initialVisibleMaximum: max, edgeLabelPlacement: EdgeLabelPlacement.shift,
      majorGridLines: MajorGridLines(width: 0), axisLine: AxisLine(width: 0), majorTickLines: MajorTickLines(size: 0));

Widget c(List<CartesianSeries<dynamic, dynamic>> s,
        {ChartAxis? x, ChartAxis? y, List<ChartAxis>? axes, bool lg = false, bool tr = false, bool tt = true, bool sbs = true,
        TrackballBehavior? tb, ZoomPanBehavior? zp, CrosshairBehavior? ch, List<CartesianChartAnnotation>? an}) =>
    SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(6, 10, 14, 4), plotAreaBorderWidth: 0, palette: pal, isTransposed: tr,
      enableSideBySideSeriesPlacement: sbs,
      legend: Legend(isVisible: lg, position: LegendPosition.bottom, overflowMode: LegendItemOverflowMode.wrap),
      tooltipBehavior: tt ? TooltipBehavior(enable: true) : null,
      trackballBehavior: tb, zoomPanBehavior: zp, crosshairBehavior: ch, annotations: an,
      primaryXAxis: x ?? cx(), primaryYAxis: y ?? nv(), axes: axes ?? <ChartAxis>[], series: s,
    );

Widget p(List<CircularSeries<dynamic, dynamic>> s, {bool lg = true, String? cy}) => SfCircularChart(
      margin: const EdgeInsets.all(6), palette: pal, centerY: cy ?? '50%',
      legend: Legend(isVisible: lg, position: LegendPosition.bottom, overflowMode: LegendItemOverflowMode.wrap),
      tooltipBehavior: TooltipBehavior(enable: true), series: s);

List<CartesianSeries<dynamic, dynamic>> m3(CartesianSeries<Pt, String> Function(List<Pt> d, String n, Color c) mk) =>
    [mk(s1, 'Arábica', pal[0]), mk(s2, 'Robusta', pal[1]), mk(s3, 'Geisha', pal[2])];

DataLabelSettings get dls => DataLabelSettings(isVisible: true, textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600));
DataLabelSettings dl([bool out = false]) => DataLabelSettings(
    isVisible: true, labelPosition: out ? ChartDataLabelPosition.outside : ChartDataLabelPosition.inside,
    textStyle: TextStyle(color: out ? null : Colors.white, fontSize: 11, fontWeight: FontWeight.w700));
LinearGradient gr(Color a, [Color? b]) => LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [a, b ?? a.withAlpha(20)]);
Widget badge(String t, Color c) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(10)),
    child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)));
Widget kpiBox(String big, String sub, Widget chart) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(big, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
      Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      const SizedBox(height: 8),
      Expanded(child: chart),
    ]));

class S { S(this.t, this.s, this.b); final String t, s; final Widget Function() b; }

extension WrapCenterExt on Widget {
  /// Superpone un texto grande y uno pequeño en el centro de la gráfica.
  Widget wrapCenter(String big, String small) => Stack(alignment: Alignment.center, children: [
        this,
        IgnorePointer(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(big, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
            Text(small, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ]),
        ),
      ]);
}

// ───────────────────────── Gráfica en tiempo real ─────────────────────────
class Live extends StatefulWidget {
  const Live({super.key});
  @override
  State<Live> createState() => LiveState();
}

class LiveState extends State<Live> {
  final d = <Nm>[for (var i = 0; i < 40; i++) Nm(i.toDouble(), 50 + 20 * math.sin(i / 4))];
  int t = 40;
  ChartSeriesController<Nm, double>? ctl;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      d.add(Nm(t.toDouble(), 50 + 20 * math.sin(t / 4) + (t % 3) * 3));
      t++;
      d.removeAt(0);
      ctl?.updateDataSource(addedDataIndexes: [d.length - 1], removedDataIndexes: [0]);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => c(tt: false, x: nv(g: false), [
        SplineAreaSeries<Nm, double>(
          dataSource: d, xValueMapper: nx, yValueMapper: ny, animationDuration: 0,
          gradient: gr(pal[6].withAlpha(210)), borderColor: pal[6], borderWidth: 2.5,
          onRendererCreated: (c) => ctl = c,
        ),
      ]);
}
