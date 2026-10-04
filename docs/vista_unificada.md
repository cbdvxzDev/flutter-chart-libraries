# Galería unificada: qué se hizo y cómo funciona

Este documento explica la rama `feature/galeria_unificada`: cómo se unieron las cuatro ramas, qué hace cada archivo nuevo de `lib/gallery/` y, línea por línea, los dos archivos principales: `gallery_catalog.dart` y `unified_gallery_page.dart`.

Nada se subió a GitHub. Todo está en commits locales.

---

## 1. Qué se unió

Se creó la rama `feature/galeria_unificada` a partir de `origin/feature/fl_chart` y se le unieron, en este orden:

1. `origin/feature/syncfusion_flutter_charts`
2. `origin/feature/directed_graph`
3. `origin/feature/financial_chart`

Unir (*merge*) significa que Git toma los cambios de otra rama y los mezcla con los de la rama actual. Si dos ramas cambiaron **la misma parte de un archivo**, Git no sabe con cuál quedarse y marca un **conflicto**. En el archivo aparecen unas marcas así:

```
<<<<<<< HEAD
lo que tenía la rama actual
=======
lo que traía la otra rama
>>>>>>> origin/feature/directed_graph
```

Resolver un conflicto es editar esa zona para dejar el resultado correcto y borrar las marcas.

### Conflictos y cómo se resolvió cada uno

| Merge | Archivo | Qué pasó | Cómo se resolvió |
|---|---|---|---|
| Syncfusion | `test/widget_test.dart` | Las dos ramas cambiaron las pruebas de la pantalla principal. | Se dejó la versión de FL Chart. Después se reescribió el archivo entero para la pantalla nueva. |
| Directed Graph | `pubspec.yaml` | Cada rama agregó su dependencia en la misma línea. | Se dejaron las dos, una por línea. |
| Directed Graph | `pubspec.lock` | Es un archivo generado automáticamente. | Se aceptó un lado y se regeneró con `flutter pub get`. |
| Directed Graph | `lib/main.dart` | Cada rama agregó un `import` y un botón (`IconButton`) en el mismo sitio. | Se dejaron los dos `import` y los dos botones. |
| Financial Chart | `pubspec.yaml`, `pubspec.lock`, `lib/main.dart` | Lo mismo que en el merge anterior. | Igual: cuatro dependencias, tres `import`, tres botones. |

`analysis_options.yaml` se unió solo, sin conflicto. Después de cada merge se ejecutaron `flutter pub get` y `flutter analyze`, y no hubo errores.

Los tres botones del `AppBar` fueron temporales: en el paso siguiente se quitaron, porque la app ahora abre directamente en la galería unificada.

### Commits de la rama

```
306ad7d Actualizar las pruebas para la galería unificada
aace397 Agregar la vista de galería unificada y abrir la app en ella
12db761 Agregar el catálogo unificado de las cuatro librerías
db932e3 Unir feature/financial_chart en la galería unificada
3b90261 Unir feature/directed_graph en la galería unificada
18ec2f5 Unir feature/syncfusion_flutter_charts en la galería unificada
```

---

## 2. Qué se cambió fuera de `lib/gallery/`

| Archivo | Cambio | Por qué |
|---|---|---|
| `lib/main.dart` | El `build` de `HomeScreen` ahora devuelve `const UnifiedGalleryPage()`. Se quitaron los tres `IconButton`, los tres `import` de las galerías viejas y la clase `_SectionHeader`, que ya nadie usaba. | Para que la app abra en la galería unificada. Las listas `basicCharts` y `advancedCharts` quedaron **intactas**, porque dos pruebas dependen de ellas. |
| `pubspec.yaml` | Las cuatro dependencias y una sección `fonts:` con las tres tipografías. | Las dependencias vienen de la unión; las fuentes, del diseño. |
| `assets/fonts/` | 6 archivos `.ttf` y 2 archivos de licencia. | Tipografías Space Grotesk, IBM Plex Sans e IBM Plex Mono, con licencia libre SIL OFL 1.1. Al estar dentro del proyecto funcionan sin internet. |
| `test/widget_test.dart` | Reescrito para la pantalla nueva. | La pantalla vieja ya no existe. |
| `test/unified_gallery_test.dart` | Nuevo. | Comprueba el catálogo. |

**No se cambió nada** dentro de `lib/charts/`, `lib/charts_sync/`, `lib/charts_grafo/` ni `lib/charts_financial/`. Tampoco en `charts_gallery.dart`, `grafos_gallery.dart` ni `financial_gallery.dart`. Se comprobó con `git diff` contra cada rama original.

---

## 3. Los archivos de `lib/gallery/`

| Archivo | Qué hace |
|---|---|
| `gallery_meta.dart` | El archivo que tú escribiste, movido aquí sin cambios. Define `ChartGlyph` (los 27 tipos de miniatura) y ocho listas con la categoría y la miniatura de cada gráfica. |
| `gallery_models.dart` | Define dos "moldes" de datos: `GalleryEntry` (una gráfica) y `GalleryLibrary` (una librería con sus colores y sus dos listas). También tiene `capitalizeFirst`, que pone en mayúscula la primera letra. |
| `gallery_catalog.dart` | Construye las cuatro `GalleryLibrary` juntando las listas de cada librería con `gallery_meta.dart`. Se explica línea por línea en la sección 4. |
| `gallery_theme.dart` | Los colores y estilos de texto del diseño, para no repetir números como `0xFF161A23` por todo el código. |
| `glyph_painter.dart` | Dibuja las miniaturas con un `CustomPainter` (ver el recuadro más abajo). Cada forma es la traducción a Flutter del SVG del plan. |
| `unified_gallery_page.dart` | La pantalla. Se explica línea por línea en la sección 5. |

> **¿Qué es un `CustomPainter`?** Normalmente en Flutter se arma la interfaz con widgets ya hechos (`Text`, `Row`, `Container`…). Cuando quieres dibujar algo libre, como una miniatura de gráfica, usas un `CustomPainter`. Es una clase con un método `paint(Canvas canvas, Size size)`: el `Canvas` es como una hoja en blanco con funciones como `drawLine`, `drawRect`, `drawCircle` y `drawPath`. El widget `CustomPaint` es el que pone ese dibujo en la pantalla. En `glyph_painter.dart`, el método `paint` escala la hoja para que las coordenadas del SVG (un lienzo de 120 × 64) llenen el espacio de 150 × 80, y luego dibuja la forma que corresponde al `ChartGlyph`.

