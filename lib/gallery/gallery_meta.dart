// Categoría y miniatura de cada gráfica de la galería unificada.
//
// Cada lista va en el MISMO orden que la lista de gráficas de su librería:
//   fl_chart    -> HomeScreen.basicCharts / HomeScreen.advancedCharts (lib/main.dart)
//   syncfusion  -> basic / adv (lib/charts_gallery.dart)
//   directed    -> simpleCharts / advancedCharts (lib/charts_grafo/...)
//   financial   -> financialBasic / financialAdvanced (lib/financial_gallery.dart)
//
// El comentario de cada línea es el número y el título de la gráfica, para
// comprobar a simple vista que la posición coincide.

/// Tipo de miniatura que se dibuja en la tarjeta de una gráfica.
enum ChartGlyph {
  /// Una línea.
  line,
  /// Dos o más líneas.
  multi,
  /// Línea escalonada.
  step,
  /// Línea con área rellena.
  area,
  /// Áreas apiladas.
  stackArea,
  /// Barras verticales.
  bars,
  /// Barras horizontales.
  hbars,
  /// Barras apiladas.
  stack,
  /// Barras flotantes (rango, cascada, ladrillos).
  range,
  /// Pastel.
  pie,
  /// Dona o anillo.
  donut,
  /// Medidor semicircular.
  gauge,
  /// Puntos dispersos.
  scatter,
  /// Burbujas.
  bubble,
  /// Radar.
  radar,
  /// Velas.
  candle,
  /// Grafo de nodos y aristas.
  graph,
  /// Cuadrícula (mapa de calor, treemap, mosaico).
  matrix,
  /// Flujo tipo Sankey.
  flow,
  /// Embudo o pirámide.
  funnel,
  /// Cajas y bigotes.
  box,
  /// Línea dentro de una banda.
  band,
  /// Oscilador entre dos niveles.
  osc,
  /// Velas arriba y panel abajo.
  panels,
  /// Niveles horizontales con zigzag.
  levels,
  /// Sparklines.
  spark,
  /// Barras de Gantt.
  gantt,
}

/// Categoría (texto del filtro) y miniatura de una gráfica.
typedef ChartMeta = (String category, ChartGlyph glyph);

/// FL Chart · básicas (43).
const flBasicMeta = <ChartMeta>[
  ('Líneas', ChartGlyph.line), // 01 Línea simple
  ('Líneas', ChartGlyph.line), // 02 Línea curva
  ('Líneas', ChartGlyph.area), // 03 Línea con área debajo
  ('Líneas', ChartGlyph.area), // 04 Línea con área encima
  ('Líneas', ChartGlyph.line), // 05 Línea con degradado
  ('Líneas', ChartGlyph.line), // 06 Línea con puntos
  ('Líneas', ChartGlyph.line), // 07 Línea con formas de punto
  ('Líneas', ChartGlyph.line), // 08 Línea discontinua
  ('Líneas', ChartGlyph.line), // 09 Línea con grosor variable
  ('Líneas', ChartGlyph.multi), // 10 Línea con dos series
  ('Líneas', ChartGlyph.step), // 11 Línea escalonada
  ('Líneas', ChartGlyph.line), // 12 Línea con sombra
  ('Líneas', ChartGlyph.line), // 13 Línea con extremos redondeados
  ('Líneas', ChartGlyph.line), // 14 Línea sin rejilla
  ('Líneas', ChartGlyph.line), // 15 Línea con títulos de eje
  ('Barras', ChartGlyph.bars), // 16 Barras simples
  ('Barras', ChartGlyph.bars), // 17 Barras agrupadas
  ('Barras', ChartGlyph.stack), // 18 Barras apiladas
  ('Barras', ChartGlyph.hbars), // 19 Barras horizontales
  ('Barras', ChartGlyph.bars), // 20 Barras con esquinas redondeadas
  ('Barras', ChartGlyph.bars), // 21 Barras con barra de fondo
  ('Barras', ChartGlyph.bars), // 22 Barras con degradado
  ('Barras', ChartGlyph.bars), // 23 Barras con etiquetas
  ('Barras', ChartGlyph.bars), // 24 Barras con alineación espaciada
  ('Barras', ChartGlyph.bars), // 25 Barras con borde punteado
  ('Pastel', ChartGlyph.pie), // 26 Pastel simple
  ('Pastel', ChartGlyph.donut), // 27 Dona (centerSpaceRadius)
  ('Pastel', ChartGlyph.pie), // 28 Pastel con separación entre secciones
  ('Pastel', ChartGlyph.pie), // 29 Pastel con esquinas redondeadas
  ('Pastel', ChartGlyph.pie), // 30 Pastel con inicio rotado (45°)
  ('Pastel', ChartGlyph.pie), // 31 Pastel con radios variables
  ('Pastel', ChartGlyph.pie), // 32 Pastel con títulos rotados
  ('Pastel', ChartGlyph.pie), // 33 Pastel con bordes
  ('Pastel', ChartGlyph.pie), // 34 Pastel sin títulos
  ('Dispersión', ChartGlyph.scatter), // 35 Dispersión simple
  ('Dispersión', ChartGlyph.scatter), // 36 Dispersión con formas
  ('Dispersión', ChartGlyph.scatter), // 37 Dispersión con ejes personalizados
  ('Radar', ChartGlyph.radar), // 38 Radar circular
  ('Radar', ChartGlyph.radar), // 39 Radar poligonal
  ('Radar', ChartGlyph.radar), // 40 Radar con rejilla y marcas
  ('Radar', ChartGlyph.radar), // 41 Radar con dos series
  ('Velas', ChartGlyph.candle), // 42 Velas (candlestick) básico
  ('Velas', ChartGlyph.candle), // 43 Velas con ejes personalizados
];

