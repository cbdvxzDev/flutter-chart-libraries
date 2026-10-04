import 'package:flutter/material.dart';

import 'charts_sync/common.dart';
import 'charts_sync/basic/linea.dart';
import 'charts_sync/basic/linea_con_marcadores.dart';
import 'charts_sync/basic/linea_punteada.dart';
import 'charts_sync/basic/spline.dart';
import 'charts_sync/basic/spline_multiple.dart';
import 'charts_sync/basic/linea_escalonada.dart';
import 'charts_sync/basic/linea_rapida.dart';
import 'charts_sync/basic/columnas.dart';
import 'charts_sync/basic/columnas_redondeadas.dart';
import 'charts_sync/basic/columnas_con_etiquetas.dart';
import 'charts_sync/basic/columnas_agrupadas.dart';
import 'charts_sync/basic/barras_horizontales.dart';
import 'charts_sync/basic/barras_con_pista.dart';
import 'charts_sync/basic/area.dart';
import 'charts_sync/basic/area_con_degradado.dart';
import 'charts_sync/basic/spline_area.dart';
import 'charts_sync/basic/step_area.dart';
import 'charts_sync/basic/areas_superpuestas.dart';
import 'charts_sync/basic/dispersion.dart';
import 'charts_sync/basic/dispersion_por_formas.dart';
import 'charts_sync/basic/burbujas.dart';
import 'charts_sync/basic/columnas_apiladas.dart';
import 'charts_sync/basic/barras_apiladas.dart';
import 'charts_sync/basic/area_apilada.dart';
import 'charts_sync/basic/linea_apilada.dart';
import 'charts_sync/basic/columnas_apiladas100.dart';
import 'charts_sync/basic/barras_apiladas100.dart';
import 'charts_sync/basic/area_apilada100.dart';
import 'charts_sync/basic/linea_apilada100.dart';
import 'charts_sync/basic/columnas_de_rango.dart';
import 'charts_sync/basic/area_de_rango.dart';
import 'charts_sync/basic/spline_de_rango.dart';
import 'charts_sync/basic/velas_japonesas.dart';
import 'charts_sync/basic/ohlc_chart.dart';
import 'charts_sync/basic/hilo.dart';
import 'charts_sync/basic/cascada.dart';
import 'charts_sync/basic/histograma.dart';
import 'charts_sync/basic/caja_y_bigotes.dart';
import 'charts_sync/basic/pastel.dart';
import 'charts_sync/basic/dona.dart';
import 'charts_sync/basic/barra_radial.dart';
import 'charts_sync/basic/piramide.dart';
import 'charts_sync/basic/embudo.dart';
import 'charts_sync/advanced/zoom_y_desplazamiento.dart';
import 'charts_sync/advanced/trackball_agrupado.dart';
import 'charts_sync/advanced/crosshair.dart';
import 'charts_sync/advanced/seleccion_de_columnas.dart';
import 'charts_sync/advanced/tendencia_lineal.dart';
import 'charts_sync/advanced/tendencia_polinomica.dart';
import 'charts_sync/advanced/media_movil.dart';
import 'charts_sync/advanced/eje_secundario.dart';
import 'charts_sync/advanced/combinacion.dart';
import 'charts_sync/advanced/eje_logaritmico.dart';
import 'charts_sync/advanced/ventana_de_fechas.dart';
import 'charts_sync/advanced/grafica_transpuesta.dart';
import 'charts_sync/advanced/bandas_de_trazado.dart';
import 'charts_sync/advanced/anotaciones.dart';
import 'charts_sync/advanced/barras_de_error.dart';
import 'charts_sync/advanced/datos_faltantes.dart';
import 'charts_sync/advanced/tiempo_real.dart';
import 'charts_sync/advanced/apiladas_agrupadas.dart';
import 'charts_sync/advanced/columnas_solapadas.dart';
import 'charts_sync/advanced/columnas_con_degradado.dart';
import 'charts_sync/advanced/linea_por_segmentos.dart';
import 'charts_sync/advanced/tres_ejes_y.dart';
import 'charts_sync/advanced/pastel_explotado.dart';
import 'charts_sync/advanced/dona_con_total_central.dart';
import 'charts_sync/advanced/medidor_semicircular.dart';
import 'charts_sync/advanced/anillos_radiales.dart';
import 'charts_sync/advanced/dona_doble.dart';
import 'charts_sync/advanced/pastel_agrupado.dart';
import 'charts_sync/advanced/piramide_con_superficie.dart';
import 'charts_sync/advanced/embudo_estilizado.dart';
import 'charts_sync/advanced/sparkline_de_linea.dart';
import 'charts_sync/advanced/sparkline_de_area.dart';
import 'charts_sync/advanced/sparkline_de_barras.dart';
import 'charts_sync/advanced/sparkline_ganar_perder.dart';
import 'charts_sync/advanced/panel_de_kpis.dart';
import 'charts_sync/advanced/velas_media_zoom.dart';