---

## 4. `gallery_catalog.dart` línea por línea

### Los `import` (líneas 1–13)

```dart
1  import 'package:flutter/material.dart';
```
Trae los widgets de Material Design (`Scaffold`, `AppBar`, `Text`, `Color`…).

```dart
3  import '../charts_gallery.dart' as sync;
4  import '../charts_sync/common.dart' as sync show S;
```
> **¿Qué es un prefijo de `import`?** Normalmente, al importar un archivo, todos sus nombres quedan disponibles directamente. `charts_gallery.dart` (Syncfusion) declara nombres muy cortos como `basic`, `adv`, `Grid` y una clase `Card` que **tapa** al `Card` de Material. Con `as sync`, esos nombres solo se pueden usar escribiendo `sync.` delante (`sync.basic`, `sync.adv`). Así no chocan con nada.

- **Línea 3:** importa la galería de Syncfusion, donde están las listas `basic` y `adv`.
- **Línea 4:** la clase `S` (cada gráfica de Syncfusion) está en otro archivo, `common.dart`. Se importa con el mismo prefijo `sync`. `show S` significa "de este archivo, tráeme solo `S`", porque `common.dart` también declara nombres como `x`, `y` y `grid`.

```dart
5  import '../charts_grafo/avanzadas/catalogo_avanzadas.dart' as grafos;
8  import '../charts_grafo/simples/catalogo_simples.dart' as grafos;
```
Los dos catálogos de Directed Graph con el prefijo `grafos`. En Dart dos archivos pueden compartir prefijo, así que se escribe `grafos.simpleCharts` y `grafos.advancedCharts`. Así no se confunden con `HomeScreen.advancedCharts` de FL Chart.

```dart
6  import '../charts_grafo/models/chart_entry.dart';
7  import '../charts_grafo/pages/chart_page.dart';
9  import '../charts_grafo/theme/colores.dart';
```
De Directed Graph se usan: la clase `ChartEntry` (línea 6), la página de detalle `ChartPage` (línea 7) y sus colores `kBg`, `kBasicA` y `kAdvA` (línea 9).

```dart
10 import '../financial_gallery.dart';
```
Trae `financialBasic`, `financialAdvanced` y `FinancialChartPage`.

```dart
11 import '../main.dart';
```
Trae `HomeScreen`, donde están las listas de FL Chart. Ojo: `main.dart` también importa la galería, así que cada archivo importa al otro. Dart lo permite sin problema.

```dart
12 import 'gallery_meta.dart';
13 import 'gallery_models.dart';
```
Los metadatos (categoría y miniatura) y los modelos `GalleryEntry` y `GalleryLibrary`.

### La lista de librerías (líneas 15–106)

```dart
15 /// Las cuatro librerías de la galería unificada, en el orden del riel.
16 final List<GalleryLibrary> galleryLibraries = [
```
- Las líneas que empiezan con `///` son **comentarios de documentación**: Dart los ignora, pero el editor los muestra al pasar el mouse sobre el nombre.
- `final` significa que la variable no se puede reasignar. Al estar fuera de cualquier clase, es una variable **global**: Dart la crea la primera vez que alguien la usa, y no antes.

```dart
17   GalleryLibrary(
18     name: 'FL Chart',
19     package: 'fl_chart',
20     version: '1.2.0',
21     description: 'Líneas, barras, pastel, dispersión, radar y velas.',
22     color: const Color(0xFF3949AB),
23     railColor: const Color(0xFF8C9EFF),
24     lightColor: const Color(0xFFE8EAF6),
```
Primera librería. Cada `nombre:` es un **parámetro con nombre**: se escribe el nombre del dato y su valor, así que el orden no importa.
- `Color(0xFF3949AB)` es un color en hexadecimal: `FF` es la opacidad (totalmente opaco) y `3949AB` es el `#3949AB` de la tabla del plan.
- `const` le dice a Dart que el valor nunca cambia, así que lo crea una sola vez.
- `color` es el color principal, `railColor` el del cuadrado del riel y `lightColor` el fondo claro de las miniaturas.

```dart
25     basic: _entries(
26       HomeScreen.basicCharts,
27       flBasicMeta,
28       title: (chart) => chart.$1,
29       open: (i, chart) => chart.$2,
30     ),
```
Construye la lista de básicas con la función `_entries` (explicada en las líneas 114–134). Le pasa:
- **Línea 26:** la lista original, `HomeScreen.basicCharts`. Cada elemento es un *record* `(String, WidgetBuilder)`: un par de valores sin nombre.
- **Línea 27:** sus metadatos, `flBasicMeta`.
- **Línea 28:** cómo sacar el título. `(chart) => chart.$1` es una **función anónima** (una función sin nombre escrita en el sitio): recibe un elemento `chart` y devuelve `chart.$1`, el primer valor del par.
- **Línea 29:** cómo abrir la gráfica. En FL Chart el segundo valor del par (`$2`) ya es un `WidgetBuilder` que crea la página completa, así que se devuelve tal cual. La `i` (la posición) no se usa aquí.

```dart
31     advanced: _entries(
32       HomeScreen.advancedCharts,
33       flAdvancedMeta,
34       title: (chart) => chart.$1,
35       open: (i, chart) => chart.$2,
36     ),
37   ),
```
Lo mismo para las avanzadas. El `),` de la línea 37 cierra la primera `GalleryLibrary`.

```dart
38   GalleryLibrary(
39     name: 'Syncfusion Charts',
40     package: 'syncfusion_flutter_charts',
41     version: '28',
42     description: 'Series cartesianas, apiladas, circulares y sparklines.',
43     color: const Color(0xFFB45309),
44     railColor: const Color(0xFFFDBA74),
45     lightColor: const Color(0xFFFBEEDD),
```
Segunda librería: Syncfusion, con sus datos y colores.

```dart
46     basic: _entries(
47       sync.basic,
48       syncBasicMeta,
49       title: (s) => s.t,
50       open: (i, s) =>
51           (_) => _SyncfusionChartPage(entry: s),
52     ),
```
- **Línea 47:** `sync.basic` es la lista de Syncfusion (gracias al prefijo).
- **Línea 49:** en la clase `S` el título se llama `t`.
- **Líneas 50–51:** Syncfusion no tenía página de detalle, así que se usa una nueva, `_SyncfusionChartPage` (líneas 147–175). Aquí hay **una función que devuelve otra función**. `(i, s) => …` recibe la posición y la gráfica, y devuelve `(_) => _SyncfusionChartPage(entry: s)`, que es el `WidgetBuilder`. El `_` es el nombre que se da a un parámetro que no se usa; en este caso, el `BuildContext`.