/// FL Chart · avanzadas (36).
const flAdvancedMeta = <ChartMeta>[
  ('Líneas', ChartGlyph.band), // 01 Línea con bandas entre series
  ('Líneas', ChartGlyph.line), // 02 Línea con línea horizontal
  ('Líneas', ChartGlyph.line), // 03 Línea con línea vertical
  ('Líneas', ChartGlyph.line), // 04 Línea con rango horizontal
  ('Líneas', ChartGlyph.line), // 05 Línea con rango vertical
  ('Líneas', ChartGlyph.line), // 06 Línea con indicadores de puntos
  ('Líneas', ChartGlyph.line), // 07 Línea con dos tooltips fijos
  ('Líneas', ChartGlyph.line), // 08 Línea con tooltip personalizado
  ('Líneas', ChartGlyph.line), // 09 Línea con indicador táctil
  ('Líneas', ChartGlyph.area), // 10 Línea con área de corte
  ('Líneas', ChartGlyph.line), // 11 Línea con barras de error
  ('Líneas', ChartGlyph.line), // 12 Línea con puntos resaltados
  ('Líneas', ChartGlyph.line), // 13 Línea con rejilla personalizada
  ('Barras', ChartGlyph.bars), // 14 Barras con rango de error
  ('Barras', ChartGlyph.stack), // 15 Barras apiladas con etiquetas
  ('Barras', ChartGlyph.stack), // 16 Tooltip sobre segmento apilado
  ('Barras', ChartGlyph.bars), // 17 Barras con valores negativos
  ('Barras', ChartGlyph.bars), // 18 Etiqueta rotada en la barra
  ('Barras', ChartGlyph.bars), // 19 Tooltip fijo con contenido propio
  ('Barras', ChartGlyph.bars), // 20 Selección de barra al tocar
  ('Barras', ChartGlyph.bars), // 21 Títulos de eje con widgets
  ('Barras', ChartGlyph.bars), // 22 Barras con animación de datos
  ('Pastel', ChartGlyph.pie), // 23 Sección que crece al tocar
  ('Pastel', ChartGlyph.pie), // 24 Pastel con degradados
  ('Pastel', ChartGlyph.pie), // 25 Pastel con insignias (badges)
  ('Dispersión', ChartGlyph.scatter), // 26 Dispersión con barras de error
  ('Dispersión', ChartGlyph.scatter), // 27 Tooltip manual en dispersión
  ('Dispersión', ChartGlyph.scatter), // 28 Etiquetas en dispersión
  ('Dispersión', ChartGlyph.scatter), // 29 Prioridad de punto y toque
  ('Radar', ChartGlyph.radar), // 30 Radar con múltiples series
  ('Radar', ChartGlyph.radar), // 31 Radar con relleno degradado
  ('Radar', ChartGlyph.radar), // 32 Radar con punto tocado
  ('Radar', ChartGlyph.radar), // 33 Radar con títulos personalizados
  ('Velas', ChartGlyph.candle), // 34 Velas con tooltip personalizado
  ('Velas', ChartGlyph.candle), // 35 Indicador de punto personalizado
  ('Velas', ChartGlyph.candle), // 36 Velas con anotaciones de rango
];