final basic = <S>[
  S('Línea', 'Ventas mensuales', linea),
  S('Línea con marcadores', 'Ventas por origen', lineaConMarcadores),
  S('Línea punteada', 'Meta vs. real', lineaPunteada),
  S('spline', 'Curva suavizada', spline),
  S('spline múltiple', 'Tres orígenes', splineMultiple),
  S('Línea escalonada', 'Precio por kilo', lineaEscalonada),
  S('Línea rápida', '2.000 puntos de sensor', lineaRapida),
  S('columnas', 'Tazas vendidas', columnas),
  S('columnas redondeadas', 'Bordes superiores', columnasRedondeadas),
  S('columnas con etiquetas', 'Valores visibles', columnasConEtiquetas),
  S('columnas agrupadas', 'Comparativa de orígenes', columnasAgrupadas),
  S('Barras horizontales', 'Ranking de bebidas', barrasHorizontales),
  S('Barras con pista', 'Color por barra', barrasConPista),
  S('Área', 'Visitas al local', area),
  S('Área con degradado', 'Ingresos', areaConDegradado),
  S('spline area', 'Área curva', splineArea),
  S('Step area', 'Inventario', stepArea),
  S('Áreas superpuestas', 'Tres sucursales', areasSuperpuestas),
  S('Dispersión', 'Temperatura vs. ventas', dispersion),
  S('Dispersión por formas', 'Tres segmentos', dispersionPorFormas),
  S('burbujas', 'Tamaño = margen', burbujas),
  S('columnas apiladas', 'Total por mes', columnasApiladas),
  S('Barras apiladas', 'Total por mes', barrasApiladas),
  S('Área apilada', 'Acumulado', areaApilada),
  S('Línea apilada', 'Acumulado', lineaApilada),
  S('columnas apiladas 100%', 'Participación', columnasApiladas100),
  S('Barras apiladas 100%', 'Participación', barrasApiladas100),
  S('Área apilada 100%', 'Participación', areaApilada100),
  S('Línea apilada 100%', 'Participación', lineaApilada100),
  S('columnas de rango', 'Mín–máx de temperatura', columnasDeRango),
  S('Área de rango', 'Banda de precios', areaDeRango),
  S('spline de rango', 'Banda suavizada', splineDeRango),
  S('Velas japonesas', 'Precio del grano', velasJaponesas),
  S('OHLC', 'Apertura/Máx/Mín/Cierre', ohlcChart),
  S('hilo', 'Rango diario', hilo),
  S('cascada', 'Del ingreso a la utilidad', cascada),
  S('histograma', 'Ticket promedio', histograma),
  S('Caja y bigotes', 'Pedidos por día', cajaYBigotes),
  S('pastel', 'Mezcla de ventas', pastel),
  S('dona', 'Mezcla de ventas', dona),
  S('Barra radial', 'Cumplimiento de metas', barraRadial),
  S('Pirámide', 'Fidelización', piramide),
  S('embudo', 'Conversión de clientes', embudo),
];