```dart
53     advanced: _entries(
54       sync.adv,
55       syncAdvancedMeta,
56       title: (s) => s.t,
57       open: (i, s) =>
58           (_) => _SyncfusionChartPage(entry: s),
59     ),
60   ),
```
Lo mismo con las avanzadas (`sync.adv`).

```dart
61   GalleryLibrary(
62     name: 'Directed Graph',
63     package: 'directed_graph',
64     version: '0.5.6',
65     description: 'Grafos dirigidos y gráficas alimentadas con sus datos.',
66     color: const Color(0xFF0F766E),
67     railColor: const Color(0xFF5EEAD4),
68     lightColor: const Color(0xFFDDF1EE),
69     basic: _entries(
70       grafos.simpleCharts,
71       directedBasicMeta,
72       title: (e) => e.title,
73       open: (i, e) => _openGrafo(e, kBasicA),
74     ),
75     advanced: _entries(
76       grafos.advancedCharts,
77       directedAdvancedMeta,
78       title: (e) => e.title,
79       open: (i, e) => _openGrafo(e, kAdvA),
80     ),
81   ),
```
Tercera librería: Directed Graph. Para abrir una gráfica se usa `_openGrafo` (líneas 137–144). Recibe el color semilla del tema: `kBasicA` (azul) para las básicas y `kAdvA` (coral) para las avanzadas, igual que hacía su galería original.

```dart
82   GalleryLibrary(
83     name: 'Financial Chart',
84     package: 'financial_chart',
85     version: '0.4.1',
86     description:
87         'Análisis técnico: velas, indicadores y herramientas de dibujo.',
88     color: const Color(0xFF9D174D),
89     railColor: const Color(0xFFF9A8D4),
90     lightColor: const Color(0xFFF8E1EA),
91     basic: _entries(
92       financialBasic,
93       financialBasicMeta,
94       title: (e) => e.title,
95       open: (i, e) =>
96           (_) => FinancialChartPage(number: i + 1, entry: e),
97     ),
98     advanced: _entries(
99       financialAdvanced,
100      financialAdvancedMeta,
101      title: (e) => e.title,
102      open: (i, e) =>
103          (_) => FinancialChartPage(number: i + 1, entry: e),
104    ),
105  ),
106 ];
```
Cuarta librería: Financial Chart. Su página de detalle necesita el número de la gráfica. La posición `i` empieza en 0, así que se le pasa `i + 1`. Aquí sí se usa la `i`. El `];` de la línea 106 cierra la lista.

### El total (líneas 108–110)

```dart
108 /// Cantidad total de gráficas de todas las librerías.
109 int get galleryTotal =>
110     galleryLibraries.fold(0, (sum, library) => sum + library.total);
```
- `get` crea un **getter**: se usa como si fuera una variable (`galleryTotal`), pero cada vez que se lee se calcula.
- `fold` recorre la lista acumulando un resultado. Empieza en `0` y, por cada librería, suma su `total` (básicas + avanzadas). Con cuatro librerías de 79 da 316. Por eso el riel no escribe "316" a mano.

### La función que une listas y metadatos (líneas 112–134)

```dart
114 List<GalleryEntry> _entries<T>(
115   List<T> items,
116   List<ChartMeta> meta, {
117   required String Function(T item) title,
118   required WidgetBuilder Function(int index, T item) open,
119 }) {
```
- **Línea 114:** el `_` al principio del nombre lo hace **privado**: solo se puede usar dentro de este archivo. `<T>` la hace **genérica**. `T` es un "tipo comodín": cada librería tiene un tipo distinto de elemento (un par en FL Chart, `S` en Syncfusion, `ChartEntry` en grafos, `FcEntry` en Financial), y gracias a `T` una sola función sirve para las cuatro.
- **Línea 115:** la lista original de la librería.
- **Línea 116:** la lista de metadatos. `ChartMeta` está definido en `gallery_meta.dart` como `(String category, ChartGlyph glyph)`.
- **Línea 117:** `title` es una función que recibe un elemento y devuelve su título. Las llaves `{ }` de las líneas 116 y 119 encierran **parámetros con nombre**, y `required` los vuelve obligatorios.
- **Línea 118:** `open` es una función que recibe la posición y el elemento, y devuelve el `WidgetBuilder` que abre la gráfica.

```dart
120   assert(
121     items.length == meta.length,
122     'La lista tiene ${items.length} gráficas y sus metadatos ${meta.length}.',
123   );
```
`assert` comprueba algo mientras desarrollas. Si las dos listas no tienen el mismo largo, la app se detiene con ese mensaje. Así, si algún día alguien agrega una gráfica y olvida su metadato, se entera de inmediato. En la versión final de la app (*release*) los `assert` no se ejecutan. `${…}` mete el valor de una expresión dentro del texto.

```dart
124   return [
125     for (var i = 0; i < items.length; i++)
126       GalleryEntry(
127         number: i + 1,
128         title: title(items[i]),
129         category: meta[i].$1,
130         glyph: meta[i].$2,
131         open: open(i, items[i]),
132       ),
133   ];
134 }
```
Construye y devuelve la lista nueva. El `for` **dentro** de los corchetes es un *collection for*: agrega un elemento por cada vuelta. Por cada posición `i`:
- **127:** número = posición + 1 (01, 02…). Es el número de la lista original y no cambia aunque haya filtros.
- **128:** el título, usando la función `title` que se recibió.
- **129–130:** la categoría (`$1`) y la miniatura (`$2`) del metadato de la misma posición.
- **131:** el `WidgetBuilder` para abrir, usando la función `open`.

### Abrir una gráfica de grafos (líneas 136–144)

```dart
137 WidgetBuilder _openGrafo(ChartEntry entry, Color seed) =>
138     (context) => Theme(
139       data: Theme.of(context).copyWith(
140         colorScheme: ColorScheme.fromSeed(seedColor: seed),
141         scaffoldBackgroundColor: kBg,
142       ),
143       child: ChartPage(entry: entry),
144     );
```
Devuelve un `WidgetBuilder` que envuelve la `ChartPage` original en un `Theme`. Un `Theme` cambia los colores de todo lo que tiene dentro.
- **139:** toma el tema actual de la app (`Theme.of(context)`) y crea una copia con dos cambios (`copyWith`).
- **140:** una paleta completa generada a partir de un solo color (la "semilla").
- **141:** el fondo `kBg` de Directed Graph.

