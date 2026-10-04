// Galería de gráficas hechas con la librería financial_chart.
//
// Cada entrada del catálogo trae su título, qué muestra y en qué se
// diferencia de las gráficas equivalentes de las otras librerías del taller.
import 'package:flutter/material.dart';

import 'charts_financial/advanced/a01_velas_volumen.dart';
import 'charts_financial/advanced/a02_velas_rsi_macd.dart';
import 'charts_financial/advanced/a03_terminal_oscura.dart';
import 'charts_financial/advanced/a04_ichimoku_adx_volumen.dart';
import 'charts_financial/advanced/a05_bollinger_b_ancho.dart';
import 'charts_financial/advanced/a06_doble_escala.dart';
import 'charts_financial/advanced/a07_lineal_logaritmica.dart';
import 'charts_financial/advanced/a08_ejes_interiores.dart';
import 'charts_financial/advanced/a09_selector_tipo_precio.dart';
import 'charts_financial/advanced/a10_selector_superposiciones.dart';
import 'charts_financial/advanced/a11_selector_oscilador.dart';
import 'charts_financial/advanced/a12_constructor_paneles.dart';
import 'charts_financial/advanced/a13_selector_periodo.dart';
import 'charts_financial/advanced/a14_tema_estilo.dart';
import 'charts_financial/advanced/a15_matriz_combinaciones.dart';
import 'charts_financial/advanced/a16_tooltip_widget.dart';
import 'charts_financial/advanced/a17_crosshair_resaltado.dart';
import 'charts_financial/advanced/a18_tocar_anotar.dart';
import 'charts_financial/advanced/a19_zoom_seleccion.dart';
import 'charts_financial/advanced/a20_medir_toques.dart';
import 'charts_financial/advanced/a21_exportar_imagen.dart';
import 'charts_financial/advanced/a22_mercado_vivo.dart';
import 'charts_financial/advanced/a23_carga_historial.dart';
import 'charts_financial/advanced/a24_graficos_sincronizados.dart';
import 'charts_financial/advanced/a25_mosaico_activos.dart';
import 'charts_financial/advanced/a26_monte_carlo.dart';
import 'charts_financial/advanced/a27_estrategia_capital.dart';
import 'charts_financial/advanced/a28_divergencia_rsi.dart';
import 'charts_financial/advanced/a29_fibonacci_completo.dart';
import 'charts_financial/advanced/a30_canal_regresion.dart';
import 'charts_financial/advanced/a31_comparacion_spread.dart';
import 'charts_financial/advanced/a32_pares_zscore.dart';
import 'charts_financial/advanced/a33_eventos_corporativos.dart';
import 'charts_financial/advanced/a34_meses_sombreados.dart';
import 'charts_financial/advanced/a35_perfil_volumen.dart';
import 'charts_financial/advanced/a36_panel_riesgo.dart';
import 'charts_financial/basic/b01_heikin_ashi.dart';
import 'charts_financial/basic/b02_velas_huecas.dart';
import 'charts_financial/basic/b03_linea_base.dart';
import 'charts_financial/basic/b04_ultimo_precio_eje.dart';
import 'charts_financial/basic/b05_renko.dart';
import 'charts_financial/basic/b06_cruce_medias.dart';
import 'charts_financial/basic/b07_cinta_emas.dart';
import 'charts_financial/basic/b08_sma_ema_wma.dart';
import 'charts_financial/basic/b09_vwap.dart';
import 'charts_financial/basic/b10_bollinger.dart';
import 'charts_financial/basic/b11_keltner.dart';
import 'charts_financial/basic/b12_donchian.dart';
import 'charts_financial/basic/b13_envolventes.dart';
import 'charts_financial/basic/b14_ichimoku.dart';
import 'charts_financial/basic/b15_parabolic_sar.dart';
import 'charts_financial/basic/b16_supertrend.dart';
import 'charts_financial/basic/b17_zigzag.dart';
import 'charts_financial/basic/b18_puntos_pivote.dart';
import 'charts_financial/basic/b19_volumen_direccion.dart';
import 'charts_financial/basic/b20_volumen_media.dart';
import 'charts_financial/basic/b21_obv.dart';
import 'charts_financial/basic/b22_acumulacion_distribucion.dart';
import 'charts_financial/basic/b23_chaikin.dart';
import 'charts_financial/basic/b24_rsi.dart';
import 'charts_financial/basic/b25_estocastico.dart';
import 'charts_financial/basic/b26_macd.dart';
import 'charts_financial/basic/b27_cci.dart';
import 'charts_financial/basic/b28_williams_r.dart';
import 'charts_financial/basic/b29_roc.dart';
import 'charts_financial/basic/b30_atr.dart';
import 'charts_financial/basic/b31_adx.dart';
import 'charts_financial/basic/b32_aroon.dart';
import 'charts_financial/basic/b33_mfi.dart';
import 'charts_financial/basic/b34_awesome.dart';
import 'charts_financial/basic/b35_volatilidad.dart';
import 'charts_financial/basic/b36_drawdown.dart';
import 'charts_financial/basic/b37_rendimiento_relativo.dart';
import 'charts_financial/basic/b38_fibonacci_retroceso.dart';
import 'charts_financial/basic/b39_fibonacci_abanico.dart';
import 'charts_financial/basic/b40_fibonacci_arcos.dart';
import 'charts_financial/basic/b41_fibonacci_tiempo.dart';
import 'charts_financial/basic/b42_tendencia_estadisticas.dart';
import 'charts_financial/basic/b43_soportes_resistencias.dart';