/// Syncfusion Charts · básicas (43).
const syncBasicMeta = <ChartMeta>[
  ('Líneas', ChartGlyph.line), // 01 Línea
  ('Líneas', ChartGlyph.line), // 02 Línea con marcadores
  ('Líneas', ChartGlyph.line), // 03 Línea punteada
  ('Líneas', ChartGlyph.line), // 04 spline
  ('Líneas', ChartGlyph.multi), // 05 spline múltiple
  ('Líneas', ChartGlyph.step), // 06 Línea escalonada
  ('Líneas', ChartGlyph.line), // 07 Línea rápida
  ('Columnas y barras', ChartGlyph.bars), // 08 columnas
  ('Columnas y barras', ChartGlyph.bars), // 09 columnas redondeadas
  ('Columnas y barras', ChartGlyph.bars), // 10 columnas con etiquetas
  ('Columnas y barras', ChartGlyph.bars), // 11 columnas agrupadas
  ('Columnas y barras', ChartGlyph.hbars), // 12 Barras horizontales
  ('Columnas y barras', ChartGlyph.hbars), // 13 Barras con pista
  ('Áreas', ChartGlyph.area), // 14 Área
  ('Áreas', ChartGlyph.area), // 15 Área con degradado
  ('Áreas', ChartGlyph.area), // 16 spline area
  ('Áreas', ChartGlyph.area), // 17 Step area
  ('Áreas', ChartGlyph.stackArea), // 18 Áreas superpuestas
  ('Dispersión', ChartGlyph.scatter), // 19 Dispersión
  ('Dispersión', ChartGlyph.scatter), // 20 Dispersión por formas
  ('Dispersión', ChartGlyph.bubble), // 21 burbujas
  ('Apiladas', ChartGlyph.stack), // 22 columnas apiladas
  ('Apiladas', ChartGlyph.stack), // 23 Barras apiladas
  ('Apiladas', ChartGlyph.stackArea), // 24 Área apilada
  ('Apiladas', ChartGlyph.multi), // 25 Línea apilada
  ('Apiladas', ChartGlyph.stack), // 26 columnas apiladas 100%
  ('Apiladas', ChartGlyph.stack), // 27 Barras apiladas 100%
  ('Apiladas', ChartGlyph.stackArea), // 28 Área apilada 100%
  ('Apiladas', ChartGlyph.multi), // 29 Línea apilada 100%
  ('Rango y financieras', ChartGlyph.range), // 30 columnas de rango
  ('Rango y financieras', ChartGlyph.band), // 31 Área de rango
  ('Rango y financieras', ChartGlyph.band), // 32 spline de rango
  ('Rango y financieras', ChartGlyph.candle), // 33 Velas japonesas
  ('Rango y financieras', ChartGlyph.candle), // 34 OHLC
  ('Rango y financieras', ChartGlyph.range), // 35 hilo
  ('Estadísticas', ChartGlyph.range), // 36 cascada
  ('Estadísticas', ChartGlyph.bars), // 37 histograma
  ('Estadísticas', ChartGlyph.box), // 38 Caja y bigotes
  ('Circulares y embudos', ChartGlyph.pie), // 39 pastel
  ('Circulares y embudos', ChartGlyph.donut), // 40 dona
  ('Circulares y embudos', ChartGlyph.gauge), // 41 Barra radial
  ('Circulares y embudos', ChartGlyph.funnel), // 42 Pirámide
  ('Circulares y embudos', ChartGlyph.funnel), // 43 embudo
];