Así la gráfica se ve igual que cuando se abría desde su galería original (`GaleriaPage`).

### Página de detalle de Syncfusion (líneas 146–175)

```dart
147 class _SyncfusionChartPage extends StatelessWidget {
148   const _SyncfusionChartPage({required this.entry});
149
150   final sync.S entry;
```
- **147:** un widget **sin estado** (`StatelessWidget`): solo muestra datos y no cambia por sí mismo. Es privado (`_`).
- **148:** el constructor. `required this.entry` obliga a pasar la gráfica y la guarda en el campo `entry`.
- **150:** el campo. Su tipo es `sync.S`, la clase `S` con prefijo.

```dart
152   @override
153   Widget build(BuildContext context) {
154     final theme = Theme.of(context);
```
`build` es el método que Flutter llama para saber qué dibujar. `@override` indica que se reemplaza el método de la clase padre. En la línea 154 se guarda el tema en una variable corta para no repetir `Theme.of(context)`.

```dart
155     return Scaffold(
156       appBar: AppBar(title: Text(capitalizeFirst(entry.t))),
```
`Scaffold` es la estructura básica de una página. La barra superior muestra el título con la primera letra en mayúscula ("spline" → "Spline"). Se hace al mostrar; el archivo de Syncfusion no se modifica.

```dart
157       body: Padding(
158         padding: const EdgeInsets.all(16),
159         child: Column(
160           crossAxisAlignment: CrossAxisAlignment.start,
161           children: [
```
El cuerpo deja 16 píxeles de margen por todos los lados y apila sus hijos en vertical (`Column`), alineados a la izquierda (`start`).

```dart
162             Text(
163               entry.s,
164               style: theme.textTheme.bodyMedium?.copyWith(
165                 color: theme.colorScheme.onSurfaceVariant,
166               ),
167             ),
```
El subtítulo (`s`), con el estilo de texto normal del tema y un color gris. El `?.` significa "si `bodyMedium` no es nulo, llama a `copyWith`; si es nulo, devuelve nulo".

```dart
168             const SizedBox(height: 12),
169             Expanded(child: entry.b()),
```
- **168:** un espacio vacío de 12 píxeles.
- **169:** `entry.b()` llama a la función de la gráfica y devuelve su widget. `Expanded` le da todo el alto que queda libre.

Las líneas 170–175 cierran los paréntesis y llaves abiertos.

---

## 5. `unified_gallery_page.dart` línea por línea

> **Estado y `setState`.** Un `StatelessWidget` siempre se dibuja igual con los mismos datos. Esta pantalla, en cambio, **recuerda cosas que cambian**: qué librería está elegida, si se ven básicas o avanzadas, qué categoría y qué texto de búsqueda. Eso es su **estado**. Para tener estado se usan dos clases: un `StatefulWidget` (el widget) y una clase `State` (donde viven las variables). Cuando cambias una variable del estado, lo haces dentro de `setState(() { … })`. Así Flutter sabe que debe volver a llamar a `build` y redibujar la pantalla con los valores nuevos. Si cambias la variable sin `setState`, la pantalla no se entera.

### `import` (líneas 1–6)

```dart
1 import 'package:flutter/material.dart';
3 import 'gallery_catalog.dart';
4 import 'gallery_models.dart';
5 import 'gallery_theme.dart';
6 import 'glyph_painter.dart';
```
Material, el catálogo (`galleryLibraries`, `galleryTotal`), los modelos, los colores y estilos, y el pintor de miniaturas.

### El widget con estado (líneas 8–14)

```dart
9  class UnifiedGalleryPage extends StatefulWidget {
10   const UnifiedGalleryPage({super.key});
12   @override
13   State<UnifiedGalleryPage> createState() => _UnifiedGalleryPageState();
14 }
```
- **9:** el widget público, el que usa `main.dart`.
- **10:** su constructor. `super.key` pasa la `key` opcional a la clase padre.
- **13:** `createState` crea el objeto que guarda el estado, `_UnifiedGalleryPageState`.

### Constantes y variables de estado (líneas 16–31)

```dart
16 class _UnifiedGalleryPageState extends State<UnifiedGalleryPage> {
18   static const _narrowWidth = 800.0;
21   static const _cardMinWidth = 230.0;
22   static const _gap = 16.0;
```
- **16:** la clase de estado.
- **18:** si la pantalla mide menos de 800 píxeles de ancho, el riel pasa arriba.
- **21–22:** ancho mínimo de una tarjeta (230) y separación entre tarjetas (16).

`static const` significa que es una constante de la clase, compartida y fija.

```dart
24   final _searchController = TextEditingController();
```
Un **controlador** del campo de búsqueda: un objeto que guarda el texto escrito. Hay que liberarlo al cerrar la pantalla (línea 65).

```dart
26   int _libraryIndex = 0;
27   bool _showBasic = true;
30   String? _category;
31   String _query = '';
```
Las cuatro variables del **estado**:
- **26:** qué librería está elegida (0 = FL Chart, la primera al abrir).
- **27:** `true` = básicas, `false` = avanzadas.
- **30:** la categoría elegida. El `?` permite que sea `null`, y aquí `null` significa "Todas".
- **31:** el texto de búsqueda.

### Datos calculados (líneas 33–51)

```dart
33   GalleryLibrary get _library => galleryLibraries[_libraryIndex];
```
Getter: la librería elegida.

```dart
35   List<GalleryEntry> get _levelEntries =>
36       _showBasic ? _library.basic : _library.advanced;
```
Las gráficas del nivel elegido. `condición ? a : b` significa "si la condición es verdadera, `a`; si no, `b`".

```dart
39   List<String> get _categories =>
40       {for (final e in _levelEntries) e.category}.toList();
```
Las categorías del nivel. Las llaves `{ }` crean un **conjunto** (`Set`): una colección que no admite repetidos y que en Dart conserva el orden en que entran los elementos. Después `.toList()` lo convierte en lista. El resultado son las categorías sin repetir, en el orden en que aparecen.

