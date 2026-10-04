import '../models/chart_entry.dart';

// Los algoritmos de esta entrega (componentes, capas, ruta critica, Dijkstra,
// layouts...) estan en lib/grafos/algoritmos.dart y lib/grafos/layouts.dart.
// Leen los datos con los metodos de directed_graph que se listan en cada
// grafica ("weightedEdges", "outDegree", ...).

/// Descripciones largas de las avanzadas (se muestran al abrir la grafica).
const Map<int, ChartDetail> advancedDetails = {
  1: ChartDetail(
    'Un orden topológico pone cada vértice después de todos los que lo preceden. Este grafo tiene un ciclo (f → i → k → f), así que no admite uno estricto: el ciclo se trata como un solo bloque. Resultado: capa 0 con a y d; capa 1 con b, c, e y el bloque {f, i, k}; capa 2 con g, h y l. Todas las flechas entre capas van de izquierda a derecha.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'En una gráfica de barras o líneas el orden lo pone el eje. Aquí el orden sale de la propia estructura: lo que depende de otra cosa siempre queda más a la derecha, y los ciclos se detectan y se agrupan en lugar de ocultarse.',
  ),
  2: ChartDetail(
    'Una arista está en un ciclo si desde su destino se puede volver a su origen. En el grafo de muestra son cuatro: f → i, i → k, k → f (el ciclo f → i → k → f) y el bucle l → l. Se pintan de rojo; el resto del grafo se atenúa para que el ciclo se vea de inmediato.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Un ciclo es una propiedad de cómo se conectan los elementos, no un valor. Ninguna gráfica estadística puede mostrarlo sin que alguien lo calcule antes; aquí se calcula sobre el grafo y se dibuja en su lugar.',
  ),
  3: ChartDetail(
    'Una componente fuertemente conexa es un grupo de vértices que se alcanzan unos a otros. Los 11 vértices forman 9 componentes: {a}, {b}, {c}, {d}, {e}, {f, i, k}, {g}, {h} y {l}. Solo {f, i, k} tiene varios vértices; {l} es cíclica porque tiene un bucle. Cada componente con ciclo lleva su propio color y las demás quedan en gris.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Es el equivalente en grafos de un análisis de conglomerados, pero sin parámetros ni distancias: dos vértices pertenecen al mismo grupo si y solo si hay camino de ida y de vuelta entre ellos.',
  ),
  4: ChartDetail(
    'Cada vértice es una tarea y una arista u → v significa que v no puede empezar hasta que u termine. La duración de cada tarea se toma como 1 + su grado de salida (a dura 6, d dura 3, g dura 1). Para que el calendario tenga sentido se omiten las dos aristas que cierran ciclos (k → f y l → l). Las tareas se programan lo más temprano posible y el proyecto completo dura 12 unidades.',
    ['WeightedDirectedGraph', 'weightedEdges', 'outDegree'],
    'Un Gantt normal se construye a mano, con fechas escritas. Este se deduce de las dependencias del grafo: si cambias una arista, cambian las fechas de inicio.',
  ),
  5: ChartDetail(
    'Es el mismo Gantt, pero ahora se calcula cuánta holgura tiene cada tarea. Las que no tienen ninguna (d, f, i, k, g) forman la ruta crítica de 12 unidades: si una se retrasa, todo el proyecto se retrasa. Las demás muestran en gris cuánto se pueden mover: a, c, h y l tienen 2 unidades, b y e tienen 3.',
    ['WeightedDirectedGraph', 'weightedEdges', 'outDegree'],
    'Distingue entre lo urgente y lo flexible. La ruta crítica no es la tarea más larga: es el camino más largo del grafo, algo que solo se ve al considerar todas las dependencias a la vez.',
  ),
  6: ChartDetail(
    'shortestPath(d, l) devuelve el camino con menos aristas: d → f → i → l, tres saltos con un peso total de 8. Un punto lo recorre arista por arista; los vértices ya visitados se encienden en rojo y el origen en verde. Cuando termina, la animación se repite.',
    ['shortestPath', 'weightedEdges'],
    'El movimiento enseña el orden del recorrido, que una imagen fija no muestra. El camino lo calcula la librería, no está escrito en la gráfica.',
  ),
  7: ChartDetail(
    'Dijkstra fija, en cada paso, el vértice no visitado con menor distancia provisional. Desde d se fijan en este orden: d (0), e (1), f (2), g (3), i (5), k (7) y l (8). Verde = distancia definitiva; naranja = frontera, con su distancia provisional bajo el vértice; gris = aún sin ver. Las aristas del árbol de caminos van en verde. Los vértices a, b, c y h nunca se alcanzan desde d.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Muestra el proceso y no solo el resultado: se ve cómo crece la frontera y por qué un vértice cambia de distancia provisional. Las gráficas estadísticas muestran estados finales, no algoritmos en marcha.',
  ),
  8: ChartDetail(
    'Toca un vértice y luego otro: si no había arista de uno al otro, se crea con peso 1; si ya existía, se borra. Debajo se recalculan al instante el número de aristas, las componentes fuertemente conexas y si el grafo tiene ciclos (las aristas en ciclo se pintan de rojo). Prueba crear b → a: aparece un ciclo. El botón Restablecer vuelve al grafo original. Los cambios viven solo en pantalla, no modifican el grafo de muestra.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Convierte el grafo en algo que se puede probar con las manos. En una gráfica estadística cambiar un dato no cambia la forma de nada más; aquí un solo toque puede crear o romper un ciclo.',
  ),
  9: ChartDetail(
    'Las posiciones no se eligen a mano: se simulan fuerzas. Todos los vértices se repelen y las aristas funcionan como resortes que acercan a los conectados. Al estabilizarse, los vértices conectados tienden a quedar cerca y los muy conectados (como a) suelen ocupar posiciones centrales. El cálculo es determinista, así que siempre sale el mismo dibujo.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'La posición de cada vértice codifica información (cercanía = conexión), algo que un eje cartesiano no puede expresar para datos que no tienen coordenadas.',
  ),
  10: ChartDetail(
    'Cada vértice va en la columna que indica el camino más largo que llega hasta él: capa 0 con a y d; capa 1 con b, c, e y f; capa 2 con h e i; capa 3 con k y l; capa 4 con g. Dentro de cada columna los vértices se ordenan para reducir cruces. Las aristas que cierran ciclos (k → f y el bucle l → l) se dibujan rojas y punteadas para que el resto fluya en un solo sentido.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Una gráfica de líneas tiene un eje de tiempo dado; aquí el eje horizontal es la profundidad dentro del grafo, calculada a partir de las dependencias.',
  ),
  11: ChartDetail(
    'Un bosque de expansión cubre todos los vértices con el menor número de aristas, eligiendo siempre la más ligera que sale del árbol hacia un vértice nuevo. Como el grafo es dirigido, se parte de las raíces (a y d, que no reciben flechas): salen 9 aristas con peso total 62. La arista a → e pesa 40 y casi todo el peso del bosque viene de ahí. Las aristas descartadas se ven en gris claro.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Enseña qué conexiones son suficientes y cuáles sobran. Es una vista de ahorro (mínimo costo para conectar todo) que no tiene equivalente en una gráfica estadística.',
  ),
  12: ChartDetail(
    'Interpreta el grafo como un proceso: los óvalos son inicio y fin (a y d empiezan; g, h y l terminan), los rombos son decisiones (c e i, que tienen dos salidas) y los rectángulos son pasos simples (b, e, f y k). Las aristas que vuelven atrás (k → f y l → l) se dibujan rojas y punteadas como repeticiones.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'La forma de cada símbolo la decide la estructura del grafo, no el autor del diagrama: si cambia el número de salidas de un vértice, cambia de rectángulo a rombo.',
  ),
  13: ChartDetail(
    'Cada columna es una capa del grafo sin ciclos y cada banda une dos vértices con un grosor proporcional al peso de la arista. Se omiten las aristas de peso 0 y la que cierra el ciclo, por lo que quedan 89 unidades de peso (de 94). Se nota enseguida que casi todo el flujo sale de a y que la banda a → e (40) es la más gruesa.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Un Sankey conserva el flujo: lo que sale de un vértice se reparte entre sus destinos. Un gráfico de barras compara totales, pero no muestra de dónde viene cada parte.',
  ),
  14: ChartDetail(
    'Los vértices se reparten alrededor de un círculo con un arco tan largo como su peso total (lo que sale más lo que entra). Cada arista es una cinta que une el tramo de salida del origen con el tramo de llegada del destino y su ancho es el peso. Los 94 puntos de peso del grafo se ven de una vez; a → e domina la figura.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Muestra relaciones entre pares de elementos con todos los vértices a la vez. Un mapa de calor lo hace en cuadrícula; aquí se ve además cuánto representa cada vértice del total.',
  ),
  15: ChartDetail(
    'Parte de d, que queda en el centro. El primer anillo contiene lo que se alcanza en 1 salto (e y f), el segundo lo que se alcanza en 2 (g e i) y el tercero lo que se alcanza en 3 (k y l). Cada rama conserva su color y su ancho depende de cuántos vértices cuelgan de ella: la rama de f ocupa el doble que la de e. En total se alcanzan 6 vértices.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Un sunburst normal exige una jerarquía ya armada. Aquí la jerarquía sale de un recorrido en anchura: los anillos son saltos reales dentro del grafo.',
  ),
  16: ChartDetail(
    'Usa el bosque de expansión (gráfica 11) como jerarquía: dos ramas, la de a (con b, c, e, g y h) y la de d (con f, i, k y l). Los rectángulos se anidan: el borde de cada grupo es un vértice interno y las hojas (b, e, g, h, k, l) tienen un área proporcional a su peso total: 1 más lo que entra y lo que sale.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Un treemap simple compara valores sueltos. Este los agrupa según cómo se conectan los vértices, de modo que ves a la vez la estructura y el peso.',
  ),
  17: ChartDetail(
    'Para cuatro orígenes (a, d, i y k) cuenta cuántos vértices nuevos se alcanzan en cada salto. Las áreas se apilan alrededor de una línea central y se suavizan. En el salto 1 se suman 11 vértices: 5 desde a, 2 desde d, 2 desde i y 2 desde k. Desde a todo ocurre en el primer salto; desde d el alcance se reparte en tres saltos.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Un streamgraph normal muestra el cambio en el tiempo. Aquí el eje no es el tiempo sino la distancia en saltos, calculada por el grafo.',
  ),
  18: ChartDetail(
    'Resume los pesos de las aristas con mediana, cuartiles y valores atípicos (los que se alejan más de 1,5 veces el rango intercuartílico). Con las 17 aristas, la mediana es 3 y el único atípico es 40 (a → e). El vértice a por sí solo tiene pesos 1, 2, 7, 7 y 40: su caja es amplia y 40 vuelve a salir como atípico. Los puntos pequeños a un lado son los valores reales.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Los pesos se agrupan por vértice de origen, algo que solo existe en un grafo: cada caja responde "¿qué tan caras son las salidas de este vértice?".',
  ),
  19: ChartDetail(
    'Dibuja la forma de la distribución de pesos con un suavizado, espejada a cada lado. Las aristas se agrupan por la capa de su vértice de origen: la capa 0 (a y d) tiene 7 aristas con un pico en pesos bajos y una cola larga hasta 40; las demás capas son más compactas. Las líneas oscuras marcan la mediana y los puntos son los datos reales.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Con muy pocos datos por grupo conviene mirar la forma y los puntos juntos. Las capas vienen de la estructura del grafo, no de una columna de datos.',
  ),
  20: ChartDetail(
    'Cada vértice es una línea que cruza cinco ejes: grado de salida, grado de entrada, peso saliente, peso entrante y vértices alcanzados. Cada eje va de su mínimo a su máximo. Se lee, por ejemplo, que a sale mucho (5 aristas, peso 57) pero no recibe ninguna, mientras que e recibe el mayor peso (41).',
    ['outDegree', 'inDegree', 'weightedEdges'],
    'Las cinco métricas salen del mismo grafo y se leen de una vez. Es la forma más corta de ver el perfil completo de cada vértice.',
  ),
  21: ChartDetail(
    'Cruza tres métricas (grado de salida, grado de entrada y peso entrante) todas contra todas. La diagonal indica la métrica y su rango; cada celda restante es una dispersión de los 11 vértices. Ayuda a ver si dos métricas se mueven juntas sin elegir de antemano cuáles comparar.',
    ['outDegree', 'inDegree', 'weightedEdges'],
    'Sustituye varias gráficas de dispersión sueltas por una sola vista. Los puntos son vértices del grafo y las métricas las calcula la librería.',
  ),
  22: ChartDetail(
    'Cada celda es el peso del camino más ligero entre el vértice de la fila y el de la columna. Las celdas en gris indican que no hay camino: de las 110 parejas posibles entre vértices distintos solo 27 tienen camino. La distancia mayor es 40 (de a hasta e). La diagonal vale 0.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Es una matriz de todos los caminos del grafo, no de datos independientes: cada celda sale de un algoritmo de rutas.',
  ),
  23: ChartDetail(
    'La misma matriz de adyacencia en dos órdenes. A la izquierda, alfabético; a la derecha, topológico por capas. En el segundo, casi todas las aristas quedan por encima de la diagonal, que es lo que se espera en un grafo sin ciclos. Solo se salen k → f (debajo de la diagonal) y el bucle l → l (sobre ella): los dos rastros del ciclo.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Mismo dato, otro orden, otra historia. Una matriz de calor normal depende del orden que le des; aquí el orden lo propone el grafo y revela la estructura.',
  ),
  24: ChartDetail(
    'Elige un vértice con los chips y se actualizan juntos tres paneles: el grafo (con sus aristas de salida en rojo y los vértices alcanzables resaltados), las barras con el peso de cada arista de salida y el resumen con los grados de entrada y de salida y el número de vértices alcanzados. Por ejemplo, a tiene 5 salidas y alcanza 5 vértices; d tiene 2 y alcanza 6.',
    ['outDegree', 'inDegree', 'weightedEdges'],
    'Las tres vistas muestran el mismo vértice desde ángulos distintos. Si cambia la selección, cambian todas, y nunca pueden contradecirse porque salen del mismo grafo.',
  ),
  25: ChartDetail(
    'El grafo se coloca con el layout de fuerzas y se puede acercar con pellizco o con la rueda del mouse (hasta 6 veces), y mover arrastrando. Al acercar se ven mejor los pesos de las aristas y las etiquetas, que en la vista completa pueden quedar muy juntas.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'En redes grandes el detalle y el panorama no caben a la vez; el zoom permite pasar de uno al otro sin cambiar de gráfica.',
  ),
  26: ChartDetail(
    'Simula un grafo que va creciendo: cada 0,7 segundos aparece una arista de las 17 del grafo de muestra, en orden mezclado, y la última se resalta en naranja. Debajo se actualizan en vivo el número de aristas, de vértices, la densidad y las componentes fuertemente conexas; a la derecha, una gráfica de líneas con la evolución. Al llegar a 17 aristas (11 vértices y 15,5 % de densidad, contando el bucle l → l) reinicia. Es una simulación local: no consulta ninguna fuente externa.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Las métricas no se guardan: se recalculan sobre el grafo cada vez que cambia. Muestra cómo se verían los indicadores de una red real que recibe conexiones nuevas.',
  ),
  27: ChartDetail(
    'Dos lecturas del mismo grafo. A la izquierda, las aristas que están en un ciclo (f → i, i → k, k → f y el bucle l → l) en rojo. A la derecha, las componentes fuertemente conexas, cada una con su color. El ciclo f → i → k → f aparece como la única componente con varios vértices, así que las dos vistas se confirman entre sí.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Cada vista sola responde una pregunta distinta (qué aristas cierran un ciclo, qué vértices se alcanzan entre sí). Juntas muestran que son dos formas de ver la misma propiedad del grafo.',
  ),
  28: ChartDetail(
    'A la izquierda, el layout por capas, con la arista que cierra el ciclo punteada. A la derecha, el Gantt con la ruta crítica en rojo y la holgura de las demás tareas. Ambas salen del mismo grafo acíclico, una vez omitidas las aristas que cierran ciclos.',
    ['WeightedDirectedGraph', 'weightedEdges', 'outDegree'],
    'Un Gantt no dice por qué una tarea espera a otra; el grafo sí. Verlos juntos conecta la causa (la dependencia) con el efecto (la fecha).',
  ),
  29: ChartDetail(
    'El mismo grafo ponderado como Sankey (bandas entre columnas de capas) y como diagrama de cuerdas (cintas entre arcos en un círculo). En ambos el grosor es el peso de la arista.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'El Sankey ordena el flujo de izquierda a derecha; las cuerdas muestran todos los cruces a la vez. Cambiar de una a otra no requiere recalcular nada: ambas leen los mismos pesos.',
  ),
  30: ChartDetail(
    'La misma jerarquía, un bosque de expansión, dibujada como sunburst (cada anillo es un salto desde el origen) y como treemap (el área es el peso). Los dos se construyen con el mismo recorrido del grafo.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'El sunburst da prioridad a la profundidad y el treemap a la proporción. Poner los dos juntos deja ver qué información sacrifica cada uno.',
  ),
  31: ChartDetail(
    'A la izquierda, el layout de fuerzas con todas las aristas. A la derecha, el árbol de expansión que conecta todos los vértices con las aristas más ligeras. Se ve cuántas conexiones se podrían quitar sin dejar vértices aislados.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Un diagrama de red normal solo muestra lo que existe. Aquí se calcula además el mínimo necesario y se dibuja al lado, para comparar lo que hay con lo que bastaría.',
  ),
  32: ChartDetail(
    'Los mismos pesos de aristas, agrupados igual, en un boxplot (mediana, cuartiles y atípicos) y en un violín (forma completa de la distribución). Con pocos datos por grupo, el boxplot resume y el violín enseña cómo se reparten.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Es la comparación clásica entre un resumen y una distribución. Los datos no se escriben a mano: salen de los pesos de las aristas del grafo.',
  ),
  33: ChartDetail(
    'A la izquierda, coordenadas paralelas: una línea por vértice cruzando cinco métricas. A la derecha, la matriz de dispersión con tres de esas métricas cruzadas por parejas. Sirve para pasar de comparar vértices a ver qué métricas se mueven juntas.',
    ['WeightedDirectedGraph', 'weightedEdges', 'outDegree'],
    'Las métricas (grados, pesos, alcance) se calculan sobre la estructura del grafo; no son columnas de una tabla que alguien preparó antes.',
  ),
  34: ChartDetail(
    'A la izquierda, el streamgraph con cuántos vértices se alcanzan en cada salto desde varios orígenes. A la derecha, el mapa de calor con el costo del camino más ligero entre cada par. La primera vista cuenta alcance; la segunda, costo.',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Alcance y distancia suelen medirse por separado. Aquí salen del mismo grafo y se ven juntos, así que se nota cuándo un vértice llega lejos en saltos pero a costo alto.',
  ),
  35: ChartDetail(
    'Los mismos pasos como diagrama de flujo (óvalos, rombos y rectángulos) y como Gantt. Ambos usan las dependencias del grafo, omitiendo las aristas que cierran ciclos.',
    ['WeightedDirectedGraph', 'weightedEdges', 'outDegree'],
    'El diagrama de flujo explica el orden lógico y el Gantt la duración. Si cambias una arista del grafo, se actualizan los dos.',
  ),
  36: ChartDetail(
    'A la izquierda, el orden topológico en capas; a la derecha, el sunburst por saltos desde un origen. Una capa responde «qué debe estar hecho antes» y un anillo «qué tan lejos queda del origen».',
    ['WeightedDirectedGraph', 'weightedEdges'],
    'Dos nociones de «distancia» en un grafo dirigido (precedencia y número de saltos) que en una gráfica normal no existen y que aquí salen de la misma estructura.',
  ),
};