/// Una gráfica del catálogo.
class FcEntry {
  const FcEntry(this.title, this.subtitle, this.diff, this.builder);

  /// Nombre de la gráfica.
  final String title;

  /// Qué muestra, en una línea.
  final String subtitle;

  /// En qué se diferencia de las otras librerías del taller.
  final String diff;

  /// Función que crea el widget de la gráfica.
  final Widget Function() builder;
}

const financialBasic = <FcEntry>[
  FcEntry(
    'Velas Heikin-Ashi',
    'Velas suavizadas: cada una se promedia con la anterior.',
    'Las velas de fl_chart y Syncfusion dibujan el precio tal cual. Aquí la librería recibe una serie transformada y las rachas quedan de un solo color.',
    b01HeikinAshi,
  ),
  FcEntry(
    'Velas huecas',
    'Alcistas solo con borde, bajistas rellenas.',
    'Ninguna otra librería del taller distingue la dirección por el relleno. Se logra con el tema de la serie OHLC, sin tocar los datos.',
    b02VelasHuecas,
  ),
  FcEntry(
    'Línea base bicolor',
    'Área verde sobre el precio medio y roja por debajo.',
    'Las áreas de las otras librerías usan un solo color. GGraphArea cambia de estilo al cruzar el valor base.',
    b03LineaBase,
  ),
  FcEntry(
    'Último precio marcado en los ejes',
    'Etiqueta del último cierre y rango reciente sobre los propios ejes.',
    'Los marcadores de eje (GValueAxisMarker y GPointAxisMarker) no existen en las otras librerías: allí las anotaciones van dentro del área de dibujo.',
    b04UltimoPrecioEje,
  ),
  FcEntry(
    'Ladrillos Renko',
    'Un ladrillo por cada avance del 2 %, sin importar el tiempo.',
    'El eje horizontal deja de ser el tiempo y pasa a ser el número de ladrillo. Se arma con barras flotantes de GGraphStackedBar.',
    b05Renko,
  ),
  FcEntry(
    'Cruce de medias con señales',
    'SMA 20 y SMA 50 con triángulos de compra y venta en cada cruce.',
    'La media móvil de Syncfusion es una sola serie. Aquí son dos y cada cruce se marca con un GShapeMarker anclado a su barra.',
    b06CruceMedias,
  ),
  FcEntry(
    'Cinta de medias exponenciales',
    'Siete EMAs de periodos crecientes en degradado.',
    'Las líneas múltiples de las otras librerías son series independientes. Aquí las siete salen del mismo precio y juntas forman un indicador.',
    b07CintaEmas,
  ),
  FcEntry(
    'SMA, EMA y WMA',
    'Tres formas de promediar el mismo periodo.',
    'Compara métodos de cálculo sobre un mismo dato, no series distintas: se ve cuál reacciona antes al precio.',
    b08SmaEmaWma,
  ),
  FcEntry(
    'VWAP',
    'Precio medio ponderado por volumen, con relleno contra el cierre.',
    'Usa dos series (precio y volumen) para calcular una tercera. El relleno entre cierre y VWAP cambia de color al cruzarse.',
    b09Vwap,
  ),
  FcEntry(
    'Bandas de Bollinger',
    'Media de 20 con una banda de ±2 desviaciones.',
    'El área de rango de Syncfusion recibe máximo y mínimo ya dados. Aquí la banda se calcula del precio y se dibuja bajo las velas.',
    b10Bollinger,
  ),
  FcEntry(
    'Canal de Keltner',
    'EMA 20 ± 2 ATR sobre barras OHLC.',
    'El ancho del canal depende del rango verdadero de cada barra. No hay un canal equivalente en las otras librerías.',
    b11Keltner,
  ),
  FcEntry(
    'Canal de Donchian',
    'Máximo y mínimo de las últimas 20 barras.',
    'La forma escalonada sale del cálculo (máximos y mínimos móviles), no de un tipo de línea escalonada como en fl_chart o Syncfusion.',
    b12Donchian,
  ),
  FcEntry(
    'Envolventes',
    'Dos bandas concéntricas a ±3 % y ±6 % de la media.',
    'Las áreas apiladas de las otras librerías suman valores. Estas son dos áreas entre series, una dentro de otra.',
    b13Envolventes,
  ),
  FcEntry(
    'Nube de Ichimoku',
    'Conversión, base y la nube entre los dos spans.',
    'Indicador de varios componentes con una nube que cambia de color. No tiene equivalente en fl_chart, Syncfusion ni directed_graph.',
    b14Ichimoku,
  ),
  FcEntry(
    'Parabolic SAR',
    'Puntos de stop que saltan de lado cuando gira la tendencia.',
    'La dispersión de las otras librerías muestra datos sueltos. Aquí los puntos son una serie calculada que sigue al precio barra a barra.',
    b15ParabolicSar,
  ),
  FcEntry(
    'SuperTrend',
    'Stop dinámico con relleno verde o rojo según la tendencia.',
    'El color lo decide la posición del precio frente al stop, no un umbral fijo como en la línea por segmentos de Syncfusion.',
    b16Supertrend,
  ),
  FcEntry(
    'ZigZag',
    'Une solo los giros de más del 6 % y rotula cada uno.',
    'No es una serie: es un GPolyLineMarker anclado a coordenadas de datos, que se mueve y escala junto con las velas.',
    b17Zigzag,
  ),
  FcEntry(
    'Puntos pivote',
    'Niveles P, R1, R2, S1 y S2 del periodo anterior.',
    'Las líneas horizontales de fl_chart son valores fijos. Aquí se calculan del máximo, mínimo y cierre de un tramo sombreado en la misma gráfica.',
    b18PuntosPivote,
  ),
  FcEntry(
    'Volumen por dirección',
    'Barras verdes o rojas según cierre la vela.',
    'El color de cada barra depende de otra serie (apertura y cierre), no de su propio valor.',
    b19VolumenDireccion,
  ),
  FcEntry(
    'Volumen con media y picos',
    'Barras, media de 20 y picos resaltados.',
    'Combina barra y línea como Syncfusion, pero además resalta solas las barras que superan 1,5 veces su media.',
    b20VolumenMedia,
  ),
  FcEntry(
    'OBV',
    'Volumen acumulado con signo y su media.',
    'Es una serie acumulada que depende de la dirección del precio, no un área de valores directos.',
    b21Obv,
  ),
  FcEntry(
    'Acumulación / distribución',
    'Flujo de dinero acumulado, bicolor alrededor de cero.',
    'Pondera el volumen por dónde cierra la barra dentro de su rango. El área cambia de color al cruzar cero.',
    b22AcumulacionDistribucion,
  ),
  FcEntry(
    'Chaikin Money Flow',
    'Presión compradora o vendedora en barras.',
    'Las barras con negativos de fl_chart y directed_graph son datos directos. Aquí son un oscilador calculado, con umbrales de ±0,05.',
    b23Chaikin,
  ),
  FcEntry(
    'RSI con zonas',
    'Fuerza relativa con sobrecompra y sobreventa.',
    'Las bandas de trazado de Syncfusion decoran cualquier serie. Aquí las zonas 70/30 son parte del indicador y la escala va fija de 0 a 100.',
    b24Rsi,
  ),
  FcEntry(
    'Oscilador estocástico',
    '%K y %D entre 0 y 100.',
    'Dos líneas donde una es la media de la otra: lo que se lee es el cruce entre ellas.',
    b25Estocastico,
  ),
  FcEntry(
    'MACD',
    'Histograma, línea y señal en un mismo panel.',
    'La combinación de Syncfusion mezcla series sin relación. Aquí las tres se derivan una de otra.',
    b26Macd,
  ),
  FcEntry(
    'CCI',
    'Desviación del precio típico, con niveles de ±100.',
    'Oscilador sin límites fijos, con relleno bicolor alrededor de cero.',
    b27Cci,
  ),
  FcEntry(
    'Williams %R',
    'Oscilador en escala de −100 a 0.',
    'Es el único indicador del taller con escala totalmente negativa y zonas invertidas.',
    b28WilliamsR,
  ),
  FcEntry(
    'ROC',
    'Variación porcentual frente a 12 barras atrás.',
    'Eje con formato de porcentaje propio (valueFormatter) y área que cambia de color en cero.',
    b29Roc,
  ),
  FcEntry(
    'ATR',
    'Rango verdadero medio de las barras.',
    'Se calcula con máximo, mínimo y cierre anterior: mide cuánto se mueve el precio, no hacia dónde.',
    b30Atr,
  ),
  FcEntry(
    'ADX con +DI y −DI',
    'Fuerza de la tendencia y su dirección.',
    'Tres líneas con papeles distintos (una mide fuerza y dos dirección) y un umbral en 25.',
    b31Adx,
  ),
  FcEntry(
    'Aroon',
    'Tiempo desde el último máximo y el último mínimo.',
    'Mide tiempo transcurrido, no precio. El relleno entre las dos líneas indica quién domina.',
    b32Aroon,
  ),
  FcEntry(
    'MFI',
    'Un RSI que además pondera por volumen.',
    'Combina precio y volumen en un oscilador de 0 a 100, con relleno bicolor en 50.',
    b33Mfi,
  ),
  FcEntry(
    'Awesome Oscillator',
    'Barras coloreadas según aceleran o frenan.',
    'El color depende de la barra anterior, no del signo. Se logra partiendo la serie en dos.',
    b34Awesome,
  ),
  FcEntry(
    'Volatilidad histórica',
    'Desviación anualizada a 20 y 60 días.',
    'Los histogramas de Syncfusion y directed_graph muestran cómo se reparten los datos. Aquí se ve cómo cambia esa dispersión con el tiempo.',
    b35Volatilidad,
  ),
  FcEntry(
    'Drawdown',
    'Caída desde el máximo anterior, con la peor señalada.',
    'Área siempre por debajo de cero, con el eje fijado arriba y un globo (GCalloutMarker) en la peor caída.',
    b36Drawdown,
  ),
  FcEntry(
    'Rendimiento relativo',
    'Activo frente a un índice, los dos en base 100.',
    'El relleno entre las dos líneas cambia de color según quién va ganando.',
    b37RendimientoRelativo,
  ),
  FcEntry(
    'Retroceso de Fibonacci',
    'Niveles de 23,6 % a 78,6 % del último gran movimiento.',
    'GFibRetracementMarker es una herramienta de dibujo propia de la librería. Ninguna otra del taller la trae.',
    b38FibonacciRetroceso,
  ),
  FcEntry(
    'Abanico de Fibonacci',
    'Rayos que salen del mínimo en proporciones de Fibonacci.',
    'GFibResistanceFanMarker: los rayos se recalculan solos al hacer zoom porque están anclados a coordenadas de datos.',
    b39FibonacciAbanico,
  ),
  FcEntry(
    'Arcos de Fibonacci',
    'Semicírculos con centro en el máximo.',
    'GFibArcMarker mezcla precio y tiempo en una misma distancia. No hay nada parecido en las otras librerías.',
    b40FibonacciArcos,
  ),
  FcEntry(
    'Zonas temporales de Fibonacci',
    'Líneas verticales a 1, 2, 3, 5, 8, 13... unidades.',
    'GFibTimeZoneMarker trabaja solo sobre el eje de tiempo y se extiende hasta donde llegue la ventana.',
    b41FibonacciTiempo,
  ),
  FcEntry(
    'Línea de tendencia con estadísticas',
    'Ángulo, variación de precio y número de barras.',
    'GStatsLineMarker calcula y dibuja las cifras. La tendencia lineal de Syncfusion es una regresión, sin medidas.',
    b42TendenciaEstadisticas,
  ),
  FcEntry(
    'Soportes y resistencias',
    'Zonas horizontales en los últimos giros del precio.',
    'Las franjas salen de los giros del propio precio y se dibujan con GRectMarker de lado a lado.',
    b43SoportesResistencias,
  ),
];