```dart
43   List<GalleryEntry> get _visibleEntries {
44     final query = _query.trim().toLowerCase();
45     return [
46       for (final e in _levelEntries)
47         if ((_category == null || e.category == _category) &&
48             e.title.toLowerCase().contains(query))
49           e,
50     ];
51   }
```
Las gráficas que se muestran en la cuadrícula.
- **44:** quita los espacios de los extremos (`trim`) y pasa el texto a minúsculas. Así "SPLINE" y "spline" buscan lo mismo.
- **46–49:** recorre las gráficas del nivel y deja solo las que cumplen **las dos** condiciones (`&&` significa "y"):
  - la categoría es "Todas" (`null`) o coincide con la elegida (`||` significa "o");
  - el título en minúsculas contiene el texto buscado. Un texto vacío está contenido en cualquier título, así que sin búsqueda pasan todas.

### Cambiar de librería o de nivel (líneas 53–61)

```dart
53   void _selectLibrary(int index) => setState(() {
54     _libraryIndex = index;
55     _category = null;
56   });
```
Al elegir una librería, cambia el índice y la categoría vuelve a "Todas", todo dentro de `setState` para que la pantalla se redibuje.

```dart
58   void _selectLevel(bool basic) => setState(() {
59     _showBasic = basic;
60     _category = null;
61   });
```
Lo mismo al cambiar entre básicas y avanzadas.

### Liberar recursos (líneas 63–67)

```dart
63   @override
64   void dispose() {
65     _searchController.dispose();
66     super.dispose();
67   }
```
Flutter llama a `dispose` cuando la pantalla desaparece para siempre. Aquí se libera el controlador del buscador y luego se deja que la clase padre haga su parte (`super.dispose()`).

### `build`: riel a la izquierda o arriba (líneas 69–102)

```dart
71     return Scaffold(
72       backgroundColor: GalleryColors.page,
73       body: SafeArea(
```
Página con fondo `#F3F4F6`. `SafeArea` evita que el contenido quede debajo de la muesca o de la barra de estado del teléfono.

```dart
74         child: LayoutBuilder(
75           builder: (context, constraints) {
76             final narrow = constraints.maxWidth < _narrowWidth;
```
`LayoutBuilder` te dice cuánto espacio hay (`constraints`). Si el ancho máximo es menor que 800, `narrow` (estrecho) vale `true`.

```dart
77             final rail = _Rail(
78               selected: _libraryIndex,
79               horizontal: narrow,
80               onSelect: _selectLibrary,
81             );
```
Crea el riel. Le pasa qué librería está elegida, si debe ir en horizontal y qué función llamar cuando se pulse una librería (`_selectLibrary`).

```dart
82             final content = _buildContent(narrow ? 16 : 32);
```
Crea el contenido de la derecha, con 16 píxeles de margen en pantalla estrecha y 32 en ancha.

```dart
83             if (narrow) {
84               return Column(
85                 children: [
86                   rail,
87                   Expanded(child: content),
88                 ],
89               );
90             }
```
Pantalla estrecha: el riel arriba y el contenido debajo, ocupando el resto del alto (`Expanded`).

```dart
91             return Row(
92               crossAxisAlignment: CrossAxisAlignment.stretch,
93               children: [
94                 SizedBox(width: 240, child: rail),
95                 Expanded(child: content),
96               ],
97             );
```
Pantalla ancha: una fila con el riel de 240 píxeles a la izquierda y el contenido ocupando el resto. `stretch` hace que los dos ocupen todo el alto.

### El contenido (líneas 104–159)

```dart
104   Widget _buildContent(double padding) {
105     final library = _library;
106     final entries = _visibleEntries;
```
Método ayudante que construye la parte derecha. Guarda en variables la librería y las gráficas visibles, para calcularlas una sola vez.

```dart
107     return LayoutBuilder(
108       builder: (context, constraints) {
109         final gridWidth = constraints.maxWidth - padding * 2;
110         final columns = ((gridWidth + _gap) / (_cardMinWidth + _gap))
111             .floor()
112             .clamp(1, 12);
```
Calcula cuántas columnas de tarjetas caben sin que ninguna mida menos de 230 píxeles.
- **109:** el ancho disponible, descontando los márgenes.
- **110–112:** cada tarjeta necesita 230 más 16 de separación. Se divide, se redondea hacia abajo (`floor`) y se limita entre 1 y 12 columnas (`clamp`). Se suma un `_gap` arriba porque la última tarjeta no lleva separación a su derecha.

```dart
113         return CustomScrollView(
114           slivers: [
```
> **`CustomScrollView` y los *slivers*.** Un `CustomScrollView` es una zona con desplazamiento hecha de piezas llamadas *slivers*. Permite mezclar en un solo desplazamiento un encabezado normal y una cuadrícula que solo construye las tarjetas visibles, lo que ahorra memoria con 43 tarjetas.

```dart
115             SliverPadding(
116               padding: EdgeInsets.fromLTRB(padding, padding, padding, 24),
117               sliver: SliverToBoxAdapter(
118                 child: Column(
119                   crossAxisAlignment: CrossAxisAlignment.start,
120                   children: [
121                     _buildHeader(library),
122                     const SizedBox(height: 24),
123                     _buildFilters(library),
124                   ],
125                 ),
126               ),
127             ),
```
Primer *sliver*: el encabezado y los filtros. `SliverToBoxAdapter` permite meter un widget normal dentro de un `CustomScrollView`. `fromLTRB` define el margen izquierdo, superior, derecho e inferior.

```dart
128             if (entries.isEmpty)
129               SliverPadding(
130                 padding: EdgeInsets.symmetric(horizontal: padding),
131                 sliver: const SliverToBoxAdapter(
132                   child: Text(
133                     'Ninguna gráfica coincide con la búsqueda.',
134                     style: GalleryText.empty,
135                   ),
136                 ),
137               )
```
Si no hay gráficas que mostrar, aparece este mensaje en lugar de la cuadrícula. Un `if` dentro de una lista (*collection if*) agrega el elemento solo si se cumple la condición.

```dart
138             else
139               SliverPadding(
140                 padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
141                 sliver: SliverGrid(
142                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
143                     crossAxisCount: columns,
144                     mainAxisSpacing: _gap,
145                     crossAxisSpacing: _gap,
146                     mainAxisExtent: 196,
147                   ),
```
Si hay gráficas, se dibuja la cuadrícula (`SliverGrid`). El *delegate* define la forma: `columns` columnas, 16 de separación vertical y horizontal, y cada tarjeta de 196 píxeles de alto (104 de miniatura más el texto).