/// Syncfusion Charts · avanzadas (36).
const syncAdvancedMeta = <ChartMeta>[
  ('Interacción', ChartGlyph.line), // 01 Zoom y desplazamiento
  ('Interacción', ChartGlyph.multi), // 02 Trackball agrupado
  ('Interacción', ChartGlyph.line), // 03 crosshair
  ('Interacción', ChartGlyph.bars), // 04 Selección de columnas
  ('Análisis', ChartGlyph.scatter), // 05 Tendencia lineal
  ('Análisis', ChartGlyph.scatter), // 06 Tendencia polinómica
  ('Análisis', ChartGlyph.multi), // 07 Media móvil
  ('Ejes', ChartGlyph.bars), // 08 Eje secundario
  ('Ejes', ChartGlyph.area), // 09 Combinación
  ('Ejes', ChartGlyph.line), // 10 Eje logarítmico
  ('Ejes', ChartGlyph.line), // 11 Ventana de fechas
  ('Ejes', ChartGlyph.hbars), // 12 Gráfica transpuesta
  ('Anotación', ChartGlyph.band), // 13 Bandas de trazado
  ('Anotación', ChartGlyph.line), // 14 anotaciones
  ('Análisis', ChartGlyph.scatter), // 15 Barras de error
  ('Análisis', ChartGlyph.line), // 16 Datos faltantes
  ('Interacción', ChartGlyph.line), // 17 Tiempo real
  ('Columnas y líneas', ChartGlyph.stack), // 18 Apiladas agrupadas
  ('Columnas y líneas', ChartGlyph.bars), // 19 columnas solapadas
  ('Columnas y líneas', ChartGlyph.bars), // 20 columnas con degradado
  ('Columnas y líneas', ChartGlyph.line), // 21 Línea por segmentos
  ('Ejes', ChartGlyph.multi), // 22 Tres ejes Y
  ('Circulares y embudos', ChartGlyph.pie), // 23 pastel explotado
  ('Circulares y embudos', ChartGlyph.donut), // 24 dona con total central
  ('Circulares y embudos', ChartGlyph.gauge), // 25 Medidor semicircular
  ('Circulares y embudos', ChartGlyph.donut), // 26 Anillos radiales
  ('Circulares y embudos', ChartGlyph.donut), // 27 dona doble
  ('Circulares y embudos', ChartGlyph.pie), // 28 pastel agrupado
  ('Circulares y embudos', ChartGlyph.funnel), // 29 Pirámide con superficie
  ('Circulares y embudos', ChartGlyph.funnel), // 30 embudo estilizado
  ('Sparklines', ChartGlyph.spark), // 31 Sparkline de línea
  ('Sparklines', ChartGlyph.spark), // 32 Sparkline de área
  ('Sparklines', ChartGlyph.spark), // 33 Sparkline de barras
  ('Sparklines', ChartGlyph.spark), // 34 Sparkline ganar/perder
  ('Sparklines', ChartGlyph.spark), // 35 Panel de KPIs
  ('Financieras', ChartGlyph.candle), // 36 Velas + media + zoom
];