const financialAdvanced = <FcEntry>[
  FcEntry(
    'Velas y volumen con divisor',
    'Dos paneles apilados; el divisor se arrastra.',
    'Los paneles comparten el eje de tiempo y se redimensionan con el divisor (GSplitter). Las otras librerías usan una gráfica por widget.',
    a01VelasVolumen,
  ),
  FcEntry(
    'Velas, RSI y MACD',
    'Tres paneles sincronizados.',
    'Un solo GChart con tres escalas verticales independientes y una retícula que cruza los tres paneles.',
    a02VelasRsiMacd,
  ),
  FcEntry(
    'Terminal en tema oscuro',
    'Bollinger, volumen, RSI y MACD en cuatro paneles.',
    'Usa el tema GThemeDark de la librería. Es la única gráfica del taller con cuatro paneles enlazados.',
    a03TerminalOscura,
  ),
  FcEntry(
    'Ichimoku con ADX y volumen',
    'Dirección, fuerza y participación en tres paneles.',
    'Cada panel responde una pregunta distinta sobre la misma tendencia.',
    a04IchimokuAdxVolumen,
  ),
  FcEntry(
    'Bollinger con %B y ancho',
    'La banda y dos lecturas derivadas de ella.',
    'Los tres paneles salen del mismo indicador: no son series independientes puestas juntas.',
    a05BollingerBAncho,
  ),
  FcEntry(
    'Precio y volumen con dos escalas',
    'El volumen ocupa el 30 % inferior del mismo panel.',
    'El eje secundario de Syncfusion pone las dos series a toda altura. Aquí cada escala ocupa su propia franja gracias a los márgenes del viewport.',
    a06DobleEscala,
  ),
  FcEntry(
    'Lineal frente a logarítmica',
    'El mismo precio en las dos escalas a la vez.',
    'Syncfusion muestra un eje logarítmico. Aquí se comparan las dos escalas en paneles con zoom compartido.',
    a07LinealLogaritmica,
  ),
  FcEntry(
    'Ejes interiores y dobles',
    'Eje dentro del área, eje repetido y formatos propios.',
    'GAxisPosition permite ejes dentro del área y duplicados arriba, abajo, izquierda y derecha.',
    a08EjesInteriores,
  ),
  FcEntry(
    'Segmentador de tipo de precio',
    'Seis formas de dibujar los mismos datos.',
    'Un segmentador cambia la serie sin tocar los datos ni los ejes.',
    a09SelectorTipoPrecio,
  ),
  FcEntry(
    'Superposiciones combinables',
    'Seis capas que se encienden por separado.',
    'Son 64 combinaciones posibles sobre el mismo precio, con la escala ajustándose a lo que esté encendido.',
    a10SelectorSuperposiciones,
  ),
  FcEntry(
    'Segmentador de oscilador',
    'Seis indicadores para el panel inferior.',
    'El panel de precio se mantiene y solo se reemplaza el de abajo.',
    a11SelectorOscilador,
  ),
  FcEntry(
    'Constructor de paneles',
    'Apila paneles en el orden en que los enciendes.',
    'El orden importa: son permutaciones de paneles, no solo combinaciones.',
    a12ConstructorPaneles,
  ),
  FcEntry(
    'Segmentador de periodo',
    '1M, 3M, 6M, 1A o todo el historial.',
    'La ventana de fechas de Syncfusion fija un rango inicial. Aquí el segmentador mueve el viewport de la gráfica ya creada.',
    a13SelectorPeriodo,
  ),
  FcEntry(
    'Tema y paleta de velas',
    'Claro u oscuro, con cuatro paletas.',
    'Dos segmentadores independientes: 8 combinaciones de apariencia sobre los mismos datos.',
    a14TemaEstilo,
  ),
  FcEntry(
    'Matriz de combinaciones',
    'Precio × capa × panel: 48 combinaciones.',
    'Tres segmentadores encadenados, con un contador que dice en qué combinación estás.',
    a15MatrizCombinaciones,
  ),
  FcEntry(
    'Tooltip con widgets de Flutter',
    'Una tarjeta propia sigue al cursor.',
    'Los tooltips de fl_chart devuelven texto. Aquí tooltipWidgetBuilder acepta cualquier widget.',
    a16TooltipWidget,
  ),
  FcEntry(
    'Retícula con puntos resaltados',
    'La línea salta de barra en barra y marca cada serie.',
    'El crosshair de Syncfusion dibuja líneas guía. Aquí además cada serie resalta su punto (crosshairHighlightValueKeys).',
    a17CrosshairResaltado,
  ),
  FcEntry(
    'Tocar para anotar',
    'Cada toque deja una nota con el precio.',
    'Convierte el píxel tocado en coordenadas de datos y agrega marcadores a la gráfica ya creada.',
    a18TocarAnotar,
  ),
  FcEntry(
    'Zoom por selección en el eje',
    'Arrastra sobre las fechas para acercar un tramo.',
    'El zoom de Syncfusion y directed_graph es por pellizco. Aquí se elige un tramo sobre el eje (GAxisScaleMode.select).',
    a19ZoomSeleccion,
  ),
  FcEntry(
    'Medir entre dos toques',
    'Una regla de precio, barras y ángulo.',
    'Herramienta de medición interactiva hecha con GStatsLineMarker.',
    a20MedirToques,
  ),
  FcEntry(
    'Exportar como imagen',
    'Captura la gráfica completa en una imagen.',
    'GChart.saveAsImage vuelve a pintar la gráfica fuera de pantalla, con todos sus paneles.',
    a21ExportarImagen,
  ),
  FcEntry(
    'Mercado en vivo',
    'La última vela se forma tic a tic.',
    'El tiempo real de las otras librerías agrega puntos. Aquí se modifica la vela en curso y una etiqueta en el eje sigue al precio.',
    a22MercadoVivo,
  ),
  FcEntry(
    'Carga de historial bajo demanda',
    'El pasado se pide por bloques al desplazarse.',
    'GDataSource llama a priorDataLoader cuando hacen falta barras y muestra un indicador de carga mientras llegan.',
    a23CargaHistorial,
  ),
  FcEntry(
    'Dos activos sincronizados',
    'Mover o acercar una gráfica mueve la otra.',
    'Son dos GChart distintos, con datos distintos, enlazados por sus ventanas de tiempo.',
    a24GraficosSincronizados,
  ),
  FcEntry(
    'Mosaico de cuatro activos',
    'Cuatro gráficas pequeñas, cada una con su tipo.',
    'El panel de KPIs de Syncfusion usa sparklines. Aquí son cuatro gráficas completas, cada una con su propio zoom.',
    a25MosaicoActivos,
  ),
  FcEntry(
    'Simulación Monte Carlo',
    '30 futuros posibles y la banda de percentiles 5 a 95.',
    'Aquí lo aleatorio es el tema: un abanico de trayectorias que arrancan del último precio real.',
    a26MonteCarlo,
  ),
  FcEntry(
    'Estrategia con curva de capital',
    'Señales de cruce arriba y resultado abajo.',
    'Une señales, operaciones y rendimiento: el panel inferior se calcula a partir de los marcadores del superior.',
    a27EstrategiaCapital,
  ),
  FcEntry(
    'Divergencia entre precio y RSI',
    'Flechas que comparan dos mínimos en ambos paneles.',
    'Los marcadores de dos paneles distintos apuntan a las mismas barras y la gráfica dice sola si hay divergencia.',
    a28DivergenciaRsi,
  ),
  FcEntry(
    'Herramientas de Fibonacci combinables',
    'Retroceso, abanico, círculos y zonas de tiempo.',
    'Cuatro herramientas de dibujo sobre el mismo movimiento, que se encienden por separado.',
    a29FibonacciCompleto,
  ),
  FcEntry(
    'Canal de regresión lineal',
    'Recta de ajuste con bandas de ±1σ y ±2σ.',
    'La tendencia lineal de Syncfusion es una recta sobre dispersión. Aquí es un canal dibujado con GPolygonMarker sobre las velas.',
    a30CanalRegresion,
  ),
  FcEntry(
    'Comparación de dos activos',
    'Dos líneas en base 100 y su diferencia debajo.',
    'El panel inferior es la resta de las dos series de arriba, con área bicolor.',
    a31ComparacionSpread,
  ),
  FcEntry(
    'Trading de pares',
    'Ratio de dos activos y su puntuación Z.',
    'Estadística aplicada a dos series: las señales aparecen cuando Z sale de ±2.',
    a32ParesZscore,
  ),
  FcEntry(
    'Eventos corporativos',
    'Resultados y dividendos señalados sobre el precio.',
    'Las anotaciones de Syncfusion son widgets sueltos. Aquí cada evento tiene globo, línea y marca en el eje de tiempo.',
    a33EventosCorporativos,
  ),
  FcEntry(
    'Meses sombreados',
    'Cada mes con su franja y su rendimiento.',
    'Las franjas se calculan leyendo las fechas de los datos y se colorean según el resultado de cada mes.',
    a34MesesSombreados,
  ),
  FcEntry(
    'Perfil de volumen por precio',
    'Cuánto se negoció en cada nivel de precio.',
    'Las barras horizontales de las otras librerías son una gráfica aparte. Aquí son GRectMarker pegados al borde derecho, sobre las velas.',
    a35PerfilVolumen,
  ),
  FcEntry(
    'Panel de riesgo',
    'Máximo alcanzado, drawdown y volatilidad.',
    'Tres lecturas del mismo riesgo en paneles enlazados.',
    a36PanelRiesgo,
  ),
];