```dart
148                   delegate: SliverChildBuilderDelegate(
149                     (context, i) =>
150                         _ChartCard(entry: entries[i], library: library),
151                     childCount: entries.length,
152                   ),
```
Crea las tarjetas **a medida que se necesitan**: cuando la tarjeta número `i` va a entrar en pantalla, se llama a esta función para construirla. `childCount` dice cuántas hay en total.

### El encabezado (líneas 161–228)

```dart
164     return SizedBox(
165       width: double.infinity,
166       child: Wrap(
167         alignment: WrapAlignment.spaceBetween,
168         spacing: 24,
169         runSpacing: 16,
```
Un `Wrap` coloca a sus hijos en fila y, si no caben, pasa los que sobran a la línea siguiente.
- `spaceBetween` empuja el primero a la izquierda y el último (el buscador) a la derecha.
- `spacing` es la separación horizontal y `runSpacing` la vertical entre líneas.
- El `SizedBox` con `width: double.infinity` le da al `Wrap` todo el ancho. Sin él, el `Wrap` se encogería al ancho de su contenido y `spaceBetween` no tendría espacio que repartir.

```dart
171           Column(
172             mainAxisSize: MainAxisSize.min,
173             crossAxisAlignment: CrossAxisAlignment.start,
174             children: [
175               Text(
176                 library.packageLabel,
177                 style: GalleryText.headerPackage.copyWith(color: library.color),
178               ),
179               const SizedBox(height: 4),
180               Text(library.name, style: GalleryText.headerTitle),
181               const SizedBox(height: 4),
182               Text(library.description, style: GalleryText.headerDescription),
183             ],
184           ),
```
Tres textos apilados: paquete y versión (en el color de la librería), nombre grande y descripción. `MainAxisSize.min` hace que la columna mida solo lo que ocupan sus hijos. `copyWith(color: …)` crea una copia del estilo cambiando solo el color.

```dart
185           SizedBox(
186             width: 280,
187             height: 44,
188             child: TextField(
189               key: const ValueKey('buscar'),
190               controller: _searchController,
191               onChanged: (value) => setState(() => _query = value),
```
El buscador de 280 × 44.
- **189:** una `key` es una etiqueta que identifica al widget. Las pruebas la usan para encontrar el campo y escribir en él.
- **190:** el controlador que guarda el texto.
- **191:** `onChanged` se llama con cada letra que escribes; guarda el texto en `_query` dentro de `setState` y la cuadrícula se filtra al instante.

```dart
192               style: GalleryText.search,
193               cursorColor: library.color,
194               textAlignVertical: TextAlignVertical.center,
```
Estilo del texto escrito, cursor del color de la librería y texto centrado en vertical.

```dart
195               decoration: InputDecoration(
196                 isDense: true,
197                 hintText: 'Buscar gráfica',
198                 hintStyle: GalleryText.search.copyWith(
199                   color: GalleryColors.inkSoft,
200                 ),
```
La "decoración" del campo. `isDense` lo hace más compacto, y `hintText` es el texto gris de ayuda que se ve cuando el campo está vacío.

```dart
201                 prefixIcon: const Icon(
202                   Icons.search,
203                   color: GalleryColors.inkSoft,
204                 ),
205                 prefixIconConstraints: const BoxConstraints(
206                   minWidth: 40,
207                   minHeight: 40,
208                 ),
```
El icono de lupa a la izquierda. Por defecto el icono pide 48 píxeles de alto, más que los 44 del campo, así que se le limita a 40.

```dart
209                 filled: true,
210                 fillColor: GalleryColors.surface,
211                 contentPadding: EdgeInsets.zero,
```
Fondo blanco y sin relleno interno extra.

```dart
212                 enabledBorder: OutlineInputBorder(
213                   borderRadius: BorderRadius.circular(6),
214                   borderSide: const BorderSide(
215                     color: GalleryColors.fieldBorder,
216                   ),
217                 ),
218                 focusedBorder: OutlineInputBorder(
219                   borderRadius: BorderRadius.circular(6),
220                   borderSide: BorderSide(color: library.color, width: 2),
221                 ),
```
El borde normal (gris `#C9CDD6`, esquinas de radio 6) y el borde cuando el campo tiene el foco, es decir, cuando estás escribiendo (color de la librería y 2 píxeles de grosor).

### Los filtros (líneas 230–264)

```dart
231     return Wrap(
232       spacing: 8,
233       runSpacing: 8,
234       crossAxisAlignment: WrapCrossAlignment.center,
```
Otro `Wrap`: el control de nivel y las fichas, que bajan de línea si no caben.

```dart
236         Padding(
237           padding: const EdgeInsets.only(right: 8),
239           child: FittedBox(
240             fit: BoxFit.scaleDown,
241             child: _LevelSwitch(
242               basicCount: library.basic.length,
243               advancedCount: library.advanced.length,
244               showBasic: _showBasic,
245               onChanged: _selectLevel,
246             ),
247           ),
248         ),
```
El control "Básicas 43 | Avanzadas 36". El `Padding` le añade 8 píxeles a la derecha. `FittedBox` con `scaleDown` lo achica **solo** si no cabe; esto se agregó porque en un teléfono muy estrecho se salía 12 píxeles por la derecha. Los números se calculan con `.length`. Cuando se pulsa, se llama a `_selectLevel`.

```dart
249         _CategoryChip(
250           label: 'Todas',
251           selected: _category == null,
252           color: library.color,
253           onTap: () => setState(() => _category = null),
254         ),
```
La ficha "Todas". Está activa cuando `_category` es `null`, y al pulsarla vuelve a `null`.

```dart
255         for (final category in _categories)
256           _CategoryChip(
257             label: category,
258             selected: _category == category,
259             color: library.color,
260             onTap: () => setState(() => _category = category),
261           ),
```
Una ficha por cada categoría del nivel. Al pulsarla, esa categoría pasa a ser la elegida.

### El riel (líneas 267–332)

```dart
271 class _Rail extends StatelessWidget {
272   const _Rail({
273     required this.selected,
274     required this.horizontal,
275     required this.onSelect,
276   });
278   final int selected;
279   final bool horizontal;
280   final ValueChanged<int> onSelect;
```
El riel **no tiene estado propio**: recibe qué librería está elegida y avisa hacia arriba cuando se pulsa una. `ValueChanged<int>` es el tipo de una función que recibe un `int` y no devuelve nada. Así la pantalla (el padre) es la única dueña del estado.