/// Directed Graph · básicas (43).
const directedBasicMeta = <ChartMeta>[
  ('Vistas del grafo', ChartGlyph.graph), // 01 Grafo dirigido básico
  ('Vistas del grafo', ChartGlyph.graph), // 02 Grafo con pesos
  ('Vistas del grafo', ChartGlyph.graph), // 03 Camino más corto
  ('Vistas del grafo', ChartGlyph.graph), // 04 Camino más ligero
  ('Vistas del grafo', ChartGlyph.graph), // 05 Camino más pesado
  ('Vistas del grafo', ChartGlyph.graph), // 06 Alcanzables desde un vértice
  ('Vistas del grafo', ChartGlyph.graph), // 07 Cerradura transitiva
  ('Vistas del grafo', ChartGlyph.bars), // 08 Aristas ordenadas por peso
  ('Vistas del grafo', ChartGlyph.graph), // 09 Antes y después de actualizar un peso
  ('Vistas del grafo', ChartGlyph.graph), // 10 Grafo con barras de grado
  ('Barras y líneas', ChartGlyph.bars), // 11 Barras: grado de salida
  ('Barras y líneas', ChartGlyph.bars), // 12 Barras: grado de entrada
  ('Barras y líneas', ChartGlyph.hbars), // 13 Barras horizontales: peso saliente
  ('Barras y líneas', ChartGlyph.bars), // 14 Barras agrupadas: entrada vs. salida
  ('Barras y líneas', ChartGlyph.stack), // 15 Barras apiladas: peso por arista
  ('Barras y líneas', ChartGlyph.stack), // 16 Barras apiladas 100%
  ('Barras y líneas', ChartGlyph.bars), // 17 Barras con negativos
  ('Barras y líneas', ChartGlyph.line), // 18 Línea: peso acumulado
  ('Barras y líneas', ChartGlyph.multi), // 19 Líneas múltiples: tres caminos
  ('Barras y líneas', ChartGlyph.step), // 20 Línea escalonada
  ('Barras y líneas', ChartGlyph.area), // 21 Área del peso acumulado
  ('Barras y líneas', ChartGlyph.stackArea), // 22 Área apilada: entrante + saliente
  ('Barras y líneas', ChartGlyph.bars), // 23 Lollipop: peso por arista
  ('Distribución y relación', ChartGlyph.scatter), // 24 Dispersión: grado vs. peso
  ('Distribución y relación', ChartGlyph.bubble), // 25 Burbujas: grado, peso y alcance
  ('Distribución y relación', ChartGlyph.bars), // 26 Histograma de pesos
  ('Distribución y relación', ChartGlyph.line), // 27 Polígono de frecuencias
  ('Distribución y relación', ChartGlyph.hbars), // 28 Dumbbell: antes y después
  ('Distribución y relación', ChartGlyph.spark), // 29 Sparkline por vértice
  ('Distribución y relación', ChartGlyph.radar), // 30 Radar de métricas
  ('Distribución y relación', ChartGlyph.range), // 31 Cascada del peso de un camino
  ('Distribución y relación', ChartGlyph.matrix), // 32 Pictograma: aristas por vértice
  ('Distribución y relación', ChartGlyph.funnel), // 33 Embudo: alcance por saltos
  ('Proporciones y mapas', ChartGlyph.pie), // 34 Pastel: alcanzables vs. no alcanzables
  ('Proporciones y mapas', ChartGlyph.donut), // 35 Dona: aristas por vértice origen
  ('Proporciones y mapas', ChartGlyph.gauge), // 36 Gauge: densidad del grafo
  ('Proporciones y mapas', ChartGlyph.donut), // 37 Progreso circular: alcanzabilidad
  ('Proporciones y mapas', ChartGlyph.matrix), // 38 Treemap: peso por vértice
  ('Proporciones y mapas', ChartGlyph.matrix), // 39 Mapa de calor: matriz de adyacencia
  ('Combinadas', ChartGlyph.bars), // 40 Pareto: pesos + acumulado
  ('Combinadas', ChartGlyph.bars), // 41 Histograma + curva de densidad
  ('Combinadas', ChartGlyph.scatter), // 42 Dispersión + recta de regresión
  ('Combinadas', ChartGlyph.bars), // 43 Barras de grado + promedio
];

/// Directed Graph · avanzadas (36).
const directedAdvancedMeta = <ChartMeta>[
  ('Algoritmos sobre el grafo', ChartGlyph.graph), // 01 Orden topológico en capas
  ('Algoritmos sobre el grafo', ChartGlyph.graph), // 02 Ciclos resaltados
  ('Algoritmos sobre el grafo', ChartGlyph.graph), // 03 Componentes fuertemente conexas
  ('Algoritmos sobre el grafo', ChartGlyph.gantt), // 04 Gantt de dependencias
  ('Algoritmos sobre el grafo', ChartGlyph.gantt), // 05 Ruta crítica sobre el Gantt
  ('Algoritmos sobre el grafo', ChartGlyph.graph), // 06 Camino más corto animado
  ('Algoritmos sobre el grafo', ChartGlyph.graph), // 07 Frontera de exploración tipo Dijkstra
  ('Algoritmos sobre el grafo', ChartGlyph.graph), // 08 Editor interactivo
  ('Layouts', ChartGlyph.graph), // 09 Layout de fuerzas
  ('Layouts', ChartGlyph.graph), // 10 Layout por capas
  ('Layouts', ChartGlyph.graph), // 11 Árbol de expansión
  ('Layouts', ChartGlyph.graph), // 12 Diagrama de flujo de proceso
  ('Flujo y jerarquía', ChartGlyph.flow), // 13 Sankey de pesos
  ('Flujo y jerarquía', ChartGlyph.donut), // 14 Diagrama de cuerdas
  ('Flujo y jerarquía', ChartGlyph.donut), // 15 Sunburst por saltos
  ('Flujo y jerarquía', ChartGlyph.matrix), // 16 Treemap jerárquico
  ('Flujo y jerarquía', ChartGlyph.stackArea), // 17 Streamgraph por saltos
  ('Estadísticas', ChartGlyph.box), // 18 Boxplot de pesos
  ('Estadísticas', ChartGlyph.box), // 19 Violín de pesos
  ('Estadísticas', ChartGlyph.multi), // 20 Coordenadas paralelas
  ('Estadísticas', ChartGlyph.scatter), // 21 Matriz de dispersión
  ('Estadísticas', ChartGlyph.matrix), // 22 Mapa de calor de distancias
  ('Estadísticas', ChartGlyph.matrix), // 23 Matriz de adyacencia reordenada
  ('Interactivas', ChartGlyph.graph), // 24 Dashboard sincronizado
  ('Interactivas', ChartGlyph.graph), // 25 Zoom y desplazamiento
  ('Interactivas', ChartGlyph.graph), // 26 Tiempo real
  ('Combinadas', ChartGlyph.graph), // 27 Ciclos + componentes fuertes
  ('Combinadas', ChartGlyph.gantt), // 28 Capas + ruta crítica
  ('Combinadas', ChartGlyph.flow), // 29 Sankey + cuerdas
  ('Combinadas', ChartGlyph.donut), // 30 Sunburst + treemap
  ('Combinadas', ChartGlyph.graph), // 31 Fuerzas + árbol de expansión
  ('Combinadas', ChartGlyph.box), // 32 Boxplot + violín
  ('Combinadas', ChartGlyph.multi), // 33 Paralelas + matriz de dispersión
  ('Combinadas', ChartGlyph.stackArea), // 34 Streamgraph + distancias
  ('Combinadas', ChartGlyph.gantt), // 35 Flujo de proceso + Gantt
  ('Combinadas', ChartGlyph.graph), // 36 Orden topológico + sunburst
];

