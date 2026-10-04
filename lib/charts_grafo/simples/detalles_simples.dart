import '../models/chart_entry.dart';

/// Descripciones largas de las sencillas (se muestran al abrir la gráfica).
const Map<int, ChartDetail> simpleDetails = {
  1: ChartDetail(
    'Dibuja la estructura que guarda un WeightedDirectedGraph: cada vértice es un círculo y cada arista una flecha con sentido (a→b no es lo mismo que b→a). También aparecen las aristas de un vértice hacia sí mismo (l→l), que la librería permite de forma explícita. Vértices y aristas se leen directamente del grafo, no se escriben a mano en la gráfica.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Una gráfica de barras o de líneas representa series de números; aquí lo que se dibuja es una relación entre elementos. Las librerías de gráficos estadísticos no traen de forma nativa el concepto de vértice ni de arista dirigida.',
  ),
  2: ChartDetail(
    'Añade a cada flecha su peso (por ejemplo, a→e vale 40 y a→b vale 1). Esos pesos son los que usan los algoritmos de la librería para calcular el camino más ligero, el más pesado y la cerradura transitiva, así que esta vista es la base para leer las demás.',
    ['weightedEdges'],
    'Aquí el peso es un atributo de la relación, no un valor suelto sobre un eje: la librería lo conserva dentro de la arista y lo reutiliza para calcular rutas.',
  ),
  3: ChartDetail(
    'shortestPath(a, g) busca la ruta con menos aristas sin mirar los pesos; en este grafo es [a, g], una sola arista aunque pese 7. El camino se resalta en rojo, el resto del grafo se atenúa y el peso total se obtiene con weightAlong.',
    ['shortestPath', 'weightAlong'],
    'El camino no se dibuja a mano: lo calcula el algoritmo de la librería y la gráfica solo lo pinta. Si cambias el grafo, el camino resaltado cambia solo.',
  ),
  4: ChartDetail(
    'lightestPath(a, g) suma los pesos y elige el camino con menor total: [a, c, g] pesa 6, mientras que el directo [a, g] pesa 7. Pasar por más vértices puede salir más barato, que es la idea detrás de las rutas de costo mínimo.',
    ['lightestPath', 'weightAlong'],
    'Contrasta con la gráfica 3: mismo grafo y mismo par de vértices, pero otro criterio da otro camino. Esa comparación solo tiene sentido en una estructura de grafo.',
  ),
  5: ChartDetail(
    'heaviestPath(a, g) devuelve el camino de mayor peso total: [a, e, g] pesa 42 (40 + 2). Se interpreta como la ruta crítica, la de mayor carga o duración. Solo considera caminos, es decir, sin repetir vértices intermedios.',
    ['heaviestPath', 'weightAlong'],
    'Es el tercer criterio sobre el mismo grafo. En una gráfica de líneas o barras no existe el concepto de ruta; aquí es el resultado de un algoritmo de la librería.',
  ),
  6: ChartDetail(
    'reachableVertices(d) devuelve el conjunto de vértices a los que se llega siguiendo flechas desde d: e, g, f, i, k y l. El origen se pinta en verde, los alcanzables en rojo y los que quedan fuera de su alcance (a, b, c, h) en gris. Las flechas que se pueden recorrer desde d se resaltan.',
    ['reachableVertices'],
    'Responde una pregunta de conectividad ("¿hasta dónde llego desde aquí?"), no de magnitudes. Es un resultado propio de los algoritmos de grafos.',
  ),
  7: ChartDetail(
    'transitiveClosure añade una arista directa por cada par de vértices unidos por algún camino, con el peso del camino más ligero. En el grafo de muestra pasa de 17 a 31 aristas (en naranja las nuevas); por ejemplo, a→g baja de 7 a 6 porque existe el camino a→c→g.',
    ['WeightedDirectedGraph.transitiveClosure'],
    'Muestra información que no está escrita en ningún dato de entrada: son conexiones indirectas deducidas por la librería. Una gráfica estadística solo puede mostrar lo que se le entrega ya calculado.',
  ),
  8: ChartDetail(
    'sortEdgesByWeight() reordena, para cada vértice, la lista de sus vecinos de menor a mayor peso. Arriba se ve el orden en que se insertaron las aristas y abajo el que deja la librería; por ejemplo, las salidas de a pasan de b, h, c, e, g a b, c, h, g, e. Al recorrer los vecinos de un vértice se encuentran primero las conexiones más baratas.',
    ['sortEdgesByWeight', 'weightedEdges'],
    'El orden de las barras no lo decide la gráfica: lo decide la librería sobre la estructura del grafo, y se agrupa por vértice origen. Es una vista del estado interno de la estructura de datos.',
  ),
  9: ChartDetail(
    'updateEdgeWeight(vertex: a, connectedVertex: b, weight: 101) cambia el peso de una sola arista del grafo ya construido. A la izquierda se ve el grafo original (a→b = 1) y a la derecha el mismo grafo después de la actualización (a→b = 101), con la arista resaltada.',
    ['updateEdgeWeight', 'weightedEdges'],
    'Presenta el grafo como una estructura que se puede modificar y recalcular: al cambiar una arista, todo lo derivado (caminos, cerradura) puede obtenerse de nuevo. Es el primer paso hacia el editor interactivo de las avanzadas.',
  ),
  10: ChartDetail(
    'Combina dos vistas del mismo grafo: la estructura y el grado de salida de cada vértice (outDegree). Se ve enseguida que a, con 5 salidas, es el que más reparte, mientras que g y h no tienen ninguna.',
    ['outDegree', 'weightedEdges'],
    'Las barras no se capturan a mano: salen del propio grafo, de modo que ambas vistas siempre son coherentes entre sí y se actualizan si cambian las aristas.',
  ),
  11: ChartDetail(
    'outDegree cuenta cuántas flechas salen de cada vértice: a tiene 5; c, d, i y k tienen 2; g y h tienen 0. El valor lo entrega la librería para cada vértice del grafo.',
    ['outDegree'],
    'Con una librería de gráficos estadísticos tendrías que calcular y pasar estos números tú mismo. Aquí los entrega el grafo y se actualizan al agregar o quitar aristas.',
  ),
  12: ChartDetail(
    'inDegree cuenta cuántas flechas llegan a cada vértice. g recibe 4 (desde a, c, e y k), por lo que es el más dependiente; a y d no reciben ninguna, es decir, son fuentes locales.',
    ['inDegree'],
    'El grado de entrada solo existe en grafos dirigidos: distingue lo que sale de lo que llega, algo que un eje de categorías no puede expresar por sí solo.',
  ),
  13: ChartDetail(
    'Suma, para cada vértice, los pesos de todas las aristas que salen de él, obtenidos con weightedEdges. a concentra 57 (1 + 7 + 2 + 40 + 7), mucho más que cualquier otro, y l aporta 0 porque su única arista pesa 0.',
    ['weightedEdges'],
    'Cada barra se calcula recorriendo las aristas ponderadas del grafo; no es una serie independiente, sino una propiedad de la estructura.',
  ),
  14: ChartDetail(
    'Pone en paralelo, para cada vértice, su grado de entrada (verde) y su grado de salida (azul). Permite ver si un vértice es sobre todo emisor (a, d), receptor (g, h) o intermedio (c, i, k).',
    ['inDegree', 'outDegree'],
    'Las dos series provienen de dos consultas distintas al mismo grafo. Es la comparación natural en una red dirigida: quién envía y quién recibe.',
  ),
  15: ChartDetail(
    'Cada barra es un vértice origen y cada color representa la arista hacia un destino distinto, con su peso como altura del tramo. Así se ve de qué conexiones se compone el peso saliente de cada vértice; la enorme barra de a se debe casi toda a la arista a→e.',
    ['weightedEdges'],
    'Descompone un total en las aristas reales del grafo: cada tramo de color corresponde a una conexión concreta, no a una categoría inventada.',
  ),
  16: ChartDetail(
    'Es la misma información que la gráfica anterior, pero cada vértice se normaliza a 100 %. Ya no importa cuánto pesa en total, sino cómo reparte su peso entre sus destinos: por ejemplo, b envía todo a h, mientras que a reparte la mayor parte hacia e.',
    ['weightedEdges'],
    'Permite comparar el reparto de nodos con tamaños muy distintos, algo útil al analizar redes donde unos pocos nodos concentran casi todo el peso.',
  ),
  17: ChartDetail(
    'Calcula salida menos entrada (outDegree − inDegree) para cada vértice. Los positivos (azul) son emisores netos, como a (+5) y d (+2); los negativos (rojo) son receptores netos, como g (−4) y h (−3). Un valor cercano a 0 indica un vértice de paso.',
    ['outDegree', 'inDegree'],
    'Es una métrica que solo existe porque el grafo es dirigido: combina las dos direcciones en un solo número con signo.',
  ),
  18: ChartDetail(
    'Toma el camino más pesado entre d y g (heaviestPath) y acumula el peso de cada arista a medida que avanza. El eje X son los vértices del camino, en orden, y el eje Y el peso acumulado hasta llegar a cada uno.',
    ['heaviestPath', 'weightedEdges'],
    'El eje X no es tiempo ni categorías sueltas: es una ruta calculada por el algoritmo. Cambiar el grafo cambia el camino y, con él, la forma de la línea.',
  ),
  19: ChartDetail(
    'Dibuja tres líneas entre a y g: el camino más corto ([a, g]), el más ligero ([a, c, g]) y el más pesado ([a, e, g]). Todas arrancan en 0 y terminan en 7, 6 y 42 respectivamente; se ve en qué salto se separan y cuánto cuesta cada decisión.',
    ['shortestPath', 'lightestPath', 'heaviestPath'],
    'Compara tres resultados de tres algoritmos distintos de la librería sobre el mismo par de vértices. Las series no son datos de entrada: son rutas calculadas.',
  ),
  20: ChartDetail(
    'Muestra el mismo acumulado del camino más pesado d → g como escalones: el valor se mantiene constante mientras se está en un vértice y salta cuando se cruza una arista. El tamaño de cada escalón es el peso de esa arista.',
    ['heaviestPath', 'weightedEdges'],
    'Cada escalón corresponde a una arista real del grafo, así que la forma de la gráfica es una lectura directa del camino.',
  ),
  21: ChartDetail(
    'Es el mismo acumulado del camino más pesado d → g, con el área bajo la curva rellena. Da una idea de volumen total recorrido y de qué tramos del camino aportan más.',
    ['heaviestPath', 'weightedEdges'],
    'El área acumula pesos de aristas de un camino calculado por la librería, no una medición continua en el tiempo.',
  ),
  22: ChartDetail(
    'Para cada vértice apila el peso que sale (azul, suma de sus aristas salientes) y el peso que llega (naranja, suma de las aristas que le apuntan). La altura total indica cuánta actividad pasa por el vértice y el reparto, si es más emisor o receptor.',
    ['weightedEdges', 'outDegree', 'inDegree'],
    'Combina dos perspectivas de la misma red dirigida (lo que sale y lo que entra) en un solo gráfico. Ambas series las deriva la librería de las aristas del grafo.',
  ),
  23: ChartDetail(
    'Cada paleta (lollipop) es una arista del grafo y su altura es el peso. Se listan las 17 aristas en el orden en que están guardadas: enseguida se nota que a→e (40) se sale de la escala del resto, mientras que l→l tiene peso 0.',
    ['weightedEdges'],
    'Cada categoría es una arista real (origen→destino) leída del grafo, no una etiqueta escrita a mano. El eje horizontal es el conjunto de aristas de la estructura.',
  ),
  24: ChartDetail(
    'Cada punto es un vértice: la posición horizontal es su grado de salida y la vertical, el peso total de sus aristas salientes. a queda aislado arriba a la derecha (5 aristas y peso 57). Los vértices que coinciden en el mismo punto se etiquetan juntos, por ejemplo c,k en (2, 9) y g,h en (0, 0).',
    ['outDegree', 'weightedEdges'],
    'Los dos ejes son métricas derivadas del mismo grafo, así que la gráfica responde si los nodos con más conexiones también cargan más peso. No son datos externos.',
  ),
  25: ChartDetail(
    'Cada burbuja es un vértice. X es su grado total (entrada + salida), Y su peso total y el tamaño, cuántos vértices alcanza con reachableVertices. d es la mayor (alcanza 6) aunque su peso es bajo, mientras que e pesa mucho (43) pero solo alcanza 1. Cuando dos vértices coinciden (c y k) se separan ligeramente.',
    ['inDegree', 'outDegree', 'weightedEdges', 'reachableVertices'],
    'Reúne tres tipos de información que la librería calcula por separado (estructura, pesos y alcance) en una sola vista. La tercera dimensión, el alcance, solo existe en un grafo.',
  ),
  26: ChartDetail(
    'Agrupa en intervalos de ancho 5 los 17 pesos de las aristas. En [0, 5) caen 11, en [5, 10) caen 5 y en [40, 45) solo uno (a→e = 40); los intervalos intermedios están vacíos, lo que muestra una distribución muy sesgada.',
    ['weightedEdges'],
    'Los valores que se agrupan son los pesos reales de las aristas del grafo. Si se actualiza un peso con updateEdgeWeight, el histograma cambia.',
  ),
  27: ChartDetail(
    'Une con una línea los puntos medios de cada intervalo del histograma anterior y cierra la figura sobre el eje. Muestra la misma distribución (11, 5 y 1 aristas en los intervalos con datos) pero enfatiza la forma y permite comparar varias distribuciones superpuestas.',
    ['weightedEdges'],
    'Al igual que el histograma, parte de los pesos de las aristas del grafo; la diferencia está en cómo se presenta la frecuencia (línea y área en lugar de columnas).',
  ),
  28: ChartDetail(
    'Se parte del grafo de muestra y se actualizan tres aristas con updateEdgeWeight: a→b pasa de 1 a 101, b→h de 6 a 1 y e→g de 2 a 20. Cada fila es un vértice: el punto gris es su peso saliente antes del cambio y el de color, el de después. a sube de 57 a 157, b baja de 6 a 1 y e sube de 2 a 20; el resto no cambia.',
    ['updateEdgeWeight', 'weightedEdges'],
    'Compara dos estados del mismo grafo después de modificarlo. La librería permite actualizar una arista sin reconstruir la estructura, y la gráfica refleja el efecto en cada nodo.',
  ),
  29: ChartDetail(
    'Una minigráfica por vértice con el peso acumulado de sus aristas salientes, ya ordenadas con sortEdgesByWeight. a sube de 1 a 57 pasando por 1, 3, 10, 17 y 57; los vértices con una sola arista se reducen a un punto, y g y h, sin salidas, aparecen vacíos.',
    ['sortEdgesByWeight', 'weightedEdges'],
    'El orden de los puntos de cada línea es el orden de los vecinos que deja la librería al ordenar las aristas. Así, la forma de cada línea es una huella de la estructura del vértice.',
  ),
  30: ChartDetail(
    'Compara cuatro vértices (a, d, e y g) en cinco métricas del grafo: grado de entrada, grado de salida, peso entrante, peso saliente y vértices alcanzables. Cada eje se normaliza respecto al máximo del grafo. a destaca en salida, d en alcance, e en peso entrante y g en grado de entrada.',
    ['inDegree', 'outDegree', 'weightedEdges', 'reachableVertices'],
    'Los cinco ejes provienen de cinco consultas distintas a la librería. El radar resume en una forma el rol de cada nodo dentro de la red.',
  ),
  31: ChartDetail(
    'Descompone el peso total del camino más pesado entre d y g (heaviestPath) en el aporte de cada arista: d→f (2), f→i (3), i→k (2) y k→g (4), que suman 11. Cada barra flotante empieza donde terminó la anterior y la última muestra el total.',
    ['heaviestPath', 'weightedEdges'],
    'Los escalones no son datos sueltos: son las aristas de un camino calculado por la librería, en el orden en que se recorren.',
  ),
  32: ChartDetail(
    'Cada fila es un vértice y cada flecha representa una de sus aristas salientes (outDegree): a dibuja cinco; c, d, i y k, dos; b, e, f y l, una; g y h ninguna.',
    ['outDegree'],
    'El símbolo es una flecha porque la dirección es la esencia de este grafo: se cuentan solo las aristas que salen, no las que llegan.',
  ),
  33: ChartDetail(
    'Se parte de los 11 vértices y se estrecha según qué tan lejos se llega desde d: 6 vértices son alcanzables en 3 saltos como máximo, 4 en 2 saltos o menos y 2 en un solo salto. El número de saltos de cada vértice sale de la longitud de shortestPath(d, v).',
    ['reachableVertices', 'shortestPath'],
    'Mide cuánto se propaga algo por la red paso a paso. Es una pregunta de conectividad que solo tiene sentido en un grafo.',
  ),
  34: ChartDetail(
    'De los 11 vértices del grafo, 6 son alcanzables desde d (reachableVertices), 4 no lo son (a, b, c y h) y 1 es el propio origen. Es la versión proporcional de la gráfica 6.',
    ['reachableVertices'],
    'Las porciones salen de un cálculo de alcance sobre el grafo, no de categorías definidas por quien dibuja. Si cambian las aristas, cambian las proporciones.',
  ),
  35: ChartDetail(
    'Cada porción es un vértice con aristas salientes y su tamaño es la proporción de las 17 aristas del grafo que salen de él: a aporta 5 (29 %); c, d, i y k aportan 2 cada uno. g y h no aparecen porque no tienen salidas.',
    ['outDegree'],
    'El total del centro (17) es el número de aristas de la estructura. La dona muestra cómo se reparte ese total entre los vértices origen.',
  ),
  36: ChartDetail(
    'La densidad es el número de aristas dividido entre las aristas posibles. Con 11 vértices hay 11 × 10 = 110 aristas posibles sin contar bucles, y el grafo tiene 16, es decir, una densidad de 14,5 %. La aguja llena casi una séptima parte del medidor.',
    ['weightedEdges'],
    'Es una métrica propia de grafos: compara lo que existe con lo máximo que podría existir. No tiene equivalente en una serie de datos común.',
  ),
  37: ChartDetail(
    'De los 110 pares ordenados de vértices distintos, 27 están unidos por algún camino (24,5 %). Es el mismo número de aristas nuevas que añade la cerradura transitiva (gráfica 7) sin contar los bucles.',
    ['reachableVertices', 'transitiveClosure'],
    'Se calcula sumando, para cada vértice, cuántos otros alcanza. Indica qué tanto de la red se puede recorrer, algo que solo se obtiene recorriendo la estructura.',
  ),
  38: ChartDetail(
    'Cada rectángulo es un vértice y su área es el peso total que lo toca (entrante + saliente). a (57) y e (43) ocupan más de la mitad del área del grafo (188 en total); h (18), g (17) y c y k (11) siguen, y d y l (3) son los más pequeños.',
    ['weightedEdges'],
    'El tamaño de cada vértice viene de sumar los pesos de sus aristas en ambos sentidos. Hace visible qué nodos dominan el peso total de la red.',
  ),
  39: ChartDetail(
    'Es la matriz de adyacencia: filas son el origen, columnas el destino y el color indica el peso. Las celdas vacías son pares sin arista. a→e (40) es la celda más intensa y en la diagonal solo hay un valor, l→l, que existe pero pesa 0.',
    ['weightedEdges'],
    'Es otra forma de representar la misma estructura que el grafo de la gráfica 2: permite ver todas las conexiones a la vez, incluso cuando dibujar flechas sería ilegible.',
  ),
  40: ChartDetail(
    'Ordena las 17 aristas de mayor a menor peso y superpone el porcentaje acumulado. Las 8 más pesadas reúnen 78 de las 94 unidades de peso total (83 %), por lo que cruzan la línea del 80 %: pocas aristas explican casi todo el peso.',
    ['weightedEdges'],
    'Combina barras y línea sobre aristas reales del grafo. El orden de las categorías lo decide el peso de cada arista, no un criterio externo.',
  ),
  41: ChartDetail(
    'Es el histograma de pesos con una curva de densidad (estimador de núcleo gaussiano) encima. La curva suaviza los intervalos: muestra que la mayoría de los pesos se concentra entre 0 y 7 y que existe una cola larga hasta 40.',
    ['weightedEdges'],
    'Los datos que se suavizan son los pesos de las aristas del grafo. La curva permite ver la forma de la distribución sin depender de cómo se agrupen los intervalos.',
  ),
  42: ChartDetail(
    'Cada punto es un vértice: grado de entrada contra peso total entrante. La recta de mínimos cuadrados resume la tendencia y se indica su ecuación y su r². En general, más aristas entrantes implican más peso recibido, pero e (2 entradas y 41 de peso) se aleja de la recta.',
    ['inDegree', 'weightedEdges'],
    'Ambas variables se derivan del propio grafo, así que la recta responde una pregunta sobre su estructura: si recibir más conexiones implica recibir más carga.',
  ),
  43: ChartDetail(
    'Muestra el grado total (entrada + salida) de cada vértice con una línea punteada en el promedio, 3,09 (34 / 11). a (5) y g (4) quedan por encima; b y d (2) por debajo; el resto está en 3, muy cerca del promedio.',
    ['inDegree', 'outDegree'],
    'El promedio se calcula sobre los vértices del grafo y sirve de referencia para ver qué nodos son atípicos dentro de la red.',
  ),
};