```dart
284     final buttons = [
285       for (var i = 0; i < galleryLibraries.length; i++)
286         _RailButton(
287           key: ValueKey('libreria-$i'),
288           library: galleryLibraries[i],
289           selected: i == selected,
290           onTap: () => onSelect(i),
291         ),
292     ];
```
Crea un botón por librería. Cada uno tiene una `key` (`libreria-0`, `libreria-1`…) para las pruebas, sabe si está elegido (`i == selected`) y, al pulsarse, llama a `onSelect(i)`.

```dart
293     return Container(
294       key: const ValueKey('riel'),
295       color: GalleryColors.ink,
296       padding: EdgeInsets.all(horizontal ? 16 : 20),
```
Fondo oscuro `#161A23`, con 16 o 20 píxeles de margen interno según el modo.

```dart
300           const Text('Taller de gráficas', style: GalleryText.railTitle),
301           const SizedBox(height: 4),
302           Text(
303             '${galleryLibraries.length} librerías · $galleryTotal gráficas',
304             style: GalleryText.railSubtitle,
305           ),
```
El título y el subtítulo. Los dos números (4 y 316) **se calculan**: `galleryLibraries.length` y `galleryTotal`. `$galleryTotal` dentro del texto es una forma corta de `${galleryTotal}`.

```dart
306           SizedBox(height: horizontal ? 12 : 24),
307           if (horizontal)
308             SingleChildScrollView(
309               scrollDirection: Axis.horizontal,
310               child: Row(
311                 children: [
312                   for (final button in buttons)
313                     Padding(
314                       padding: const EdgeInsets.only(right: 8),
315                       child: SizedBox(width: 230, child: button),
316                     ),
317                 ],
318               ),
319             )
```
En pantalla estrecha, los botones van en una fila (`Row`) que se desplaza de lado (`SingleChildScrollView` horizontal). Cada botón mide 230 de ancho, con 8 de separación.

```dart
320           else
321             Expanded(
322               child: ListView.separated(
323                 itemCount: buttons.length,
324                 separatorBuilder: (_, _) => const SizedBox(height: 4),
325                 itemBuilder: (_, i) => buttons[i],
326               ),
327             ),
```
En pantalla ancha, una lista vertical (`ListView`) con 4 píxeles entre botones, ocupando el alto que sobra (`Expanded`).

### Botón de librería (líneas 334–391)

```dart
349     return Semantics(
350       selected: selected,
351       button: true,
```
`Semantics` describe el widget a los lectores de pantalla que usan las personas ciegas: "esto es un botón y está seleccionado".

```dart
352       child: Material(
353         color: selected ? GalleryColors.railSelected : Colors.transparent,
354         borderRadius: BorderRadius.circular(6),
355         child: InkWell(
356           borderRadius: BorderRadius.circular(6),
357           onTap: onTap,
```
`Material` pone el fondo (`#2B3142` si está elegido, transparente si no) y `InkWell` lo hace pulsable, con el efecto de onda al tocarlo.

```dart
358           child: ConstrainedBox(
359             constraints: const BoxConstraints(minHeight: 52),
360             child: Padding(
361               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
```
Alto mínimo de 52 píxeles y relleno interno.

```dart
362               child: Row(
363                 children: [
364                   Container(width: 12, height: 12, color: library.railColor),
365                   const SizedBox(width: 12),
```
Una fila que empieza con el cuadrado de color de 12 × 12.

```dart
366                   Expanded(
367                     child: Column(
368                       crossAxisAlignment: CrossAxisAlignment.start,
369                       mainAxisSize: MainAxisSize.min,
370                       children: [
371                         Text(library.name, style: GalleryText.railName),
372                         Text(
373                           library.package,
374                           maxLines: 1,
375                           overflow: TextOverflow.ellipsis,
376                           style: GalleryText.railPackage,
377                         ),
378                       ],
379                     ),
380                   ),
```
En medio, el nombre y debajo el paquete. `Expanded` hace que ocupen el espacio libre. Si el paquete no cabe (`syncfusion_flutter_charts`), se corta con "…" (`ellipsis`).

```dart
381                   const SizedBox(width: 8),
382                   Text('${library.total}', style: GalleryText.railCount),
```
A la derecha, el total de gráficas (79).

### Control "Básicas | Avanzadas" (líneas 393–466)

```dart
409     return Container(
410       height: 44,
411       decoration: BoxDecoration(
412         border: Border.all(color: GalleryColors.ink),
413         borderRadius: BorderRadius.circular(6),
414       ),
415       clipBehavior: Clip.antiAlias,
```
Una caja de 44 de alto con borde oscuro y radio 6. `clipBehavior` recorta lo de dentro para que el fondo negro del botón activo respete las esquinas redondeadas.

```dart
416       child: Row(
417         mainAxisSize: MainAxisSize.min,
418         children: [
419           _segment('nivel-basicas', 'Básicas', basicCount, showBasic, true),
420           _segment(
421             'nivel-avanzadas',
422             'Avanzadas',
423             advancedCount,
424             !showBasic,
425             false,
426           ),
427         ],
428       ),
```
Dos segmentos lado a lado. El de básicas está activo si `showBasic` es verdadero, y el de avanzadas si es falso (`!` niega).

```dart
432   Widget _segment(
433     String key,
434     String label,
435     int count,
436     bool active,
437     bool basic,
438   ) {
439     final foreground = active ? GalleryColors.surface : GalleryColors.ink;
```
Ayudante que crea un segmento. El color del texto es blanco si está activo y oscuro si no.

```dart
443       child: Material(
444         key: ValueKey(key),
445         color: active ? GalleryColors.ink : GalleryColors.surface,
446         child: InkWell(
447           onTap: () => onChanged(basic),
```
Fondo oscuro si está activo y blanco si no. Al pulsar avisa al padre con `true` (básicas) o `false` (avanzadas).

```dart
451               child: Text.rich(
452                 TextSpan(
453                   children: [
454                     TextSpan(text: '$label '),
455                     TextSpan(text: '$count', style: GalleryText.segmentCount),
456                   ],
457                 ),
458                 style: GalleryText.segment.copyWith(color: foreground),
459               ),
```
`Text.rich` permite mezclar estilos en un solo texto: "Básicas " en la fuente normal y "43" en la fuente monoespaciada (Mono).

### Ficha de categoría (líneas 468–515)