/// Financial Chart · básicas (43).
const financialBasicMeta = <ChartMeta>[
  ('Precio', ChartGlyph.candle), // 01 Velas Heikin-Ashi
  ('Precio', ChartGlyph.candle), // 02 Velas huecas
  ('Precio', ChartGlyph.area), // 03 Línea base bicolor
  ('Precio', ChartGlyph.line), // 04 Último precio marcado en los ejes
  ('Precio', ChartGlyph.range), // 05 Ladrillos Renko
  ('Superposiciones', ChartGlyph.multi), // 06 Cruce de medias con señales
  ('Superposiciones', ChartGlyph.multi), // 07 Cinta de medias exponenciales
  ('Superposiciones', ChartGlyph.multi), // 08 SMA, EMA y WMA
  ('Superposiciones', ChartGlyph.multi), // 09 VWAP
  ('Superposiciones', ChartGlyph.band), // 10 Bandas de Bollinger
  ('Superposiciones', ChartGlyph.band), // 11 Canal de Keltner
  ('Superposiciones', ChartGlyph.band), // 12 Canal de Donchian
  ('Superposiciones', ChartGlyph.band), // 13 Envolventes
  ('Superposiciones', ChartGlyph.band), // 14 Nube de Ichimoku
  ('Superposiciones', ChartGlyph.scatter), // 15 Parabolic SAR
  ('Superposiciones', ChartGlyph.area), // 16 SuperTrend
  ('Superposiciones', ChartGlyph.line), // 17 ZigZag
  ('Superposiciones', ChartGlyph.levels), // 18 Puntos pivote
  ('Volumen', ChartGlyph.bars), // 19 Volumen por dirección
  ('Volumen', ChartGlyph.bars), // 20 Volumen con media y picos
  ('Volumen', ChartGlyph.line), // 21 OBV
  ('Volumen', ChartGlyph.area), // 22 Acumulación / distribución
  ('Volumen', ChartGlyph.bars), // 23 Chaikin Money Flow
  ('Osciladores', ChartGlyph.osc), // 24 RSI con zonas
  ('Osciladores', ChartGlyph.osc), // 25 Oscilador estocástico
  ('Osciladores', ChartGlyph.bars), // 26 MACD
  ('Osciladores', ChartGlyph.osc), // 27 CCI
  ('Osciladores', ChartGlyph.osc), // 28 Williams %R
  ('Osciladores', ChartGlyph.osc), // 29 ROC
  ('Osciladores', ChartGlyph.line), // 30 ATR
  ('Osciladores', ChartGlyph.multi), // 31 ADX con +DI y −DI
  ('Osciladores', ChartGlyph.multi), // 32 Aroon
  ('Osciladores', ChartGlyph.osc), // 33 MFI
  ('Osciladores', ChartGlyph.bars), // 34 Awesome Oscillator
  ('Riesgo', ChartGlyph.multi), // 35 Volatilidad histórica
  ('Riesgo', ChartGlyph.area), // 36 Drawdown
  ('Riesgo', ChartGlyph.multi), // 37 Rendimiento relativo
  ('Dibujo', ChartGlyph.levels), // 38 Retroceso de Fibonacci
  ('Dibujo', ChartGlyph.levels), // 39 Abanico de Fibonacci
  ('Dibujo', ChartGlyph.levels), // 40 Arcos de Fibonacci
  ('Dibujo', ChartGlyph.levels), // 41 Zonas temporales de Fibonacci
  ('Dibujo', ChartGlyph.line), // 42 Línea de tendencia con estadísticas
  ('Dibujo', ChartGlyph.levels), // 43 Soportes y resistencias
];