final adv = <S>[
  S('Zoom y desplazamiento', 'Pellizca, arrastra o rueda del mouse', zoomYDesplazamiento),
  S('Trackball agrupado', 'Toca para comparar series', trackballAgrupado),
  S('crosshair', 'Líneas guía al tocar', crosshair),
  S('Selección de columnas', 'Toca una barra', seleccionDeColumnas),
  S('Tendencia lineal', 'Regresión sobre dispersión', tendenciaLineal),
  S('Tendencia polinómica', 'Orden 3', tendenciaPolinomica),
  S('Media móvil', 'Periodo de 3 meses', mediaMovil),
  S('Eje secundario', 'Ventas (col.) y satisfacción (línea)', ejeSecundario),
  S('Combinación', 'Área + columna + spline', combinacion),
  S('Eje logarítmico', 'Crecimiento exponencial', ejeLogaritmico),
  S('Ventana de fechas', 'Eje temporal con rango inicial', ventanaDeFechas),
  S('Gráfica transpuesta', 'Ejes intercambiados', graficaTranspuesta),
  S('Bandas de trazado', 'Zona objetivo y meta', bandasDeTrazado),
  S('anotaciones', 'Widgets sobre el punto máximo', anotaciones),
  S('Barras de error', 'Incertidumbre ±6', barrasDeError),
  S('Datos faltantes', 'Hueco vs. promedio', datosFaltantes),
  S('Tiempo real', 'Actualización en vivo (0,7 s)', tiempoReal),
  S('Apiladas agrupadas', 'Dos tiendas, dos pilas', apiladasAgrupadas),
  S('columnas solapadas', 'Real, meta y mínimo', columnasSolapadas),
  S('columnas con degradado', 'Pista y etiquetas', columnasConDegradado),
  S('Línea por segmentos', 'Color según umbral', lineaPorSegmentos),
  S('Tres ejes Y', 'Ventas, clima y clientes', tresEjesY),
  S('pastel explotado', 'Etiquetas externas con conector', pastelExplotado),
  S('dona con total central', 'Anotación circular', donaConTotalCentral),
  S('Medidor semicircular', 'Avance de la meta', medidorSemicircular),
  S('Anillos radiales', 'Esquinas redondeadas', anillosRadiales),
  S('dona doble', 'Actual vs. proyectado', donaDoble),
  S('pastel agrupado', 'Valores < 25 → "Otros"', pastelAgrupado),
  S('Pirámide con superficie', 'Modo surface y etiquetas', piramideConSuperficie),
  S('embudo estilizado', 'Cuello ajustado', embudoEstilizado),
  S('Sparkline de línea', 'Máx/mín resaltados', sparklineDeLinea),
  S('Sparkline de área', 'Tendencia compacta', sparklineDeArea),
  S('Sparkline de barras', 'Barras mínimas', sparklineDeBarras),
  S('Sparkline ganar/perder', 'Días sobre/bajo la meta', sparklineGanarPerder),
  S('Panel de KPIs', 'Cuatro sparklines en una tarjeta', panelDeKpis),
  S('Velas + media + zoom', 'Candle con MA(5) y zoom', velasMediaZoom),
];

// ───────────────────────── Vista principal ─────────────────────────
class ChartsGalleryPage extends StatelessWidget {
  const ChartsGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Charts - Galería de gráficas'),
          bottom: TabBar(tabs: [Tab(text: 'Básicas · ${basic.length}'), Tab(text: 'Avanzadas · ${adv.length}')]),
        ),
        body: TabBarView(children: [Grid(basic), Grid(adv)]),
      ),
    );
  }
}

class Grid extends StatelessWidget {
  const Grid(this.items, {super.key});
  final List<S> items;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, box) {
        final cols = (box.maxWidth / 440).floor().clamp(1, 4).toInt();
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          addAutomaticKeepAlives: false,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols, mainAxisExtent: 360, crossAxisSpacing: 16, mainAxisSpacing: 16),
          itemCount: items.length,
          itemBuilder: (_, i) => Card(i + 1, items[i]),
        );
      });
}

class Card extends StatelessWidget {
  const Card(this.n, this.s, {super.key});
  final int n;
  final S s;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cs.outlineVariant.withAlpha(120)),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 18, offset: Offset(0, 6))],
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
          child: Row(children: [
            Container(
              width: 30, height: 30, alignment: Alignment.center,
              decoration: BoxDecoration(gradient: LinearGradient(colors: [pal[0], pal[5]]), borderRadius: BorderRadius.circular(10)),
              child: Text('$n', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.t, maxLines: 1, overflow: TextOverflow.ellipsis, style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                Text(s.s, maxLines: 1, overflow: TextOverflow.ellipsis, style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
              ]),
            ),
          ]),
        ),
        Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(22), child: RepaintBoundary(child: s.b()))),
      ]),
    );
  }
}