```dart
484     final shape = RoundedRectangleBorder(
485       borderRadius: BorderRadius.circular(22),
486       side: BorderSide(color: selected ? color : GalleryColors.fieldBorder),
487     );
```
La forma de píldora (radio 22, la mitad de 44). El borde es del color de la librería si está activa y gris si no.

```dart
491       child: Material(
492         color: selected ? color : GalleryColors.surface,
493         shape: shape,
494         child: InkWell(
495           customBorder: shape,
496           onTap: onTap,
```
Fondo de color o blanco. `customBorder` hace que la onda del toque respete la forma de píldora.

```dart
497           child: Container(
498             height: 44,
499             padding: const EdgeInsets.symmetric(horizontal: 16),
501             child: Center(
502               widthFactor: 1,
503               child: Text(
```
44 de alto y 16 de relleno lateral. `Center(widthFactor: 1)` centra el texto, pero mide solo lo que mide el texto. Un `Center` normal se estiraría a todo el ancho; así estaba al principio, y las fichas ocupaban toda la fila.

### Tarjeta (líneas 517–591)

```dart
526     return Material(
527       color: GalleryColors.surface,
528       clipBehavior: Clip.antiAlias,
529       shape: RoundedRectangleBorder(
530         borderRadius: BorderRadius.circular(6),
531         side: const BorderSide(color: GalleryColors.cardBorder),
532       ),
```
Tarjeta blanca con borde `#D8DBE2`, radio 6 y sin sombra.

```dart
533       child: InkWell(
534         onTap: () => Navigator.of(
535           context,
536         ).push(MaterialPageRoute<void>(builder: entry.open)),
```
Toda la tarjeta es pulsable. `Navigator.push` abre una página nueva encima de la actual, y el botón "atrás" la cierra. `entry.open` es el `WidgetBuilder` que preparó el catálogo para cada librería.

```dart
537         child: Column(
538           crossAxisAlignment: CrossAxisAlignment.stretch,
539           children: [
540             Container(
541               height: 104,
542               color: library.lightColor,
543               alignment: Alignment.center,
544               child: CustomPaint(
545                 size: const Size(150, 80),
546                 painter: GlyphPainter(glyph: entry.glyph, color: library.color),
547               ),
548             ),
```
La zona de arriba, de 104 de alto y con el fondo claro de la librería. En el centro, un `CustomPaint` de 150 × 80 que usa `GlyphPainter` para dibujar la miniatura en el color de la librería.

```dart
549             Expanded(
550               child: Padding(
551                 padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
```
La zona de abajo ocupa el resto del alto, con relleno de 12 arriba y 14 a los lados y abajo.

```dart
555                     Row(
556                       children: [
557                         Text(
558                           entry.number.toString().padLeft(2, '0'),
559                           style: GalleryText.cardMeta,
560                         ),
561                         const SizedBox(width: 8),
562                         Expanded(
563                           child: Text(
564                             entry.category,
565                             textAlign: TextAlign.right,
566                             maxLines: 1,
567                             overflow: TextOverflow.ellipsis,
568                             style: GalleryText.cardMeta,
569                           ),
570                         ),
571                       ],
572                     ),
```
La fila con el número a la izquierda y la categoría a la derecha. `padLeft(2, '0')` rellena con ceros a la izquierda hasta tener 2 cifras: 1 → "01".

```dart
573                     const SizedBox(height: 6),
574                     Flexible(
575                       child: Text(
576                         entry.displayTitle,
577                         maxLines: 2,
578                         overflow: TextOverflow.ellipsis,
579                         style: GalleryText.cardTitle,
580                       ),
581                     ),
```
El título, con un máximo de 2 líneas y "…" si es más largo. `displayTitle` es el título con la primera letra en mayúscula. `Flexible` evita un error de desborde si el texto no cabe en el alto disponible.

---

## 6. Pruebas

`flutter test`: **177 pruebas, todas en verde.**

| Archivo | Qué comprueba |
|---|---|
| `widget_test.dart` (8 pruebas, nuevo) | El riel muestra las cuatro librerías y "4 librerías · 316 gráficas". "Avanzadas" cambia la lista. Pulsar una tarjeta abre la gráfica. Las fichas filtran y el número es el de la lista original. La búsqueda ignora mayúsculas, muestra "Spline" con mayúscula y, si no hay coincidencias, muestra el mensaje. Cambiar de librería vuelve a "Todas". Se abre la primera gráfica de Syncfusion, Directed Graph y Financial Chart y se vuelve atrás. En pantalla estrecha el riel queda arriba. |
| `unified_gallery_test.dart` (5 pruebas, nuevo) | 43 + 36 por librería y 316 en total. Ninguna categoría vacía y números del 1 al n. Los títulos están en el mismo orden que las listas originales. Las categorías de Directed Graph coinciden con su campo `group`. Las 27 miniaturas se dibujan sin errores. |
| `all_charts_test.dart`, `no_duplicate_demos_test.dart`, `financial_charts_test.dart` | No se tocaron y siguen pasando. |

Detalle: las pruebas de pantalla usan una ventana de 1280 × 900. En las pruebas, Flutter usa una fuente especial que dibuja cada letra como un cuadrado, mucho más ancho que una letra real. Con la ventana por defecto (800 × 600), los filtros ocupaban casi todo el alto y las tarjetas quedaban fuera de vista.

`flutter analyze`: **sin errores.** Quedan 6 avisos (2 *warning* y 4 *info*) en `lib/charts_grafo/`. Ya estaban en la rama `feature/directed_graph` y no se corrigieron porque el plan prohíbe tocar el código de las gráficas.

---

## 7. Cómo probarlo tú

El comando `flutter` no está en tu PATH, así que hay que usar la ruta completa del SDK (o agregarlo al PATH):

```powershell
& "C:\Users\Luis Meza\Desktop\sdk-flutter\flutter\bin\flutter.bat" run -d windows
```

Revisa a mano:

- cambia entre las cuatro librerías;
- pasa a "Avanzadas";
- elige una categoría;
- busca un título;
- abre una gráfica de cada librería y vuelve atrás;
- estrecha la ventana a menos de 800 píxeles para ver el riel arriba.

Para subir la rama cuando la hayas revisado:

```bash
git push -u origin feature/galeria_unificada
```

(La rama se creó a partir de `origin/feature/fl_chart` y quedó "siguiendo" a esa rama remota. Se le quitó ese seguimiento para que un `git push` sin más no pueda apuntar a `feature/fl_chart` por error. El `-u` del comando de arriba le asigna como destino su propia rama remota.)