/// Financial Chart · avanzadas (36).
const financialAdvancedMeta = <ChartMeta>[
  ('Paneles', ChartGlyph.panels), // 01 Velas y volumen con divisor
  ('Paneles', ChartGlyph.panels), // 02 Velas, RSI y MACD
  ('Paneles', ChartGlyph.panels), // 03 Terminal en tema oscuro
  ('Paneles', ChartGlyph.panels), // 04 Ichimoku con ADX y volumen
  ('Paneles', ChartGlyph.panels), // 05 Bollinger con %B y ancho
  ('Paneles', ChartGlyph.panels), // 06 Precio y volumen con dos escalas
  ('Paneles', ChartGlyph.multi), // 07 Lineal frente a logarítmica
  ('Paneles', ChartGlyph.candle), // 08 Ejes interiores y dobles
  ('Segmentadores', ChartGlyph.candle), // 09 Segmentador de tipo de precio
  ('Segmentadores', ChartGlyph.band), // 10 Superposiciones combinables
  ('Segmentadores', ChartGlyph.osc), // 11 Segmentador de oscilador
  ('Segmentadores', ChartGlyph.panels), // 12 Constructor de paneles
  ('Segmentadores', ChartGlyph.candle), // 13 Segmentador de periodo
  ('Segmentadores', ChartGlyph.candle), // 14 Tema y paleta de velas
  ('Segmentadores', ChartGlyph.panels), // 15 Matriz de combinaciones
  ('Interacción', ChartGlyph.candle), // 16 Tooltip con widgets de Flutter
  ('Interacción', ChartGlyph.line), // 17 Retícula con puntos resaltados
  ('Interacción', ChartGlyph.candle), // 18 Tocar para anotar
  ('Interacción', ChartGlyph.candle), // 19 Zoom por selección en el eje
  ('Interacción', ChartGlyph.line), // 20 Medir entre dos toques
  ('Interacción', ChartGlyph.candle), // 21 Exportar como imagen
  ('Datos', ChartGlyph.candle), // 22 Mercado en vivo
  ('Datos', ChartGlyph.candle), // 23 Carga de historial bajo demanda
  ('Datos', ChartGlyph.panels), // 24 Dos activos sincronizados
  ('Datos', ChartGlyph.matrix), // 25 Mosaico de cuatro activos
  ('Datos', ChartGlyph.multi), // 26 Simulación Monte Carlo
  ('Análisis', ChartGlyph.panels), // 27 Estrategia con curva de capital
  ('Análisis', ChartGlyph.panels), // 28 Divergencia entre precio y RSI
  ('Análisis', ChartGlyph.levels), // 29 Herramientas de Fibonacci combinables
  ('Análisis', ChartGlyph.band), // 30 Canal de regresión lineal
  ('Análisis', ChartGlyph.multi), // 31 Comparación de dos activos
  ('Análisis', ChartGlyph.osc), // 32 Trading de pares
  ('Análisis', ChartGlyph.candle), // 33 Eventos corporativos
  ('Análisis', ChartGlyph.line), // 34 Meses sombreados
  ('Análisis', ChartGlyph.hbars), // 35 Perfil de volumen por precio
  ('Análisis', ChartGlyph.panels), // 36 Panel de riesgo
];
