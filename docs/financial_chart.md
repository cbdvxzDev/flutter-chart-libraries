# Gráficas con `financial_chart`

Galería de 79 gráficas (43 básicas y 36 avanzadas) hechas con la librería
[`financial_chart`](https://pub.dev/packages/financial_chart). Todas usan datos
aleatorios: cada vez que se abre una gráfica, o se pulsa el dado de la barra
superior, se inventa un activo nuevo.

## Cómo ejecutarla

```bash
flutter pub get          # descarga financial_chart (se agregó al pubspec.yaml)
flutter analyze          # revisa que el código compile sin errores
flutter test             # abre las 79 gráficas una por una y verifica que se dibujan
flutter run -d windows   # o -d chrome
```

En la pantalla principal, el botón con el icono de velas (arriba a la derecha)
abre la galería.

## Dónde está cada cosa

```
lib/
├── financial_gallery.dart        catálogo (título, descripción, diferencia) y pantallas
└── charts_financial/
    ├── indicators.dart           indicadores técnicos en Dart puro (SMA, RSI, MACD...)
    ├── common.dart               datos aleatorios, colores y ayudantes para armar gráficas
    ├── panels.dart               paneles ya armados (precio, volumen, RSI, MACD...)
    ├── basic/     b01 ... b43    una gráfica básica por archivo
    └── advanced/  a01 ... a36    una gráfica avanzada por archivo
test/financial_charts_test.dart   prueba que abre todas las gráficas
```

## Cómo piensa la librería

`financial_chart` no tiene un widget distinto por tipo de gráfica, como fl_chart
(`LineChart`, `BarChart`...). Tiene un solo modelo, `GChart`, que se arma con
piezas:

```
GChart
├── dataSource      una tabla: cada fila es una barra de tiempo, cada columna una serie con nombre
├── pointViewPort   qué tramo del eje horizontal se ve (zoom y desplazamiento)
└── panels[]        uno o más paneles apilados; todos comparten el eje de tiempo
    ├── valueViewPorts[]   escalas verticales (qué rango de valores se ve)
    ├── valueAxes[]        ejes de valores (derecha, izquierda o dentro)
    ├── pointAxes[]        ejes de tiempo (abajo, arriba)
    ├── graphs[]           las series: velas, líneas, áreas, barras
    │   └── overlayMarkers[]   dibujos encima: líneas, textos, flechas, Fibonacci...
    └── tooltip            recuadro de valores al pasar el cursor
```

Tres ideas que se repiten en todo el código:

- **Las series se piden por nombre.** A la fuente de datos se le agrega una
  columna (`d.add('rsi', ...)`) y luego la serie dice qué columna dibuja
  (`fcLine('rsi', ...)`).
- **Los indicadores no vienen en la librería.** Se calculan en
  `indicators.dart` y se agregan como una columna más. Los primeros valores,
  que todavía no se pueden calcular, quedan como `NaN` y la librería los salta.
- **Los marcadores usan coordenadas.** `at(barra, valor)` ancla un dibujo a un
  dato (se mueve con el zoom); `atValue(x, valor)` lo ancla a un valor pero de
  lado a lado; `atPoint(barra, y)` a una barra pero de arriba abajo.

## Una gráfica, línea por línea

`basic/b10_bollinger.dart` completo:

```dart
Widget b10Bollinger() => FcView(build: (d) {
```
`FcView` es el widget común: crea los datos aleatorios (`d`), llama a esta
función para armar la gráfica y la muestra. `d` trae las series `o`, `h`, `l`,
`c`, `v` (apertura, máximo, mínimo, cierre y volumen).

```dart
      final bb = bollinger(d.c);
```
Calcula las bandas a partir de los cierres. Devuelve tres listas: `mid`
(media de 20), `up` (media + 2 desviaciones) y `lo` (media − 2 desviaciones).

```dart
      d.add('bbM', bb.mid, label: 'Media 20');
      d.add('bbU', bb.up, label: 'Banda superior');
      d.add('bbL', bb.lo, label: 'Banda inferior');
```
Agrega las tres listas a los datos como columnas nuevas. El `label` es el
texto que se verá en el tooltip.

```dart
      return fcChart(d, [
        fcPanel(
```
`fcChart` crea la `GChart` con un solo panel.

```dart
          scale: [kH, kL, 'bbU', 'bbL'],
```
Series que deciden el rango del eje vertical: el máximo, el mínimo y las dos
bandas. Así nada queda cortado.

```dart
          graphs: [
            fcArea('bbU', fcBlue, baseKey: 'bbL', alpha: 0.10, w: 1),
```
Un área entre dos series: de la banda superior a la inferior, en azul casi
transparente. Va primero para quedar al fondo.

```dart
            fcLine('bbM', fcBlue, w: 1),
            fcCandles(),
          ],
```
Encima la media y, por último, las velas (lo último de la lista queda arriba).

```dart
          tooltip: fcTip([kC, 'bbU', 'bbM', 'bbL'], follow: kC),
        ),
      ]);
    });
```
El tooltip muestra el cierre y las tres bandas, y se pega a la altura del
cierre.

Las otras 78 gráficas siguen el mismo esquema: calcular, agregar columnas y
describir paneles.

## Ayudantes de `common.dart`

| Ayudante | Qué crea |
|---|---|
| `FcData` | Los datos aleatorios (paseo aleatorio con OHLC y volumen) |
| `fcChart`, `fcPanel` | La gráfica y cada uno de sus paneles |
| `fcCandles`, `fcLine`, `fcArea`, `fcBars`, `fcStack` | Las series |
| `fcHLine`, `fcVLine`, `fcHBand`, `fcVBand`, `fcPath` | Líneas y franjas |
| `fcLabel`, `fcCallout`, `fcLegend` | Textos, globos y leyendas |
| `fcShape`, `fcBuy`, `fcSell`, `fcArrow` | Formas, señales y flechas |
| `fcTip` | El tooltip |
| `FcView` | Widget para gráficas sin controles |
| `FcState` | Estado base para gráficas con controles |
| `fcSeg`, `fcChips` | Segmentador de una opción y fichas de varias |

## Cómo agregar una gráfica

1. Crear el archivo en `basic/` o `advanced/` con una función que devuelva un
   `Widget` (copiar una parecida es lo más rápido).
2. Importarlo en `financial_gallery.dart`.
3. Agregar su `FcEntry` a la lista `financialBasic` o `financialAdvanced`:
   título, qué muestra, en qué se diferencia y la función.

La prueba `flutter test` la toma sola, porque recorre las dos listas.

## De dónde salen los datos

`FcData` genera cada barra a partir de la anterior:

- la apertura es el cierre anterior con un pequeño salto;
- el cierre es la apertura más un cambio aleatorio con distribución normal;
- el máximo y el mínimo se alejan un poco de los dos anteriores;
- el volumen crece cuando el movimiento del día es grande.

Las fechas son días hábiles consecutivos. No hay semilla fija, así que dos
ejecuciones nunca dan lo mismo.

## Archivos compartidos que se tocaron

Para la unión de ramas, estos son los únicos archivos fuera de las carpetas
propias que cambian:

- `pubspec.yaml`: una línea, `financial_chart: ^0.4.1`.
- `lib/main.dart`: un `import` y un botón en `actions` del `AppBar`, en el
  mismo lugar donde las ramas de Syncfusion y directed_graph pusieron el suyo.
- `pubspec.lock`: se actualiza solo al ejecutar `flutter pub get`.