/// Pantalla principal de la galería: dos pestañas con la lista de gráficas.
class FinancialGalleryPage extends StatelessWidget {
  const FinancialGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('financial_chart — Galería'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Básicas · ${financialBasic.length}'),
              Tab(text: 'Avanzadas · ${financialAdvanced.length}'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _EntryList(entries: financialBasic),
            _EntryList(entries: financialAdvanced),
          ],
        ),
      ),
    );
  }
}

class _EntryList extends StatelessWidget {
  const _EntryList({required this.entries});

  final List<FcEntry> entries;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: entries.length,
      separatorBuilder: (context, index) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 18,
            backgroundColor: scheme.primaryContainer,
            child: Text(
              '${index + 1}'.padLeft(2, '0'),
              style: TextStyle(fontSize: 12, color: scheme.onPrimaryContainer),
            ),
          ),
          title: Text(entry.title),
          subtitle: Text(entry.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => FinancialChartPage(number: index + 1, entry: entry),
              ),
            );
          },
        );
      },
    );
  }
}

/// Pantalla de una gráfica: descripción arriba y la gráfica ocupando el resto.
class FinancialChartPage extends StatefulWidget {
  const FinancialChartPage({super.key, required this.number, required this.entry});

  final int number;
  final FcEntry entry;

  @override
  State<FinancialChartPage> createState() => _FinancialChartPageState();
}

class _FinancialChartPageState extends State<FinancialChartPage> {
  /// Cada vez que cambia, la gráfica se vuelve a crear con datos nuevos.
  int _round = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entry = widget.entry;
    final number = widget.number.toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(
        title: Text('$number. ${entry.title}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.casino_outlined),
            tooltip: 'Generar datos aleatorios nuevos',
            onPressed: () => setState(() => _round++),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.subtitle, style: theme.textTheme.titleSmall),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.compare_arrows, size: 16, color: theme.colorScheme.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        entry.diff,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              // La llave cambia con cada tirada del dado: Flutter descarta la
              // gráfica anterior y crea otra desde cero, con datos distintos.
              child: KeyedSubtree(key: ValueKey(_round), child: entry.builder()),
            ),
          ),
        ],
      ),
    );
  }
}
